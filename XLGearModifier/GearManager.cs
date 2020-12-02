﻿using HarmonyLib;
using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using XLGearModifier.Unity;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Interfaces;
using GearCategory = XLGearModifier.Unity.GearCategory;

namespace XLGearModifier
{
	public class GearManager
	{
		private static GearManager __instance;
		public static GearManager Instance => __instance ?? (__instance = new GearManager());

		public CustomFolderInfo CurrentFolder;
		
		public List<CustomGear> CustomGear;

		public List<ICustomInfo> CustomMeshes;
		public List<ICustomInfo> ProGear;
		public List<ICustomInfo> FemaleGear;
		public List<ICustomInfo> MaleGear;

		private GearInfo[][][] gearListSource;
		private GearInfo[][][] customGearListSource;

		public GearManager()
		{
			CustomMeshes = new List<ICustomInfo>();
			CustomGear = new List<CustomGear>();

			ProGear = new List<ICustomInfo>();
			FemaleGear = new List<ICustomInfo>();
			MaleGear = new List<ICustomInfo>();
		}

		#region In Game Gear
		public void LoadGameGear()
		{
			gearListSource = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();
			customGearListSource = Traverse.Create(GearDatabase.Instance).Field("customGearListSource").GetValue<GearInfo[][][]>();

			LoadMaleGear();
			LoadFemaleGear();
			LoadProGear();
		}

		private void LoadMaleGear()
		{
			LoadCharacterGear(Character.MaleStandard, MaleGear);
		}

		private void LoadFemaleGear()
		{
			LoadCharacterGear(Character.FemaleStandard, FemaleGear);
		}

		private void LoadProGear()
		{
			LoadCharacterGear(Character.EvanSmith, ProGear);
			LoadCharacterGear(Character.TomAsta, ProGear);
			LoadCharacterGear(Character.TiagoLemos, ProGear);
			LoadCharacterGear(Character.BrandonWestgate, ProGear);
		}

		private void LoadCharacterGear(Character character, List<ICustomInfo> destList)
		{
			var gearCategories = gearListSource[(int)character];
			CustomFolderInfo parent = null;
			AddCharacterGear(character, gearCategories, destList, ref parent);

			var customGearCategories = customGearListSource[(int)character];
			parent = null;
			AddCharacterGear(character, customGearCategories, destList, ref parent);
		}

		private void AddCharacterGear(Character character, GearInfo[][] gearCategories, List<ICustomInfo> destList, ref CustomFolderInfo parent)
		{
			for (int gearCategory = 0; gearCategory < gearCategories.Length; gearCategory++)
			{
				var currentGearCategory = gearCategories[gearCategory];

				switch (character)
				{
					case Character.MaleStandard when (gearCategory < (int)GearCategory.Hair || gearCategory > (int)GearCategory.Shoes):
					case Character.FemaleStandard when (gearCategory < (int)GearCategory.Hair || gearCategory > (int)GearCategory.Shoes):
					case Character.EvanSmith when (gearCategory < (int)EvanSmithGearCategory.Top || gearCategory > (int)EvanSmithGearCategory.Shoes):
					case Character.TomAsta when (gearCategory < (int)TomAstaGearCategory.Headwear || gearCategory > (int)TomAstaGearCategory.Shoes):
					case Character.BrandonWestgate when (gearCategory < (int)BrandonWestgateGearCategory.Top || gearCategory > (int)BrandonWestgateGearCategory.Shoes):
					case Character.TiagoLemos when (gearCategory < (int)TiagoLemosGearCategory.Top || gearCategory > (int)TiagoLemosGearCategory.Shoes):
						continue;
				}

				if (currentGearCategory.Length <= 0) continue;

				switch (character)
				{
					case Character.EvanSmith:
						AddFolder<CustomGearFolderInfo>(((EvanSmithGearCategory)gearCategory).ToString(), string.Empty, destList, ref parent);
						break;
					case Character.TomAsta:
						AddFolder<CustomGearFolderInfo>(((TomAstaGearCategory)gearCategory).ToString(), string.Empty, destList, ref parent);
						break;
					case Character.BrandonWestgate:
						AddFolder<CustomGearFolderInfo>(((BrandonWestgateGearCategory)gearCategory).ToString(), string.Empty, destList, ref parent);
						break;
					case Character.TiagoLemos:
						AddFolder<CustomGearFolderInfo>(((TiagoLemosGearCategory)gearCategory).ToString(), string.Empty, destList, ref parent);
						break;
					case Character.MaleStandard:
					case Character.FemaleStandard:
					default:
						AddFolder<CustomGearFolderInfo>(((GearCategory)gearCategory).ToString(), string.Empty, destList, ref parent);
						break;
				}

				for (int gear = 0; gear < currentGearCategory.Length; gear++)
				{
					var currentGear = currentGearCategory[gear] as CharacterGearInfo;
					if (currentGear == null) continue;
					AddItem(currentGear, parent.Children, ref parent);
				}
			}
		}

