using HarmonyLib;
using System;
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
				var match = FindGear(__instance.gearInfo.name);
				if (match != null)
				{
					__result = Task.FromResult(match.Prefab);
				}
			}

			private static CustomGear FindGear(string name)
			{
				return GearManager.Instance.CustomGear.FirstOrDefault(customGear => customGear.GearInfo.name.Equals(name, StringComparison.InvariantCultureIgnoreCase));
			}
		}
	}
}
