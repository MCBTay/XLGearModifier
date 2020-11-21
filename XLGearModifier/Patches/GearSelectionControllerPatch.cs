using HarmonyLib;
using System;
using System.Linq;
using TMPro;
using UnityEngine.EventSystems;
using XLGearModifier.Unity;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;

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

				if (index[1] == 20)
				{
					if (index.depth == 2)
					{
						var items = GearManager.Instance.NestedItems;
						__result = GearManager.Instance.NestedItems.Count;
					}
					else if (index.depth >= 3)
					{
						__result = GearManager.Instance.CurrentFolder.HasChildren() ? GearManager.Instance.CurrentFolder.Children.Count : GearManager.Instance.NestedItems.Count;
					}
				}
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), nameof(GearSelectionController.ConfigureHeaderView))]
		public static class ConfigureHeaderViewPatch
		{
			static void Postfix(IndexPath index, MVCListHeaderView itemView)
			{
				if (index.depth < 2 || index[1] != 20) return;

				if (index.depth == 2)
				{
					itemView.SetText("Custom Meshes");
				}
				else if (index.depth >= 3)
				{
					itemView.Label.spriteAsset = AssetBundleHelper.GearModifierUISpriteSheet;
					itemView.SetText(GearManager.Instance.CurrentFolder.GetName().Replace("\\", "<sprite=0> "));
				}
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), nameof(GearSelectionController.ConfigureListItemView))]
		public static class ConfigureListItemViewPatch
		{
			static void Postfix(GearSelectionController __instance, IndexPath index, ref MVCListItemView itemView)
			{
				if (index.depth >= 3 && index[1] == 20)
				{
					itemView.Label.richText = true;

					GearInfo gearAtIndex = GearDatabase.Instance.GetGearAtIndex(index, out bool _);

					if (gearAtIndex == null)
					{
						itemView.SetText("NOT FOUND", false);
						Traverse.Create(GearSelectionController.Instance).Method("SetIsEquippedIndicators", itemView, false).GetValue();
					}

					if (AssetBundleHelper.GearModifierUISpriteSheet != null)
					{
						itemView.Label.spriteAsset = AssetBundleHelper.GearModifierUISpriteSheet;
					}

					if (gearAtIndex.name.StartsWith("\\"))
					{
						var newText = "<space=18px><sprite=0 tint=1>";
						itemView.SetText(gearAtIndex.name.Replace("\\", newText), true);
					}
					else if (gearAtIndex.name.Equals("..\\"))
					{
						itemView.SetText(gearAtIndex.name.Replace("..\\", "<space=18px><sprite=9 tint=1>Go Back"), true);
					}
					else
					{
						itemView.SetText(gearAtIndex.name, true);
					}

					// To ensure the items have the proper font and weight.
					itemView.Label.font = FontDatabase.bookOblique;
					itemView.Label.fontStyle = FontStyles.Normal;

					Traverse.Create(__instance).Method("SetIsEquippedIndicators", itemView, __instance.previewCustomizer.HasEquipped(gearAtIndex)).GetValue();
				}
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), "ListView_OnItemSelectedEvent")]
		public static class ListView_OnItemSelectedEventPatch
		{
			static bool Prefix(GearSelectionController __instance, IndexPath index)
			{
				if (index.depth >= 3 && index[1] == 20)
				{
					var gear = GearDatabase.Instance.GetGearAtIndex(index);

					if (gear is CustomGearFolderInfo selectedFolder)
					{
						selectedFolder.FolderInfo.Children = selectedFolder.FolderInfo.Children;

						var currentIndexPath =
							Traverse.Create(__instance.listView).Property<IndexPath>("currentIndexPath");

						if (selectedFolder.FolderInfo.GetName() == "..\\")
						{
							GearManager.Instance.CurrentFolder = selectedFolder.FolderInfo.Parent;
							currentIndexPath.Value = __instance.listView.currentIndexPath.Up();

							__instance.listView.UpdateList();
							__instance.listView.SetHighlighted(
								Traverse.Create(__instance.listView).Property<IndexPath>("currentIndexPath").Value, true);
						}
						else
						{
							if (index.depth == 3)
							{
								var match = GearManager.Instance.NestedItems.FirstOrDefault(x => x.Name == gear.name);
								if (match != null)
								{
									switch (Enum.Parse(typeof(GearCategory), match.Name.Replace("\\", string.Empty)))
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

							GearManager.Instance.CurrentFolder = selectedFolder.FolderInfo;

							if (GearManager.Instance.CurrentFolder.Parent != null)
							{
								currentIndexPath.Value = __instance.listView.currentIndexPath.Sub(
									GearManager.Instance.CurrentFolder.Parent.Children.IndexOf(GearManager.Instance
										.CurrentFolder));
							}
							else
							{
								var gearList = Traverse.Create(GearDatabase.Instance).Field("gearListSource")
									.GetValue<GearInfo[][][]>();
								currentIndexPath.Value = __instance.listView.currentIndexPath.Sub(
									GearManager.Instance.NestedItems.IndexOf(GearManager.Instance.CurrentFolder));
							}

							EventSystem.current.SetSelectedGameObject(null);
							__instance.listView.UpdateList();
						}

						return false;
					}

					if (index.depth >= 3)
					{
						if (__instance.previewCustomizer.HasEquipped((ICharacterCustomizationItem) gear))
							return false;
						try
						{
							__instance.previewCustomizer.EquipGear(gear);
							__instance.previewCustomizer.OnlyShowEquippedGear();
							Traverse.Create(__instance).Field<bool>("didChangeGear").Value = true;
						}
						catch (Exception ex)
						{
						}

						__instance.Save();
						__instance.listView.UpdateList();

						return false;
					}

					GearManager.Instance.CurrentFolder = null;
					return true;
				}

				return true;
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

				var match = GearManager.Instance.NestedItems.FirstOrDefault(x => x.Name == gear.name);
				if (match == null) return;


			}
		}

		[HarmonyPatch(typeof(GearSelectionController), "Update")]
		public static class UpdatePatch
		{
			static bool Prefix(GearSelectionController __instance)
			{
				if (__instance.listView.currentIndexPath.depth >= 3 && __instance.listView.currentIndexPath[1] == 20)
				{
					if (GearManager.Instance.CurrentFolder == null) return true;
					if (!PlayerController.Instance.inputController.player.GetButtonDown("B")) return true;

					UISounds.Instance?.PlayOneShotSelectMajor();

					GearManager.Instance.CurrentFolder = GearManager.Instance.CurrentFolder.Parent;
					Traverse.Create(__instance.listView).Property<IndexPath>("currentIndexPath").Value = __instance.listView.currentIndexPath.Up();

					__instance.listView.UpdateList();
					__instance.listView.SetHighlighted(Traverse.Create(__instance.listView).Property<IndexPath>("currentIndexPath").Value, true);

					return false;
				}

				return true;
			}
		}
	}
}
