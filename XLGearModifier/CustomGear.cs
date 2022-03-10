using HarmonyLib;
using Newtonsoft.Json;
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
using ClothingGearCategory = SkaterXL.Gear.ClothingGearCategory;

namespace XLGearModifier
{
    public class CustomGear : CustomInfo
	{
		public XLGMMetadata Metadata;
		public XLGMClothingGearMetadata ClothingMetadata => Metadata as XLGMClothingGearMetadata;
		public XLGMBoardGearMetadata BoardMetadata => Metadata as XLGMBoardGearMetadata;
		public XLGMSkaterMetadata SkaterMetadata => Metadata as XLGMSkaterMetadata;

		public GameObject Prefab;
		[JsonIgnore]
		public GearInfo GearInfo;

		public CustomGear(XLGMMetadata metadata, GameObject prefab)
		{
			Metadata = metadata;
			Prefab = prefab;
		}

		public CustomGear(CustomGear gearToClone, GearInfoSingleMaterial gearInfo) : this(gearToClone.Metadata, gearToClone.Prefab)
		{
			GearInfo = gearInfo;
		}

		public async Task Instantiate()
		{
			switch (Metadata)
			{
				case XLGMClothingGearMetadata clothingMetadata:
					InstantiateCustomClothing(clothingMetadata);
					break;
				case XLGMSkaterMetadata skaterMetadata:
                    //InstantiateCustomSkater(skaterMetadata);
					break;
				case XLGMBoardGearMetadata boardMetadata:
					await InstantiateCustomBoard(boardMetadata);
					break;
			}
		}

		#region Custom ClothingGear methods
		private void InstantiateCustomClothing(XLGMClothingGearMetadata clothingMetadata)
		{
			var name = string.IsNullOrEmpty(clothingMetadata.DisplayName) ? Prefab.name : clothingMetadata.DisplayName;

			GearInfo = new CustomCharacterGearInfo(name, clothingMetadata.Prefix, false, GetDefaultTextureChanges(), new string[0]);
            
            SetTexturesAndShader(clothingMetadata);
            
			AddPrefixToGearFilters();
			this.AddCharacterGearTemplate(clothingMetadata);
		}

        /// <summary>
        /// Adds the default texture from XLGMTextureSet (if exists, else uses empties), and puts the asset material on the MasterShaderCloth_v2 shader.
        /// </summary>
        private void SetTexturesAndShader(XLGMClothingGearMetadata metadata)
        {
            if (metadata == null) return;

            var materialControllers = Prefab.GetComponentsInChildren<MaterialController>();
            if (materialControllers == null || !materialControllers.Any()) return;

            foreach (var materialController in materialControllers)
            {
                CreateMaterialWithTexturesOnProperShader(materialController, metadata);
            }
        }

        private void CreateMaterialWithTexturesOnProperShader(MaterialController materialController, XLGMClothingGearMetadata clothingMetadata)
        {
            if (materialController == null) return;

            var textures = CreateTextureDictionary();
            var material = materialController.GenerateMaterialWithChanges(textures);

            // TODO: Because we're having to make the materials in HDRP/Lit in the editor (until we get their shader, hopefully)
            // we need to store off a copy of the normal and mask maps, and ensure we assign them to the correct property names once the shader has been changed.
            // Hopefully, if we can get access to their cloth shader, we can just assign properties directly in editor and get rid of most of this code.
            var normalMap = GetNormalMap(material);
            var maskMap = GetMaskMap(material);

            material.shader = GetClothingShader(clothingMetadata);

            material.SetTexture("_texture2D_normal", normalMap);
            material.SetTexture("_texture2D_maskPBR", maskMap);

            materialController.SetMaterial(material);
        }

