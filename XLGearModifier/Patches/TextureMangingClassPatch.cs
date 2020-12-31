using System.Collections.Generic;
using System.Linq;
using HarmonyLib;
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

				if (texturePath.EndsWith("Empty_Albedo.png"))
				{
					__result = Task.FromResult<Texture>(AssetBundleHelper.emptyAlbedo);
					return false;
				}
				else
				{
					var split = texturePath.Split('\\');
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
