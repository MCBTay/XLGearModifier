using HarmonyLib;
using SkaterXL.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine.EventSystems;
using UnityModManagerNet;
using XLGearModifier.CustomGear;
using XLGearModifier.Texturing;
using XLGearModifier.Unity;
using XLMenuMod;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Interfaces;
using XLMenuMod.Utilities.UserInterface;

namespace XLGearModifier.Patches
{
    public static class GearSelectionControllerPatch
	{
		private static void SetItemText(this MVCListItemView item, GearInfo gearAtIndex, CustomGearFolderInfo customGearFolder)
		{
			if (!customGearFolder.isCustom || gearAtIndex.name.Equals("\\mod.io"))
				item.SetBrandSprite(customGearFolder);
			else
			{
				string newText = "<space=18px><sprite name=\"folder_outline\" tint=1>";
				if (customGearFolder.CustomSprite != null)
				{
					item.Label.spriteAsset = customGearFolder.CustomSprite;
					newText = "<space=18px><sprite=0 tint=1>";
				}
				else
				{
					item.Label.spriteAsset = SpriteHelper.MenuIcons;
				}

				item.SetText(gearAtIndex.name.Replace("\\", newText), true);
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), nameof(GearSelectionController.GetNumberOfItems))]
		public static class GetNumberOfItemsPatch
		{
			static void Postfix(GearSelectionController __instance, ref int __result, IndexPath index)
			{
				if (index[0] < 0) return;
				
				if (index.depth == 1)
				{
					__result = 2 * GearDatabase.Instance.skaters[index[0]].GearFilters.Count + Enum.GetNames(typeof(GearModifierTab)).Length;
				}

				if (index.depth < 2) return;

                __result = GearDatabase.Instance.GetGearListAtIndex(index).Length;
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
						case (int)GearModifierTab.CustomMeshes:
                        case (int)GearModifierTab.CustomFemaleMeshes: 
                            itemView.SetText("Custom Meshes"); 
                            break;
                        case (int)GearModifierTab.Eyes:
                            itemView.Label.spriteAsset = UserInterfaceHelper.Instance.GearModifierUISpriteSheet;
							var newText = "<space=18px><sprite name=\"Eyes\" tint=1>Eyes";
                            itemView.SetText(newText); break;
					}
				}
				else if (index.depth >= 3)
				{
					itemView.Label.spriteAsset = UserInterfaceHelper.Instance.GearModifierUISpriteSheet;
					string newText = string.Empty;
					if (index.depth == 3)
					{
						newText = $"<space=18px><sprite name=\"{GearManager.Instance.CurrentFolder.GetName().Replace("\\", string.Empty)}\" tint=1>";
					}
					else if (index.depth == 4)
					{
						SetMeshFoldersText(itemView, GearManager.Instance.CurrentFolder.GetParentObject() as CustomGearFolderInfo, index);
						return;
					}
					itemView.SetText(GearManager.Instance.CurrentFolder.GetName().Replace("\\", newText), true);

				}
			}
		}

		private static void SetMeshFoldersText(MenuButton itemView, GearInfo gearAtIndex, IndexPath index)
		{
			string newText = string.Empty;

			var customGearFolder = gearAtIndex as CustomGearFolderInfo;
			if (customGearFolder != null)
			{
				// since this is just a folder representing the mesh, we can get the configured sprite type out of of one of the actual items, which is a child
				// of this folder.  get the 2nd child because the first will always be the "Go Back" folder.
				if (customGearFolder.FolderInfo.Children.Count > 1)
				{
					var child = GetFirstChild(customGearFolder);

					if (child != null)
					{
						if (child.GetParentObject() is CustomGearBase customGear)
						{
							newText = $"<space=18px><sprite name=\"{customGear.Metadata.GetSprite()}\" tint=1>";
							itemView.SetText(gearAtIndex.name.Replace("\\", newText), true);
						}
						else if (child.GetParentObject() is CustomCharacterGearInfo customCharacterGear)
						{
							if (!customCharacterGear.isCustom || gearAtIndex.name.Equals("\\mod.io"))
							{
								if (index[1] != (int)GearModifierTab.CustomMeshes || index[1] != (int)GearModifierTab.CustomFemaleMeshes)
								{
									switch (itemView)
									{
										case MVCListItemView listItem:
											listItem.SetBrandSprite(customGearFolder);
											break;
										case MVCListHeaderView headerItem:
											headerItem.SetBrandSprite(customGearFolder);
											break;
									}
								}
								else
								{
									itemView.SetText(gearAtIndex.name.Replace("\\", newText), true);
								}
							}
							else
							{
								itemView.SetText(gearAtIndex.name.Replace("\\", newText), true);
							}
						}
						else
						{
							itemView.SetText(gearAtIndex.name.Replace("\\", newText), true);
						}
					}

				}
			}
		}

		private static ICustomInfo GetFirstChild(CustomGearFolderInfo customGearFolder)
		{
			// get the second as the first child will always be the "Go Back" folder
			if (customGearFolder.FolderInfo.Children == null || customGearFolder.FolderInfo.Children.Count <= 1) return null;

			var child = customGearFolder.FolderInfo.Children.ElementAt(1);
			if (child == null) return null;

			if (child.GetParentObject() is CustomGearFolderInfo nestedFolder)
			{
				return GetFirstChild(nestedFolder);
			}
			if (child.GetParentObject() is CustomCharacterGearInfo)
			{
				return child;
			}
			if (child.GetParentObject() is CustomGearBase)
			{
				return child;
			}

			return null;
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

				if (UserInterfaceHelper.Instance.GearModifierUISpriteSheet != null)
				{
					itemView.Label.spriteAsset = UserInterfaceHelper.Instance.GearModifierUISpriteSheet;
				}

				if (gearAtIndex.name.StartsWith("\\"))
				{
					string newText = string.Empty;
					if (index.depth == 3)
					{
						newText = $"<space=18px><sprite name=\"{gearAtIndex.name.Replace("\\", string.Empty)}\" tint=1>";
						itemView.SetText(gearAtIndex.name.Replace("\\", newText), true);
					}
					else if (index.depth == 4)
					{
						SetMeshFoldersText(itemView, gearAtIndex, index);
					}
					else if (index.depth > 4)
					{
						var customGearFolder = gearAtIndex as CustomGearFolderInfo;
						if (customGearFolder != null)
						{
							var child = GetFirstChild(customGearFolder);
							if (child.GetParentObject() is CustomGearBase)
							{
								itemView.SetItemText(gearAtIndex, customGearFolder);
							}
							else if (child.GetParentObject() is CustomGearFolderInfo)
							{
								itemView.SetItemText(gearAtIndex, customGearFolder);
							}
							else if (child.GetParentObject() is CustomCharacterGearInfo)
							{
								itemView.SetItemText(gearAtIndex, customGearFolder);
							}
						}
					}
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
			static bool Prefix(GearSelectionController __instance, IndexPath index, CustomizedPlayerDataV2[] ___skaterCustomizations)
            {
                if (!__instance.initialized) return true;
                if (index.depth < 3) return true;

				var gear = GearDatabase.Instance.GetGearAtIndex(index);
				if (!IsOnXLGMTab(index[1]))
				{
					if (!(gear is CustomGearFolderInfo))
					{
						EquipUnequipItem(__instance, gear, index, ___skaterCustomizations);
						return false;
					}
				}

				if (gear is CustomGearFolderInfo selectedFolder)
				{
					selectedFolder.FolderInfo.Children = GearManager.Instance.SortList(selectedFolder.FolderInfo.Children);

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
                            case (int)GearModifierTab.CustomFemaleMeshes:
                                sourceList = GearManager.Instance.CustomFemaleMeshes;
                                break;
                            case (int)GearModifierTab.Eyes:
								sourceList = EyeTextureManager.Instance.Eyes;
								break;
						}

						if (sourceList == null) return true;

						if (index.depth == 3)
						{
							var match = sourceList.FirstOrDefault(x => x.Name == gear.name);
							if (match != null)
							{
								switch (Enum.Parse(typeof(Unity.ClothingGearCategory), match.Name.Replace("\\", string.Empty)))
								{
									case Unity.ClothingGearCategory.Hair:
									case Unity.ClothingGearCategory.Headwear:
									case Unity.ClothingGearCategory.FacialHair:
										__instance.SetCameraView(GearRoomCameraView.Head);
										break;
									case Unity.ClothingGearCategory.Top:
										__instance.SetCameraView(GearRoomCameraView.Top);
										break;
									case Unity.ClothingGearCategory.Bottom:
										__instance.SetCameraView(GearRoomCameraView.Bottom);
										break;
									case Unity.ClothingGearCategory.Shoes:
									case Unity.ClothingGearCategory.Socks:
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

				EquipUnequipItem(__instance, gear, index, ___skaterCustomizations);
				return false;
			}

			private static void EquipUnequipItem(GearSelectionController __instance, GearInfo gear, IndexPath index, CustomizedPlayerDataV2[] ___skaterCustomizations)
			{
				try
				{
					if (__instance.previewCustomizer.HasEquipped(gear))
					{
						if (gear is CustomBoardGearInfo || gear is BoardGearInfo || gear is CustomCharacterBodyInfo || gear is CharacterBodyInfo) return;
						Traverse.Create(__instance.previewCustomizer).Method("RemoveGear", gear).GetValue();

						// Set this to prevent previewing this item as long as the index hasn't changed.
                        GearManager.Instance.UnequippedItemIndexPath = index;

                        if (gear.type == "eyes")
                        {
                            EyeTextureManager.Instance.ToggleDefaultEyeTextureVisibility(__instance.previewCustomizer, true);
                        }
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
					UnityModManager.Logger.Log("XLGearModifier.OnItemSelectedPatch: " + ex);
				}

				__instance.Save();
				__instance.listView.UpdateList();

				UserInterfaceHelper.Instance.RefreshWhatsEquippedList(___skaterCustomizations, index);
			}
		}

		[HarmonyPatch(typeof(GearSelectionController), "ListView_OnItemHighlightedEvent")]
		public static class ListView_OnItemHighlightedEventPatch
		{
			/// <summary>
			/// Controls whether or not we allow the OnItemHighlighted base method to execute.  If <see cref="GearManager.UnequippedItemIndexPath" />
			/// has not been set, or is different than the current index we've got highlighted, then allow the preview to proceed as normal.
			/// If we are still previewing the item that was unequipped, don't allow the preview to proceed.
			/// </summary>
			/// <param name="index">The index of the item being previewed.</param>
			/// <returns>True if <see cref="GearManager.UnequippedItemIndexPath" /> is null or different than the current preview item.  False if the path is the same as the current preview item.</returns>
            static bool Prefix(IndexPath index)
            {
                if (GearManager.Instance.UnequippedItemIndexPath == null) return true;
                if (GearManager.Instance.UnequippedItemIndexPath == index) return false;

                GearManager.Instance.UnequippedItemIndexPath = null;
                return true;
            }

			static void Postfix(GearSelectionController __instance, IndexPath index, CustomizedPlayerDataV2[] ___skaterCustomizations)
			{
				if (index.depth == 1)
				{
					UserInterfaceHelper.Instance.RefreshWhatsEquippedList(___skaterCustomizations, index);
				}

				if (index.depth < 3) return;

				if (index[1] == (int)GearCategory.SkinTone && index[0] > 5)
				{
					__instance.previewCustomizer.PreviewItem(GearDatabase.Instance.GetGearAtIndex(index), null);
				}

				if (!IsOnXLGMTab(index[1])) return;

                if (GearManager.Instance.UnequippedItemIndexPath != null && GearManager.Instance.UnequippedItemIndexPath == index)
                {
                    return;
                }

                GearManager.Instance.UnequippedItemIndexPath = null;

				GearInfo gearAtIndex1 = GearDatabase.Instance.GetGearAtIndex(index);
				if (gearAtIndex1 == null) return;

				List<GearInfo> toBeCachedGear = new List<GearInfo>();
				for (int steps = -__instance.preloadedItemsPerSide; steps <= __instance.preloadedItemsPerSide; ++steps)
				{
					GearInfo gearAtIndex2 = GearDatabase.Instance.GetGearAtIndex(index.Horizontal(steps));
                    if (gearAtIndex2 != null)
                        toBeCachedGear.Add(gearAtIndex2);
                }

				if (index.depth == 3 && gearAtIndex1 is CustomGearFolderInfo)
				{
					__instance.previewCustomizer.PreviewItem(null, toBeCachedGear);
					return;
				}
				if (index.depth == 4 && gearAtIndex1 is CustomGearFolderInfo gearFolder)
				{
					if (gearFolder.FolderInfo.Children.Count <= 1)
					{
						__instance.previewCustomizer.PreviewItem(null, toBeCachedGear);
						return;
					}

					var child = gearFolder.FolderInfo.Children.ElementAt(1);
					if (child != null && child.GetParentObject() is CustomGearBase customGear)
					{
						__instance.previewCustomizer.PreviewItem(customGear.GearInfo, toBeCachedGear);
					}
				}
				else
				{
					if (gearAtIndex1 is CustomGearFolderInfo customGearFolder)
					{
						__instance.previewCustomizer.PreviewItem(null, toBeCachedGear);
						return;
					}

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

		public static bool IsOnXLGMTab(int tabIndex)
		{
			return tabIndex == (int) GearModifierTab.CustomMeshes ||
                   tabIndex == (int) GearModifierTab.CustomFemaleMeshes ||
                   tabIndex == (int) GearModifierTab.Eyes;
		}
	}
}
