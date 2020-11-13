using System.Collections.Generic;
using System.Linq;
using HarmonyLib;
using TMPro;
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
				if (index[0] < 0) return;
				
				if (index.depth == 1)
				{
					__result = 2 * GearDatabase.Instance.skaters[index[0]].GearFilters.Count + 1;
				}

				if (index.depth <= 1) return;

				if (index.depth == 2 && index[1] == 20)
				{
					__result = GearManager.Instance.CustomGear.Count;
				}
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), nameof(GearSelectionController.ConfigureHeaderView))]
		public static class ConfigureHeaderViewPatch
		{
			static void Postfix(IndexPath index, MVCListHeaderView itemView)
			{
				if (index.depth == 2 && index[1] == 20)
				{
					itemView.SetText("Custom Meshes");
				}
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), nameof(GearSelectionController.ConfigureListItemView))]
		public static class ConfigureListItemViewPatch
		{
			static void Postfix(GearSelectionController __instance, IndexPath index, ref MVCListItemView itemView)
			{
				if (index.depth == 3 && index[1] == 20)
				{
					GearInfo gearAtIndex = GearDatabase.Instance.GetGearAtIndex(index, out bool _);

					if (gearAtIndex == null)
					{
						itemView.SetText("NOT FOUND", false);
						Traverse.Create(GearSelectionController.Instance).Method("SetIsEquippedIndicators", itemView, false).GetValue();
					}

					// To ensure the items have the proper font and weight.
					itemView.Label.font = FontDatabase.bookOblique;
					itemView.Label.fontStyle = FontStyles.Normal;

					itemView.SetText(gearAtIndex.name, true);

					Traverse.Create(__instance).Method("SetIsEquippedIndicators", itemView, __instance.previewCustomizer.HasEquipped(gearAtIndex)).GetValue();
				}
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), "ListView_OnItemHighlightedEvent")]
		public static class ListView_OnItemHighlightedEventPatch
		{
			static void Postfix(GearSelectionController __instance, IndexPath index)
			{
				if (index.depth < 3) return;
				if (index[1] != 20) return;

				GearInfo gear = GearDatabase.Instance.GetGearAtIndex(index);

				var match = GearManager.Instance.CustomGear.FirstOrDefault(x => x.GearInfo.name == gear.name);
				if (match == null) return;
				
				switch (match.Category)
				{
					case GearCategory.Hair:
					case GearCategory.Headwear:
						__instance.SetCameraView(GearRoomCameraView.Head);
						break;
					case GearCategory.Top:
						__instance.SetCameraView(GearRoomCameraView.Top);
						break;
					case GearCategory.Bottom:
						__instance.SetCameraView(GearRoomCameraView.Bottom);
						break;
					case GearCategory.Shoes:
						__instance.SetCameraView(GearRoomCameraView.Shoes);
						break;
					default:
						__instance.SetCameraView(GearRoomCameraView.FullSkater);
						break;
				}
			}
		}
	}
}
