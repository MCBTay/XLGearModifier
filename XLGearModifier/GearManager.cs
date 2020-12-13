﻿using HarmonyLib;
using System;
using System.Collections.Generic;
using System.Linq;
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

			// We have to re-sort the list because TomAsta has a hat, which causes Headwear to show up at the bottom of the pro gear list.
			ProGear = ProGear.OrderBy(x => Enum.Parse(typeof(GearCategory), x.GetName().Replace("\\", string.Empty))).ToList();
		}

		private void LoadCharacterGear(Character character, List<ICustomInfo> destList)
		{
			var gearListSource = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();
			var gearCategories = gearListSource[(int)character];
			CustomFolderInfo parent = null;
			AddCharacterGear(character, gearCategories, destList, ref parent, false);

			var customGearListSource = Traverse.Create(GearDatabase.Instance).Field("customGearListSource").GetValue<GearInfo[][][]>();
			var customGearCategories = customGearListSource[(int)character];
			parent = null;
			AddCharacterGear(character, customGearCategories, destList, ref parent, true);
		}

		private void AddCharacterGear(Character character, GearInfo[][] gearCategories, List<ICustomInfo> destList, ref CustomFolderInfo parent, bool isCustom)
		{
			for (int gearCategory = 0; gearCategory < gearCategories.Length; gearCategory++)
			{
				var currentGearCategory = gearCategories[gearCategory];
				if (currentGearCategory.Length <= 0) continue;

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

				string folderName = string.Empty;
				switch (character)
				{
					case Character.EvanSmith:
						folderName = ((EvanSmithGearCategory)gearCategory).ToString();
						break;
					case Character.TomAsta:
						folderName = ((TomAstaGearCategory)gearCategory).ToString();
						break;
					case Character.BrandonWestgate:
						folderName = ((BrandonWestgateGearCategory)gearCategory).ToString();
						break;
					case Character.TiagoLemos:
						folderName = ((TiagoLemosGearCategory)gearCategory).ToString();
						break;
					case Character.MaleStandard:
					case Character.FemaleStandard:
					default:
						folderName = ((GearCategory)gearCategory).ToString();
						break;
				}

				AddFolder<CustomGearFolderInfo>(folderName, string.Empty, destList, ref parent);

				if (Main.XLMenuModEnabled)
				{
					LeverageXLMenuMod(gearCategory, currentGearCategory, ref parent, isCustom);
				}
				else
				{
					foreach (var gear in currentGearCategory)
					{
						var currentGear = gear as CharacterGearInfo;
						if (currentGear == null) continue;

						AddItem(currentGear, parent.Children, ref parent);
					}
				}
			}
		}

		public void LeverageXLMenuMod(int gearCategory, GearInfo[] currentGearCategory, ref CustomFolderInfo parent, bool isCustom)
		{
			if (isCustom)
			{
				CustomGearManager.Instance.LoadNestedItems(currentGearCategory);
				AddItemsFromXLMenuMod(CustomGearManager.Instance.NestedItems, ref parent);
			}
			else
			{
				if (gearCategory == (int)GearCategory.Hair)
				{
					CustomGearManager.Instance.LoadNestedHairItems(currentGearCategory);
				}
				else
				{
					CustomGearManager.Instance.LoadNestedOfficialItems(currentGearCategory);
				}

				AddItemsFromXLMenuMod(CustomGearManager.Instance.NestedOfficialItems, ref parent);
			}
		}

		public void AddItemsFromXLMenuMod(List<ICustomInfo> itemsToAdd, ref CustomFolderInfo parent)
		{
			foreach (var item in itemsToAdd)
			{
				item.Parent = parent;
			}

			parent.Children.AddRange(itemsToAdd);
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
				var metadata = asset.GetComponent<XLGMMetadata>();
				if (metadata == null) continue;
				if (string.IsNullOrEmpty(metadata.Prefix)) continue;

				var customGear = new CustomGear(metadata, asset);
				CustomGear.Add(customGear);

				switch (metadata)
				{
					case XLGMClothingGearMetadata clothingMetadata:
						AddClothingMesh(clothingMetadata, customGear, asset);
						break;
					case XLGMBoardGearMetadata boardMetadata:
						AddBoardMesh(boardMetadata, customGear, asset);
						break;
				}
			}

			CustomMeshes = CustomMeshes.OrderBy(x => Enum.Parse(typeof(GearCategory), x.GetName().Replace("\\", string.Empty))).ToList();
		}

		private void AddBoardMesh(XLGMBoardGearMetadata metadata, CustomGear customGear, GameObject asset)
		{
			CustomFolderInfo parent = null;

			AddFolder<CustomGearFolderInfo>(metadata.Category.ToString(), string.Empty, CustomMeshes, ref parent);
			AddFolder<CustomGearFolderInfo>(string.IsNullOrEmpty(metadata.DisplayName) ? asset.name : metadata.DisplayName, string.Empty, parent.Children, ref parent);

			if (metadata.BaseOnDefaultGear)
			{
				var officialTextures = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();
				AddItem(customGear, officialTextures, parent.Children, ref parent);
			}
			else
			{
				AddItem(customGear, null, parent.Children, ref parent);
			}
		}

		private void AddClothingMesh(XLGMClothingGearMetadata metadata, CustomGear customGear, GameObject asset)
		{
			CustomFolderInfo parent = null;

			AddFolder<CustomGearFolderInfo>(metadata.Category.ToString(), string.Empty, CustomMeshes, ref parent);
			AddFolder<CustomGearFolderInfo>(string.IsNullOrEmpty(metadata.DisplayName) ? asset.name : metadata.DisplayName, string.Empty, parent.Children, ref parent);

			if (metadata.BaseOnDefaultGear)
			{
				var officialTextures = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();
				AddItem(customGear, officialTextures, parent.Children, ref parent);
			}
			else
			{
				AddItem(customGear, null, parent.Children, ref parent);
			}
		}

		public void LoadAssetCustomTextures()
		{
			foreach (var customGear in CustomGear)
			{
				CustomFolderInfo parent = null;

				AddFolder<CustomGearFolderInfo>(customGear.Metadata.GetCategory(), string.Empty, CustomMeshes, ref parent);
				AddFolder<CustomGearFolderInfo>(string.IsNullOrEmpty(customGear.Metadata.DisplayName) ? customGear.Prefab.name : customGear.Metadata.DisplayName, string.Empty, parent.Children, ref parent);

				var customTextures = Traverse.Create(GearDatabase.Instance).Field("customGearListSource").GetValue<GearInfo[][][]>();
				AddItem(customGear, customTextures, parent.Children, ref parent, true);
			}
		}

		public void AddItem(CustomGear customGear, GearInfo[][][] sourceList, List<ICustomInfo> destList, ref CustomFolderInfo parent, bool isCustom = false)
		{
			if (sourceList == null)
			{
				var characterGearInfo = new CustomCharacterGearInfo(customGear.Metadata.Prefix, customGear.Metadata.Prefix, false, new[] { new TextureChange("albedo", "XLGearModifier\\Empty_Albedo.png") }, new string[] {});
				AddToList(customGear, characterGearInfo, destList, ref parent, isCustom);
				return;
			}

			int skaterIndex = customGear.GetSkaterIndex();
			int categoryIndex = customGear.GetCategoryIndex(skaterIndex);

			var categoryTextures = sourceList[skaterIndex][categoryIndex];
			
			var textures = categoryTextures
				.Where(x => x.type == customGear.Metadata.Prefix.ToLower())
				.Select(x => x as GearInfoSingleMaterial)
				.ToList();

			if (customGear.Metadata.BasedOnDefaultGear())
			{
				if (customGear.BoardMetdata != null)
				{
					var baseTypes = categoryTextures.Where(x => x.type == customGear.Metadata.GetBaseType().ToLower()).Select(x => x as BoardGearInfo).ToList();
					textures = textures.Concat(baseTypes).ToList();
				}
				else
				{
					var baseTypes = categoryTextures.Where(x => x.type == customGear.Metadata.GetBaseType().ToLower()).Select(x => x as CharacterGearInfo).ToList();
					textures = textures.Concat(baseTypes).ToList();
				}
			}

			foreach (var texture in textures)
			{
				AddToList(customGear, texture, destList, ref parent, isCustom);
			}

			if (textures.Any() && isCustom && !customGear.Metadata.BasedOnDefaultGear())
			{
				var defaultTexture = destList.FirstOrDefault(x => x.GetName() == customGear.Metadata.Prefix);
				if (defaultTexture != null)
					destList.Remove(defaultTexture);
			}
		}

		private void AddToList(CustomGear customGear, GearInfoSingleMaterial baseTexture, List<ICustomInfo> destList, ref CustomFolderInfo parent, bool isCustom)
		{
			var child = destList.FirstOrDefault(x => x.GetName().Equals(baseTexture.name, StringComparison.InvariantCultureIgnoreCase));
			if (child != null) return;

			if (customGear.BoardMetdata != null)
			{
				CustomBoardGearInfo gearInfo = new CustomBoardGearInfo(baseTexture.name, customGear.GearInfo.type, isCustom, baseTexture.textureChanges, customGear.GearInfo.tags);
				gearInfo.Info.Parent = parent;
				gearInfo.Info.ParentObject = new CustomGear(customGear, gearInfo);
				destList.Add(gearInfo.Info);

				GearDatabase.Instance.boardGear.Add(gearInfo);
			}
			else
			{
				CustomCharacterGearInfo gearInfo = new CustomCharacterGearInfo(baseTexture.name, customGear.GearInfo.type, isCustom, baseTexture.textureChanges, customGear.GearInfo.tags);
				gearInfo.Info.Parent = parent;
				gearInfo.Info.ParentObject = new CustomGear(customGear, gearInfo);
				destList.Add(gearInfo.Info);

				GearDatabase.Instance.clothingGear.Add(gearInfo);
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
