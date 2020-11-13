using HarmonyLib;
using System.Linq;

namespace XLGearModifier.Patches
{
	public class GearDatabasePatch
	{
		[HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetGearAtIndex), new[] { typeof(IndexPath), typeof(bool) }, new[] { ArgumentType.Normal, ArgumentType.Out })]
		public static class GetGearAtIndexPatch
		{
			static void Postfix(IndexPath index, ref GearInfo __result)
			{
				if (index.depth >= 3 && index[1] == 20)
				{
					__result = GearManager.Instance.CustomGear.ElementAt(index[2]).GearInfo;
				}
			}
		}
	}
}
