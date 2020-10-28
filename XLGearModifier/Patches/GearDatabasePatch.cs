using HarmonyLib;
using System.Collections.Generic;

namespace XLGearModifier.Patches
{
	public class GearDatabasePatch
	{
		[HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetGearListAtIndex), new[] { typeof(IndexPath), typeof(bool) }, new[] { ArgumentType.Normal, ArgumentType.Out })]
		public static class GetGearListAtIndexPatch
		{
			static void Postfix(GearDatabase __instance, IndexPath index, ref GearInfo[] __result)
			{
				var gear = Traverse.Create(__instance).Field("gearListSource").GetValue<GearInfo[][][]>();

				if (index[1] < gear[index[0]].Length) return;

				var customGear = Traverse.Create(__instance).Field("customGearListSource").GetValue<GearInfo[][][]>();

				var tempIndex = index[1] - customGear[index[0]].Length;

				if (tempIndex != (int) GearCategory.Hair) return;


				List<GearInfo> customHair = new List<GearInfo>();
				foreach (var hair in GearManager.Instance.CustomGear[GearCategory.Hair])
				{
					customHair.Add(hair.GearInfo);
				}

				__result.AddRangeToArray(customHair.ToArray());
			}
		}

		[HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetGearAtIndex), new[] { typeof(IndexPath), typeof(bool) }, new[] { ArgumentType.Normal, ArgumentType.Out })]
		public static class GetGearAtIndexPatch
		{
			static void Postfix(GearDatabase __instance, IndexPath index, ref GearInfo __result)
			{
				if (index.depth < 3) return;
				if (index[1] < 10) return;

				var tempIndex = index[1] - 10;

				if (tempIndex != (int) GearCategory.Hair) return;

				foreach (var hair in GearManager.Instance.CustomGear[GearCategory.Hair])
				{
					__result = hair.GearInfo;
				}
			}
		}
	}
}
