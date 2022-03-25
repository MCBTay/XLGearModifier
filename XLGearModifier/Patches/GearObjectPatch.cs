using HarmonyLib;
using System.Threading.Tasks;
using UnityEngine;
using XLGearModifier.CustomGear;
using XLGearModifier.Texturing;

namespace XLGearModifier.Patches
{
    public class GearObjectPatch
	{
        [HarmonyPatch(typeof(GearObject), "LoadPrefab")]
		public static class LoadPrefabPatch
		{
			static bool Prefix(GearObject __instance, string path, ref Task<GameObject> __result)
			{
                if (!path.StartsWith("XLGearModifier")) return true;

                if (__instance.gearInfo.type == "eyes")
                {
                    var customizer = Traverse.Create(__instance).Field("customizer").GetValue<CharacterCustomizer>();

                    EyeTextureManager.Instance.GetGameObjectReference(customizer);
                    __result = Task.FromResult(EyeTextureManager.Instance.EyesGameObject);
                    return false;
                }

                var customGear = GearManager.Instance.CustomGear[__instance.gearInfo.type];
                if (customGear == null) return true;

				__result = Task.FromResult(customGear.Prefab);
				return false;
			}
		}
    }
}