        /// <summary>
        /// Creates a dictionary of textures for albedo, normal, and mask pbr.  If we can't find default texture information on the prefab we will use the empties bundled into mod.
        /// </summary>
        private Dictionary<string, Texture> CreateTextureDictionary()
        {
            var textures = new Dictionary<string, Texture>();

            var defaultTexture = Metadata.GetMaterialInformation()?.DefaultTexture;

            textures.Add("albedo", defaultTexture?.textureColor ?? AssetBundleHelper.Instance.emptyAlbedo);
            textures.Add("normal", defaultTexture?.textureNormalMap ?? AssetBundleHelper.Instance.emptyNormalMap);
            textures.Add("maskpbr", defaultTexture?.textureMaskPBR ?? AssetBundleHelper.Instance.emptyMaskPBR);
            //textures.Add(shaderName == "MasterShaderCloth_v2" ? "_texture2D_maskPBR" : "_texture2D_rgmtao", Metadata.GetMaterialInformation()?.DefaultTexture?.textureMaskPBR ?? AssetBundleHelper.Instance.emptyMaskPBR);

            return textures;
        }

        /// <summary>
        /// Gets the normal map from the material using HDRP/Lit property names.  If no normal is found, then it returns the default empty normal we have in our base bundle.
        /// </summary>
        /// <param name="material">The material to look for textures on.</param>
        /// <returns>Either the normal found on the material or a default empty normal.</returns>
        private Texture GetNormalMap(Material material)
        {
            return material.GetTexture("_NormalMap") ?? AssetBundleHelper.Instance.emptyNormalMap;
        }

        /// <summary>
        /// Gets the mask map from the material using HDRP/Lit property names.  If no mask is found, then it returns the default empty mask we have in our base bundle.
        /// </summary>
        /// <param name="material">The material to look for textures on.</param>
        /// <returns>Either the mask found on the material or a default empty mask.</returns>
        private Texture GetMaskMap(Material material)
        {
            return material.GetTexture("_MaskMap") ?? AssetBundleHelper.Instance.emptyNormalMap;
        }

		/// <summary>
        /// Gets reference to MasterShaderCloth_v2 unless the metadata category is Hair or Facial Hair, then returns a reference to MasterShaderHair_AlphaTest_v1.
        /// </summary>
        private Shader GetClothingShader(XLGMClothingGearMetadata clothingMetadata)
        {
            if (clothingMetadata != null &&
                (clothingMetadata.Category == Unity.ClothingGearCategory.Hair ||
                 clothingMetadata.Category == Unity.ClothingGearCategory.FacialHair))
            {
                return GearManager.Instance.MasterShaderHair_AlphaTest_v1;
            }

            return GearManager.Instance.MasterShaderCloth_v2;
        }

        private void AddPrefixToGearFilters()
        {
            var skaterIndex = ClothingMetadata != null ? (int) ClothingMetadata.Skater : (int) SkaterBase.Male;

            var typeFilter = GearDatabase.Instance.skaters[skaterIndex].GearFilters[GetCategoryIndex(skaterIndex)];

            if (!typeFilter.includedTypes.Contains(Metadata.Prefix))
            {
                Array.Resize(ref typeFilter.includedTypes, typeFilter.includedTypes.Length + 1);
                typeFilter.includedTypes[typeFilter.includedTypes.Length - 1] = Metadata.Prefix;
            }
        }

        private void AddCharacterGearTemplate(XLGMClothingGearMetadata metadata)
        {
            if (GearDatabase.Instance.CharGearTemplateForID.ContainsKey(metadata.Prefix.ToLower())) return;

            var newGearTemplate = new CharacterGearTemplate
            {
                alphaMasks = new List<GearAlphaMaskConfig>(),
                category = MapCategory(metadata.Category),
                id = metadata.Prefix.ToLower(),
                path = $"XLGearModifier/{Prefab.name}"
            };

            AddOrUpdateTemplateAlphaMasks(metadata, newGearTemplate);

            GearDatabase.Instance.CharGearTemplateForID.Add(metadata.Prefix.ToLower(), newGearTemplate);
        }

        private ClothingGearCategory MapCategory(Unity.ClothingGearCategory category)
        {
            switch (category)
            {
                case Unity.ClothingGearCategory.Hair:
                case Unity.ClothingGearCategory.FacialHair:
                case Unity.ClothingGearCategory.Headwear:
                    return ClothingGearCategory.Hat;
                case Unity.ClothingGearCategory.Shoes:
                case Unity.ClothingGearCategory.Socks:
                    return ClothingGearCategory.Shoes;
                case Unity.ClothingGearCategory.Bottom:
                    return ClothingGearCategory.Pants;
                default:
                case Unity.ClothingGearCategory.Top:
                    return ClothingGearCategory.Shirt;
            }
        }

