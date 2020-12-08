using HarmonyLib;
using System;
using System.Linq;
using XLGearModifier.Unity;
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
				if (other is ClothingGearObjet cgo)
				{
					if (__instance.template.category == ClothingGearCategory.Hat && cgo.template.category == ClothingGearCategory.Hat)
					{
						if ((__instance.IsLayerable<HairStyles>() && cgo.IsLayerable<HeadwearTypes>()) || 
						    (__instance.IsLayerable<HeadwearTypes>() && cgo.IsLayerable<HairStyles>()))
						{
							__result = false;
							return false;
						}

						return true;
					}
					else if((__instance.IsLayerable<TopTypes>(ClothingGearCategory.LongSleeve) && cgo.IsLayerable<TopTypes>(ClothingGearCategory.Shirt)) || 
					        (__instance.IsLayerable<TopTypes>(ClothingGearCategory.Shirt) && cgo.IsLayerable<TopTypes>(ClothingGearCategory.LongSleeve)))
					{
						__result = false;
						return false;
					}
					else if ((__instance.IsLayerable<TopTypes>(ClothingGearCategory.Hoodie) && cgo.IsLayerable<TopTypes>(ClothingGearCategory.Shirt)) ||
					         (__instance.IsLayerable<TopTypes>(ClothingGearCategory.Shirt) && cgo.IsLayerable<TopTypes>(ClothingGearCategory.Hoodie)))
					{
						__result = false;
						return false;
					}
				}

				return true;
			}
		}

		static bool IsLayerable<T>(this ClothingGearObjet clothingGear, ClothingGearCategory? specificCategory = null) where T : Enum
		{
			if (specificCategory == null || clothingGear.template.category != specificCategory.Value)
				return false;

			bool isType = Enum.GetValues(typeof(T)).Cast<T>().Any(style => style.ToString() == clothingGear.template.id);
			bool isLayerable = false;

			var customGearInfo = clothingGear.gearInfo as CustomCharacterGearInfo;
			if (customGearInfo == null) return false;

			if (customGearInfo.Info.GetParentObject() is CustomGear customGear)
			{
				if (!isType && customGear.Metadata.BaseOnDefaultGear)
				{
					isType = Enum.GetValues(typeof(T)).Cast<T>().Any(style => style.ToString() == customGear.GetBaseType());
				}

				isLayerable = customGear.IsLayerable;
			}

			return isType && isLayerable;
		}
	}
}
