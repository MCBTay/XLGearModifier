using HarmonyLib;
using SkaterXL.Data;
using System.Linq;

namespace XLGearModifier.Patches
{
    public class CustomizedPlayerDataV2Patch
	{
		[HarmonyPatch(typeof(CustomizedPlayerDataV2), nameof(CustomizedPlayerDataV2.GetBuiltInSkater))]
		static class GetBuiltInSkaterPatch
		{
			static void Postfix(string skaterName, ref CustomizedPlayerDataV2 __result)
			{
				if (__result != null) return;

				__result = new CustomizedPlayerDataV2
				{
					boardGear = new BoardGearInfo[] { },
					clothingGear = new CharacterGearInfo[] { },
					body = GearManager.Instance.CustomGear.FirstOrDefault(x => x.GearInfo is CharacterBodyInfo cbi && cbi.name == skaterName)?.GearInfo as CharacterBodyInfo
				};
			}
		}
	}
}
