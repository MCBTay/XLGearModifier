﻿using HarmonyLib;
using SkaterXL.Data;
using SkaterXL.Gear;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using XLGearModifier.CustomGear;
using XLGearModifier.Unity;
using XLMenuMod;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Interfaces;

namespace XLGearModifier
{
    public class GearManager
	{
		private static GearManager __instance;
		public static GearManager Instance => __instance ?? (__instance = new GearManager());

		public CustomFolderInfo CurrentFolder;
		
		public List<CustomGearBase> CustomGear;

		public List<ICustomInfo> CustomMeshes;
		public List<ICustomInfo> ProGear;
		public List<ICustomInfo> FemaleGear;
		public List<ICustomInfo> MaleGear;
		public List<ICustomInfo> Eyes;

        public Shader MasterShaderCloth_v2;
        public Shader MasterShaderHair_AlphaTest_v1;

		public Texture2D EmptyAlbedo;
		public Texture2D EmptyMaskPBR;
		public Texture2D EmptyNormalMap;

		public GearManager()
		{
			CustomMeshes = new List<ICustomInfo>();
			CustomGear = new List<CustomGearBase>();

			ProGear = new List<ICustomInfo>();
			FemaleGear = new List<ICustomInfo>();
			MaleGear = new List<ICustomInfo>();

			Eyes = new List<ICustomInfo>();
        }

        public async Task LoadGameShaders()
        {
            await Task.WhenAll(new List<Task>
            {
                LoadClothingShader(),
                LoadHairShader()
            });
        }

        private async Task LoadClothingShader()
        {
            MasterShaderCloth_v2 = await LoadBaseGameAssetShader(TopTypes.MShirt.ToString().ToLower());
		}

        private async Task LoadHairShader()
        {
            MasterShaderHair_AlphaTest_v1 = await LoadBaseGameAssetShader(HairStyles.MHairCounterpart.ToString().ToLower());
        }

        private async Task<Shader> LoadBaseGameAssetShader(string templateId)
        {
            var template = GearDatabase.Instance.CharGearTemplateForID[templateId];
            if (template == null) return null;

            AsyncOperationHandle<GameObject> loadOp = Addressables.LoadAssetAsync<GameObject>(template.path);
            await new WaitUntil(() => loadOp.IsDone);
            GameObject result = loadOp.Result;
            if (result == null)
            {
                Debug.Log("XLGM: No prefab found for template at path '" + template.path + "'");
                return null;
            }

            var materialController = result.GetComponentInChildren<MaterialController>();
            if (materialController == null) return null;

			return materialController?.targets?.FirstOrDefault()?.renderer.material.shader;
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
			LoadCharacterGear(Skater.MaleStandard, MaleGear);
		}

		private void LoadFemaleGear()
		{
			LoadCharacterGear(Skater.FemaleStandard, FemaleGear);
		}

		private void LoadProGear()
		{
			LoadCharacterGear(Skater.EvanSmith, ProGear);
			LoadCharacterGear(Skater.TomAsta, ProGear);
			LoadCharacterGear(Skater.TiagoLemos, ProGear);
			LoadCharacterGear(Skater.BrandonWestgate, ProGear);

			// We have to re-sort the list because TomAsta has a hat, which causes Headwear to show up at the bottom of the pro gear list.
			ProGear = ProGear.OrderBy(x => Enum.Parse(typeof(GearCategory), x.GetName().Replace("\\", string.Empty))).ToList();
		}

		private void LoadCharacterGear(Skater skater, List<ICustomInfo> destList)
		{
			var gearListSource = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();
			var gearCategories = gearListSource[(int)skater];
			CustomFolderInfo parent = null;
			AddCharacterGear(skater, gearCategories, destList, ref parent, false);

			var customGearListSource = Traverse.Create(GearDatabase.Instance).Field("customGearListSource").GetValue<GearInfo[][][]>();
			if (customGearListSource == null) return;
			var customGearCategories = customGearListSource[(int)skater];
			parent = null;
			AddCharacterGear(skater, customGearCategories, destList, ref parent, true);
		}

