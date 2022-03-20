using HarmonyLib;
using SkaterXL.Gear;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using XLGearModifier.Unity;
using XLMenuMod;
using XLMenuMod.Utilities.Gear;
using ClothingGearCategory = SkaterXL.Gear.ClothingGearCategory;

namespace XLGearModifier.CustomGear
{
    public class ClothingGear : CustomGearBase
    {
        public XLGMClothingGearMetadata ClothingMetadata => Metadata as XLGMClothingGearMetadata;

        public XLGMCustomCharacterGearInfo XLGMGearInfo => GearInfo as XLGMCustomCharacterGearInfo;

        public XLGMBlendShapeController BlendShapeController { get; set; }

        public ClothingGear(XLGMClothingGearMetadata metadata, GameObject prefab) : base(metadata, prefab)
        {

        }

        public ClothingGear(ClothingGear gearToClone, CustomCharacterGearInfo gearInfo) : base(gearToClone, gearInfo)
        {
            BlendShapeController = gearToClone.BlendShapeController;
        }

        public override void Instantiate()
        {
            var name = string.IsNullOrEmpty(ClothingMetadata.DisplayName) ? Prefab.name : ClothingMetadata.DisplayName;

            GearInfo = new CustomCharacterGearInfo(name, ClothingMetadata.Prefix, false, GetDefaultTextureChanges(), new string[0]);

            GetBlendShapeController();
            SetTexturesAndShader();
            AddGearFilters();
            AddGearTemplates();
        }

        private void GetBlendShapeController()
        {
            BlendShapeController = Prefab.GetComponentInChildren<XLGMBlendShapeController>(true);

            if (BlendShapeController == null) return;
            if (BlendShapeController.BlendShapes != null) return;

            BlendShapeController.BlendShapes = new List<XLGMBlendShapeData>();

            //TODO: This is a hack, figure out why the blendshapes are coming through null from editor
            for (int i = 0; i < BlendShapeController.SkinnedMesh.blendShapeCount; i++)
            {
                var name = BlendShapeController.SkinnedMesh.GetBlendShapeName(i);
                var weight = BlendShapeController.SkinnedMeshRenderer.GetBlendShapeWeight(i);

                BlendShapeController.BlendShapes.Add(new XLGMBlendShapeData
                {
                    index = i,
                    name = name,
                    weight = weight
                });
            }
        }

        /// <summary>
        /// Adds the default texture from XLGMTextureSet (if exists, else uses empties), and puts the asset material on the MasterShaderCloth_v2 shader.
        /// </summary>
        private void SetTexturesAndShader()
        {
            var materialControllers = Prefab.GetComponentsInChildren<MaterialController>();
            if (materialControllers == null || !materialControllers.Any()) return;

            foreach (var materialController in materialControllers)
            {
                CreateMaterialWithTexturesOnProperShader(materialController);
            }
        }

        private void CreateMaterialWithTexturesOnProperShader(MaterialController materialController)
        {
            if (materialController == null) return;

            var textures = CreateDefaultTextureDictionary();

            var isHair = ClothingMetadata.Category == Unity.ClothingGearCategory.Hair ||
                         ClothingMetadata.Category == Unity.ClothingGearCategory.FacialHair;

            var propNameSubs = new List<PropertyNameSubstitution>
            {
                new PropertyNameSubstitution { oldName = "albedo", newName = isHair ? "_texture_color" : "_texture2D_color" },
                new PropertyNameSubstitution { oldName = "normal", newName = isHair ? "_texture_normal" : "_texture2D_normal" },
                new PropertyNameSubstitution { oldName = "maskpbr", newName = isHair ? "_texture_mask" : "_texture2D_maskPBR" }
            };

            // Because hair/clothing gear are on different shaders, all of Easy Day's hair has this substitution.
            // We're just doing it here in code to avoid every hair in editor needing to add it.
            if (isHair) propNameSubs.Add(new PropertyNameSubstitution { oldName = "_texture2D_color", newName = "_texture_color" });

            var traverse = Traverse.Create(materialController);
            traverse.Field("m_propertyNameSubstitutions").SetValue(propNameSubs);

            if (ClothingMetadata.BaseOnDefaultGear)
            {
                SetBaseMaterial(textures, materialController);
                return;
            }

            var alphaThreshold = 0f;

            // TODO: Because we're having to make the materials in HDRP/Lit in the editor (until we get their shader, hopefully)
            // we need to store off a copy of the normal and mask maps, and ensure we assign them to the correct property names once the shader has been changed.
            // Hopefully, if we can get access to their cloth shader, we can just assign properties directly in editor and get rid of most of this code.
            var materialCopy = materialController.GetMaterialCopy();
            if (materialCopy != null)
            {
                var color = materialCopy.GetTexture("_BaseColorMap");
                if (color != null) textures["albedo"] = color;

                var normal = materialCopy.GetTexture("_NormalMap");
                if (normal != null) textures["normal"] = normal;

                var mask = materialCopy.GetTexture("_MaskMap");
                if (mask != null) textures["maskpbr"] = mask;

                materialCopy.SetFloat("_alpha_threshold", materialCopy.GetFloat("_AlphaCutoff"));
            }

            traverse.Field("_originalMaterial").GetValue<Material>().shader = GetClothingShader();
            var material = materialController.GenerateMaterialWithChanges(textures);
            materialController.SetMaterial(material);
        }