        private void AddOrUpdateTemplateAlphaMasks(XLGMClothingGearMetadata metadata, CharacterGearTemplate template)
        {
            if (metadata.AlphaMaskThresholds == null || !metadata.AlphaMaskThresholds.Any()) return;

            foreach (var mask in metadata.AlphaMaskThresholds)
            {
                if (mask == null) continue;

                if (mask.Threshold > 250) mask.Threshold = 250;

                var existing = template.alphaMasks.FirstOrDefault(x => (int)x.MaskLocation == (int)mask.MaskLocation);
                if (existing == null)
                {
                    template.alphaMasks.Add(mask);
                }
                else
                {
                    existing.Threshold = mask.Threshold;
                }
            }
        }
		#endregion

		#region Custom Skater methods
		/// <summary>
		/// Creates a list of type filters for custom skaters.  This controls what "texture groups" they do/don't have access to, and which prefixes to use.
		/// By default, custom skaters currently only have access to custom board textures.
		/// </summary>
		/// <returns>List of TypeFilters</returns>
		private TypeFilterList GetCustomSkaterTypeFilters()
        {
            return new TypeFilterList(new List<TypeFilter>
            {
                new TypeFilter
                {
                    allowCustomGear = true,
                    cameraView = GearRoomCameraView.Deck,
                    excludedTags = new[] { "ProOnly" },
                    includedTypes = new[] { "Deck" },
                    label = "Deck",
                    requiredTag = ""
                },
                new TypeFilter
                {
                    allowCustomGear = true,
                    cameraView = GearRoomCameraView.Grip,
                    excludedTags = new[] { "ProOnly" },
                    includedTypes = new[] { "GripTape" },
                    label = "Griptape",
                    requiredTag = ""
                },
                new TypeFilter
                {
                    allowCustomGear = true,
                    cameraView = GearRoomCameraView.Truck,
                    excludedTags = new[] { "ProOnly" },
                    includedTypes = new [] { "Trucks", "TrucksIndependent", "TrucksThunder", "TrucksVenture" },
                    label = "Trucks",
                    requiredTag = ""
                },
                new TypeFilter
                {
                    allowCustomGear = true,
                    cameraView = GearRoomCameraView.Wheel,
                    excludedTags = new[] { "ProOnly" },
                    includedTypes = new [] { "Wheels" },
                    label = "Wheels",
                    requiredTag = ""
                }
            });
        }

		private void InstantiateCustomSkater(XLGMSkaterMetadata skaterMetadata)
		{
			var name = string.IsNullOrEmpty(skaterMetadata.DisplayName) ? Prefab.name : skaterMetadata.DisplayName;

            var skaterInfo = new SkaterInfo
			{
				stance = SkaterInfo.Stance.Regular,
                bodyID = skaterMetadata.Prefix,
                name = name,
                GearFilters = GetCustomSkaterTypeFilters(),
            };
            GearDatabase.Instance.skaters.Add(skaterInfo);
            //Traverse.Create(GearDatabase.Instance).Method("GenerateGearListSource").GetValue();

			GearInfo = new CharacterBodyInfo(name, skaterMetadata.Prefix, false, new List<MaterialChange>(), new string[] { });

			SetTexturesAndShader(skaterMetadata);

			this.AddBodyGearTemplate();
			GearDatabase.Instance.bodyGear.Add(GearInfo as CharacterBodyInfo);
		}

		private void SetTexturesAndShader(XLGMSkaterMetadata metadata)
        {
            if (metadata == null) return;

            var cbi = GearInfo as CharacterBodyInfo;
            if (cbi == null) return;

            var materialControllers = Prefab.GetComponentsInChildren<MaterialController>();
            if (materialControllers == null || !materialControllers.Any()) return;

            var materialChanges = new List<MaterialChange>();

            foreach (var materialController in materialControllers)
            {
                CreateMaterialWithTexturesOnProperShader(materialController, metadata);

                var texturePath = $"XLGearModifier/{Prefab.name}/{materialController.materialID}/";

				var textureChanges = new List<TextureChange>
                {
                    new TextureChange("albedo", texturePath + "albedo"),
                    new TextureChange("normal", texturePath + "normal"),
                    new TextureChange("maskpbr", texturePath + "maskpbr")
                };

				materialChanges.Add(new MaterialChange(materialController.materialID, textureChanges.ToArray()));
            }

			cbi.materialChanges = materialChanges;
		}

