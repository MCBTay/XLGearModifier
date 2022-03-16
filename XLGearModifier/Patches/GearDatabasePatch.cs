using HarmonyLib;
using SkaterXL.Data;
using System.Collections.Generic;
using System.Linq;
using XLGearModifier.CustomGear;
using XLGearModifier.Texturing;
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
				if (!GearSelectionControllerPatch.IsOnXLGMTab(index[1]))
				{
					List<GearInfo> newResult = new List<GearInfo>(__result);

					// check to see if custom meshes are in list, if so, remove
					var customMeshes = GearManager.Instance.CustomGear;
					foreach (var mesh in customMeshes)
					{
						newResult.RemoveAll(x => x.type == mesh.Metadata.Prefix.ToLower());
					}

					__result = newResult.ToArray();
					return;
				}

                var sourceList = GetSourceList(index[1]);

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
				if (!GearSelectionControllerPatch.IsOnXLGMTab(index[1])) return;

                var sourceList = GetSourceList(index[1]);

				if (index.depth == 3)
				{
					if (index.LastIndex < 0 || index.LastIndex > sourceList.Count - 1) return;
					
					switch (sourceList.ElementAt(index.LastIndex).GetParentObject())
					{
						case CustomGearFolderInfo customGearFolderInfo:
							__result = customGearFolderInfo;
							break;
						case CustomCharacterGearInfo customCharacterGerInfo:
                            __result = customCharacterGerInfo;
                            break;
					}
				}
				// mesh per type, you've already selected a type so current folder should be valid, regardless of whether or not XLMenuMod is installed
				else if (index.depth >= 4)
				{
					var children = GearManager.Instance.CurrentFolder.Children;
					if (index.LastIndex < 0 || index.LastIndex > children.Count - 1) return;

					var parentObject = children.ElementAt(index.LastIndex).GetParentObject();
					switch (parentObject)
					{
						case CustomCharacterGearInfo customCharacterGearInfo:
							__result = customCharacterGearInfo;
							break;
						case CustomBoardGearInfo customBoardGearInfo:
							__result = customBoardGearInfo;
							break;
						case CustomGearFolderInfo customGearFolderInfo:
							__result = customGearFolderInfo;
							break;
						case CustomGearBase customGear:
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

				SkateShopTextureManager.Instance.LookForSkateshopTextures();
				EyeTextureManager.Instance.LookForEyeTextures();
            }
		}

        private static List<ICustomInfo> GetSourceList(int index)
        {
            switch ((GearModifierTab)index)
            {
                case GearModifierTab.CustomMeshes: return GearManager.Instance.CustomMeshes;
                case GearModifierTab.CustomFemaleMeshes: return GearManager.Instance.CustomFemaleMeshes;
                case GearModifierTab.Eyes: return GearManager.Instance.Eyes;
                default: return new List<ICustomInfo>();
            }
        }

        [HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetCamerView))]
        public static class GetCamerViewPatch
		{
            static void Postfix(IndexPath index, ref GearRoomCameraView __result)
            {
                if (index.depth < 2) return;

                if (index[1] != (int) GearModifierTab.Eyes) return;

                __result = GearRoomCameraView.Head;
            }
        }

		/// <summary>
		/// Patching into GearDatabase.ContainsClothingTemplateWithID such that I can call GearDatabase.GetGearIn for eye textures
		/// and it actually load them properly.
		/// </summary>
        [HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.ContainsClothingTemplateWithID))]
        public static class ContainsClothingTemplateWithIDPatch
        {
            static void Postfix(string id, ref bool __result)
            {
                if (id != "eyes") return;

                __result = true;
            }
        }
    }
}
