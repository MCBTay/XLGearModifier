using HarmonyLib;
using System.Collections.Generic;
using System.Linq;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Interfaces;

namespace XLGearModifier.Patches
{
	public class GearDatabasePatch
	{
		[HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetGearListAtIndex), new[] { typeof(IndexPath), typeof(bool) }, new[] { ArgumentType.Normal, ArgumentType.Out })]
		public static class GetGearListAtIndexPatch
		{
			static void Postfix(GearDatabase __instance, IndexPath index, ref GearInfo[][][] ___gearListSource, ref GearInfo[] __result)
			{
				if (index.depth < 2) return;

				List<ICustomInfo> sourceList = null;
				if (index[1] == 20)
				{
					sourceList = GearManager.Instance.CurrentFolder.HasChildren() ? GearManager.Instance.CurrentFolder.Children : GearManager.Instance.NestedItems;
				}

				if (sourceList == null) return;
				__result = sourceList.Select(x => x.GetParentObject() as GearInfo).ToArray();
			}
		}

		[HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetGearAtIndex), new[] { typeof(IndexPath), typeof(bool) }, new[] { ArgumentType.Normal, ArgumentType.Out })]
		public static class GetGearAtIndexPatch
		{
			static void Postfix(IndexPath index, ref GearInfo __result)
			{
				if (index.depth >= 3 && index[1] == 20)
				{
					if (index.depth == 3)
					{
						switch (GearManager.Instance.NestedItems.ElementAt(index.LastIndex).GetParentObject())
						{
							case CustomGearFolderInfo customGearFolderInfo:
								__result = customGearFolderInfo;
								break;
						}
					}
					// mesh per type, you've already selected a type so current folder should be valid
					else if (index.depth >= 4)
					{
						switch (GearManager.Instance.CurrentFolder.Children.ElementAt(index.LastIndex).GetParentObject())
						{
							case CustomCharacterGearInfo customCharacterGearInfo:
								__result = customCharacterGearInfo;
								break;
	   						case CustomGearFolderInfo customGearFolderInfo:
								__result = customGearFolderInfo;
								break;
						}
					}
				}
			}
		}
	}
}
