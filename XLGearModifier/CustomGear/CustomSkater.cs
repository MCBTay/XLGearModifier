using SkaterXL.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SkaterXL.Gear;
using UnityEngine;
using XLGearModifier.Unity;

namespace XLGearModifier.CustomGear
{
    public class CustomSkater : CustomGearBase
    {
        public XLGMSkaterMetadata SkaterMetadata => Metadata as XLGMSkaterMetadata;

        public CustomSkater(XLGMSkaterMetadata metadata, GameObject prefab) 
            : base(metadata, prefab)
        {
        }

        public override void Instantiate()
        {
            var name = string.IsNullOrEmpty(SkaterMetadata.DisplayName) ? Prefab.name : SkaterMetadata.DisplayName;

            var skaterInfo = new SkaterInfo
            {
                stance = SkaterInfo.Stance.Regular,
                bodyID = SkaterMetadata.Prefix,
                name = name,
                GearFilters = GetCustomSkaterTypeFilters(),
            };
            GearDatabase.Instance.skaters.Add(skaterInfo);
            //Traverse.Create(GearDatabase.Instance).Method("GenerateGearListSource").GetValue();

            GearInfo = new CharacterBodyInfo(name, SkaterMetadata.Prefix, false, new List<MaterialChange>(), new string[] { });

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

                var texturePath = $"XLGearModifier/{Prefab.name}/{materialController.materialID}/";

                var textureChanges = new List<TextureChange>
                {
                    new TextureChange("albedo", texturePath + "albedo"),
                    new TextureChange("normal", texturePath + "normal"),
                    new TextureChange("maskpbr", texturePath + "maskpbr")
                };

                materialChanges.Add(new MaterialChange(materialController.materialID, textureChanges.ToArray()));
            }

            cbi.materialChanges = materialChanges;
        }

        private void CreateMaterialWithTexturesOnProperShader(MaterialController materialController)
        {
            if (materialController == null) return;

            var renderer = materialController.targets.FirstOrDefault()?.renderer;
            if (renderer == null) return;

            var textures = new Dictionary<string, Texture>();

            var target = materialController.targets.FirstOrDefault();
            if (target == null) return;

            var material = renderer.materials[target.materialIndex];

            textures.Add("albedo", material.GetTexture("_BaseColorMap") ?? AssetBundleHelper.Instance.EmptyAlbedo);
            textures.Add("normal", material.GetTexture("_NormalMap") ?? AssetBundleHelper.Instance.EmptyNormalMap);
            textures.Add("maskpbr", material.GetTexture("_MaskMap") ?? AssetBundleHelper.Instance.EmptyMaskPBR);

            var newMaterial = materialController.GenerateMaterialWithChanges(textures);
            //material.shader = Shader.Find("MasterShaderCloth_v1");
            materialController.SetMaterial(newMaterial);
        }

        private void AddBodyGearTemplate()
        {
            if (GearDatabase.Instance.CharBodyTemplateForID.ContainsKey(Metadata.Prefix.ToLower())) return;

            var newBodyTemplate = new CharacterBodyTemplate
            {
                id = Metadata.Prefix.ToLower(),
                path = $"XLGearModifier/{Prefab.name}",
                leftEyeLocalPosition = new Vector3(1, 0, 0),
                rightEyeLocalPosition = new Vector3(-1, 0, 0)
            };
            GearDatabase.Instance.CharBodyTemplateForID.Add(Metadata.Prefix.ToLower(), newBodyTemplate);
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
