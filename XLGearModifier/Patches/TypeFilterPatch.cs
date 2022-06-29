using System;
using HarmonyLib;
using SkaterXL.Data;
using XLGearModifier.Unity;
using XLMenuMod.Utilities.Gear;

namespace XLGearModifier.Patches
{
    public class TypeFilterPatch
    {
        [HarmonyPatch(typeof(TypeFilter), nameof(TypeFilter.Includes))]
        static class IncludesPatch
        {
            /// <summary>
            /// Patching into Includes, which is used by GenerateGearListSource and FetchCustomGear, in order to filter out
            /// custom meshes from showing up on Easy Day's tabs.
            /// </summary>
            static void Postfix(TypeFilter __instance, ICharacterCustomizationItem item, ref bool __result)
            {
                if (item is CustomCharacterGearInfo)
                {
                    __result = false;
                }
            }
        }
    }
}