		private void AddCharacterGear(Skater skater, GearInfo[][] gearCategories, List<ICustomInfo> destList, ref CustomFolderInfo parent, bool isCustom)
		{
			for (int gearCategory = 0; gearCategory < gearCategories.Length; gearCategory++)
			{
				var currentGearCategory = gearCategories[gearCategory];
				if (currentGearCategory.Length <= 0) continue;

				switch (skater)
				{
					case Skater.MaleStandard when (gearCategory < (int)GearCategory.Hair || gearCategory > (int)GearCategory.Shoes):
					case Skater.FemaleStandard when (gearCategory < (int)GearCategory.Hair || gearCategory > (int)GearCategory.Shoes):
					case Skater.EvanSmith when (gearCategory < (int)EvanSmithGearCategory.Top || gearCategory > (int)EvanSmithGearCategory.Shoes):
					case Skater.TomAsta when (gearCategory < (int)TomAstaGearCategory.Headwear || gearCategory > (int)TomAstaGearCategory.Shoes):
					case Skater.BrandonWestgate when (gearCategory < (int)BrandonWestgateGearCategory.Top || gearCategory > (int)BrandonWestgateGearCategory.Shoes):
					case Skater.TiagoLemos when (gearCategory < (int)TiagoLemosGearCategory.Top || gearCategory > (int)TiagoLemosGearCategory.Shoes):
						continue;
				}

				string folderName = string.Empty;
				switch (skater)
				{
					case Skater.EvanSmith:
						folderName = ((EvanSmithGearCategory)gearCategory).ToString();
						break;
					case Skater.TomAsta:
						folderName = ((TomAstaGearCategory)gearCategory).ToString();
						break;
					case Skater.BrandonWestgate:
						folderName = ((BrandonWestgateGearCategory)gearCategory).ToString();
						break;
					case Skater.TiagoLemos:
						folderName = ((TiagoLemosGearCategory)gearCategory).ToString();
						break;
					case Skater.MaleStandard:
					case Skater.FemaleStandard:
					default:
						folderName = ((GearCategory)gearCategory).ToString();
						break;
				}

				AddFolder<CustomGearFolderInfo>(folderName, string.Empty, destList, ref parent);

				if (Main.XLMenuModEnabled)
				{
					var toBeAdded = LeverageXLMenuMod(gearCategory, currentGearCategory, isCustom);
					AddItemsFromXLMenuMod(toBeAdded, ref parent);
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

        public void AddBoardMesh(XLGMBoardGearMetadata metadata, CustomGearBase customGearBase, GameObject asset)
		{
			CustomFolderInfo parent = null;

			AddFolder<CustomGearFolderInfo>(metadata.Category.ToString(), string.Empty, CustomMeshes, ref parent);
			AddFolder<CustomGearFolderInfo>(string.IsNullOrEmpty(metadata.DisplayName) ? asset.name : metadata.DisplayName, string.Empty, parent.Children, ref parent);

			if (metadata.BaseOnDefaultGear)
			{
				var officialTextures = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();
				AddItem(customGearBase, officialTextures, parent.Children, ref parent);
			}
			else
			{
				AddItem(customGearBase, null, parent.Children, ref parent);
			}
		}

		public void AddClothingMesh(XLGMClothingGearMetadata metadata, CustomGearBase customGearBase, GameObject asset)
		{
			CustomFolderInfo parent = null;

			AddFolder<CustomGearFolderInfo>(metadata.Category.ToString(), string.Empty, CustomMeshes, ref parent);
			AddFolder<CustomGearFolderInfo>(string.IsNullOrEmpty(metadata.DisplayName) ? asset.name : metadata.DisplayName, string.Empty, parent.Children, ref parent);

			if (metadata.BaseOnDefaultGear)
			{
				var officialTextures = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();
				AddItem(customGearBase, officialTextures, parent.Children, ref parent);
			}
			else
			{
				AddItem(customGearBase, null, parent.Children, ref parent);
			}
		}

		public void LoadAssetCustomTextures()
		{
            var customTextures = Traverse.Create(GearDatabase.Instance).Field("customGearListSource").GetValue<GearInfo[][][]>();

			foreach (var customGear in CustomGear)
            {
                if (customGear is CustomSkater) continue;

				CustomFolderInfo parent = null;

				AddFolder<CustomGearFolderInfo>(customGear.Metadata.GetCategory(), string.Empty, CustomMeshes, ref parent);
				AddFolder<CustomGearFolderInfo>(string.IsNullOrEmpty(customGear.Metadata.DisplayName) ? customGear.Prefab.name : customGear.Metadata.DisplayName, string.Empty, parent.Children, ref parent);

				AddItem(customGear, customTextures, parent.Children, ref parent, true);
			}
		}

		public void AddItem(CustomGearBase customGearBase, GearInfo[][][] sourceList, List<ICustomInfo> destList, ref CustomFolderInfo parent, bool isCustom = false)
		{
			if (sourceList == null)
			{
				var defaultTexture = customGearBase.Metadata?.GetMaterialInformation()?.DefaultTexture;
				var altTextures = customGearBase.Metadata?.GetMaterialInformation()?.AlternativeTextures;

				if (defaultTexture == null && (altTextures == null || !altTextures.Any()))
				{
                    var textureChanges = new List<TextureChange>
                    {
                        new TextureChange("albedo", "XLGearModifier/Empty_Albedo.png"),
                        new TextureChange("normal", "XLGearModifier/Empty_Normal_Map.png"),
                        new TextureChange("maskpbr", "XLGearModifier/Empty_Maskpbr_Map.png")
                    };

					var characterGearInfo = new CustomCharacterGearInfo(customGearBase.Metadata.Prefix, customGearBase.Metadata.Prefix, false, textureChanges.ToArray(), new List<string>().ToArray());
					AddToList(customGearBase, characterGearInfo, destList, ref parent, isCustom);
				}
				else
				{
					// Either a default texture or an alternative texture is defined
					if (defaultTexture.textureColor != null)
					{
						var texturePath = $"XLGearModifier/{customGearBase.Prefab.name}/{defaultTexture.textureName}/";

                        var textureChanges = new List<TextureChange>
                        {
                            new TextureChange("albedo", texturePath + "albedo"),
                            new TextureChange("normal", texturePath + "normal"),
                            new TextureChange("maskpbr", texturePath + "maskpbr")
                        };

						var characterGearInfo = new CustomCharacterGearInfo(defaultTexture.textureName, customGearBase.Metadata.Prefix, false, textureChanges.ToArray(), new List<string>().ToArray());
						AddToList(customGearBase, characterGearInfo, destList, ref parent, isCustom);
					}

					foreach (var texture in altTextures.Where(x => x.textureColor != null))
					{
						var texturePath = $"XLGearModifier/{customGearBase.Prefab.name}/{texture.textureName}/";

                        var textureChanges = new List<TextureChange>
                        {
                            new TextureChange("albedo", texturePath + "albedo"),
                            new TextureChange("normal", texturePath + "normal"),
                            new TextureChange("maskpbr", texturePath + "maskpbr")
                        };

						var characterGearInfo = new CustomCharacterGearInfo(texture.textureName, customGearBase.Metadata.Prefix, false, textureChanges.ToArray(), new string[] { });
						AddToList(customGearBase, characterGearInfo, destList, ref parent, isCustom);
					}
				}

				return;
			}

			int skaterIndex = customGearBase.GetSkaterIndex();
			int categoryIndex = customGearBase.GetCategoryIndex(skaterIndex);

			var categoryTextures = sourceList[skaterIndex][categoryIndex];
			
			var textures = categoryTextures
				.Where(x => x.type == customGearBase.Metadata.Prefix.ToLower())
				.Select(x => x as GearInfoSingleMaterial)
				.ToList();

			if (customGearBase.Metadata.BasedOnDefaultGear())
			{
				if (customGearBase is CustomBoardGear)
                {
					var baseTypes = categoryTextures.Where(x => x.type == customGearBase.Metadata.GetBaseType().ToLower()).Select(x => x as BoardGearInfo).ToList();
					textures = textures.Concat(baseTypes).ToList();
				}
				else
				{
					var baseTypes = categoryTextures.Where(x => x.type == customGearBase.Metadata.GetBaseType().ToLower()).Select(x => x as CharacterGearInfo).ToList();
					textures = textures.Concat(baseTypes).ToList();
				}
			}

			if (Main.XLMenuModEnabled)
			{
				var toBeAdded = LeverageXLMenuMod(categoryIndex, textures.ToArray(), isCustom);

				foreach(var texture in toBeAdded)
				{
					if (texture.GetParentObject() is CustomCharacterGearInfo charGearInfo)
						AddToList(customGearBase, charGearInfo, destList, ref parent, isCustom);
					else if (texture.GetParentObject() is CustomGearFolderInfo folderInfo)
						AddFolder<CustomGearFolderInfo>(customGearBase, folderInfo, destList, ref parent, isCustom);
				}
			}
			else
			{
				foreach (var texture in textures)
				{
					AddToList(customGearBase, texture, destList, ref parent, isCustom);
				}
			}

			if (textures.Any() && isCustom && !customGearBase.Metadata.BasedOnDefaultGear())
			{
				var defaultTexture = destList.FirstOrDefault(x => x.GetName() == customGearBase.Metadata.Prefix);
				if (defaultTexture != null)
					destList.Remove(defaultTexture);
			}
		}

		public List<ICustomInfo> LeverageXLMenuMod(int gearCategory, GearInfo[] currentGearCategory, bool isCustom)
		{
			if (isCustom)
			{
				CustomGearManager.Instance.LoadNestedItems(currentGearCategory);
				return CustomGearManager.Instance.NestedItems;
			}

			if (gearCategory == (int)GearCategory.Hair)
			{
				CustomGearManager.Instance.LoadNestedHairItems(currentGearCategory);
			}
			else
			{
				CustomGearManager.Instance.LoadNestedOfficialItems(currentGearCategory);
			}

			return CustomGearManager.Instance.NestedOfficialItems;
		}

		public void AddItemsFromXLMenuMod(List<ICustomInfo> itemsToAdd, ref CustomFolderInfo parent)
		{
			foreach (var item in itemsToAdd)
			{
				item.Parent = parent;
			}

			parent.Children.AddRange(itemsToAdd);
		}

		private void AddToList(CustomGearBase customGearBase, GearInfoSingleMaterial baseTexture, List<ICustomInfo> destList, ref CustomFolderInfo parent, bool isCustom)
		{
			var child = destList.FirstOrDefault(x => x.GetName().Equals(baseTexture.name, StringComparison.InvariantCultureIgnoreCase));
			if (child != null) return;

			if (customGearBase is CustomBoardGear)
			{
				CustomBoardGearInfo gearInfo = new CustomBoardGearInfo(baseTexture.name, customGearBase.GearInfo.type, isCustom, baseTexture.textureChanges, customGearBase.GearInfo.tags);
				gearInfo.Info.Parent = parent;
				gearInfo.Info.ParentObject = new CustomBoardGear(customGearBase, gearInfo);
				destList.Add(gearInfo.Info);

				GearDatabase.Instance.boardGear.Add(gearInfo);
			}
			else
			{
				CustomCharacterGearInfo gearInfo = new CustomCharacterGearInfo(baseTexture.name, customGearBase.GearInfo.type, isCustom, baseTexture.textureChanges, customGearBase.GearInfo.tags);
				gearInfo.Info.Parent = parent;
				gearInfo.Info.ParentObject = new CustomClothingGear(customGearBase, gearInfo);
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

		public void AddFolder<T>(CustomGearBase customGearBase, CustomGearFolderInfo gearFolder, List<ICustomInfo> sourceList, ref CustomFolderInfo parent, bool isCustom) where T : ICustomFolderInfo
		{
			var child = sourceList.FirstOrDefault(x => x.GetName().Equals(gearFolder.FolderInfo.Name, StringComparison.InvariantCultureIgnoreCase) && x is CustomFolderInfo) as CustomFolderInfo;
			if (child == null)
			{
				CustomGearFolderInfo newFolder;

				if (typeof(T) == typeof(CustomGearFolderInfo))
				{
					newFolder = gearFolder;
					newFolder.isCustom = isCustom;
					newFolder.FolderInfo.Parent = parent;

					var goBack = newFolder.FolderInfo.Children.FirstOrDefault();
					if (goBack != null)
						goBack.Parent = parent;

					UpdateChildren(newFolder, customGearBase);
				}
				else return;

				sourceList.Add(newFolder.FolderInfo);
			}
		}

		private void UpdateChildren(ICustomFolderInfo folder, CustomGearBase customGearBase)
		{
			foreach (var child in folder.FolderInfo.Children)
			{
				if (child.GetParentObject() is CustomCharacterGearInfo characterGear)
				{
					characterGear.type = customGearBase.Metadata.Prefix.ToLower();
					//child.ParentObject = customGear;
					child.ParentObject = new CustomClothingGear(customGearBase, characterGear);
				}
				else if (child.GetParentObject() is CustomGearFolderInfo customGearFolder)
				{
					UpdateChildren(customGearFolder, customGearBase);
				}
			}
		}
	}
}
