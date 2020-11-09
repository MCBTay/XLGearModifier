using HarmonyLib;
using XLGearModifier.Unity;

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

				if (index[0] < 0 && index.depth <= 1) return;
				bool isCustom = index[0] < gear.Length && index[1] >= gear[index[0]].Length;
				if (!isCustom) return;

				if (GearManager.Instance.CustomGear.ContainsKey((GearCategory)index[1]))
					__result += GearManager.Instance.CustomGear[(GearCategory)index[1]].Count;
			}
		}
	}
}
