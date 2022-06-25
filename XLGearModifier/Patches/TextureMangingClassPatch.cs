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
            /// <summary>
            /// Patching into LoadTextureAsync to prevent the base game from trying to load textures that it certainly won't be able to find.  Anything starting with XLGearModifier is
            /// something we're trying to handle internally, so this patch handles that.  If the texturePath does not start with XLGearModifier, we allow execution to flow to the game's method.
            /// </summary>
            /// <param name="texturePath">The texture path being evaluated.</param>
            /// <param name="__result">A Task<Texture> with the appropriate texture, if the texture path contains a known filename.  Else, is not modified.</Texture></param>
            /// <returns>True when the texturePath doesn't start with XLGearModifier, false otherwise.</returns>
			static bool Prefix(string texturePath, ref Task<Texture> __result)
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

            /// <summary>
            /// Checks to see if <see cref="texturePath"/> ends with any of the known "empty" texture names, and if so, updates <see cref="__result"/> to use them.
            /// </summary>
            /// <param name="texturePath">The texture path being evaluated.</param>
            /// <param name="__result">A Task<Texture> with the appropriate texture, if the texture path contains a known filename.  Else, is not modified.</Texture></param>
            /// <returns>True when a texture is found, false otherwise.</returns>
            private static bool IsEmptyTexture(string texturePath, ref Task<Texture> __result)
            {
                if (texturePath.EndsWith(Path.GetFileNameWithoutExtension(Strings.EmptyAlbedoFilename)))
                {
                    __result = Task.FromResult<Texture>(GearManager.Instance.EmptyAlbedo);
                    return true;
                }

                if (texturePath.EndsWith(Path.GetFileNameWithoutExtension(Strings.EmptyNormalFilename)))
                {
                    __result = Task.FromResult<Texture>(GearManager.Instance.EmptyNormalMap);
                    return true;
                }

                if (texturePath.EndsWith(Path.GetFileNameWithoutExtension(Strings.EmptyMaskFilename)))
                {
                    __result = Task.FromResult<Texture>(GearManager.Instance.EmptyMaskPBR);
                    return true;
                }

                return false;
            }

            /// <summary>
            /// A method to handle textures for custom skaters.
            /// </summary>
            /// <param name="templateName">The prefix of the custom skater being evaluated.</param>
            /// <param name="textureName">The name of the texture being evaluated.</param>
            /// <param name="textureType">The type of texture being evaluated.</param>
            /// <param name="__result">Updated to a reference of the texture, if one is found.</param>
            private static void HandleSkaterTexture(string templateName, string textureName, string textureType, ref Task<Texture> __result)
            {
                if (!GearManager.Instance.CustomSkaters.ContainsKey(templateName)) return;

                var customSkater = GearManager.Instance.CustomSkaters[templateName];
                if (customSkater == null) return;

                if (!customSkater.MaterialControllerTextures.ContainsKey(textureName)) return;

                var textures = customSkater.MaterialControllerTextures[textureName];
                __result = Task.FromResult(textures[textureType]);
            }

            /// <summary>
            /// A method to handle textures for custom clothing, which includes hair.
            /// </summary>
            /// <param name="templateName">The prefix of the custom clothing being evaluated.</param>
            /// <param name="textureName">The name of the texture being evaluated.</param>
            /// <param name="textureType">The type of texture being evaluated.</param>
            /// <param name="__result">Updated to a reference of the texture, if one is found.</param>
            private static void HandleClothingTexture(string templateName, string textureName, string textureType, ref Task<Texture> __result)
            {
                if (!GearManager.Instance.CustomGear.ContainsKey(templateName)) return;

                var customClothing = GearManager.Instance.CustomGear[templateName] as ClothingGear;
                if (customClothing == null) return;

                var materialController = customClothing.Prefab.GetComponentInChildren<MaterialController>();
                if (materialController == null) return;

                var target = materialController.targets.FirstOrDefault();
                if (target == null) return;

                var isHair = customClothing.ClothingMetadata.Category == Unity.ClothingGearCategory.Hair ||
                             customClothing.ClothingMetadata.Category == Unity.ClothingGearCategory.FacialHair;

                switch (textureType)
                {
                    case TextureTypes.Albedo:
                        __result = Task.FromResult(target.sharedMaterial.GetTexture(isHair ? Strings.HairAlbedoPropertyName : Strings.ClothAlbedoPropertyName));
                        break;
                    case TextureTypes.Normal:
                        __result = Task.FromResult(target.sharedMaterial.GetTexture(isHair ? Strings.HairNormalPropertyName : Strings.ClothNormalPropertyName));
                        break;
                    case TextureTypes.MaskPBR:
                        __result = Task.FromResult(target.sharedMaterial.GetTexture(isHair ? Strings.HairRgmtaoPropertyName : Strings.ClothRgmtaoPropertyName));
                        break;
                }
            }
        }
	}
}
