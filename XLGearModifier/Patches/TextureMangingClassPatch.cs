﻿using HarmonyLib;
using System.IO;
using System.Threading.Tasks;
using UnityEngine;
using XLGearModifier.CustomGear;
using XLGearModifier.Utilities;

namespace XLGearModifier.Patches
{
    public class TextureMangingClassPatch
	{
		[HarmonyPatch(typeof(TextureMangingClass), "LoadTextureAsync")]
		static class LoadTextureAsyncPatch
		{
			static bool Prefix(string texturePath, bool linear, ref Task<Texture> __result)
			{
				if (!texturePath.StartsWith("XLGearModifier")) return true;

                if (IsEmptyTexture(texturePath, ref __result)) return false;

                var split = texturePath.Split('/');
                if (split.Length < 4) return false;

                var templateName = split[1];
                var textureName = split[2];
                var textureType = split[3];

                if (!GearManager.Instance.CustomGear.ContainsKey(templateName)) return false;

                var customGear = GearManager.Instance.CustomGear[templateName];

                if (customGear is Skater skater)
                {
                    if (!skater.MaterialControllerTextures.ContainsKey(textureName)) return false;

                    var textures = skater.MaterialControllerTextures[textureName];
                    __result = Task.FromResult(textures[textureType]);
                }

                return false;
			}

            private static bool IsEmptyTexture(string texturePath, ref Task<Texture> __result)
            {
                if (texturePath.EndsWith(Path.GetFileNameWithoutExtension(EmptyTextureConstants.EmptyAlbedoFilename)))
                {
                    __result = Task.FromResult<Texture>(GearManager.Instance.EmptyAlbedo);
                    return true;
                }

                if (texturePath.EndsWith(Path.GetFileNameWithoutExtension(EmptyTextureConstants.EmptyNormalFilename)))
                {
                    __result = Task.FromResult<Texture>(GearManager.Instance.EmptyNormalMap);
                    return true;
                }

                if (texturePath.EndsWith(Path.GetFileNameWithoutExtension(EmptyTextureConstants.EmptyMaskFilename)))
                {
                    __result = Task.FromResult<Texture>(GearManager.Instance.EmptyMaskPBR);
                    return true;
                }

                return false;
            }
        }
	}
}
