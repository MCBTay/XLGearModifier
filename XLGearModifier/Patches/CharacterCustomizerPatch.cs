using HarmonyLib;
using SkaterXL.Data;
using SkaterXL.Gear;
using System.Collections.Generic;
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

        /// <summary>
        /// Patching into CharacterCustomizer.LoadClothingAsync to support loading of eye textures.
        /// </summary>
        [HarmonyPatch(typeof(CharacterCustomizer), "LoadClothingAsync")]
        static class LoadClothingAsyncPatch
        {
            static void Postfix(CharacterCustomizer __instance, ref CharacterGearInfo gear, ref ClothingGearObjet __result)
            {
                if (gear.type != "eyes" && __result != null) return;

                var clothingGearObject = new ClothingGearObjet(gear, __instance);

                clothingGearObject.template = new CharacterGearTemplate
                {
                    alphaMasks = new List<GearAlphaMaskConfig>(),
                    id = "eyes",
                    path = string.Empty
                };

				clothingGearObject.LoadOn();

                var gearCache = Traverse.Create(__instance).Field("gearCache").GetValue<Dictionary<int, GearObject>>();
                gearCache.Add(gear.GetHashCode(), clothingGearObject);
				__result = clothingGearObject;
            }
        }

        /// <summary>
        /// Patching into CharacterCustomizer.PreviewItem in order to be able to facilitate previewing eye textures.
        /// </summary>
        [HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.PreviewItem))]
        static class PreviewItemPatch
        {
            static bool Prefix(CharacterCustomizer __instance, ref GearInfo preview)
            {
                if (preview.type != "eyes") return true;
                
                EyeTextureManager.Instance.SetEyeTextures(preview as CharacterGearInfo);
                return false;
            }
        }
    }
}
