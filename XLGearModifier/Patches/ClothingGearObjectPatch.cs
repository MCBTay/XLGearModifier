using HarmonyLib;
using System;

namespace XLGearModifier.Patches
{
	public static class ClothingGearObjectPatch
	{
		[HarmonyPatch(typeof(ClothingGearObjet), nameof(ClothingGearObjet.Blocks))]
		static class BlocksPatch
		{
			static bool Prefix(ClothingGearObjet __instance, GearObject other, ref bool __result)
			{
				if (!Main.Enabled || !Settings.Instance.AllowMultipleGearItemsPerSlot) return true;

				if (GearSelectionController.Instance != null)
				{
					IndexPath index = GearSelectionController.Instance.listView.currentIndexPath;
					if (index.depth > 0)
					{
						var numCategories = Enum.GetValues(typeof(GearCategory)).Length;
						var isHairOrHeadwear = index[1] < numCategories && (index[1] == (int)GearCategory.Hair || index[1] == (int)GearCategory.Headwear);
						var isCustomHairOrHeadwear = index[1] >= numCategories && (index[1] - numCategories == (int)GearCategory.Hair || index[1] - numCategories == (int)GearCategory.Headwear);

						if (!isHairOrHeadwear && !isCustomHairOrHeadwear) return true;

						if (other is ClothingGearObjet cgo)
						{
							if (__instance.template.category == ClothingGearCategory.Hat && cgo.template.category == ClothingGearCategory.Hat)
							{
								if (__instance.IsHair() && cgo.IsHeadwear())
								{
									__result = false;
									return false;
								}

								if (__instance.IsHeadwear() && cgo.IsHair())
								{
									__result = false;
									return false;
								}

								return true;
							}
						}
					}
				}

				return true;
			}
		}

		static bool IsHair(this ClothingGearObjet clothingGear)
		{
			var hair = Enum.GetValues(typeof(HairStyles));

			foreach (HairStyles hairStyle in hair)
			{
				if (hairStyle.ToString() == clothingGear.template.id)
					return true;
			}

			return false;
		}

		static bool IsHeadwear(this ClothingGearObjet clothingGear)
		{
			var headwear = Enum.GetValues(typeof(HeadwearTypes));

			foreach (HeadwearTypes headwearStyle in headwear)
			{
				if (headwearStyle.ToString() == clothingGear.template.id)
					return true;
			}

			return false;
		}
	}
}
