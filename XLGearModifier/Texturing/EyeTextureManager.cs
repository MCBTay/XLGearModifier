using HarmonyLib;
using SkaterXL.Data;
using SkaterXL.Gear;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using XLGearModifier.Utilities;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Interfaces;

namespace XLGearModifier.Texturing
{
    public class EyeTextureManager
    {
        private static EyeTextureManager __instance;
        public static EyeTextureManager Instance => __instance ?? (__instance = new EyeTextureManager());

        private Dictionary<string, Texture> OriginalEyeTextures;

        public List<ICustomInfo> Eyes;

        public CharacterGearTemplate EyeGearTemplate;

        public Dictionary<string, GameObject> EyesGameObjects;

        public EyeTextureManager()
        {
            OriginalEyeTextures = new Dictionary<string, Texture>();
            Eyes = new List<ICustomInfo>();
            EyesGameObjects = new Dictionary<string, GameObject>();
        }

        public void AddEyeTemplate()
        {
            EyeGearTemplate = new CharacterGearTemplate
            {
                alphaMasks = new List<GearAlphaMaskConfig>(),
                id = "eyes",
                path = "XLGearModifier/eyes",
                categoryName = "Hat"
            };

            if (GearDatabase.Instance.CharGearTemplateForID.ContainsKey(EyeGearTemplate.id)) return;

            GearDatabase.Instance.CharGearTemplateForID.Add(EyeGearTemplate.id, EyeGearTemplate);
        }

        public void GetGameObjectReference(CharacterCustomizer customizer)
        {
            if (EyesGameObjects.ContainsKey(customizer.name)) return;

            var traverse = Traverse.Create(customizer);

            var currentBodyGO = traverse.Field("currentBody").GetValue<CharacterBodyObject>()?.gameObject;

            if (customizer.name == "Playback Skater Root")
            {
                // reset current body go
            }
            
            var eyeRenderers = currentBodyGO?
                .GetComponentsInChildren<SkinnedMeshRenderer>(true)
                .Where(x => x.name.Contains("eye_mesh"));

            if (eyeRenderers == null) return;

            foreach (var eyeRenderer in eyeRenderers)
            {
                if (!EyesGameObjects.ContainsKey(customizer.name))
                {
                    EyesGameObjects.Add(customizer.name, eyeRenderer.gameObject.transform.parent.parent.gameObject);
                }

                PopulateOriginalEyeTextureDictionary(eyeRenderer);

                var materialController = eyeRenderer.gameObject.GetComponent<MaterialController>();
                if (materialController == null)
                {
                    materialController = eyeRenderer.gameObject.AddComponent<MaterialController>();
                    materialController.alphaMasks = Array.Empty<AlphaMaskTextureInfo>();
                    SetPropertyNameSubstitutions(materialController);
                    materialController.FindTargets();
                }

                var gearPrefabController = eyeRenderer.gameObject.GetComponent<GearPrefabController>();
                if (gearPrefabController == null)
                {
                    gearPrefabController = eyeRenderer.gameObject.AddComponent<GearPrefabController>();
                    gearPrefabController.PreparePrefab();
                }
            }
        }

        private void PopulateOriginalEyeTextureDictionary(SkinnedMeshRenderer eyeRenderer)
        {
            if (!OriginalEyeTextures.ContainsKey(TextureTypes.Albedo))
            {
                OriginalEyeTextures.Add(TextureTypes.Albedo, eyeRenderer.material.GetTexture(EyeTextureConstants.ColorTextureName));
            }

            if (!OriginalEyeTextures.ContainsKey(TextureTypes.Normal))
            {
                OriginalEyeTextures.Add(TextureTypes.Normal, eyeRenderer.material.GetTexture(EyeTextureConstants.NormalTextureName));
            }

            if (!OriginalEyeTextures.ContainsKey(TextureTypes.MaskPBR))
            {
                OriginalEyeTextures.Add(TextureTypes.MaskPBR, eyeRenderer.material.GetTexture(EyeTextureConstants.RgmtaoTextureName));
            }
        }