        /// <summary>
        /// Intended to be used when an object is based on default gear.  This method looks up the prefab this gear item is based on, pulls the material off of it.
        /// Sets that base material as the original material, such that when we generate the new material with textures, it should have any normals/masks.
        /// </summary>
        /// <param name="textures"></param>
        /// <param name="materialController"></param>
        /// <returns></returns>
        private async Task SetBaseMaterial(Dictionary<string, Texture> textures, MaterialController materialController)
        {
            var baseObject = await GetBaseObject();
            var renderer = baseObject.GetComponentInChildren<Renderer>();

            // set original material such that when we call generate, the new material will be based off of this one.
            Traverse.Create(materialController).Field("_originalMaterial").SetValue(renderer.material);

            var newMaterial = materialController.GenerateMaterialWithChanges(textures);
            materialController.SetMaterial(newMaterial);
        }

        /// <summary>
        /// Creates a dictionary of default textures for albedo, normal, and mask pbr using the empty textures in our project.
        /// </summary>
        private Dictionary<string, Texture> CreateDefaultTextureDictionary()
        {
            var textures = new Dictionary<string, Texture>
            {
                { "albedo", GearManager.Instance.EmptyAlbedo },
                { "normal", GearManager.Instance.EmptyNormalMap },
                { "maskpbr", GearManager.Instance.EmptyMaskPBR }
            };

            //textures.Add(shaderName == "MasterShaderCloth_v2" ? "_texture2D_maskPBR" : "_texture2D_rgmtao", Metadata.GetMaterialInformation()?.DefaultTexture?.textureMaskPBR ?? AssetBundleHelper.Instance.EmptyMaskPBR);

            return textures;
        }

        /// <summary>
        /// Gets reference to MasterShaderCloth_v2 unless the metadata category is Hair or Facial Hair, then returns a reference to MasterShaderHair_AlphaTest_v1.
        /// </summary>
        private Shader GetClothingShader()
        {
            if (ClothingMetadata.Category == Unity.ClothingGearCategory.Hair || ClothingMetadata.Category == Unity.ClothingGearCategory.FacialHair)
            {
                return GearManager.Instance.MasterShaderHair_AlphaTest_v1;
            }

            return GearManager.Instance.MasterShaderCloth_v2;
        }

        #region GearFilter methods
        private void AddGearFilters()
        {
            var skaterIndex = (int)ClothingMetadata.Skater;
            var typeFilter = GearDatabase.Instance.skaters[skaterIndex].GearFilters[GetCategoryIndex(skaterIndex)];

            AddGearFilter(ClothingMetadata.Prefix, typeFilter);
            AddGearFilter(ClothingMetadata.PrefixAlias, typeFilter);
        }

        private void AddGearFilter(string type, TypeFilter typeFilter)
        {
            if (string.IsNullOrEmpty(type)) return;
            if (typeFilter.includedTypes.Contains(type)) return;

            Array.Resize(ref typeFilter.includedTypes, typeFilter.includedTypes.Length + 1);
            typeFilter.includedTypes[typeFilter.includedTypes.Length - 1] = type;
        }
        #endregion

        #region GearTemplate methods
        /// <summary>
        /// Adds the Prefix and Prefix Alias (if exists) to the CharGearTemplateForID dictionary in GearDatabase.
        /// </summary>
        private void AddGearTemplates()
        {
            AddGearTemplate(ClothingMetadata.Prefix);
            AddGearTemplate(ClothingMetadata.PrefixAlias, true);
        }

