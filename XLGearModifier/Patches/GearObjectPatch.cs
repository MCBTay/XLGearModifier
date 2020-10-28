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
			static void Postfix(GearObject __instance, string path, ref Task<GameObject> __result)
			{
				//TODO: Update this hardcoded nonsense.
				if (__instance.gearInfo.name.StartsWith("Long-Hair-Beanie--Hair"))
				{
					__result = Task.FromResult(GearManager.Instance.CustomGear[GearCategory.Hair].First().Prefab);
				}
			}
		}
	}
}
