using System.IO;
using HarmonyLib;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using XLGearModifier.Unity.ScriptableObjects;

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

				if (texturePath.EndsWith("Empty_Albedo.png") || split.Length < 3)
				{
					__result = Task.FromResult<Texture>(AssetBundleHelper.Instance.emptyAlbedo);
					return false;
				}
				else
				{
					var prefabName = split[1];
					var textureName = split[2];
                    var textureType = split[3];

					var customGear = GearManager.Instance.CustomGear.FirstOrDefault(x => x.Prefab.name == prefabName);
					if (customGear == null) return true;

					var defaultTexture = customGear.Metadata?.GetMaterialInformation()?.DefaultTexture;
					var altTextures = customGear.Metadata?.GetMaterialInformation()?.AlternativeTextures;

					if (textureName == defaultTexture.textureName)
					{
						__result = Task.FromResult<Texture>(GetTextureByType(defaultTexture, textureType));
					}
					else if (altTextures != null && altTextures.Any(x => textureName == x.textureName && x.textureColor != null))
					{
                        __result = Task.FromResult<Texture>(GetTextureByType(altTextures.FirstOrDefault(x => textureName == x.textureName), textureType));
					}
					return false;
				}
			}

            private static Texture2D GetTextureByType(XLGMTextureInfo textureInfo, string type)
            {
                switch (type)
                {
					case "albedo": return textureInfo.textureColor;
					case "normal": return textureInfo.textureNormalMap;
					case "maskpbr": return textureInfo.textureMaskPBR;
                    default: return null;
                }
            }
		}
	}
}
