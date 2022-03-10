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
    public class CustomClothingGear : CustomGearBase
    {
        public XLGMClothingGearMetadata ClothingMetadata => Metadata as XLGMClothingGearMetadata;

        public CustomClothingGear(XLGMClothingGearMetadata metadata, GameObject prefab) 
            : base(metadata, prefab)
        {
        }

        public CustomClothingGear(CustomGearBase customGearBase, CustomCharacterGearInfo gearInfo)
            : base(customGearBase, gearInfo)
        {

        }

        public override void Instantiate()
        {
            var name = string.IsNullOrEmpty(ClothingMetadata.DisplayName) ? Prefab.name : ClothingMetadata.DisplayName;

            GearInfo = new CustomCharacterGearInfo(name, ClothingMetadata.Prefix, false, GetDefaultTextureChanges(), new string[0]);

            SetTexturesAndShader();
            AddPrefixToGearFilters();
            AddCharacterGearTemplate();
        }

        /// <summary>
        /// Adds the default texture from XLGMTextureSet (if exists, else uses empties), and puts the asset material on the MasterShaderCloth_v2 shader.
        /// </summary>
        private void SetTexturesAndShader()
        {
            if (ClothingMetadata == null) return;

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

            var textures = CreateTextureDictionary();

            if (ClothingMetadata.BaseOnDefaultGear)
            {
                SetBaseMaterial(textures, materialController);
                return;
            }

            // TODO: Because we're having to make the materials in HDRP/Lit in the editor (until we get their shader, hopefully)
            // we need to store off a copy of the normal and mask maps, and ensure we assign them to the correct property names once the shader has been changed.
            // Hopefully, if we can get access to their cloth shader, we can just assign properties directly in editor and get rid of most of this code.
            materialController.PropertyNameSubstitutions.Add("_NormalMap", "_texture2D_normal");
            materialController.PropertyNameSubstitutions.Add("_MaskMap", "_texture2D_maskPBR");

            var material = materialController.GenerateMaterialWithChanges(textures);
            material.shader = GetClothingShader();
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
        /// Creates a dictionary of textures for albedo, normal, and mask pbr.  If we can't find default texture information on the prefab we will use the empties bundled into mod.
        /// </summary>
        private Dictionary<string, Texture> CreateTextureDictionary()
        {
            var textures = new Dictionary<string, Texture>();

            var defaultTexture = Metadata.GetMaterialInformation()?.DefaultTexture;

            textures.Add("albedo", defaultTexture?.textureColor ?? AssetBundleHelper.Instance.emptyAlbedo);
            textures.Add("normal", defaultTexture?.textureNormalMap ?? AssetBundleHelper.Instance.emptyNormalMap);
            textures.Add("maskpbr", defaultTexture?.textureMaskPBR ?? AssetBundleHelper.Instance.emptyMaskPBR);
            //textures.Add(shaderName == "MasterShaderCloth_v2" ? "_texture2D_maskPBR" : "_texture2D_rgmtao", Metadata.GetMaterialInformation()?.DefaultTexture?.textureMaskPBR ?? AssetBundleHelper.Instance.emptyMaskPBR);

            return textures;
        }

        /// <summary>
        /// Gets reference to MasterShaderCloth_v2 unless the metadata category is Hair or Facial Hair, then returns a reference to MasterShaderHair_AlphaTest_v1.
        /// </summary>
        private Shader GetClothingShader()
        {
            if (ClothingMetadata != null &&
                (ClothingMetadata.Category == Unity.ClothingGearCategory.Hair ||
                 ClothingMetadata.Category == Unity.ClothingGearCategory.FacialHair))
            {
                return GearManager.Instance.MasterShaderHair_AlphaTest_v1;
            }

            return GearManager.Instance.MasterShaderCloth_v2;
        }

        private void AddPrefixToGearFilters()
        {
            var skaterIndex = ClothingMetadata != null ? (int)ClothingMetadata.Skater : (int)SkaterBase.Male;

            var typeFilter = GearDatabase.Instance.skaters[skaterIndex].GearFilters[GetCategoryIndex(skaterIndex)];

            if (!typeFilter.includedTypes.Contains(Metadata.Prefix))
            {
                Array.Resize(ref typeFilter.includedTypes, typeFilter.includedTypes.Length + 1);
                typeFilter.includedTypes[typeFilter.includedTypes.Length - 1] = Metadata.Prefix;
            }
        }

        private void AddCharacterGearTemplate()
        {
            if (GearDatabase.Instance.CharGearTemplateForID.ContainsKey(ClothingMetadata.Prefix.ToLower())) return;

            var newGearTemplate = new CharacterGearTemplate
            {
                alphaMasks = new List<GearAlphaMaskConfig>(),
                category = MapCategory(ClothingMetadata.Category),
                id = ClothingMetadata.Prefix.ToLower(),
                path = $"XLGearModifier/{Prefab.name}"
            };

            AddOrUpdateTemplateAlphaMasks(ClothingMetadata, newGearTemplate);

            GearDatabase.Instance.CharGearTemplateForID.Add(ClothingMetadata.Prefix.ToLower(), newGearTemplate);
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

        public override int GetCategoryIndex(int skaterIndex)
        {
            if (ClothingMetadata == null) return 0;

            var categoryIndex = (int)ClothingMetadata.Category;
            var category = ClothingMetadata.Category.ToString();

            switch (skaterIndex)
            {
                case (int)Skater.EvanSmith:
                    Enum.TryParse(category, out EvanSmithGearCategory esCategory);
                    categoryIndex = (int)esCategory;
                    break;
                case (int)Skater.TomAsta:
                    Enum.TryParse(category, out TomAstaGearCategory taCategory);
                    categoryIndex = (int)taCategory;
                    break;
                case (int)Skater.BrandonWestgate:
                    Enum.TryParse(category, out BrandonWestgateGearCategory bwCategory);
                    categoryIndex = (int)bwCategory;
                    break;
                case (int)Skater.TiagoLemos:
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
