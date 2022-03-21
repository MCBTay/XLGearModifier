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

        public List<CustomGearBase> CustomGear;

		public List<ICustomInfo> CustomMeshes;
        public List<ICustomInfo> CustomFemaleMeshes;
		
		public List<ICustomInfo> Eyes;

        public Shader MasterShaderCloth_v2;
        public Shader MasterShaderHair_AlphaTest_v1;

		public Texture2D EmptyAlbedo;
        public Texture2D EmptyMaskPBR;
        public Texture2D EmptyNormalMap;

        public const string EmptyAlbedoFilename = "Empty_Albedo.png";
        public const string EmptyNormalFilename = "Empty_Normal_Map.png";
        public const string EmptyMaskFilename = "Empty_Maskpbr_Map.png";

        public Dictionary<string, Dictionary<string, Texture>> BaseGameTextures;

        public GearManager()
		{
			CustomMeshes = new List<ICustomInfo>();
            CustomFemaleMeshes = new List<ICustomInfo>();

			CustomGear = new List<CustomGearBase>();

            Eyes = new List<ICustomInfo>();

            BaseGameTextures = new Dictionary<string, Dictionary<string, Texture>>();
        }

        /// <summary>
        /// Loads materials from the base game.  Loads materials for tops, bottoms, shoes, headwear, and hair.
        /// </summary>
        public async Task LoadGameMaterials()
        {
            await Task.WhenAll(new List<Task>
            {
                LoadBaseMaterials<TopTypes>(),
                LoadBaseMaterials<BottomTypes>(),
                LoadBaseMaterials<ShoeTypes>(),
                LoadBaseMaterials<HeadwearTypes>(),
                LoadBaseMaterials<HairStyles>(true)
            });
        }

        private async Task LoadBaseMaterials<T>(bool isHair = false) where T : Enum
        {
            var names = Enum.GetNames(typeof(T)).Select(x => x.ToLower());

            foreach (var name in names)
            {
                var material = await LoadBaseGameAssetMaterial(name);
                if (material == null) continue;

                if (name == TopTypes.MShirt.ToString().ToLower() && MasterShaderCloth_v2 == null)
                {
                    MasterShaderCloth_v2 = material.shader;
                }

                if (name == HairStyles.MHairCounterpart.ToString().ToLower() && MasterShaderHair_AlphaTest_v1 == null)
                {
                    MasterShaderHair_AlphaTest_v1 = material.shader;
                }

                var textures = new Dictionary<string, Texture>
                {
                    { "normal", material.GetTexture(isHair ? "_texture_normal" : "_texture2D_normal") },
                    { "maskpbr", material.GetTexture(isHair ? "_texture_mask" : "_texture2D_maskPBR") }
                };

                BaseGameTextures.Add(name, textures);
            }
        }

        /// <summary>
        /// Finds the material being used by the specified TemplateId and returns it.  Has to load the prefab from the Addressables system in order to be able to get that reference to the material.
        /// </summary>
        /// <param name="templateId">The template/mesh to get the shader for.</param>
        /// <returns>A reference to the shader being used by the mesh/template.</returns>
        private async Task<Material> LoadBaseGameAssetMaterial(string templateId)
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

            var target = materialController.targets?.FirstOrDefault();
            if (target == null) return null;

            return target.renderer?.material;
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

                var officialCount = AddOfficialTextures(clothingGear, officialTextures, ref parent);
				var customCount = AddCustomTextures(clothingGear, customTextures, ref parent);

                if (officialCount + customCount == 0)
                {
					AddDefaultEmptyTexture(clothingGear, parent.Children, ref parent);
                }
            }

            CustomMeshes = CustomMeshes.OrderBy(x => Enum.Parse(typeof(ClothingGearCategory), x.GetName().Replace("\\", string.Empty))).ToList();
            CustomFemaleMeshes = CustomFemaleMeshes.OrderBy(x => Enum.Parse(typeof(ClothingGearCategory), x.GetName().Replace("\\", string.Empty))).ToList();
		}

        private int AddOfficialTextures(ClothingGear clothingGear, GearInfo[][][] officialTextures, ref CustomFolderInfo parent)
        {
            if (!clothingGear.ClothingMetadata.BaseOnDefaultGear) return 0;

            return AddTextures(clothingGear, officialTextures, parent.Children, ref parent);
		}

        private int AddCustomTextures(ClothingGear clothingGear, GearInfo[][][] customTextures, ref CustomFolderInfo parent)
        {
            return AddTextures(clothingGear, customTextures, parent.Children, ref parent, true);
		}

		/// <summary>
		/// A method to look through gearListSource or customGearListSource in order to add appropriate textures to appropriate mesh lists based on defined prefixes.
		/// </summary>
		/// <param name="clothingGear">The clothing gear item we're looking for textures for.</param>
		/// <param name="sourceList">The source list we'll be looking for textures in.</param>
		/// <param name="destList">The list where we will be adding the texture.</param>
		/// <param name="parent">The parent of the list we're adding to.</param>
		/// <param name="isCustom">True if the texture is on disk, false otherwise.</param>
		/// <returns>The number of textures added.</returns>
		public int AddTextures(ClothingGear clothingGear, GearInfo[][][] sourceList, List<ICustomInfo> destList, ref CustomFolderInfo parent, bool isCustom = false)
        {
            int skaterIndex = (int)clothingGear.ClothingMetadata.Skater;

            if (clothingGear.ClothingMetadata.BaseOnDefaultGear)
            {
                skaterIndex = clothingGear.GetSkaterIndexForDefaultGear();
            }

			int categoryIndex = clothingGear.GetCategoryIndex(skaterIndex);

			var categoryTextures = sourceList[skaterIndex][categoryIndex];

            var prefixesToSearch = GetPrefixesToSearch(clothingGear.ClothingMetadata);

			var textures = categoryTextures
                .Where(x => prefixesToSearch.Contains(x.type))
                .Select(x => x as GearInfoSingleMaterial)
                .ToList();

            foreach (var texture in textures)
            {
                AddToList(clothingGear, texture, destList, ref parent, isCustom);
            }

            return textures.Count;
        }

		/// <summary>
		/// Returns a list of texture prefixes to search for.  By default will return the prefix of the mesh, but if it is based on default or has an alias, it will include those as well.
		/// </summary>
        private List<string> GetPrefixesToSearch(XLGMClothingGearMetadata metadata)
        {
            var prefixes = new List<string> { metadata.Prefix.ToLower() };

            if (metadata.BaseOnDefaultGear)
            {
                prefixes.Add(metadata.GetBaseType().ToLower());
            }

            if (!string.IsNullOrEmpty(metadata.PrefixAlias))
            {
                prefixes.Add(metadata.PrefixAlias.ToLower());
            }

            return prefixes;
        }

        private void AddDefaultEmptyTexture(ClothingGear clothingGear, List<ICustomInfo> destList, ref CustomFolderInfo parent)
        {
            string texturePath = $"XLGearModifier/{clothingGear.Prefab.name}";

            var textureChanges = new List<TextureChange>
            {
                new TextureChange("albedo", $"{texturePath}/{EmptyAlbedoFilename}"),
                new TextureChange("normal", $"{texturePath}/{EmptyNormalFilename}"),
                new TextureChange("maskpbr", $"{texturePath}/{EmptyMaskFilename}")
            };

            var characterGearInfo = new CustomCharacterGearInfo(clothingGear.Metadata.Prefix, clothingGear.Metadata.Prefix, false, textureChanges.ToArray(), new List<string>().ToArray());
            AddToList(clothingGear, characterGearInfo, destList, ref parent, false);
		}

        private void AddToList(ClothingGear customGearBase, GearInfoSingleMaterial baseTexture, List<ICustomInfo> destList, ref CustomFolderInfo parent, bool isCustom)
		{
			var child = destList.FirstOrDefault(x => x.GetName().Equals(baseTexture.name, StringComparison.InvariantCultureIgnoreCase));
			if (child != null) return;

            var gearInfo = new CustomCharacterGearInfo(baseTexture.name, customGearBase.GearInfo.type, isCustom, baseTexture.textureChanges, customGearBase.GearInfo.tags);
            gearInfo.Info.Parent = parent;
            gearInfo.Info.ParentObject = new ClothingGear(customGearBase, gearInfo);
            destList.Add(gearInfo.Info);

            GearDatabase.Instance.clothingGear.Add(gearInfo);
        }

        public override List<ICustomInfo> SortList(List<ICustomInfo> sourceList)
        {
            CurrentSort = (int)GearSortMethod.Name_ASC;
            return base.SortList(sourceList);
        }
    }
}
