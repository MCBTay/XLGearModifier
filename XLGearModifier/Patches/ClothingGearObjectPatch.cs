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
					else if ((__instance.template.category == ClothingGearCategory.LongSleeve && cgo.template.category == ClothingGearCategory.Shirt) ||
					         (__instance.template.category == ClothingGearCategory.Shirt && cgo.template.category == ClothingGearCategory.LongSleeve))
					{
						var currentObj = __instance.gearInfo as CustomCharacterGearInfo;
						if (currentObj == null) return true;
						if (!(currentObj.Info.GetParentObject() is CustomGear customGear)) return true;

						__result = !customGear.IsLayerable;
						return false;
					}
					else if ((__instance.template.category == ClothingGearCategory.Hoodie && cgo.template.category == ClothingGearCategory.Shirt) ||
							 (__instance.template.category == ClothingGearCategory.Shirt && cgo.template.category == ClothingGearCategory.Hoodie))
					{
						var test = __instance.gearInfo as CustomCharacterGearInfo;
						if (test == null) return true;
						if (!(test.Info.GetParentObject() is CustomGear customGear)) return true;

						__result = !customGear.IsLayerable;
						return false;
					}
				}

				return true;
			}
		}

		static bool IsLayerable<T>(this ClothingGearObjet clothingGear) where T : Enum
		{
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