        public void LookForEyeTextures()
        {
            var eyeTextures = Directory.GetFiles(SaveManager.Instance.CustomGearDir, "Eyes_*.png", SearchOption.AllDirectories).ToList();
            if (!eyeTextures.Any()) return;

            Eyes.Clear();

            var gearInfos = GearDatabase.GetGearIn(eyeTextures, true);

            foreach (var gearInfo in gearInfos)
            {
                var characterGearInfo = gearInfo as CharacterGearInfo;
                if (characterGearInfo == null) continue;

                var newGearInfo = new CustomCharacterGearInfo(gearInfo.name, gearInfo.type, gearInfo.isCustom, characterGearInfo.textureChanges, gearInfo.tags);
                Eyes.Add(newGearInfo.Info);
            }
        }

        private List<MaterialController> SetupMaterialControllers(CharacterCustomizer customizer)
        {
            var materialControllers = new List<MaterialController>();

            var traverse = Traverse.Create(customizer);
            var currentBody = traverse.Field("currentBody").GetValue<CharacterBodyObject>();

            var eyeRenderers = currentBody.gameObject.GetComponentsInChildren<SkinnedMeshRenderer>(true).Where(x => x.name.Contains("eye_mesh"));

            foreach (var eyeRenderer in eyeRenderers)
            {
                if (!OriginalEyeTextures.ContainsKey(TextureTypes.Albedo))
                {
                    OriginalEyeTextures.Add(TextureTypes.Albedo, eyeRenderer.material.GetTexture(EyeTextureConstants.ColorTextureName));
                }

                if (!OriginalEyeTextures.ContainsKey(TextureTypes.Normal))
                {
                    OriginalEyeTextures.Add(TextureTypes.Normal, eyeRenderer.material.GetTexture(EyeTextureConstants.NormalTextureName));
                }

                if (!OriginalEyeTextures.ContainsKey(TextureTypes.MaskPBR))
                {
                    OriginalEyeTextures.Add(TextureTypes.MaskPBR, eyeRenderer.material.GetTexture(EyeTextureConstants.RgmtaoTextureName));
                }

                var materialController = eyeRenderer.gameObject.GetComponent<MaterialController>();
                if (materialController == null)
                {
                    materialController = eyeRenderer.gameObject.AddComponent<MaterialController>();
                }

                materialController.alphaMasks = Array.Empty<AlphaMaskTextureInfo>();

                SetPropertyNameSubstitutions(materialController);

                materialController.FindTargets();
                materialControllers.Add(materialController);
            }

            return materialControllers;
        }

        private void SetPropertyNameSubstitutions(MaterialController materialController)
        {
            var propNameSubsTraverse = Traverse.Create(materialController).Field("m_propertyNameSubstitutions");

            propNameSubsTraverse.SetValue(new List<PropertyNameSubstitution>());
            
            var propNameSubs = propNameSubsTraverse.GetValue<List<PropertyNameSubstitution>>();

            propNameSubs.Add(new PropertyNameSubstitution { oldName = MasterShaderClothTextureConstants.ColorTextureName, newName = EyeTextureConstants.ColorTextureName });
            propNameSubs.Add(new PropertyNameSubstitution { oldName = MasterShaderClothTextureConstants.NormalTextureName, newName = EyeTextureConstants.NormalTextureName });
            propNameSubs.Add(new PropertyNameSubstitution { oldName = MasterShaderClothTextureConstants.RgmtaoTextureName, newName = EyeTextureConstants.RgmtaoTextureName });
        }


        /// <summary>
        /// Applies textures passed in via gearInfo to the passed in MeshRenderer.
        /// </summary>
        /// <param name="renderer">The renderer to apply the textures to.</param>
        public void SetEyeTextures(CharacterCustomizer customizer, CharacterGearInfo characterGearInfo)
        {
            var materialControllers = SetupMaterialControllers(customizer);

            var dict = new Dictionary<string, Texture>();

            foreach (var textureChange in characterGearInfo.textureChanges)
            {
                var texture = new Texture2D(2, 2);
                if (!texture.LoadImage(File.ReadAllBytes(textureChange.texturePath))) continue;

                dict.Add(textureChange.textureID, texture);
            }

            foreach (var materialController in materialControllers)
            {
                materialController.SetMaterial(materialController.GenerateMaterialWithChanges(dict));
            }
        }

        public void SetEyeTexturesBackToDefault(CharacterCustomizer customizer)
        {
            if (OriginalEyeTextures == null) return;
            if (!OriginalEyeTextures.Any()) return;

            var materialControllers = SetupMaterialControllers(customizer);

            foreach (var materialController in materialControllers)
            {
                materialController.SetMaterial(materialController.GenerateMaterialWithChanges(OriginalEyeTextures));
            }
        }
    }
}
