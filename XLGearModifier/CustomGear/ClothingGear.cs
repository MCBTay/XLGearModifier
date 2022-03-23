using HarmonyLib;
using SkaterXL.Gear;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using XLGearModifier.Texturing;
using XLGearModifier.Unity;
using XLMenuMod;
using XLMenuMod.Utilities.Gear;
using ClothingGearCategory = SkaterXL.Gear.ClothingGearCategory;

namespace XLGearModifier.CustomGear
{
    public class ClothingGear : CustomGearBase
    {
        public XLGMClothingGearMetadata ClothingMetadata => Metadata as XLGMClothingGearMetadata;

        public ClothingGear(XLGMClothingGearMetadata metadata, GameObject prefab) : base(metadata, prefab)
        {
        }

        public ClothingGear(CustomGearBase customGearBase, CustomCharacterGearInfo gearInfo) : base(customGearBase, gearInfo)
        {
        }

        public override void Instantiate()
        {
            var name = string.IsNullOrEmpty(ClothingMetadata.DisplayName) ? Prefab.name : ClothingMetadata.DisplayName;

            GearInfo = new CustomCharacterGearInfo(name, ClothingMetadata.CharacterGearTemplate.id, false, GetDefaultTextureChanges(), new string[0]);

            SetTexturesAndShader();
            AddGearFilters();
            AddGearTemplates();
        }

        /// <summary>
        /// Adds the default textures from the material (if they exist, else fall back to empties) to the material, and puts the asset material on the MasterShaderCloth_v2 or MasterShaderHair_AlphaTest_v1 shader.
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

        /// <summary>
        /// Recreates the material on the material controller to use proper textures as well as the proper shader.  Sets any necessary
        /// PropertyNameSubstitutions and creates a dictionary of textures to be used when calling GenerateMaterialWithChanges.
        /// </summary>
        /// <param name="materialController">The material controller to recreate the material on.</param>
        private void CreateMaterialWithTexturesOnProperShader(MaterialController materialController)
        {
            if (materialController == null) return;

            var textures = CreateDefaultTextureDictionary();

            SetPropertyNameSubstitutions(materialController);

            float alphaThreshold = -1;

            var traverse = Traverse.Create(materialController);
            var originalMaterial = traverse.Property("originalMaterial").GetValue<Material>();

            textures = UpdateTextureDictionaryWithMaterialTextures(originalMaterial, textures);

            if (originalMaterial.HasProperty("_AlphaCutoff"))
            {
                alphaThreshold = originalMaterial.GetFloat("_AlphaCutoff");
            }

            SetShaderOnOriginalMaterial(materialController);

            var material = materialController.GenerateMaterialWithChanges(textures);

            if (alphaThreshold > 0) material.SetFloat("_alpha_threshold", alphaThreshold);

            materialController.SetMaterial(material);
        }

        /// <summary>
        /// Sets property name substitutions to handle all of our assets coming from HDRP/Lit to go to Easy Day shaders.  Most of this code
        /// can hopefully get removed once we get native access to their shaders.  Also adds property name substitutions for hair, to mimic what
        /// Easy Day does with their own hair meshes in editor.
        /// </summary>
        /// <param name="materialController">The material controller to operate on</param>
        private void SetPropertyNameSubstitutions(MaterialController materialController)
        {
            var isHair = ClothingMetadata.Category == Unity.ClothingGearCategory.Hair ||
                         ClothingMetadata.Category == Unity.ClothingGearCategory.FacialHair;

            //TODO: This 3 entries below can likely be removed once we get access to their shaders.
            var propNameSubs = new List<PropertyNameSubstitution>
            {
                new PropertyNameSubstitution { oldName = "albedo", newName = isHair ? "_texture_color" : "_texture2D_color" },
                new PropertyNameSubstitution { oldName = "normal", newName = isHair ? "_texture_normal" : "_texture2D_normal" },
                new PropertyNameSubstitution { oldName = "maskpbr", newName = isHair ? "_texture_mask" : "_texture2D_maskPBR" }
            };

            // Because hair/clothing gear are on different shaders, all of Easy Day's hair has this substitution for color.
            // We're just doing it here in code to avoid every hair in editor needing to add it.
            if (isHair)
            {
                propNameSubs.Add(new PropertyNameSubstitution { oldName = "_texture2D_color", newName = "_texture_color" });
                propNameSubs.Add(new PropertyNameSubstitution { oldName = "_texture2D_normal", newName = "_texture_normal" });
                propNameSubs.Add(new PropertyNameSubstitution { oldName = "_texture2D_maskPBR", newName = "_texture_mask" });
            }

            var traverse = Traverse.Create(materialController);
            traverse.Field("m_propertyNameSubstitutions").SetValue(propNameSubs);
        }

