using System;
using System.Collections.Generic;
using System.Linq;
using HarmonyLib;
using SkaterXL.Data;
using System.Collections.Generic;
using System.Linq;
using XLGearModifier.CustomGear;
using XLGearModifier.Texturing;
using XLGearModifier.Unity;
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
        
        [HarmonyPatch(typeof(CharacterCustomizer), nameof(CharacterCustomizer.LoadCustomizations))]
        static class LoadCustomizationsPatch
        {
            static void Postfix(CharacterCustomizer __instance, CustomizedPlayerDataV2 data)
            {
                var traverse = Traverse.Create(__instance);

                var equippedGear = traverse.Field("equippedGear").GetValue<List<ClothingGearObjet>>();
                if (equippedGear == null || !equippedGear.Any()) return;

                foreach (var clothingGearObject in equippedGear)
                {
                    var blendShapeController = clothingGearObject.gameObject?.GetComponentInChildren<XLGMBlendShapeController>();
                    if (blendShapeController == null) continue;

                    var xlgmGearInfo = clothingGearObject.gearInfo as XLGMCustomCharacterGearInfo;
                    if (xlgmGearInfo == null) continue;

                    foreach (var blendshape in xlgmGearInfo.blendShapes)
                    {
                        blendShapeController.SkinnedMeshRenderer.SetBlendShapeWeight(blendshape.index, blendshape.weight);
                    }
                }
            }
        }
    }
}
