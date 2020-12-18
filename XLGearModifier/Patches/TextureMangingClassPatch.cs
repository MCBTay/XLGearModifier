using HarmonyLib;
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
				if (texturePath.StartsWith("XLGearModifier"))
				{
					__result = Task.FromResult<Texture>(AssetBundleHelper.emptyAlbedo);
					return false;
				}

				return true;
			}
		}
	}
}
