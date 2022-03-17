using HarmonyLib;
using SkaterXL.Data;
using SkaterXL.Gear;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using XLGearModifier.Unity;
using XLGearModifier.Unity.ScriptableObjects;
using XLMenuMod;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Interfaces;
using ClothingGearCategory = XLGearModifier.Unity.ClothingGearCategory;

namespace XLGearModifier.CustomGear
{
	public class GearManager : CustomGearManager
	{
		private static GearManager __instance;
		public static GearManager Instance => __instance ?? (__instance = new GearManager());

		public CustomFolderInfo CurrentFolder;
		
		public List<CustomGearBase> CustomGear;

		public List<ICustomInfo> CustomMeshes;
        public List<ICustomInfo> CustomFemaleMeshes;
		
		public List<ICustomInfo> Eyes;

        public Shader MasterShaderCloth_v2;
        public Shader MasterShaderHair_AlphaTest_v1;

		public Texture2D EmptyAlbedo;
		public Texture2D EmptyMaskPBR;
		public Texture2D EmptyNormalMap;

		public GearManager()
		{
			CustomMeshes = new List<ICustomInfo>();
            CustomFemaleMeshes = new List<ICustomInfo>();

			CustomGear = new List<CustomGearBase>();

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

        public void LoadNestedItems()
        {
            var traverse = Traverse.Create(GearDatabase.Instance);

            var officialTextures = traverse.Field("gearListSource").GetValue<GearInfo[][][]>();
			var customTextures = traverse.Field("customGearListSource").GetValue<GearInfo[][][]>();

			CustomMeshes.Clear();
			CustomFemaleMeshes.Clear();

			foreach (var customGear in CustomGear)
            {
                if (customGear is Skater) continue;

				CustomFolderInfo parent = null;

                var clothingGear = customGear as ClothingGear;

				var sourceList = clothingGear.ClothingMetadata.Skater == SkaterBase.Male ? CustomMeshes : CustomFemaleMeshes;

				AddFolder<CustomGearFolderInfo>(clothingGear.ClothingMetadata.Category.ToString(), string.Empty, sourceList, ref parent);
                AddFolder<CustomGearFolderInfo>(string.IsNullOrEmpty(customGear.Metadata.DisplayName) ? customGear.Prefab.name : customGear.Metadata.DisplayName, string.Empty, parent.Children, ref parent);

                AddOfficialTextures(clothingGear, officialTextures, ref parent);
				AddCustomTextures(clothingGear, customTextures, ref parent);
                AddTextureSetTextures(clothingGear, parent.Children, ref parent);
            }

            CustomMeshes = CustomMeshes.OrderBy(x => Enum.Parse(typeof(ClothingGearCategory), x.GetName().Replace("\\", string.Empty))).ToList();
            CustomFemaleMeshes = CustomFemaleMeshes.OrderBy(x => Enum.Parse(typeof(ClothingGearCategory), x.GetName().Replace("\\", string.Empty))).ToList();
		}

        private void AddOfficialTextures(ClothingGear clothingGear, GearInfo[][][] officialTextures, ref CustomFolderInfo parent)
        {
            if (!clothingGear.ClothingMetadata.BaseOnDefaultGear) return;

            AddItem(clothingGear, officialTextures, parent.Children, ref parent);
		}

        private void AddCustomTextures(ClothingGear clothingGear, GearInfo[][][] customTextures, ref CustomFolderInfo parent)
        {
            AddItem(clothingGear, customTextures, parent.Children, ref parent, true);
		}

        private void AddTextureSetTextures(ClothingGear clothingGear, List<ICustomInfo> destList, ref CustomFolderInfo parent)
        {
            if (clothingGear.ClothingMetadata.BaseOnDefaultGear) return;
            if (clothingGear.ClothingMetadata.TextureSet == null) return;

			var defaultTexture = clothingGear.ClothingMetadata.TextureSet.DefaultTexture;
			var altTextures = clothingGear.ClothingMetadata.TextureSet.AlternativeTextures;

            if (defaultTexture == null && (altTextures == null || !altTextures.Any()))
			{
				AddTextureSetTexture(clothingGear, null, destList, ref parent);
                return;
            }

			AddTextureSetTexture(clothingGear, defaultTexture, destList, ref parent);

			foreach (var altTexture in altTextures)
            {
                AddTextureSetTexture(clothingGear, altTexture, destList, ref parent);
            }
        }

        private void AddTextureSetTexture(ClothingGear clothingGear, XLGMTextureInfo textureInfo, List<ICustomInfo> destList, ref CustomFolderInfo parent)
        {
            string albedoPath, normalPath, maskPath;

            albedoPath = normalPath = maskPath = $"XLGearModifier/{clothingGear.Prefab.name}/";

            if (textureInfo == null)
            {
                albedoPath += "Empty_Albedo.png";
                normalPath += "Empty_Normal_Map.png";
				maskPath += "Empty_Maskpbr_Map.png";
            }
			else if (textureInfo.textureColor == null) return;
			else
			{
                albedoPath += $"{textureInfo.textureName}/albedo";
                normalPath += $"{textureInfo.textureName}/normal";
                maskPath += $"{textureInfo.textureName}/maskpbr";
            }

            var textureChanges = new List<TextureChange>
            {
                new TextureChange("albedo", albedoPath),
                new TextureChange("normal", normalPath),
                new TextureChange("maskpbr", maskPath)
            };

            var characterGearInfo = new CustomCharacterGearInfo(textureInfo.textureName, clothingGear.Metadata.Prefix, false, textureChanges.ToArray(), new List<string>().ToArray());
            AddToList(clothingGear, characterGearInfo, destList, ref parent, false);
		}

        public void AddItem(CustomGearBase customGearBase, GearInfo[][][] sourceList, List<ICustomInfo> destList, ref CustomFolderInfo parent, bool isCustom = false)
		{
			int skaterIndex = customGearBase.GetSkaterIndex();
			int categoryIndex = customGearBase.GetCategoryIndex(skaterIndex);

			var categoryTextures = sourceList[skaterIndex][categoryIndex];
			
			var textures = categoryTextures
				.Where(x => x.type == customGearBase.Metadata.Prefix.ToLower())
				.Select(x => x as GearInfoSingleMaterial)
				.ToList();

			if (customGearBase.Metadata.BasedOnDefaultGear())
			{
				if (customGearBase is BoardGear)
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

            var clothingMetadata = customGearBase.Metadata as XLGMClothingGearMetadata;
            if (!string.IsNullOrEmpty(clothingMetadata?.PrefixAlias))
            {
				var aliasTypes = categoryTextures.Where(x => x.type == clothingMetadata.PrefixAlias.ToLower()).Select(x => x as CharacterGearInfo).ToList();
                textures = textures.Concat(aliasTypes).ToList();
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

			if (customGearBase is BoardGear)
			{
				CustomBoardGearInfo gearInfo = new CustomBoardGearInfo(baseTexture.name, customGearBase.GearInfo.type, isCustom, baseTexture.textureChanges, customGearBase.GearInfo.tags);
				gearInfo.Info.Parent = parent;
				gearInfo.Info.ParentObject = new BoardGear(customGearBase, gearInfo);
				destList.Add(gearInfo.Info);

				GearDatabase.Instance.boardGear.Add(gearInfo);
			}
			else
			{
				CustomCharacterGearInfo gearInfo = new CustomCharacterGearInfo(baseTexture.name, customGearBase.GearInfo.type, isCustom, baseTexture.textureChanges, customGearBase.GearInfo.tags);
				gearInfo.Info.Parent = parent;
				gearInfo.Info.ParentObject = new ClothingGear(customGearBase, gearInfo);
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
					child.ParentObject = new ClothingGear(customGearBase, characterGear);
				}
				else if (child.GetParentObject() is CustomGearFolderInfo customGearFolder)
				{
					UpdateChildren(customGearFolder, customGearBase);
				}
			}
		}

        public override List<ICustomInfo> SortList(List<ICustomInfo> sourceList)
        {
            CurrentSort = (int)GearSortMethod.Name_ASC;
            
            return base.SortList(sourceList);
        }

    }
}
