using HarmonyLib;
using System.Linq;
using XLGearModifier.Unity;

namespace XLGearModifier.Patches
{
	public class GearDatabasePatch
	{
		[HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.FetchCustomGear))]
		public static class FetchCustomGearPatch
		{
			static void Postfix(GearDatabase __instance, ref GearInfo[][][] ___customGearListSource)
			{
				AddCustomGear(GearCategory.Hair, ref ___customGearListSource);
				AddCustomGear(GearCategory.Headwear, ref ___customGearListSource);
				AddCustomGear(GearCategory.Shoes, ref ___customGearListSource);
				AddCustomGear(GearCategory.Top, ref ___customGearListSource);
				AddCustomGear(GearCategory.Bottom, ref ___customGearListSource);
			}

			static void AddCustomGear(GearCategory category, ref GearInfo[][][] ___customGearListSource)
			{
				var list = ___customGearListSource[0][(int)category].ToList();
				foreach (var gear in GearManager.Instance.CustomGear[category])
				{
					if (!list.Contains(gear.GearInfo))
						list.Add(gear.GearInfo);
				}
				___customGearListSource[0][(int)category] = list.ToArray();
			}
		}
	}
}
