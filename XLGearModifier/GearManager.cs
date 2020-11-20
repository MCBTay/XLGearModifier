using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using XLGearModifier.Unity;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Interfaces;

namespace XLGearModifier
{
	public class GearManager
	{
		private static GearManager __instance;
		public static GearManager Instance => __instance ?? (__instance = new GearManager());

		public CustomFolderInfo CurrentFolder { get; set; }
		public List<ICustomInfo> NestedItems { get; set; }
		public List<CustomGear> CustomGear;

		public GearManager()
		{
			NestedItems = new List<ICustomInfo>();
			CustomGear = new List<CustomGear>();
		}

		public void LoadAssets(AssetBundle bundle)
		{
			var assets = bundle.LoadAllAssets<GameObject>();

			if (assets == null || !assets.Any()) return;

			foreach (var asset in assets)
			{
				var metadata = asset.GetComponent<XLGearModifierMetadata>();
				if (metadata == null) continue;

				var customGear = new CustomGear(metadata, asset);

				CustomFolderInfo parent = null;

				AddFolder<CustomGearFolderInfo>(customGear.Category.ToString(), string.Empty, NestedItems, ref parent);
				AddFolder<CustomGearFolderInfo>(string.IsNullOrEmpty(metadata.DisplayName) ? asset.name : metadata.DisplayName, string.Empty, parent.Children, ref parent);

				var newGear = new CustomGear(metadata, asset);
				CustomGear.Add(newGear);
				AddItem(newGear, parent.Children, ref parent);
			}
		}

		public virtual void AddItem(CustomGear customGear, List<ICustomInfo> sourceList, ref CustomFolderInfo parent)
		{
			var existing = sourceList.FirstOrDefault(x => x.GetName() == customGear.Name);
			if (existing == null)
			{
				var test = new CustomCharacterGearInfo(customGear.GearInfo.name, customGear.GearInfo.type, false, customGear.GearInfo.textureChanges, customGear.GearInfo.tags);
				test.Info.Parent = parent;
				sourceList.Add(test.Info);
			}
		}

		public virtual void AddFolder<T>(string folder, string path, List<ICustomInfo> sourceList, ref CustomFolderInfo parent) where T : ICustomFolderInfo
		{
			string folderName = $"\\{folder}";

			var child = sourceList.FirstOrDefault(x => x.GetName().Equals(folderName, StringComparison.InvariantCultureIgnoreCase) && x is CustomFolderInfo) as CustomFolderInfo;
			if (child == null)
			{
				ICustomFolderInfo newFolder;

				if (typeof(T) == typeof(CustomGearFolderInfo))
				{
					newFolder = new CustomGearFolderInfo($"\\{folder}", path, parent);
				}
				else return;

				sourceList.Add(newFolder.FolderInfo);
				parent = newFolder.FolderInfo;
			}
			else
			{
				parent = child;
			}
		}
	}
}
