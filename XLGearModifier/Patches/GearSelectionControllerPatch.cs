using HarmonyLib;
using System.Linq;

namespace XLGearModifier.Patches
{
	public class GearSelectionControllerPatch
	{
		[HarmonyPatch(typeof(GearSelectionController), nameof(GearSelectionController.GetNumberOfItems))]
		public static class GetNumberOfItemsPatch
		{
			static void Postfix(ref int __result, IndexPath index)
			{
				var gear = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();

				if (index[0] < 0) return;
				bool isCustom = index[0] < gear.Length && index[1] >= gear[index[0]].Length;
				if (!isCustom) return;

				var customIndex = index[1] - gear[index[0]].Length;
				__result += GearManager.Instance.CustomGear[(GearCategory)customIndex].Count;
			}
		}
	}
}
