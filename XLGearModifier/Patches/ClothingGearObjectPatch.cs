using HarmonyLib;
using XLGearModifier.CustomGear;
using XLMenuMod.Utilities.Gear;

namespace XLGearModifier.Patches
{
    public static class ClothingGearObjectPatch
	{
        [HarmonyPatch(typeof(ClothingGearObjet), nameof(ClothingGearObjet.Blocks))]
		static class BlocksPatch
		{
            static bool Prefix(ClothingGearObjet __instance, GearObject other, ref bool __result)
            {
                var otherCGO = other as ClothingGearObjet;
                if (otherCGO == null) return true;

                // If both clothing items are of the same template ID, they block.
                if (__instance.template.id == otherCGO.template.id)
                {
                    __result = true;
                    return false;
                }

                // If either item are Eyes, it shouldn't block any other items (except other eyes, which would be covered by the template id check above)
                if (__instance.template.id == "eyes" || otherCGO.template.id == "eyes")
                {
                    __result = false;
                    return false;
                }

                // If both clothing items are layerable, then they're not blocking and should be able to be applied.
                if (__instance.IsLayerable() && otherCGO.IsLayerable())
                {
                    __result = false;
                    return false;
                }

                // If either item is "Other" and layerable in our metadata script, it shouldn't block any other items
                if (__instance.IsLayerableCategory(Unity.ClothingGearCategory.Other) || otherCGO.IsLayerableCategory(Unity.ClothingGearCategory.Other))
                {
                    __result = false;
                    return false;
                }

                // If either item is "Facial Hair" and layerable in our metadata script, it shouldn't block any other items
                if (__instance.IsLayerableCategory(Unity.ClothingGearCategory.FacialHair) || otherCGO.IsLayerableCategory(Unity.ClothingGearCategory.FacialHair))
                {
                    __result = false;
                    return false;
                }

                return true;
			}
		}

        /// <summary>
        /// Determines whether or not <see cref="clothingGearObject"/> is a layerable custom mesh or not.
        /// </summary>
        /// <param name="clothingGearObject">The <see cref="ClothingGearObjet"/> to evaluate.</param>
        /// <returns>True if layerable, false otherwise.</returns>
        static bool IsLayerable(this ClothingGearObjet clothingGearObject)
        {
            var customGearInfo = clothingGearObject.gearInfo as CustomCharacterGearInfo;
            if (customGearInfo == null) return false;

            return customGearInfo.Info?.GetParentObject() is ClothingGear clothingGear && clothingGear.ClothingMetadata.IsLayerable;
        }

        /// <summary>
        /// Determines whether or not <see cref="clothingGearObject"/> is a custom mesh in the specified category.
        /// </summary>
        /// <param name="clothingGearObject">The <see cref="ClothingGearObjet"/> to evaluate.</param>
        /// /// <param name="category">The category to evaluate.</param>
        /// <returns>True if in category Other, false otherwise.</returns>
        static bool IsCategory(this ClothingGearObjet clothingGearObject, Unity.ClothingGearCategory category)
        {
            var customGearInfo = clothingGearObject.gearInfo as CustomCharacterGearInfo;
            if (customGearInfo == null) return false;

            return customGearInfo.Info.GetParentObject() is ClothingGear clothingGear &&
                   clothingGear.ClothingMetadata.Category == category;
        }

        /// <summary>
        /// Determines whether or not <see cref="clothingGearObject"/> is a custom mesh that is layerable and in the specified category.
        /// </summary>
        /// <param name="clothingGearObject">The <see cref="ClothingGearObjet"/> to evaluate.</param>
        /// <param name="category">The category to evaluate.</param>
        /// <returns>True if layerable and in category Other, false otherwise.</returns>
        static bool IsLayerableCategory(this ClothingGearObjet clothingGearObject, Unity.ClothingGearCategory category)
        {
            return IsLayerable(clothingGearObject) && IsCategory(clothingGearObject, category);
        }
    }
}
