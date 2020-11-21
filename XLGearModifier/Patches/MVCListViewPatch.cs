using HarmonyLib;

namespace XLGearModifier.Patches
{
	static class MVCListViewPatch
	{
		[HarmonyPatch(typeof(MVCListView), "Header_OnPreviousCategory")]
		public static class Header_OnPreviewCategoryPatch
		{
			static void Prefix(MVCListView __instance)
			{
				if (__instance.DataSource != null)
				{
					var newIndexPath = __instance.currentIndexPath;

					if (__instance.DataSource is GearSelectionController && __instance.currentIndexPath.depth > 2)
					{
						while (newIndexPath.depth != 2) { newIndexPath = newIndexPath.Up(); }

						Traverse.Create(__instance).Property("currentIndexPath").SetValue(newIndexPath);
						GearManager.Instance.CurrentFolder = null;
					}
				}
			}
		}

		[HarmonyPatch(typeof(MVCListView), "Header_OnNextCategory")]
		public static class Header_OnNextCategoryPatch
		{
			static void Prefix(MVCListView __instance)
			{
				if (__instance.DataSource != null)
				{
					var newIndexPath = __instance.currentIndexPath;

					if (__instance.DataSource is GearSelectionController && __instance.currentIndexPath.depth > 2)
					{
						while (newIndexPath.depth != 2) { newIndexPath = newIndexPath.Up(); }

						Traverse.Create(__instance).Property("currentIndexPath").SetValue(newIndexPath);
						GearManager.Instance.CurrentFolder = null;
					}
				}
			}
		}
	}
}
