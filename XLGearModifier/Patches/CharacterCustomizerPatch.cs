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
            static bool Prefix(CharacterCustomizer __instance, ref CharacterGearInfo gear, ref ClothingGearObjet __result)
            {
                if (gear.type != "eyes") return true;

                var clothingGearObject = new ClothingGearObjet(gear, __instance)
                {
                    template = new CharacterGearTemplate
                    {
                        alphaMasks = new List<GearAlphaMaskConfig>(),
                        id = "eyes",
                        path = "XLGearModifier/eyes"
                    }
                };

                clothingGearObject.LoadOn();

                var gearCache = Traverse.Create(__instance).Field("gearCache").GetValue<Dictionary<int, GearObject>>();
                gearCache.Add(gear.GetHashCode(), clothingGearObject);
				__result = clothingGearObject;

                return false;
            }
        }

        /// <summary>
        /// Patching into <see cref="CharacterCustomizer.PreviewItem" /> in order to be able to facilitate previewing eye textures.
        /// </summary>
        [HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.PreviewItem))]
        static class PreviewItemPatch
        {
            static bool Prefix(CharacterCustomizer __instance, ref GearInfo preview)
            {
                if (preview.type != "eyes") return true;

                //EyeTextureManager.Instance.SetEyeTextures(preview as CharacterGearInfo);
                return false;
            }
        }

        /// <summary>
        /// Patching into <see cref="CharacterCustomizer.EquipCharacterGear"/> to handle the scenario where an eye texture is equipped.  If the geart ype is eyes, we call out to
        /// the <see cref="EyeTextureManager" /> to load/set the eye textures.
        /// </summary>
        [HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.EquipCharacterGear), new [] { typeof(CharacterGearInfo), typeof(bool) })]
        static class EquipCharacterGearPatch
        {
            static void Prefix(CharacterCustomizer __instance, CharacterGearInfo gear)
            {
                if (gear.type != "eyes") return;

                EyeTextureManager.Instance.SetEyeTextures(__instance, gear);
            }
        }

        /// <summary>
        /// Patching into <see cref="CharacterCustomizer.RemoveGear" /> in order to be able to handle the scenario where we're removing an eye texture.  In this event,
        /// we want to set the eye texture back to the default texture, so we call out to <see cref="EyeTextureManager" /> to do so.
        /// </summary>
        [HarmonyPatch(typeof(CharacterCustomizer), "RemoveGear", new[] { typeof(GearObject) })]
        static class RemoveGearPatch
        {
            static void Postfix(CharacterCustomizer __instance, GearObject gear)
            {
                //TODO: Why is gear ever null here?  Seems like that should not be the case.
                if (gear?.gearInfo == null) return;
                if (gear.gearInfo.type != "eyes") return;

                EyeTextureManager.Instance.SetEyeTexturesBackToDefault(__instance);
            }
        }
    }
}
