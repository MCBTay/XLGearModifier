using HarmonyLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace XLGearModifier.Patches
{
	public class CharacterCustomizerPatch
	{
		[HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.EquipCharacterGear), new [] { typeof(CharacterGearInfo), typeof(bool) })]
		static class EquipCharacterGearPatch
		{
			static bool Prefix(CharacterCustomizer __instance, CharacterGearInfo gear, bool updateMask)
			{
				if (!Main.Enabled || !Settings.Instance.AllowMultipleGearItemsPerSlot) return true;

				var index = GearSelectionController.Instance.listView.currentIndexPath;
				if (index[1] != (int)GearCategory.Hair && index[1] != (int)GearCategory.Headwear) return true;

				Traverse traverse = Traverse.Create(__instance);
				ClothingGearObjet shoes = traverse.Method("LoadClothingAsync", gear).GetValue<ClothingGearObjet>();
				if (shoes == null)
					throw new Exception("Failed to load clothing gear: " + gear);
				shoes.SetVisible(true);

				if (shoes.template.category == ClothingGearCategory.Shoes && traverse.Field("showColoredShoes").GetValue<bool>())
					traverse.Method("MakeShoesColored", shoes, true).GetValue();

				traverse.Field("equippedGear").GetValue<List<ClothingGearObjet>>().Add(shoes);
				if (!updateMask)
					return false;

				traverse.Method("UpdateMasksFrom", (IEnumerable<ClothingGearObjet>) traverse.Field("equippedGear")).GetValue();
				traverse.Method("ApplyMasks").GetValue();

				return false;
			}
		}

		[HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.PreviewItem))]
		static class PreviewItemPatch
		{
			static bool Prefix(CharacterCustomizer __instance, GearInfo preview, List<GearInfo> toBeCachedGear)
			{
				if (!Main.Enabled || !Settings.Instance.AllowMultipleGearItemsPerSlot) return true;

				var index = GearSelectionController.Instance.listView.currentIndexPath;
				if (index[1] != (int)GearCategory.Hair && index[1] != (int)GearCategory.Headwear) return true;

				var traverse = Traverse.Create(__instance);

				//__instance.gearCachesNeededForPreview = toBeCachedGear.Select(g => g.GetHashCode()).ToList();
				traverse.Field("gearCachesNeededForPreview").SetValue(toBeCachedGear.Select(g => g.GetHashCode()).ToList());
				__instance.RemoveNotUsedCache();
				foreach (GearInfo gear in toBeCachedGear)
					__instance.LoadGearAsync(gear);
				if (preview != null)
				{
					int previewHash = preview.GetHashCode();
					//__instance.currentPreviewHash = previewHash;
					traverse.Field("currentPreviewHash").SetValue(previewHash);


					GearObject previewObject = __instance.LoadGearAsync(preview);
					if (previewObject.IsLoading && previewObject.LoadingTask != null)
					{
						previewObject.SetVisible(false);
						Task.Run(async () => await previewObject.LoadingTask);
						//if (__instance.currentPreviewHash != previewHash || previewObject.LoadingTask.IsFaulted || previewObject.LoadingTask.IsCanceled)
						if (traverse.Field("currentPreviewHash").GetValue<int>() != previewHash || previewObject.LoadingTask.IsFaulted || previewObject.LoadingTask.IsCanceled)
							return true;
					}

					//foreach (GearObject gearObject in __instance.gearCache.Values)
					foreach (GearObject gearObject in traverse.Field("gearCache").GetValue<Dictionary<int, GearObject>>().Values)
						gearObject.SetVisible(gearObject.gearInfo == preview || __instance.HasEquipped(gearObject));
					//__instance.UpdateMasksFrom(__instance.gearCache.Values.Where((go => go is ClothingGearObjet && go.Visible)).Cast<ClothingGearObjet>());
					traverse.Method("UpdateMasksFrom", traverse.Field("gearCache").GetValue<Dictionary<int, GearObject>>().Values.Where(go => go is ClothingGearObjet && go.Visible).Cast<ClothingGearObjet>()).GetValue();
					//__instance.ApplyMasks();
					traverse.Method("ApplyMasks").GetValue();
					previewObject = (GearObject)null;
				}
				else
				{
					//__instance.currentPreviewHash = 0;
					traverse.Field("currentPreviewHash").SetValue(0);
					__instance.OnlyShowEquippedGear();
				}

				return false;
			}
		}
	}
}
