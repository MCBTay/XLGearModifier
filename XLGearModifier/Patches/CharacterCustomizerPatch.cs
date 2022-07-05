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
        [HarmonyPatch(typeof(CharacterCustomizer), "UpdateMasksFrom")]
        static class UpdateMasksFromPatch
        {
            /// <summary>
            /// Filters out any gear where template is null, which was an issue when trying to load the character. 
            /// </summary>
            static void Prefix(CharacterCustomizer __instance, ref IEnumerable<ClothingGearObjet> gearForMask)
            {
                gearForMask = gearForMask?.Where(x => x?.template != null);
            }
        }

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

                if (EyeTextureManager.Instance.EyesGameObjects.ContainsKey(__instance.name))
                {
                    EyeTextureManager.Instance.EyesGameObjects[__instance.name].SetActive(false);
                }
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
                if (preview.type != "eyes") return;

                if (EyeTextureManager.Instance.EyesGameObjects.ContainsKey(__instance.name))
                {
                    EyeTextureManager.Instance.EyesGameObjects[__instance.name].SetActive(false);
                }
            }
        }
    }
}
