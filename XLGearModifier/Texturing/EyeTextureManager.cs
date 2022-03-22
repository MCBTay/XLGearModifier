﻿using HarmonyLib;
using SkaterXL.Data;
using SkaterXL.Gear;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Interfaces;

namespace XLGearModifier.Texturing
{
    public  class EyeTextureManager
    {
        private static EyeTextureManager __instance;
        public static EyeTextureManager Instance => __instance ?? (__instance = new EyeTextureManager());

        private Texture OriginalEyeTexture;

        private const string ColorTextureName = "Texture2D_4128E5C7";
        private const string NormalTextureName = "Texture2D_BEC07F52";
        private const string RgmtaoTextureName = "Texture2D_B56F9766";

        private List<MaterialController> PreviewEyeMaterialControllers;

        public List<ICustomInfo> Eyes;

        public EyeTextureManager()
        {
            PreviewEyeMaterialControllers = new List<MaterialController>();
            Eyes = new List<ICustomInfo>();
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

        private void SetupMaterialControllers(CharacterCustomizer customizer)
        {
            var traverse = Traverse.Create(customizer);
            var currentBody = traverse.Field("currentBody").GetValue<CharacterBodyObject>();

            var eyeRenderers = currentBody.gameObject.GetComponentsInChildren<SkinnedMeshRenderer>(true).Where(x => x.name.Contains("eye_mesh"));

            foreach (var eyeRenderer in eyeRenderers)
            {
                if (OriginalEyeTexture == null)
                {
                    OriginalEyeTexture = eyeRenderer.material.GetTexture(ColorTextureName);
                }

                var materialController = eyeRenderer.gameObject.GetComponent<MaterialController>();
                if (materialController == null)
                {
                    materialController = eyeRenderer.gameObject.AddComponent<MaterialController>();
                }

                materialController.alphaMasks = Array.Empty<AlphaMaskTextureInfo>();

                SetPropertyNameSubstitutions(materialController);

                materialController.FindTargets();
                PreviewEyeMaterialControllers.Add(materialController);
            }
        }

        private void SetPropertyNameSubstitutions(MaterialController materialController)
        {
            var traverse = Traverse.Create(materialController);
            traverse.Field("m_propertyNameSubstitutions").SetValue(new List<PropertyNameSubstitution>());

            if (!materialController.PropertyNameSubstitutions.ContainsKey("albedo"))
            {
                materialController.PropertyNameSubstitutions.Add("albedo", ColorTextureName);
            }

            if (!materialController.PropertyNameSubstitutions.ContainsKey("normal"))
            {
                materialController.PropertyNameSubstitutions.Add("normal", NormalTextureName);
            }

            if (!materialController.PropertyNameSubstitutions.ContainsKey("rgmtao"))
            {
                materialController.PropertyNameSubstitutions.Add("rgmtao", RgmtaoTextureName);
            }
        }


        /// <summary>
        /// Applies textures passed in via gearInfo to the passed in MeshRenderer.
        /// </summary>
        /// <param name="renderer">The renderer to apply the textures to.</param>
        public void SetEyeTextures(CharacterCustomizer customizer, CharacterGearInfo characterGearInfo)
        {
            SetupMaterialControllers(customizer);

            var dict = new Dictionary<string, Texture>();

            foreach (var textureChange in characterGearInfo.textureChanges)
            {
                var texture = new Texture2D(2, 2);
                if (!texture.LoadImage(File.ReadAllBytes(textureChange.texturePath))) continue;

                dict.Add(textureChange.textureID, texture);
            }

            foreach (var materialController in PreviewEyeMaterialControllers)
            {
                materialController.SetMaterial(materialController.GenerateMaterialWithChanges(dict));
            }
        }
    }
}