		public void AddItem(CharacterGearInfo currentGear, List<ICustomInfo> destList, ref CustomFolderInfo parent)
		{
			var existing = destList.FirstOrDefault(x => x.Name == currentGear.name);
			if (existing == null)
			{
				var customInfo = new CustomCharacterGearInfo(currentGear.name, currentGear.type, currentGear.isCustom, currentGear.textureChanges, currentGear.tags);
				customInfo.Info.Parent = parent;
				destList.Add(customInfo.Info);
			}
		}
		#endregion

		public void LoadAssets(AssetBundle bundle)
		{
			var assets = bundle.LoadAllAssets<GameObject>();

			if (assets == null || !assets.Any()) return;

			foreach (var asset in assets)
			{
				var metadata = asset.GetComponent<XLGearModifierMetadata>();
				if (metadata == null) continue;

				var newGear = new CustomGear(metadata, asset);
				CustomGear.Add(newGear);

				CustomFolderInfo parent = null;

				AddFolder<CustomGearFolderInfo>(metadata.Category.ToString(), string.Empty, CustomMeshes, ref parent);
				AddFolder<CustomGearFolderInfo>(string.IsNullOrEmpty(metadata.DisplayName) ? asset.name : metadata.DisplayName, string.Empty, parent.Children, ref parent);

				var officialTextures = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();
				AddItem(newGear, officialTextures, parent.Children, metadata.BaseOnDefaultGear, ref parent);
			}
		}

		public void LoadAssetCustomTextures()
		{
			foreach (var customGear in CustomGear)
			{
				CustomFolderInfo parent = null;

				AddFolder<CustomGearFolderInfo>(customGear.Metadata.Category.ToString(), string.Empty, CustomMeshes, ref parent);
				AddFolder<CustomGearFolderInfo>(string.IsNullOrEmpty(customGear.Metadata.DisplayName) ? customGear.Prefab.name : customGear.Metadata.DisplayName, string.Empty, parent.Children, ref parent);

				var customTextures = Traverse.Create(GearDatabase.Instance).Field("customGearListSource").GetValue<GearInfo[][][]>();
				AddItem(customGear, customTextures, parent.Children, customGear.Metadata.BaseOnDefaultGear, ref parent);
			}
		}

		public void AddItem(CustomGear customGear, GearInfo[][][] sourceList, List<ICustomInfo> destList, bool basedOnDefaultGear, ref CustomFolderInfo parent)
		{
			var existing = destList.FirstOrDefault(x => x.GetName() == customGear.Name);
			if (existing == null)
			{
				if (sourceList == null) return;


				if (basedOnDefaultGear)
				{
					int skaterIndex = customGear.GetSkaterIndex();
					int categoryIndex = customGear.GetCategoryIndex(skaterIndex);

					var categoryTextures = sourceList[skaterIndex][categoryIndex];
					
					var baseTextures = categoryTextures.Where(x => x.type == customGear.Type.ToLower()).Select(x => x as CharacterGearInfo).ToList();
					foreach (var baseTexture in baseTextures)
					{
						var gearInfo = new CustomCharacterGearInfo(baseTexture.name, customGear.GearInfo.type, false, baseTexture.textureChanges, customGear.GearInfo.tags);
						gearInfo.Info.Parent = parent;
						gearInfo.Info.ParentObject = new CustomGear(customGear, gearInfo);
						destList.Add(gearInfo.Info);

						GearDatabase.Instance.clothingGear.Add(gearInfo);
					}
				}
				else
				{
					var gearInfo = new CustomCharacterGearInfo(customGear.GearInfo.name, customGear.GearInfo.type, false, customGear.GearInfo.textureChanges, customGear.GearInfo.tags);
					gearInfo.Info.Parent = parent;
					gearInfo.Info.ParentObject = new CustomGear(customGear, gearInfo);
					destList.Add(gearInfo.Info);

					GearDatabase.Instance.clothingGear.Add(gearInfo);
				}
			}
		}

		public void AddFolder<T>(string folder, string path, List<ICustomInfo> sourceList, ref CustomFolderInfo parent) where T : ICustomFolderInfo
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