        private void AddGearTemplate(string templateId, bool isAlias = false)
        {
            if (string.IsNullOrEmpty(templateId)) return;
            if (GearDatabase.Instance.ContainsClothingTemplateWithID(templateId)) return;

            var path = "XLGearModifier";
            if (isAlias) path += "/alias";
            path += $"/{Prefab.name}";

            var template = new CharacterGearTemplate
            {
                alphaMasks = new List<GearAlphaMaskConfig>(),
                category = MapCategory(ClothingMetadata.Category),
                id = templateId.ToLower(),
                path = path
            };

            if (!isAlias) AddOrUpdateTemplateAlphaMasks(ClothingMetadata, template);

            GearDatabase.Instance.CharGearTemplateForID.Add(templateId.ToLower(), template);
        }

        private ClothingGearCategory MapCategory(Unity.ClothingGearCategory category)
        {
            switch (category)
            {
                case Unity.ClothingGearCategory.Hair:
                case Unity.ClothingGearCategory.FacialHair:
                case Unity.ClothingGearCategory.Headwear:
                    return ClothingGearCategory.Hat;
                case Unity.ClothingGearCategory.Shoes:
                case Unity.ClothingGearCategory.Socks:
                    return ClothingGearCategory.Shoes;
                case Unity.ClothingGearCategory.Bottom:
                    return ClothingGearCategory.Pants;
                default:
                case Unity.ClothingGearCategory.Top:
                    return ClothingGearCategory.Shirt;
            }
        }

        private void AddOrUpdateTemplateAlphaMasks(XLGMClothingGearMetadata metadata, CharacterGearTemplate template)
        {
            if (metadata.AlphaMaskThresholds == null || !metadata.AlphaMaskThresholds.Any()) return;

            foreach (var mask in metadata.AlphaMaskThresholds)
            {
                if (mask == null) continue;

                if (mask.Threshold > 250) mask.Threshold = 250;

                var existing = template.alphaMasks.FirstOrDefault(x => (int)x.MaskLocation == (int)mask.MaskLocation);
                if (existing == null)
                {
                    template.alphaMasks.Add(mask);
                }
                else
                {
                    existing.Threshold = mask.Threshold;
                }
            }
        }
        #endregion

        public override int GetCategoryIndex(int skaterIndex)
        {
            if (ClothingMetadata == null) return 0;

            var categoryIndex = (int)ClothingMetadata.Category;
            var category = ClothingMetadata.Category.ToString();

            switch (skaterIndex)
            {
                case (int)XLMenuMod.Skater.EvanSmith:
                    Enum.TryParse(category, out EvanSmithGearCategory esCategory);
                    categoryIndex = (int)esCategory;
                    break;
                case (int)XLMenuMod.Skater.TomAsta:
                    Enum.TryParse(category, out TomAstaGearCategory taCategory);
                    categoryIndex = (int)taCategory;
                    break;
                case (int)XLMenuMod.Skater.BrandonWestgate:
                    Enum.TryParse(category, out BrandonWestgateGearCategory bwCategory);
                    categoryIndex = (int)bwCategory;
                    break;
                case (int)XLMenuMod.Skater.TiagoLemos:
                    Enum.TryParse(category, out TiagoLemosGearCategory tlCategory);
                    categoryIndex = (int)tlCategory;
                    break;
            }

            return categoryIndex;
        }

        public override async Task<GameObject> GetBaseObject()
        {
            var info = GetBaseGearInfo();
            if (info == null) return null;

            var path = GearDatabase.Instance.CharGearTemplateForID[info.type].path;

            AsyncOperationHandle<GameObject> loadOp = Addressables.LoadAssetAsync<GameObject>(path);
            await new WaitUntil(() => loadOp.IsDone);
            GameObject result = loadOp.Result;
            if (result == null)
            {
                Debug.Log("XLGM: No prefab found for template at path '" + path + "'");
            }
            return result;
        }

        /// <summary>
        /// Returns the object's Prefix, unless BaseOnDefaultGear is true, then returns the base type's Prefix.
        /// </summary>
        public override string GetTypeName()
        {
            var type = base.GetTypeName();

            if (ClothingMetadata.BaseOnDefaultGear)
            {
                type = ClothingMetadata.GetBaseType();
            }

            return type;
        }
    }
}
