using System.Collections.Generic;
using HarmonyLib;
using SkaterXL.Data;
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
            static void Postfix(CharacterCustomizer __instance, CharacterGearInfo gear, bool updateMask)
            {
                if (gear.type != "eyes") return;

                EyeTextureManager.Instance.GetGameObjectReference(__instance);

                if (EyeTextureManager.Instance.EyesGameObjects.ContainsKey(__instance.name))
                {
                    EyeTextureManager.Instance.EyesGameObjects[__instance.name].SetActive(false);
                }
            }
        }

        [HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.PreviewItem))]
        static class PreviewItemPatch
        {
            static void Postfix(CharacterCustomizer __instance, GearInfo preview, List<GearInfo> toBeCachedGear)
            {
                if (preview.type != "eyes") return;

                if (EyeTextureManager.Instance.EyesGameObjects.ContainsKey(__instance.name))
                {
                    EyeTextureManager.Instance.EyesGameObjects[__instance.name].SetActive(false);
                }
            }
        }
    }
}
