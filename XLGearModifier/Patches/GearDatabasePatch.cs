using HarmonyLib;
using System.Collections.Generic;
using System.Linq;
using XLGearModifier.Unity;
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

				switch (index[1])
				{
					case (int) GearModifierTab.CustomMeshes: sourceList = GearManager.Instance.CustomMeshes; break;
					case (int) GearModifierTab.ProGear:      sourceList = GearManager.Instance.ProGear;      break;
					case (int) GearModifierTab.FemaleGear:   sourceList = GearManager.Instance.FemaleGear;   break;
					case (int) GearModifierTab.MaleGear:     sourceList = GearManager.Instance.MaleGear;     break;
				}

				if (sourceList == null) return;

				var list = GearManager.Instance.CurrentFolder.HasChildren() ? GearManager.Instance.CurrentFolder.Children : sourceList;

				if (list == null) return;
				__result = list.Select(x => x.GetParentObject() as GearInfo).ToArray();
			}
		}

		[HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetGearAtIndex), new[] { typeof(IndexPath), typeof(bool) }, new[] { ArgumentType.Normal, ArgumentType.Out })]
		public static class GetGearAtIndexPatch
		{
			static void Postfix(IndexPath index, ref GearInfo __result)
			{
				if (index.depth < 3) return;
				if (index[1] != (int)GearModifierTab.CustomMeshes &&
				    index[1] != (int)GearModifierTab.ProGear &&
				    index[1] != (int)GearModifierTab.FemaleGear &&
				    index[1] != (int)GearModifierTab.MaleGear) return;

				List<ICustomInfo> sourceList = null;

				switch (index[1])
				{
					case (int)GearModifierTab.CustomMeshes:
						sourceList = GearManager.Instance.CustomMeshes;
						break;
					case (int)GearModifierTab.ProGear:
						sourceList = GearManager.Instance.ProGear;
						break;
					case (int)GearModifierTab.FemaleGear:
						sourceList = GearManager.Instance.FemaleGear;
						break;
					case (int)GearModifierTab.MaleGear:
						sourceList = GearManager.Instance.MaleGear;
						break;
				}

				if (sourceList == null) return;

				if (index.depth == 3)
				{
					if (index.LastIndex < 0) return;

					switch (sourceList.ElementAt(index.LastIndex).GetParentObject())
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
						case CustomGear customGear:
							__result = customGear.GearInfo;
							break;
					}
				}
			}
		}

		[HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.FetchCustomGear))]
		public static class FetchCustomGearPatch
		{
			static void Prefix(GearDatabase __instance)
			{
				foreach (var skater in __instance.skaters)
				{
					foreach (var filter in skater.GearFilters)
					{
						filter.allowCustomGear = true;
					}
				}
			}

			static void Postfix(GearDatabase __instance)
			{
				GearManager.Instance.LoadGameGear();
				GearManager.Instance.LoadAssetCustomTextures();
			}
		}
	}
}
