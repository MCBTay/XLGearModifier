using HarmonyLib;
using System;
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
				foreach (var kvp in GearManager.Instance.CustomGear)
				{
					foreach (var customGear in kvp.Value)
					{
						if (customGear.GearInfo.name.Equals(name, StringComparison.InvariantCultureIgnoreCase))
						{
							return customGear;
						}
					}
				}

				return null;
			}
		}
	}
}
