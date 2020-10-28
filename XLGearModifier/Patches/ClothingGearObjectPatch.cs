using HarmonyLib;
using System;

namespace XLGearModifier.Patches
{
	public static class ClothingGearObjectPatch
	{
		[HarmonyPatch(typeof(ClothingGearObjet), nameof(ClothingGearObjet.Blocks))]
		static class BlocksPatch
		{
			static bool Prefix(ClothingGearObjet __instance, GearObject other, ref bool __result)
			{
				if (!Main.Enabled || !Settings.Instance.AllowMultipleGearItemsPerSlot) return true;

				if (other is ClothingGearObjet cgo)
				{
					if (__instance.template.category == ClothingGearCategory.Hat && cgo.template.category == ClothingGearCategory.Hat)
					{
						if (__instance.IsHair() && cgo.IsHeadwear())
						{
							__result = false;
							return false;
						}

						if (__instance.IsHeadwear() && cgo.IsHair())
						{
							__result = false;
							return false;
						}

						return true;
					}
				}

				return true;
			}
		}

		static bool IsHair(this ClothingGearObjet clothingGear)
		{
			var hair = Enum.GetValues(typeof(HairStyles));

			foreach (HairStyles hairStyle in hair)
			{
				if (hairStyle.ToString() == clothingGear.template.id)
					return true;
			}

			return false;
		}

		static bool IsHeadwear(this ClothingGearObjet clothingGear)
		{
			var headwear = Enum.GetValues(typeof(HeadwearTypes));

			foreach (HeadwearTypes headwearStyle in headwear)
			{
				if (headwearStyle.ToString() == clothingGear.template.id)
					return true;
			}

			return false;
		}
	}
}