        private void CreateMaterialWithTexturesOnProperShader(MaterialController materialController, XLGMSkaterMetadata metadata)
        {
            if (materialController == null) return;

            var renderer = materialController.targets.FirstOrDefault()?.renderer;
			if (renderer == null) return;

            var textures = new Dictionary<string, Texture>();

            var target = materialController.targets.FirstOrDefault();
			if (target == null) return;

            var material = renderer.materials[target.materialIndex];

			textures.Add("albedo", material.GetTexture("_BaseColorMap") ?? AssetBundleHelper.Instance.emptyAlbedo);
			textures.Add("normal", material.GetTexture("_NormalMap") ?? AssetBundleHelper.Instance.emptyNormalMap);
			textures.Add("maskpbr", material.GetTexture("_MaskMap") ?? AssetBundleHelper.Instance.emptyMaskPBR);

			var newMaterial = materialController.GenerateMaterialWithChanges(textures);
            //material.shader = Shader.Find("MasterShaderCloth_v1");
            materialController.SetMaterial(newMaterial);
        }
        #endregion

        #region Custom BoardGear methods
        // likely broken, can come back to this
        private async Task InstantiateCustomBoard(XLGMBoardGearMetadata boardMetadata)
		{
			var name = string.IsNullOrEmpty(boardMetadata.DisplayName) ? Prefab.name : boardMetadata.DisplayName;

			GearInfo = new CustomBoardGearInfo(name, boardMetadata.Prefix, false, GetDefaultTextureChanges(), new string[0]);

			if (boardMetadata.Category == Unity.BoardGearCategory.Deck)
			{
				await AddDeckMaterialControllers();
			}
			else
			{
                //SetTexturesAndShader(boardMetadata);
			}

			this.AddPrefixToGearFilters();
			this.AddBoardGearTemplate(boardMetadata);
		}

        private async Task AddDeckMaterialControllers()
        {
            var materialControllers = await GetDefaultGearMaterialControllers();

            foreach (var materialController in materialControllers)
            {
                //CreateNewMaterialController(Prefab, materialController);
            }
        }

        private async Task<IEnumerable<MaterialController>> GetDefaultGearMaterialControllers()
        {
            return (await GetBaseObject())?.GetComponentsInChildren<MaterialController>();
        }
        #endregion

        private TextureChange[] GetDefaultTextureChanges()
		{
            return GetBaseGearInfo()?.textureChanges;
        }

		public async Task<GameObject> GetBaseObject()
		{
			var info = GetBaseGearInfo();
			if (info == null) return null;

            var path = BoardMetadata != null ? GearDatabase.Instance.DeckTemplateForID[info.type].path : GearDatabase.Instance.CharGearTemplateForID[info.type].path;
			
			AsyncOperationHandle<GameObject> loadOp = Addressables.LoadAssetAsync<GameObject>(path);
			await new WaitUntil(() => loadOp.IsDone);
			GameObject result = loadOp.Result;
			if (result == null)
			{
				Debug.Log("XLGM: No prefab found for template at path '" + path + "'");
			}
			return result;
		}

		private GearInfoSingleMaterial GetBaseGearInfo()
		{
			var gear = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();

			var skaterIndex = GetSkaterIndex();
			GearInfo[] officialGear = gear[skaterIndex][GetCategoryIndex(skaterIndex)];
			return officialGear.Where(x => x.type.Equals(Metadata.GetBaseType(), StringComparison.InvariantCultureIgnoreCase)).Cast<GearInfoSingleMaterial>().FirstOrDefault();
		}

