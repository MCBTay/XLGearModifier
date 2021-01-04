using HarmonyLib;
using System.Collections.Generic;

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
					body = new CharacterBodyInfo(skaterName, "mspiderman", false, new List<MaterialChange>
					{
						new MaterialChange("head", new[] { new TextureChange("head", "XLGearModifier") }),
						new MaterialChange("body", new[] { new TextureChange("body", "XLGearModifier") }),
					}, new string[] { })
				};
			}
		}
	}
}
