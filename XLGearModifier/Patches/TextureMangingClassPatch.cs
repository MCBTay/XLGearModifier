using HarmonyLib;
using System.Linq;
using System.Threading.Tasks;
using SkaterXL.Data;
using SkaterXL.Gear;
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

				if (texturePath.EndsWith("Empty_Albedo.png"))
				{
					__result = Task.FromResult<Texture>(AssetBundleHelper.Instance.EmptyAlbedo);
					return false;
				}

                if (texturePath.EndsWith("Empty_Normal_Map.png"))
                {
                    __result = Task.FromResult<Texture>(AssetBundleHelper.Instance.EmptyNormalMap);
                    return false;
				}

                if (texturePath.EndsWith("Empty_Maskpbr_Map.png"))
                {
                    __result = Task.FromResult<Texture>(AssetBundleHelper.Instance.EmptyMaskPBR);
                    return false;
				}

                if (split.Length < 4) return true;

                var prefabName = split[1];
                var textureName = split[2];
                var textureType = split[3];

                var customGear = GearManager.Instance.CustomGear.FirstOrDefault(x => x.Prefab.name == prefabName);
                if (customGear == null) return true;

                if (customGear.GearInfo is CharacterBodyInfo cbi)
                {
                    //TODO: Assumes 1 target per controller.  Update to handle more
                    var materialController = customGear.Prefab.GetComponentsInChildren<MaterialController>().FirstOrDefault(x => x.materialID == textureName);
                    __result = Task.FromResult<Texture>(materialController.targets[0].renderer.materials[materialController.targets[0].materialIndex].mainTexture);

                    return false;
                }

                var defaultTexture = customGear.Metadata?.GetMaterialInformation()?.DefaultTexture;
                var altTextures = customGear.Metadata?.GetMaterialInformation()?.AlternativeTextures;

                if (textureName == defaultTexture?.textureName)
                {
                    __result = Task.FromResult<Texture>(GetTextureByType(defaultTexture, textureType));
                }
                else if (altTextures != null && altTextures.Any(x => textureName == x.textureName && x.textureColor != null))
                {
                    __result = Task.FromResult<Texture>(GetTextureByType(altTextures.FirstOrDefault(x => textureName == x.textureName), textureType));
                }
                return false;
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
