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
						if ((__instance.IsLayerableHair() && cgo.IsLayerableHeadwear()) || (__instance.IsLayerableHeadwear() && cgo.IsLayerableHair()))
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

		static bool IsLayerableHair(this ClothingGearObjet clothingGear)
		{
			bool isHair = Enum.GetValues(typeof(HairStyles)).Cast<HairStyles>().Any(hairStyle => hairStyle.ToString() == clothingGear.template.id);
			bool isLayerable = false;

			var customGearInfo = clothingGear.gearInfo as CustomCharacterGearInfo;
			if (customGearInfo == null) return false;

			if (customGearInfo.Info.GetParentObject() is CustomGear customGear)
			{
				if (!isHair && customGear.Metadata.BaseOnDefaultGear)
				{
					isHair = Enum.GetValues(typeof(HairStyles)).Cast<HairStyles>().Any(hairStyle => hairStyle.ToString() == customGear.GetBaseType());
				}

				isLayerable = customGear.IsLayerable;
			}

			return isHair && isLayerable;
		}

		static bool IsLayerableHeadwear(this ClothingGearObjet clothingGear)
		{
			bool isHeadwear = Enum.GetValues(typeof(HeadwearTypes)).Cast<HeadwearTypes>().Any(headwearStyle => headwearStyle.ToString() == clothingGear.template.id);
			bool isLayerable = false;

			var customGearInfo = clothingGear.gearInfo as CustomCharacterGearInfo;
			if (customGearInfo == null) return false;

			if (customGearInfo.Info.GetParentObject() is CustomGear customGear)
			{
				if (!isHeadwear && customGear.Metadata.BaseOnDefaultGear)
				{
					isHeadwear = Enum.GetValues(typeof(HeadwearTypes)).Cast<HeadwearTypes>().Any(headwearStyle => headwearStyle.ToString() == customGear.GetBaseType());
				}

				isLayerable = customGear.IsLayerable;
			}

			return isHeadwear && isLayerable;
		}
	}
}
