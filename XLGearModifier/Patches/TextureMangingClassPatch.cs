using HarmonyLib;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using SkaterXL.Gear;
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

                HandleSkaterTexture(templateName, textureName, textureType, ref __result);
                HandleClothingTexture(templateName, textureName, textureType, ref __result);

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

            private static void HandleSkaterTexture(string templateName, string textureName, string textureType, ref Task<Texture> __result)
            {
                if (!GearManager.Instance.CustomSkaters.ContainsKey(templateName)) return;

                var customSkater = GearManager.Instance.CustomSkaters[templateName];
                if (customSkater == null) return;

                if (!customSkater.MaterialControllerTextures.ContainsKey(textureName)) return;

                var textures = customSkater.MaterialControllerTextures[textureName];
                __result = Task.FromResult(textures[textureType]);
            }

            private static void HandleClothingTexture(string templateName, string textureName, string textureType, ref Task<Texture> __result)
            {
                if (!GearManager.Instance.CustomGear.ContainsKey(templateName)) return;

                var customClothing = GearManager.Instance.CustomGear[templateName];
                if (customClothing == null) return;

                var materialController = customClothing.Prefab.GetComponentInChildren<MaterialController>();
                if (materialController == null) return;

                var target = materialController.targets.FirstOrDefault();
                if (target == null) return;

                switch (textureType)
                {
                    case TextureTypes.Albedo:
                        __result = Task.FromResult(target.sharedMaterial.GetTexture(MasterShaderClothTextureConstants.ColorTextureName));
                        break;
                    case TextureTypes.Normal:
                        __result = Task.FromResult(target.sharedMaterial.GetTexture(MasterShaderClothTextureConstants.NormalTextureName));
                        break;
                    case TextureTypes.MaskPBR:
                        __result = Task.FromResult(target.sharedMaterial.GetTexture(MasterShaderClothTextureConstants.RgmtaoTextureName));
                        break;
                }
            }
        }
	}
}
