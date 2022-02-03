using HarmonyLib;
using SkaterXL.Gear;
using UnityEngine;

namespace XLGearModifier.Patches
{
    public class GearPrefabControllerPatch
	{
		[HarmonyPatch(typeof(GearPrefabController), nameof(GearPrefabController.skinnedMeshRenderer), MethodType.Getter)]
		static class skinnedMeshRendererGetterPatch
		{
			static void Postfix(GearPrefabController __instance, ref SkinnedMeshRenderer __result)
			{
				if (__result == null)
				{
					var skinnedMeshRenderer = Traverse.Create(__instance).Field("_skinnedMeshRenderer");

					if (skinnedMeshRenderer.GetValue<SkinnedMeshRenderer>() == null)
						skinnedMeshRenderer.SetValue(__instance.GetComponentInChildren<SkinnedMeshRenderer>());

					__result = skinnedMeshRenderer.GetValue<SkinnedMeshRenderer>();
				}
			}
		}
	}
}
