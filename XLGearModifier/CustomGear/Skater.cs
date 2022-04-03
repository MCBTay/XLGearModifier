using SkaterXL.Data;
using SkaterXL.Gear;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HarmonyLib;
using UnityEngine;
using XLGearModifier.Texturing;
using XLGearModifier.Unity;
using XLGearModifier.Utilities;

namespace XLGearModifier.CustomGear
{
    public class Skater : CustomGearBase
    {
        public XLGMSkaterMetadata SkaterMetadata => Metadata as XLGMSkaterMetadata;

        public Dictionary<string, Dictionary<string, Texture>> MaterialControllerTextures;

        public const string HDRPLitColorName = "_BaseColorMap";
        public const string HDRPLitNormalName = "_NormalMap";
        public const string HDRPLitMaskName = "_MaskMap";

        public Skater(XLGMSkaterMetadata metadata, GameObject prefab) : base(metadata, prefab)
        {
            MaterialControllerTextures = new Dictionary<string, Dictionary<string, Texture>>();
        }

        public override void Instantiate()
        {
            var name = string.IsNullOrEmpty(SkaterMetadata.DisplayName) ? Prefab.name : SkaterMetadata.DisplayName;

            var skaterInfo = new SkaterInfo
            {
                stance = SkaterInfo.Stance.Regular,
                bodyID = SkaterMetadata.CharacterBodyTemplate.id,
                name = name,
                GearFilters = GetCustomSkaterTypeFilters(),
            };
            GearDatabase.Instance.skaters.Add(skaterInfo);
            Traverse.Create(GearDatabase.Instance).Method("GenerateGearListSource").GetValue();

            GearInfo = new CharacterBodyInfo(name, SkaterMetadata.CharacterBodyTemplate.id, false, new List<MaterialChange>(), new string[] { });

            SetTexturesAndShader();

            AddBodyGearTemplate();
            GearDatabase.Instance.bodyGear.Add(GearInfo as CharacterBodyInfo);
        }

        private void SetTexturesAndShader()
        {
            if (SkaterMetadata == null) return;

            var cbi = GearInfo as CharacterBodyInfo;
            if (cbi == null) return;

            var materialControllers = Prefab.GetComponentsInChildren<MaterialController>();
            if (materialControllers == null || !materialControllers.Any()) return;

            var materialChanges = new List<MaterialChange>();

            foreach (var materialController in materialControllers)
            {
                CreateMaterialWithTexturesOnProperShader(materialController);

                var texturePath = $"XLGearModifier/{SkaterMetadata.CharacterBodyTemplate.id}/{materialController.materialID}/";

                var textureChanges = new List<TextureChange>
                {
                    new TextureChange(HDRPLitColorName, texturePath + HDRPLitColorName),
                    new TextureChange(HDRPLitNormalName, texturePath + HDRPLitNormalName),
                    new TextureChange(HDRPLitMaskName, texturePath + HDRPLitMaskName)
                };

                materialChanges.Add(new MaterialChange(materialController.materialID, textureChanges.ToArray()));
            }

            cbi.materialChanges = materialChanges;
        }

        private void CreateMaterialWithTexturesOnProperShader(MaterialController materialController)
        {
            if (materialController == null) return;

            SetPropertyNameSubstitutions(materialController);

            var target = materialController.targets.FirstOrDefault();
            if (target == null) return;

            var renderer = target.renderer;
            if (renderer == null) return;

            var textures = new Dictionary<string, Texture>();

            var material = renderer.materials[target.materialIndex];

            textures.Add(HDRPLitColorName, material.GetTexture(HDRPLitColorName) ?? GearManager.Instance.EmptyAlbedo);
            textures.Add(HDRPLitNormalName, material.GetTexture(HDRPLitNormalName) ?? GearManager.Instance.EmptyNormalMap);
            textures.Add(HDRPLitMaskName, material.GetTexture(HDRPLitMaskName) ?? GearManager.Instance.EmptyMaskPBR);

            MaterialControllerTextures.Add(materialController.materialID, textures);

            var newMaterial = materialController.GenerateMaterialWithChanges(textures);
            materialController.SetMaterial(newMaterial);
        }

