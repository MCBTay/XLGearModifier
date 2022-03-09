using HarmonyLib;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityModManagerNet;

namespace XLGearModifier.Patches
{
    public class GearObjectPatch
	{
        [HarmonyPatch(typeof(CharacterGearObject), "LoadTask")]
        public static class LoadTaskPatch
        {
            static void Prefix(CharacterGearObject __instance)
            {
                UnityModManager.Logger.Log("XLGM: Loading char gear obj for " + __instance.template.path);
            }
        }

		[HarmonyPatch(typeof(GearObject), "LoadPrefab")]
		public static class LoadPrefabPatch
		{
			static bool Prefix(GearObject __instance, string path, ref Task<GameObject> __result)
			{
				UnityModManager.Logger.Log("XLGM: Loading prefab for " + path);

				if (!path.StartsWith("XLGearModifier")) return true;

				var customGear = GearManager.Instance.CustomGear.FirstOrDefault(x => x.GearInfo != null && x.GearInfo.type == __instance.gearInfo.type);
				if (customGear == null) return true;

				__result = Task.FromResult(customGear.Prefab);
				return false;
			}
		}
    }
}
