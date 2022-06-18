using HarmonyLib;
using SkaterXL.Data;
using System.Collections.Generic;
using System.Linq;
using XLGearModifier.CustomGear;
using XLGearModifier.Texturing;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Gear.Interfaces;

namespace XLGearModifier.Patches
{
    public class CharacterCustomizerPatch
	{
		[HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.HasEquipped), typeof(ICharacterCustomizationItem))]
		static class HasEquippedPatch
		{
			static bool Prefix(ref ICharacterCustomizationItem item)
			{
				if (item is ICustomGearInfo customGearInfo)
				{
					if (customGearInfo.Info is CustomFolderInfo) return false;
					if (customGearInfo.Info is CustomGearBase customGear) item = customGear.GearInfo;
				}
				if (item is CustomCharacterGearInfo customCharGearInfo) item = customCharGearInfo;
				if (item is CustomBoardGearInfo customBoardGearInfo) item = customBoardGearInfo;
				if (item is CustomGearFolderInfo) return false;

                return true;
			}
        }

        [HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.EquipCharacterGear), typeof(CharacterGearInfo), typeof(bool))]
        static class EquipCharacterGearPatch
        {
            /// <summary>
            /// Handles the equipping of custom eye textures.
            /// </summary>
            static void Postfix(CharacterCustomizer __instance, CharacterGearInfo gear)
            {
                if (gear.type != "eyes") return;

                EyeTextureManager.Instance.GetGameObjectReference(__instance);
                EyeTextureManager.Instance.ToggleDefaultEyeTextureVisibility(__instance, false);
            }
        }

        [HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.PreviewItem))]
        static class PreviewItemPatch
        {
            /// <summary>
            /// Handles the previewing of custom eye textures.
            /// </summary>
            static void Postfix(CharacterCustomizer __instance, GearInfo preview, List<GearInfo> toBeCachedGear)
            {
                if (preview == null) return;
                if (preview.type != "eyes")
                {
                    var equippedGear = Traverse.Create(__instance).Field("equippedGear").GetValue<List<ClothingGearObjet>>();
                    if (equippedGear != null && equippedGear.All(x => x.gearInfo.type != "eyes"))
                    {
                        // not previewing eyes, and no eyes equipped, ensure default eyes are visible
                        EyeTextureManager.Instance.ToggleDefaultEyeTextureVisibility(__instance, true);
                    }
                    return;
                }

                EyeTextureManager.Instance.ToggleDefaultEyeTextureVisibility(__instance, false);
            }
        }
    }
}
