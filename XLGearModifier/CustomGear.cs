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

		#region Custom Clothing methods
		private void InstantiateCustomClothing(XLGMClothingGearMetadata clothingMetadata)
		{
			var name = string.IsNullOrEmpty(clothingMetadata.DisplayName) ? Prefab.name : clothingMetadata.DisplayName;

			GearInfo = new CustomCharacterGearInfo(name, clothingMetadata.Prefix, false, GetDefaultTextureChanges(), new string[0]);
            
            SetTexturesAndShader(clothingMetadata);
            
			this.AddPrefixToGearFilters();
			this.AddCharacterGearTemplate(clothingMetadata);
		}

        #endregion

		#region Custom Skater methods

        private TypeFilterList GetCustomSkaterTypeFilters()
        {
            return new TypeFilterList(new List<TypeFilter>
            {
                //new TypeFilter
                //{
                //	allowCustomGear = true,
                //	cameraView = GearRoomCameraView.FullSkater,
                //	excludedTags = new[] { "ProOnly" },
                //	includedTypes = new [] { skaterMetadata.Prefix },
                //	label = "Skintone",
                //	requiredTag = ""
                //},
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

			GearDatabase.Instance.skaters.Add(new SkaterInfo
			{
				stance = SkaterInfo.Stance.Regular,
				bodyID = skaterMetadata.Prefix,
				name = name,
				GearFilters = GetCustomSkaterTypeFilters(),
			});
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
                    //new TextureChange("normal", texturePath + "normal"),
                    //new TextureChange("maskpbr", texturePath + "maskpbr")
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

            textures.Add("albedo", renderer.materials[materialController.targets.FirstOrDefault().materialIndex].mainTexture);
            //textures.Add("normal", renderer.materials[materialController.targets.FirstOrDefault().materialIndex].GetTexture("_BumpMap"));
            //textures.Add("maskpbr", renderer.materials[materialController.targets.FirstOrDefault().materialIndex].GetTexture("_MaskMap"));

			var material = materialController.GenerateMaterialWithChanges(textures);
            material.shader = Shader.Find("MasterShaderCloth_v1");
            materialController.SetMaterial(material);
        }
		#endregion

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

		#region TextureSet Controller methods
        private async Task AddDeckMaterialControllers()
		{
			var materialControllers = await GetDefaultGearMaterialControllers();

			foreach (var materialController in materialControllers)
			{
				//CreateNewMaterialController(Prefab, materialController);
			}
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
            material.shader = GetClothingShader(clothingMetadata);
            materialController.SetMaterial(material);
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

			var clothingMetadata = Metadata as XLGMClothingGearMetadata;
			var boardMetadata = Metadata as XLGMBoardGearMetadata;

			if (clothingMetadata != null && clothingMetadata.BaseOnDefaultGear)
			{
				type = clothingMetadata.GetBaseType();
			}
			else if (boardMetadata != null && boardMetadata.BaseOnDefaultGear)
			{
				type = boardMetadata.GetBaseType();
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
        public static void AddPrefixToGearFilters(this CustomGear customGear)
		{
			var typeFilter = GearDatabase.Instance.skaters[customGear.GetSkaterIndex()].GearFilters[customGear.GetCategoryIndex(customGear.GetSkaterIndex())];

			if (!typeFilter.includedTypes.Contains(customGear.Metadata.Prefix))
			{
				Array.Resize(ref typeFilter.includedTypes, typeFilter.includedTypes.Length + 1);
                typeFilter.includedTypes[typeFilter.includedTypes.Length - 1] = customGear.Metadata.Prefix;
            }
		}

		#region Gear Template methods
		public static void AddCharacterGearTemplate(this CustomGear customGear, XLGMClothingGearMetadata metadata)
		{
			if (GearDatabase.Instance.CharGearTemplateForID.ContainsKey(metadata.Prefix.ToLower())) return;

			var newGearTemplate = new CharacterGearTemplate
			{
				alphaMasks = new List<GearAlphaMaskConfig>(),
				category = MapCategory(metadata.Category),
				id = metadata.Prefix.ToLower(),
				path = "XLGearModifier"
			};

			if (metadata.BaseOnDefaultGear)
			{
				var baseGearTemplate = GearDatabase.Instance.CharGearTemplateForID.FirstOrDefault(x => x.Key == customGear.Metadata.GetBaseType().ToLower()).Value;

                newGearTemplate = baseGearTemplate.Copy();
                // TODO: remove when Copy() copies this field over too
                newGearTemplate.alphaMasks = baseGearTemplate?.alphaMasks;
            }

			AddOrUpdateTemplateAlphaMasks(metadata, newGearTemplate);

			GearDatabase.Instance.CharGearTemplateForID.Add(metadata.Prefix.ToLower(), newGearTemplate);
		}

		private static ClothingGearCategory MapCategory(Unity.ClothingGearCategory category)
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

		private static void AddOrUpdateTemplateAlphaMasks(XLGMClothingGearMetadata metadata, CharacterGearTemplate template)
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

		public static void AddBodyGearTemplate(this CustomGear customGear)
		{
			if (GearDatabase.Instance.CharBodyTemplateForID.ContainsKey(customGear.Metadata.Prefix.ToLower())) return;

			var newBodyTemplate = new CharacterBodyTemplate
			{
				id = customGear.Metadata.Prefix.ToLower(),
				path = "XLGearModifier",
				leftEyeLocalPosition = new Vector3(1, 0, 0),
				rightEyeLocalPosition = new Vector3(-1, 0, 0)
			};
			GearDatabase.Instance.CharBodyTemplateForID.Add(customGear.Metadata.Prefix.ToLower(), newBodyTemplate);
		}

		public static void AddBoardGearTemplate(this CustomGear customGear, XLGMBoardGearMetadata metadata)
		{
			if (metadata.Category != Unity.BoardGearCategory.Deck) return;
			if (GearDatabase.Instance.DeckTemplateForID.ContainsKey(metadata.Prefix.ToLower())) return;

			var newGearTemplate = new DeckTemplate { id = string.Empty, path = "XLGearModifier" };

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
