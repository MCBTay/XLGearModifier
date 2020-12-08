using HarmonyLib;
using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine.EventSystems;
using UnityModManagerNet;
using XLGearModifier.Unity;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Interfaces;
using XLMenuMod.Utilities.UserInterface;

namespace XLGearModifier.Patches
{
	public class GearSelectionControllerPatch
	{
		[HarmonyPatch(typeof(GearSelectionController), nameof(GearSelectionController.GetNumberOfItems))]
		public static class GetNumberOfItemsPatch
		{
			static void Postfix(GearSelectionController __instance, ref int __result, IndexPath index)
			{
				if (index[0] < 0) return;
				
				if (index.depth == 1)
				{
					__result = 2 * GearDatabase.Instance.skaters[index[0]].GearFilters.Count + 4;
				}

				if (index.depth < 2) return;

				List<ICustomInfo> sourceList = null;

				switch (index[1])
				{
					case (int)GearModifierTab.CustomMeshes:
						sourceList = GearManager.Instance.CustomMeshes;
						break;
					case (int)GearModifierTab.ProGear:
						sourceList = GearManager.Instance.ProGear;
						break;
					case (int)GearModifierTab.FemaleGear:
						sourceList = index[0] == (int)Character.FemaleStandard ? new List<ICustomInfo>() : GearManager.Instance.FemaleGear;
						break;
					case (int)GearModifierTab.MaleGear:
						sourceList = index[0] == (int)Character.MaleStandard ? new List<ICustomInfo>() : GearManager.Instance.MaleGear;
						break;
				}

				if (sourceList == null) return;

				if (index.depth == 2)
				{
					__result = sourceList.Count;
				}
				else if (index.depth >= 3)
				{
					__result = GearManager.Instance.CurrentFolder.HasChildren() ? GearManager.Instance.CurrentFolder.Children.Count : sourceList.Count;
				}
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), nameof(GearSelectionController.ConfigureHeaderView))]
		public static class ConfigureHeaderViewPatch
		{
			static void Postfix(IndexPath index, MVCListHeaderView itemView)
			{
				if (index.depth < 2) return;
				if (!IsOnXLGMTab(index[1])) return;

				if (index.depth == 2)
				{
					switch (index[1])
					{
						case (int)GearModifierTab.CustomMeshes: itemView.SetText("Custom Meshes"); break;
						case (int)GearModifierTab.ProGear:      itemView.SetText("Pro Gear");      break;
						case (int)GearModifierTab.FemaleGear:   itemView.SetText("Female Gear");   break;
						case (int)GearModifierTab.MaleGear:     itemView.SetText("Male Gear");     break;
					}
				}
				else if (index.depth >= 3)
				{
					itemView.Label.spriteAsset = AssetBundleHelper.GearModifierUISpriteSheet;
					//itemView.SetText(GearManager.Instance.CurrentFolder.GetName().Replace("\\", $"<sprite name=\"{GearManager.Instance.CurrentFolder.GetName().Replace("\\", string.Empty)}\"> "));
					string newText = string.Empty;
					if (index.depth == 3)
					{
						newText = $"<space=18px><sprite name=\"{GearManager.Instance.CurrentFolder.GetName().Replace("\\", string.Empty)}\" tint=1>";
					}
					else if (index.depth == 4)
					{
						// since this is just a folder representing the mesh, we can get the configured sprite type out of of one of the actual items, which is a child
						// of this folder.  get the 2nd child because the first will always be the "Go Back" folder.
						if (GearManager.Instance.CurrentFolder.Children.Count > 1)
						{
							var child = GearManager.Instance.CurrentFolder.Children.ElementAt(1);
							if (child != null)
							{
								if (child.GetParentObject() is CustomGear customGear)
								{
									newText = $"<space=18px><sprite name=\"{customGear.Sprite}\" tint=1>";
								}
							}
						}
					}
					itemView.SetText(GearManager.Instance.CurrentFolder.GetName().Replace("\\", newText), true);
				}
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), nameof(GearSelectionController.ConfigureListItemView))]
		public static class ConfigureListItemViewPatch
		{
			static void Postfix(GearSelectionController __instance, IndexPath index, ref MVCListItemView itemView)
			{
				if (index.depth < 3) return;
				if (!IsOnXLGMTab(index[1])) return;

				itemView.Label.richText = true;

				GearInfo gearAtIndex = GearDatabase.Instance.GetGearAtIndex(index, out bool _);

				if (gearAtIndex == null)
				{
					itemView.SetText("NOT FOUND", false);
					Traverse.Create(GearSelectionController.Instance).Method("SetIsEquippedIndicators", itemView, false).GetValue();
					return;
				}

				if (AssetBundleHelper.GearModifierUISpriteSheet != null)
				{
					itemView.Label.spriteAsset = AssetBundleHelper.GearModifierUISpriteSheet;
				}

				if (gearAtIndex.name.StartsWith("\\"))
				{
					string newText = string.Empty;
					if (index.depth == 3)
					{
						newText = $"<space=18px><sprite name=\"{gearAtIndex.name.Replace("\\", string.Empty)}\" tint=1>";
					}
					else if (index.depth == 4)
					{
						var customGearFolder = gearAtIndex as CustomGearFolderInfo;
						if (customGearFolder != null)
						{
							// since this is just a folder representing the mesh, we can get the configured sprite type out of of one of the actual items, which is a child
							// of this folder.  get the 2nd child because the first will always be the "Go Back" folder.
							if (customGearFolder.FolderInfo.Children.Count > 1)
							{
								var child = customGearFolder.FolderInfo.Children.ElementAt(1);
								if (child != null)
								{
									if (child.GetParentObject() is CustomGear customGear)
									{
										newText = $"<space=18px><sprite name=\"{customGear.Sprite}\" tint=1>";
									}
								}
							}
						}
					}
					itemView.SetText(gearAtIndex.name.Replace("\\", newText), true);
				}
				else if (gearAtIndex.name.Equals("..\\"))
				{
					itemView.Label.spriteAsset = SpriteHelper.MenuIcons;
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

		[HarmonyPatch(typeof(GearSelectionController), "ListView_OnItemSelectedEvent")]
		public static class ListView_OnItemSelectedEventPatch
		{
			static bool Prefix(GearSelectionController __instance, IndexPath index)
			{
				if (index.depth < 3) return true;
				if (!IsOnXLGMTab(index[1])) return true;

				var gear = GearDatabase.Instance.GetGearAtIndex(index);
				if (gear is CustomGearFolderInfo selectedFolder)
				{
					selectedFolder.FolderInfo.Children = selectedFolder.FolderInfo.Children;

					var currentIndexPath = Traverse.Create(__instance.listView).Property<IndexPath>("currentIndexPath");

					if (selectedFolder.FolderInfo.GetName() == "..\\")
					{
						GearManager.Instance.CurrentFolder = selectedFolder.FolderInfo.Parent;
						currentIndexPath.Value = __instance.listView.currentIndexPath.Up();

						__instance.listView.UpdateList();
						__instance.listView.SetHighlighted(Traverse.Create(__instance.listView).Property<IndexPath>("currentIndexPath").Value, true);
					}
					else
					{
						List<ICustomInfo> sourceList = null;

						switch (index[1])
						{
							case (int)GearModifierTab.CustomMeshes:
								sourceList = GearManager.Instance.CustomMeshes;
								break;
							case (int)GearModifierTab.ProGear:
								sourceList = GearManager.Instance.ProGear;
								break;
							case (int)GearModifierTab.FemaleGear:
								sourceList = GearManager.Instance.FemaleGear;
								break;
							case (int)GearModifierTab.MaleGear:
								sourceList = GearManager.Instance.MaleGear;
								break;
						}

						if (sourceList == null) return true;

						if (index.depth == 3)
						{
							var match = sourceList.FirstOrDefault(x => x.Name == gear.name);
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
							currentIndexPath.Value = __instance.listView.currentIndexPath.Sub(GearManager.Instance.CurrentFolder.Parent.Children.IndexOf(GearManager.Instance.CurrentFolder));
						}
						else
						{
							currentIndexPath.Value = __instance.listView.currentIndexPath.Sub(sourceList.IndexOf(GearManager.Instance.CurrentFolder));
						}

						EventSystem.current.SetSelectedGameObject(null);
						__instance.listView.UpdateList();
					}

					return false;
				}

				if (index.depth >= 3)
				{
					try
					{
						if (__instance.previewCustomizer.HasEquipped(gear))
						{
							Traverse.Create(__instance.previewCustomizer).Method("RemoveGear", gear).GetValue();
						}
						else
						{
							__instance.previewCustomizer.EquipGear(gear);
						}

						__instance.previewCustomizer.OnlyShowEquippedGear();
						Traverse.Create(__instance).Field<bool>("didChangeGear").Value = true;

					}
					catch (Exception ex)
					{
						UnityModManager.Logger.Log("XLGearModifier: " + ex);
					}

					__instance.Save();
					__instance.listView.UpdateList();

					return false;
				}

				GearManager.Instance.CurrentFolder = null;
				return true;
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), "ListView_OnItemHighlightedEvent")]
		public static class ListView_OnItemHighlightedEventPatch
		{
			static void Postfix(GearSelectionController __instance, IndexPath index)
			{
				if (index.depth < 3) return;
				if (!IsOnXLGMTab(index[1])) return;

				GearInfo gearAtIndex1 = GearDatabase.Instance.GetGearAtIndex(index);
				if (gearAtIndex1 == null) return;

				List<GearInfo> toBeCachedGear = new List<GearInfo>();
				for (int steps = -__instance.preloadedItemsPerSide; steps <= __instance.preloadedItemsPerSide; ++steps)
				{
					GearInfo gearAtIndex2 = GearDatabase.Instance.GetGearAtIndex(index.Horizontal(steps));
					if (gearAtIndex2 != null)
						toBeCachedGear.Add(gearAtIndex2);
				}

				if (index.depth == 4 && gearAtIndex1 is CustomGearFolderInfo gearFolder)
				{
					if (gearFolder.FolderInfo.Children.Count <= 1) return;

					var child = gearFolder.FolderInfo.Children.ElementAt(1);
					if (child != null && child.GetParentObject() is CustomGear customGear)
					{
						__instance.previewCustomizer.PreviewItem(customGear.GearInfo, toBeCachedGear);
					}
				}
				else
				{
					__instance.previewCustomizer.PreviewItem(gearAtIndex1, toBeCachedGear);
				}
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), "Update")]
		public static class UpdatePatch
		{
			static bool Prefix(GearSelectionController __instance)
			{
				if (__instance.listView.currentIndexPath.depth < 3) return true;
				if (!IsOnXLGMTab(__instance.listView.currentIndexPath[1])) return true;

				if (GearManager.Instance.CurrentFolder == null) return true;
				if (!PlayerController.Instance.inputController.player.GetButtonDown("B")) return true;

				UISounds.Instance?.PlayOneShotSelectMajor();

				GearManager.Instance.CurrentFolder = GearManager.Instance.CurrentFolder.Parent;
				Traverse.Create(__instance.listView).Property<IndexPath>("currentIndexPath").Value = __instance.listView.currentIndexPath.Up();

				__instance.listView.UpdateList();
				__instance.listView.SetHighlighted(Traverse.Create(__instance.listView).Property<IndexPath>("currentIndexPath").Value, true);

				return false;

			}
		}

		static bool IsOnXLGMTab(int tabIndex)
		{
			return tabIndex == (int) GearModifierTab.CustomMeshes ||
			       tabIndex == (int) GearModifierTab.ProGear ||
			       tabIndex == (int) GearModifierTab.FemaleGear ||
			       tabIndex == (int) GearModifierTab.MaleGear;
		}
	}
}
