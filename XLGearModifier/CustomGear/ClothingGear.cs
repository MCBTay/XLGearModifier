﻿using HarmonyLib;
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
using XLGearModifier.Utilities;
using XLMenuMod;
using XLMenuMod.Utilities.Gear;

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

            GearInfo = new CustomCharacterGearInfo(name, ClothingMetadata.CharacterGearTemplate.id, false, GetDefaultTextureChanges(), new string[0]);

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

            if (originalMaterial != null && originalMaterial.HasProperty("_AlphaCutoff"))
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
                new PropertyNameSubstitution { oldName = Strings.Albedo, newName = isHair ? Strings.HairAlbedoPropertyName : Strings.ClothAlbedoPropertyName},
                new PropertyNameSubstitution { oldName = Strings.Normal, newName = isHair ? Strings.HairNormalPropertyName : Strings.ClothNormalPropertyName },
                new PropertyNameSubstitution { oldName = Strings.MaskPBR, newName = isHair ? Strings.HairRgmtaoPropertyName : Strings.ClothRgmtaoPropertyName }
            };

            // Because hair/clothing gear are on different shaders, all of Easy Day's hair has this substitution for color.
            // We're just doing it here in code to avoid every hair in editor needing to add it.
            if (isHair)
            {
                propNameSubs.Add(new PropertyNameSubstitution { oldName = Strings.ClothAlbedoPropertyName, newName = Strings.HairAlbedoPropertyName });
                propNameSubs.Add(new PropertyNameSubstitution { oldName = Strings.ClothNormalPropertyName, newName = Strings.HairNormalPropertyName });
                propNameSubs.Add(new PropertyNameSubstitution { oldName = Strings.ClothRgmtaoPropertyName, newName = Strings.HairRgmtaoPropertyName });
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
                var id = ClothingMetadata.GetBaseType().ToLower();

                if (!BaseGameTextureManager.Instance.BaseGameTextures.ContainsKey(id)) return textures;

                var baseTextures = BaseGameTextureManager.Instance.BaseGameTextures[id];

                if (baseTextures.ContainsKey(Strings.Normal))
                {
                    textures[Strings.Normal] = baseTextures[Strings.Normal];
                }

                if (baseTextures.ContainsKey(Strings.MaskPBR))
                {
                    textures[Strings.MaskPBR] = baseTextures[Strings.MaskPBR];
                }

                return textures;
            }

            var color = originalMaterial.GetTexture(Strings.HDRPLitAlbedoPropertyName);
            if (color != null) textures[Strings.Albedo] = color;

            var normal = originalMaterial.GetTexture(Strings.HDRPLitNormalPropertyName);
            if (normal != null) textures[Strings.Normal] = normal;

            var mask = originalMaterial.GetTexture(Strings.HDRPLitRgmtaoPropertyName);
            if (mask != null) textures[Strings.MaskPBR] = mask;

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
            var material = traverse.Field("_originalMaterial").GetValue<Material>();
            if (material == null)
            {
                Debug.Log("XLGearModifier: _originalMaterial for " + materialController.name + " is null, attempting to one.");
                var sharedMaterial = materialController.targets.FirstOrDefault()?.sharedMaterial;
                material = sharedMaterial == null ? new Material(Shader.Find("HDRP/Lit")) : new Material(sharedMaterial);
            }

            material.shader = GetClothingShader();
        }

        /// <summary>
        /// Creates a dictionary of default textures for albedo, normal, and mask pbr using the empty textures in our project.
        /// </summary>
        public Dictionary<string, Texture> CreateDefaultTextureDictionary()
        {
            var textures = new Dictionary<string, Texture>
            {
                { Strings.Albedo, GearManager.Instance.EmptyAlbedo },
                { Strings.Normal, GearManager.Instance.EmptyNormalMap },
                { Strings.MaskPBR, GearManager.Instance.EmptyMaskPBR }
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

            typeFilter.includedTypes.Add(type);
        }
        #endregion

        #region GearTemplate methods
        /// <summary>
        /// Adds the Prefix and Prefix Alias (if exists) to the CharGearTemplateForID dictionary in GearDatabase.
        /// </summary>
        private void AddGearTemplates()
        {
            if (!GearDatabase.Instance.ContainsClothingTemplateWithID(ClothingMetadata.CharacterGearTemplate.id))
            {
                GearDatabase.Instance.CharGearTemplateForID.Add(ClothingMetadata.CharacterGearTemplate.id, ClothingMetadata.CharacterGearTemplate);
            }

            if (!string.IsNullOrEmpty(ClothingMetadata.AliasCharacterGearTemplate?.id) &&
                !GearDatabase.Instance.ContainsClothingTemplateWithID(ClothingMetadata.AliasCharacterGearTemplate.id))
            {
                GearDatabase.Instance.CharGearTemplateForID.Add(ClothingMetadata.AliasCharacterGearTemplate.id, ClothingMetadata.AliasCharacterGearTemplate);
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
