using HarmonyLib;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;

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

				var split = texturePath.Split('\\');

				if (texturePath.EndsWith("Empty_Albedo.png") || split.Length < 3)
				{
					__result = Task.FromResult<Texture>(AssetBundleHelper.emptyAlbedo);
					return false;
				}
				else
				{
					var prefabName = split[1];
					var textureName = split[2];

					var customGear = GearManager.Instance.CustomGear.FirstOrDefault(x => x.Prefab.name == prefabName);
					if (customGear == null) return true;

					var defaultTexture = customGear.Metadata?.GetMaterialInformation()?.DefaultTexture;
					var altTextures = customGear.Metadata?.GetMaterialInformation()?.AlternativeTextures;

					if (textureName == defaultTexture.textureName)
					{
						__result = Task.FromResult<Texture>(defaultTexture.textureColor);
					}
					else if (altTextures != null && altTextures.Any(x => textureName == x.textureName && x.textureColor != null))
					{
						__result = Task.FromResult<Texture>(altTextures.FirstOrDefault(x => textureName == x.textureName).textureColor);
					}
					return false;
				}
			}
		}
	}
}
