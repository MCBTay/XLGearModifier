using HarmonyLib;
using System;
using System.Linq;
using XLGearModifier.CustomGear;
using XLGearModifier.Unity;
using XLMenuMod.Utilities.Gear;
using ClothingGearCategory = SkaterXL.Gear.ClothingGearCategory;

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

						if (__instance.IsLayerable(Unity.ClothingGearCategory.FacialHair) || cgo.IsLayerable(Unity.ClothingGearCategory.FacialHair))
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
					else if (__instance.IsLayerable(Unity.ClothingGearCategory.Other) || cgo.IsLayerable(Unity.ClothingGearCategory.Other))
					{
						__result = false;
						return false;
					}
				}

				return true;
			}
		}

		static bool IsLayerable<T>(this ClothingGearObjet clothingGear, ClothingGearCategory specificCategory) where T : Enum
		{
			if (clothingGear.template.category != specificCategory)
				return false;

			return IsLayerable<T>(clothingGear);
		}

		static bool IsLayerable<T>(this ClothingGearObjet clothingGear) where T : Enum
		{
			bool isType = Enum.GetValues(typeof(T)).Cast<T>().Any(style => style.ToString() == clothingGear.template.id);
			bool isLayerable = false;

			var customGearInfo = clothingGear.gearInfo as CustomCharacterGearInfo;
			if (customGearInfo == null) return false;

			if (customGearInfo.Info.GetParentObject() is CustomClothingGear customGear)
			{
				if (!isType)
				{
					isType = !customGear.Metadata.BasedOnDefaultGear() || Enum.GetValues(typeof(T)).Cast<T>().Any(style => style.ToString() == customGear.Metadata.GetBaseType());
				}
				
				isLayerable = customGear.ClothingMetadata.IsLayerable;
			}

			return isType && isLayerable;
		}


		static bool IsLayerable(this ClothingGearObjet clothingGear, Unity.ClothingGearCategory clothingGearCategory)
		{
			var customGearInfo = clothingGear.gearInfo as CustomCharacterGearInfo;
			if (customGearInfo == null) return false;

			bool isLayerable = false;

			if (customGearInfo.Info.GetParentObject() is CustomClothingGear customGear)
			{
				isLayerable = customGear.ClothingMetadata.IsLayerable && customGear.Metadata.GetCategory().StartsWith(clothingGearCategory.ToString());
			}

			return isLayerable;
		}
	}
}