		public int GetSkaterIndex()
		{
			var skaterIndex = (int)Skater.MaleStandard;

            var type = Metadata.Prefix;

            if (ClothingMetadata != null && ClothingMetadata.BaseOnDefaultGear)
            {
                type = ClothingMetadata.GetBaseType();
            }
            else if (BoardMetadata != null && BoardMetadata.BaseOnDefaultGear)
            {
                type = BoardMetadata.GetBaseType();
            }

            if (string.IsNullOrEmpty(type)) return (int)Skater.MaleStandard;

            if (type.StartsWith("m", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.MaleStandard;
            }
            else if (type.StartsWith("f", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.FemaleStandard;
            }
            else if (type.StartsWith("es", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.EvanSmith;
            }
            else if (type.StartsWith("ta", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.TomAsta;
            }
            else if (type.StartsWith("bw", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.BrandonWestgate;
            }
            else if (type.StartsWith("tl", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.TiagoLemos;
            }

            return skaterIndex;
        }

		public int GetCategoryIndex(int skaterIndex)
		{
			if (ClothingMetadata == null && BoardMetadata == null) return 0;

			var categoryIndex = ClothingMetadata != null ? (int)ClothingMetadata.Category : (int)BoardMetadata.Category;
			var category = ClothingMetadata != null ? ClothingMetadata.Category.ToString() : BoardMetadata.Category.ToString();

			switch (skaterIndex)
			{
				case (int)Skater.EvanSmith:
					Enum.TryParse(category, out EvanSmithGearCategory esCategory);
					categoryIndex = (int)esCategory;
					break;
				case (int)Skater.TomAsta:
					Enum.TryParse(category, out TomAstaGearCategory taCategory);
					categoryIndex = (int)taCategory;
					break;
				case (int)Skater.BrandonWestgate:
					Enum.TryParse(category, out BrandonWestgateGearCategory bwCategory);
					categoryIndex = (int)bwCategory;
					break;
				case (int)Skater.TiagoLemos:
					Enum.TryParse(category, out TiagoLemosGearCategory tlCategory);
					categoryIndex = (int)tlCategory;
					break;
			}

			return categoryIndex;
		}
	}

	public static class CustomGearExtensions
	{
		#region Gear Template methods
        public static void AddBodyGearTemplate(this CustomGear customGear)
		{
			if (GearDatabase.Instance.CharBodyTemplateForID.ContainsKey(customGear.Metadata.Prefix.ToLower())) return;

			var newBodyTemplate = new CharacterBodyTemplate
			{
				id = customGear.Metadata.Prefix.ToLower(),
                path = $"XLGearModifier/{customGear.Prefab.name}",
				leftEyeLocalPosition = new Vector3(1, 0, 0),
				rightEyeLocalPosition = new Vector3(-1, 0, 0)
			};
			GearDatabase.Instance.CharBodyTemplateForID.Add(customGear.Metadata.Prefix.ToLower(), newBodyTemplate);
		}

		public static void AddBoardGearTemplate(this CustomGear customGear, XLGMBoardGearMetadata metadata)
		{
			if (metadata.Category != Unity.BoardGearCategory.Deck) return;
			if (GearDatabase.Instance.DeckTemplateForID.ContainsKey(metadata.Prefix.ToLower())) return;

			var newGearTemplate = new DeckTemplate { id = string.Empty, path = $"XLGearModifier/{customGear.Prefab.name}" };

			if (metadata.BaseOnDefaultGear)
			{
				var baseGearTemplate = GearDatabase.Instance.DeckTemplateForID.FirstOrDefault(x => x.Key == customGear.Metadata.GetBaseType().ToLower()).Value;
				if (baseGearTemplate != null)
				{
					newGearTemplate.id = baseGearTemplate.id;
				}
			}

			GearDatabase.Instance.DeckTemplateForID.Add(metadata.Prefix.ToLower(), newGearTemplate);
		}
		#endregion

		#region MaterialController methods
		public static void UpdateMaterialControllerPropertyNameSubstitutions(this MaterialController materialController)
		{
            var traverse = Traverse.Create(materialController);

            traverse.Field("m_propertyNameSubstitutionsDict").SetValue(new Dictionary<string, string>());

            var propNameSubs = traverse.Field("m_propertyNameSubstitutions").GetValue<List<PropertyNameSubstitution>>() ?? new List<PropertyNameSubstitution>();
			propNameSubs.Add(new PropertyNameSubstitution { oldName = "_texture2D_color", newName = "_BaseColorMap" });

            traverse.Field("m_propertyNameSubstitutionsDict").SetValue(propNameSubs.ToDictionary(s => s.oldName, s => s.newName));
		}
		#endregion
	}
}