        /// <summary>
        /// Sets property name substitutions to handle all of our assets coming from HDRP/Lit to go to Easy Day shaders.  Most of this code
        /// can hopefully get removed once we get native access to their shaders.  Also adds property name substitutions for hair, to mimic what
        /// Easy Day does with their own hair meshes in editor.
        /// </summary>
        /// <param name="materialController">The material controller to operate on</param>
        private void SetPropertyNameSubstitutions(MaterialController materialController)
        {
            //TODO: This 3 entries below can likely be removed once we get access to their shaders.
            var propNameSubs = new List<PropertyNameSubstitution>
            {
                new PropertyNameSubstitution { oldName = MasterShaderClothTextureConstants.ColorTextureName, newName = HDRPLitColorName },
                new PropertyNameSubstitution { oldName = MasterShaderClothTextureConstants.NormalTextureName, newName = HDRPLitNormalName },
                new PropertyNameSubstitution { oldName = MasterShaderClothTextureConstants.RgmtaoTextureName, newName = HDRPLitMaskName }
            };

            var traverse = Traverse.Create(materialController);
            traverse.Field("m_propertyNameSubstitutions").SetValue(propNameSubs);
        }

        private void AddBodyGearTemplate()
        {
            if (GearDatabase.Instance.CharBodyTemplateForID.ContainsKey(SkaterMetadata.CharacterBodyTemplate.id)) return;

            GearDatabase.Instance.CharBodyTemplateForID.Add(SkaterMetadata.CharacterBodyTemplate.id, SkaterMetadata.CharacterBodyTemplate);
        }

        public override Task<GameObject> GetBaseObject()
        {
            throw new NotImplementedException();
        }

        public override int GetCategoryIndex(int skaterIndex)
        {
            throw new NotImplementedException();
        }

        /// <summary>
		/// Creates a list of type filters for custom skaters.  This controls what "texture groups" they do/don't have access to, and which prefixes to use.
		/// By default, custom skaters currently only have access to custom board textures.
		/// </summary>
		/// <returns>List of TypeFilters</returns>
		private TypeFilterList GetCustomSkaterTypeFilters()
        {
            return new TypeFilterList(new List<TypeFilter>
            {
                new TypeFilter
                {
                    allowCustomGear = true,
                    cameraView = GearRoomCameraView.FullSkater,
                    excludedTags = new string[] { },
                    includedTypes = new [] { SkaterMetadata.CharacterBodyTemplate.id },
                    label = "Skin Tone",
                    requiredTag = ""
                },
                new TypeFilter
                {
                    allowCustomGear = true,
                    cameraView = GearRoomCameraView.Deck,
                    excludedTags = new[] { "ProOnly" },
                    includedTypes = new[] { "Deck" },
                    label = "Deck",
                    requiredTag = ""
                },
                new TypeFilter
                {
                    allowCustomGear = true,
                    cameraView = GearRoomCameraView.Grip,
                    excludedTags = new[] { "ProOnly" },
                    includedTypes = new[] { "GripTape" },
                    label = "Griptape",
                    requiredTag = ""
                },
                new TypeFilter
                {
                    allowCustomGear = true,
                    cameraView = GearRoomCameraView.Truck,
                    excludedTags = new[] { "ProOnly" },
                    includedTypes = new [] { "Trucks", "TrucksIndependent", "TrucksThunder", "TrucksVenture" },
                    label = "Trucks",
                    requiredTag = ""
                },
                new TypeFilter
                {
                    allowCustomGear = true,
                    cameraView = GearRoomCameraView.Wheel,
                    excludedTags = new[] { "ProOnly" },
                    includedTypes = new [] { "Wheels" },
                    label = "Wheels",
                    requiredTag = ""
                }
            });
        }
    }
}
