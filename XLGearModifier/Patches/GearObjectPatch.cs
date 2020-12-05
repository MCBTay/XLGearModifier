using HarmonyLib;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;

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

				var customGear = GearManager.Instance.CustomGear.FirstOrDefault(x => x.GearInfo.type == __instance.gearInfo.type);
				if (customGear == null) return true;

				__result = Task.FromResult(customGear.Prefab);
				return false;
			}
		}
	}
}
