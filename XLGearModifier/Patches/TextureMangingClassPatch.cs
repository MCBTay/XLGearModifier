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

				if (texturePath.EndsWith(GearManager.EmptyAlbedoFilename))
				{
					__result = Task.FromResult<Texture>(GearManager.Instance.EmptyAlbedo);
					return false;
				}

                if (texturePath.EndsWith(GearManager.EmptyNormalFilename))
                {
                    __result = Task.FromResult<Texture>(GearManager.Instance.EmptyNormalMap);
                    return false;
				}

                if (texturePath.EndsWith(GearManager.EmptyMaskFilename))
                {
                    __result = Task.FromResult<Texture>(GearManager.Instance.EmptyMaskPBR);
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

                return false;
			}
        }
	}
}