        /// <summary>
        /// Pulls _BaseColorMap, _NormalMap, and _MaskMap off of the original material (assuming the material is using HDRP/Lit shader), and updates the textures dictionary passed in
        /// with their values (if they exist).  This should leave us with a textures dictionary that defaults to our empty textures, and an textures on the material should overwrite them,
        /// which should give us our desired texture fallback.
        /// </summary>
        /// <param name="originalMaterial">The material to pull textures off of.</param>
        /// <param name="textures">The collection of textures to update, should be a list of the 3 empty textures on the way in.</param>
        /// <returns>A dictionary of textures that should be the textures off the material (if they existed), else the empty textures.</returns>
        public Dictionary<string, Texture> UpdateTextureDictionaryWithMaterialTextures(Material originalMaterial, Dictionary<string, Texture> textures)
        {
            // TODO: Because we're having to make the materials in HDRP/Lit in the editor (until we get their shader, hopefully)
            // we need to store off a copy of the normal and mask maps, and ensure we assign them to the correct property names once the shader has been changed.
            // Hopefully, if we can get access to their cloth shader, we can just assign properties directly in editor and get rid of most of this code.
            if (originalMaterial == null) return textures;

            if (ClothingMetadata.BaseOnDefaultGear)
            {
                var baseTextures = BaseGameTextureManager.Instance.BaseGameTextures[ClothingMetadata.GetBaseType().ToLower()];
                textures["normal"] = baseTextures["normal"];
                textures["maskpbr"] = baseTextures["maskpbr"];

                return textures;
            }

            var color = originalMaterial.GetTexture("_BaseColorMap");
            if (color != null) textures["albedo"] = color;

            var normal = originalMaterial.GetTexture("_NormalMap");
            if (normal != null) textures["normal"] = normal;

            var mask = originalMaterial.GetTexture("_MaskMap");
            if (mask != null) textures["maskpbr"] = mask;

            return textures;
        }

        /// <summary>
        /// Sets the shader on _originalMaterial to the clothing or hair shader depending on the asset.  This allows the material generated by
        /// GenerateMaterialWithChanges to already be on the proper shader, such that we can leverage the PropertyNameSubstitutions to handle shader
        /// property name differences.
        /// </summary>
        /// <param name="materialController"></param>
        private void SetShaderOnOriginalMaterial(MaterialController materialController)
        {
            var traverse = Traverse.Create(materialController);
            traverse.Field("_originalMaterial").GetValue<Material>().shader = GetClothingShader();
        }

        /// <summary>
        /// Creates a dictionary of default textures for albedo, normal, and mask pbr using the empty textures in our project.
        /// </summary>
        public Dictionary<string, Texture> CreateDefaultTextureDictionary()
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
                return BaseGameTextureManager.Instance.MasterShaderHair_AlphaTest_v1;
            }

            return BaseGameTextureManager.Instance.MasterShaderCloth_v2;
        }

        #region GearFilter methods
        private void AddGearFilters()
        {
            var skaterIndex = (int)ClothingMetadata.Skater;
            var typeFilter = GearDatabase.Instance.skaters[skaterIndex].GearFilters[GetCategoryIndex(skaterIndex)];

            AddGearFilter(ClothingMetadata.CharacterGearTemplate.id, typeFilter);
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
            AddGearTemplate(ClothingMetadata.CharacterGearTemplate.id);
            AddGearTemplate(ClothingMetadata.PrefixAlias, true);
        }

        private void AddGearTemplate(string templateId, bool isAlias = false)
        {
            if (string.IsNullOrEmpty(templateId)) return;
            if (GearDatabase.Instance.ContainsClothingTemplateWithID(templateId)) return;

            var path = "XLGearModifier";
            if (isAlias) path += "/alias";
            path += $"/{templateId.ToLower()}";

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
            if (metadata.CharacterGearTemplate.alphaMasks == null || !metadata.CharacterGearTemplate.alphaMasks.Any()) return;

            foreach (var mask in metadata.CharacterGearTemplate.alphaMasks)
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
    }
}
