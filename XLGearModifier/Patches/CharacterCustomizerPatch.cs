using System;
using System.Collections.Generic;
using System.Linq;
using HarmonyLib;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Gear.Interfaces;

namespace XLGearModifier.Patches
{
	public class CharacterCustomizerPatch
	{
		[HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.HasEquipped), new[] { typeof(ICharacterCustomizationItem) })]
		static class HasEquippedPatch
		{
			static bool Prefix(ref ICharacterCustomizationItem item)
			{
				if (item is ICustomGearInfo customGear)
				{
					if (customGear.Info is CustomFolderInfo) return false;
					if (customGear.Info is CustomCharacterGearInfo charGear) item = charGear;
				}

				return true;
			}
		}
	}
}
