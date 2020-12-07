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
					if (__instance.template.category == ClothingGearCategory.Hat &&
						cgo.template.category == ClothingGearCategory.Hat)
					{
						if ((!__instance.IsHair() || !cgo.IsHeadwear()) && (!__instance.IsHeadwear() || !cgo.IsHair()))
							return true;

						__result = false;
						return false;

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

		static bool IsHair(this ClothingGearObjet clothingGear)
		{
			return Enum.GetValues(typeof(HairStyles)).Cast<HairStyles>().Any(hairStyle => hairStyle.ToString() == clothingGear.template.id);
		}

		static bool IsHeadwear(this ClothingGearObjet clothingGear)
		{
			return Enum.GetValues(typeof(HeadwearTypes)).Cast<HeadwearTypes>().Any(headwearStyle => headwearStyle.ToString() == clothingGear.template.id);
		}
	}
}
