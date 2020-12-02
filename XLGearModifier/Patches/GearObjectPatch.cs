using HarmonyLib;
using System.Threading.Tasks;
using UnityEngine;
using XLMenuMod.Utilities.Gear;

namespace XLGearModifier.Patches
{
	public class GearObjectPatch
	{
		[HarmonyPatch(typeof(GearObject), "LoadPrefab")]
		public static class LoadPrefabPatch
		{
			static void Postfix(GearObject __instance, string path, ref Task<GameObject> __result)
			{
				var gearInfo = __instance.gearInfo as CustomCharacterGearInfo;
				if (gearInfo?.Info?.GetParentObject() is CustomGear parentObject)
				{
					__result = Task.FromResult(parentObject.Prefab);
				}
			}
		}
	}
}
