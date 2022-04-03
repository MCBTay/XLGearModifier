﻿using System.IO;
using HarmonyLib;
using SkaterXL.Data;
using SkaterXL.Gear;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using XLGearModifier.CustomGear;

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

				var split = texturePath.Split('/');

				if (texturePath.EndsWith(Path.GetFileNameWithoutExtension(GearManager.EmptyAlbedoFilename)))
				{
					__result = Task.FromResult<Texture>(GearManager.Instance.EmptyAlbedo);
					return false;
				}

                if (texturePath.EndsWith(Path.GetFileNameWithoutExtension(GearManager.EmptyNormalFilename)))
                {
                    __result = Task.FromResult<Texture>(GearManager.Instance.EmptyNormalMap);
                    return false;
				}

                if (texturePath.EndsWith(Path.GetFileNameWithoutExtension(GearManager.EmptyMaskFilename)))
                {
                    __result = Task.FromResult<Texture>(GearManager.Instance.EmptyMaskPBR);
                    return false;
				}

                if (split.Length < 4) return true;

                var templateName = split[1];
                var textureName = split[2];
                var textureType = split[3];

                if (!GearManager.Instance.CustomGear.ContainsKey(templateName)) return true;

                var customGear = GearManager.Instance.CustomGear[templateName];

                if (customGear is Skater skater)
                {
                    if (!skater.MaterialControllerTextures.ContainsKey(textureName)) return false;

                    var textures = skater.MaterialControllerTextures[textureName];
                    __result = Task.FromResult(textures[textureType]);
                }

                return false;
			}
        }
	}
}
