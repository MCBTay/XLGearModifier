using HarmonyLib;
using System;
using System.Collections.Generic;

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
					traverse.Method("MakeShoesColored", shoes, true);

				traverse.Field("equippedGear").GetValue<List<ClothingGearObjet>>().Add(shoes);
				if (!updateMask)
					return false;

				traverse.Method("UpdateMasksFrom", (IEnumerable<ClothingGearObjet>) traverse.Field("equippedGear"));
				traverse.Method("ApplyMasks");

				return false;
			}
		}
	}
}
