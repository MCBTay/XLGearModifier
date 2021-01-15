using HarmonyLib;
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

namespace XLGearModifier
{
	public class CustomGear : CustomInfo
	{
		public XLGMMetadata Metadata;
		public XLGMClothingGearMetadata ClothingMetadata => Metadata as XLGMClothingGearMetadata;
		public XLGMBoardGearMetadata BoardMetadata => Metadata as XLGMBoardGearMetadata;
		public XLGMSkaterMetadata SkaterMetadata => Metadata as XLGMSkaterMetadata;

		public GameObject Prefab;
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
					await InstantiateCustomClothing(clothingMetadata);
					break;
				case XLGMSkaterMetadata skaterMetadata:
					InstantiateCustomSkater(skaterMetadata);
					break;
				case XLGMBoardGearMetadata boardMetadata:
					await InstantiateCustomBoard(boardMetadata);
					break;
			}
		}

		#region Custom Clothing methods
		private async Task InstantiateCustomClothing(XLGMClothingGearMetadata clothingMetadata)
		{
			var name = string.IsNullOrEmpty(clothingMetadata.DisplayName) ? Prefab.name : clothingMetadata.DisplayName;

			GearInfo = new CustomCharacterGearInfo(name, clothingMetadata.Prefix, false, GetDefaultTextureChanges(), new string[0]);

			if (clothingMetadata.Category == Unity.ClothingGearCategory.Shoes || clothingMetadata.Category == Unity.ClothingGearCategory.Socks)
			{
				AddShoePrefabControllers();
				await AddShoeMaterialControllers(clothingMetadata);
			}
			else
			{
				Prefab.AddGearPrefabController();
				await AddMaterialController(clothingMetadata);
			}

			this.AddPrefixToGearFilters();
			this.AddCharacterGearTemplate(clothingMetadata);
		}

		#region Shoe GearPrefabController and MaterialController methods
		private void AddShoePrefabControllers()
		{
			foreach (Transform child in Prefab.transform)
			{
				child.gameObject.AddGearPrefabController();
			}
		}
		#endregion

		#endregion

		#region Custom Skater methods
		private void InstantiateCustomSkater(XLGMSkaterMetadata skaterMetadata)
		{
			var name = string.IsNullOrEmpty(skaterMetadata.DisplayName) ? Prefab.name : skaterMetadata.DisplayName;

			GearDatabase.Instance.skaters.Add(new SkaterInfo
			{
				stance = SkaterInfo.Stance.Regular,
				bodyID = skaterMetadata.Prefix,
				name = name,
				GearFilters = new TypeFilterList(new List<TypeFilter>
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
				})
			});
			Traverse.Create(GearDatabase.Instance).Method("GenerateGearListSource").GetValue();

			var materialChanges = new List<MaterialChange>()
			{
				new MaterialChange("head", new[] { new TextureChange("head", "XLGearModifier") }),
				new MaterialChange("body", new[] { new TextureChange("body", "XLGearModifier") }),
			};
			GearInfo = new CharacterBodyInfo(name, skaterMetadata.Prefix, false, materialChanges, new string[] { });

			Prefab.AddGearPrefabController();
			CreateNewMaterialController(Prefab, "shaderStandard_wTexAlphaCut_DoubleSide");

			this.AddBodyGearTemplate();
			GearDatabase.Instance.bodyGear.Add(GearInfo as CharacterBodyInfo);
		}
		#endregion

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
				Prefab.AddGearPrefabController();
				await AddMaterialController(boardMetadata);
			}

			this.AddPrefixToGearFilters();
			this.AddBoardGearTemplate(boardMetadata);
		}

		#region TextureSet Controller methods
		private async Task AddShoeMaterialControllers(XLGMClothingGearMetadata clothingMetadata)
		{
			if (clothingMetadata.BaseOnDefaultGear)
			{
				var origMaterialController = await GetDefaultGearMaterialController();
				if (origMaterialController == null) return;

				foreach (Transform child in Prefab.transform)
				{
					CreateNewMaterialController(child.gameObject, origMaterialController);
				}
			}
			else
			{
				foreach (Transform child in Prefab.transform)
				{
					CreateNewMaterialController(child.gameObject, "MasterShaderCloth_v2");
				}
			}
		}

		private async Task AddDeckMaterialControllers()
		{
			var materialControllers = await GetDefaultGearMaterialControllers();

			foreach (var materialController in materialControllers)
			{
				CreateNewMaterialController(Prefab, materialController);
			}
		}

		private async Task AddMaterialController(XLGMMetadata metadata)
		{
			var clothingMetadata = metadata as XLGMClothingGearMetadata;
			var boardMetadata = metadata as XLGMBoardGearMetadata;

			if (clothingMetadata == null && boardMetadata == null) return;

			if (metadata.BasedOnDefaultGear())
			{
				var origMaterialController = await GetDefaultGearMaterialController();
				if (origMaterialController != null)
				{
					CreateNewMaterialController(Prefab, origMaterialController);
				}
			}
			else
			{
				CreateNewMaterialController(Prefab);
				//if (clothingMetadata != null && 
				//    (clothingMetadata.Category == Unity.ClothingGearCategory.Hair || clothingMetadata.Category == Unity.ClothingGearCategory.FacialHair))
				//{
				//	CreateNewMaterialController(Prefab);
				//}
				//else
				//{
				//	CreateNewMaterialController(Prefab, "MasterShaderCloth_v2");
				//}
			}
		}

		private void CreateNewMaterialController(GameObject prefab, MaterialController origMaterialController)
		{
			var newMaterialController = prefab.AddComponent<MaterialController>();
			newMaterialController.targets = new List<MaterialController.TargetMaterialConfig>();

			newMaterialController.PropertyNameSubstitutions = origMaterialController.PropertyNameSubstitutions;
			newMaterialController.alphaMasks = origMaterialController.alphaMasks;
			newMaterialController.materialID = origMaterialController.materialID;

			var renderer = prefab.GetComponentInChildren<Renderer>();
			foreach (var target in origMaterialController.targets)
			{
				renderer.sharedMaterials = target.renderer.sharedMaterials;

				newMaterialController.targets.Add(new MaterialController.TargetMaterialConfig
				{
					renderer = renderer,
					materialIndex = target.materialIndex,
					sharedMaterial = target.renderer.material
				});
			}

			var clothingMetdata = Metadata as XLGMClothingGearMetadata;
			if (clothingMetdata != null &&
				(clothingMetdata.Category == Unity.ClothingGearCategory.Hair || clothingMetdata.Category == Unity.ClothingGearCategory.FacialHair))
			{
				newMaterialController.UpdateMaterialControllerPropertyNameSubstitutions();
			}
			UpdateMaterialControllerAlphaMasks(newMaterialController);

			Traverse.Create(newMaterialController).Field("_originalMaterial").SetValue(Traverse.Create(origMaterialController).Field("originalMaterial").GetValue<Material>());
		}

		private void CreateNewMaterialController(GameObject prefab, string shaderName = "")
		{
			var renderer = prefab.GetComponentInChildren<SkinnedMeshRenderer>(true);

			var materials = renderer.materials;
			if (materials == null || !materials.Any()) return;

			int materialIndex = 0;
			foreach (var material in materials)
			{
				var newMaterialController = prefab.AddComponent<MaterialController>();

				newMaterialController.targets = new List<MaterialController.TargetMaterialConfig>();

				if (!string.IsNullOrEmpty(material.name))
				{
					newMaterialController.materialID = material.name;
				}

				newMaterialController.materialID = materialIndex.ToString();

				if (!string.IsNullOrEmpty(shaderName))
					material.shader = Shader.Find(shaderName);
				else
				{
					if (material.shader.name != "HDRP/Lit")
						material.shader = Shader.Find("HDRP/Lit");

					newMaterialController.UpdateMaterialControllerPropertyNameSubstitutions();
				}

				newMaterialController.targets.Add(new MaterialController.TargetMaterialConfig
				{
					renderer = renderer,
					materialIndex = materialIndex,
					sharedMaterial = material
				});

				materialIndex++;

				var textures = new Dictionary<string, Texture>();
				textures.Add("_texture2D_color", Metadata.GetMaterialInformation()?.DefaultTexture?.textureColor ?? AssetBundleHelper.Instance.emptyAlbedo);
				textures.Add("_texture2D_normal", Metadata.GetMaterialInformation()?.DefaultTexture?.textureNormalMap ?? AssetBundleHelper.Instance.emptyNormalMap);
				textures.Add(shaderName == "MasterShaderCloth_v2" ? "_texture2D_maskPBR" : "_texture2D_rgmtao", Metadata.GetMaterialInformation()?.DefaultTexture?.textureMaskPBR ?? AssetBundleHelper.Instance.emptyMaskPBR);

				newMaterialController.SetTextures(textures);

				UpdateMaterialControllerAlphaMasks(newMaterialController);

				Traverse.Create(newMaterialController).Field("_originalMaterial").SetValue(Traverse.Create(newMaterialController).Field("originalMaterial").GetValue<Material>());


				if (materialIndex > 5)
					break;
			}
		}

		private async Task<MaterialController> GetDefaultGearMaterialController()
		{
			var baseObject = await GetBaseObject();
			return baseObject != null ? baseObject.GetComponentInChildren<MaterialController>() : null;
		}

		private async Task<IEnumerable<MaterialController>> GetDefaultGearMaterialControllers()
		{
			var baseObject = await GetBaseObject();
			return baseObject != null ? baseObject.GetComponentsInChildren<MaterialController>() : null;
		}

		private void UpdateMaterialControllerAlphaMasks(MaterialController materialController)
		{
			if (ClothingMetadata?.MaterialAlphaMasks == null || !ClothingMetadata.MaterialAlphaMasks.Any()) return;

			if (materialController.alphaMasks == null)
			{
				materialController.alphaMasks = new AlphaMaskTextureInfo[] { };
			}

			foreach (var mask in ClothingMetadata.MaterialAlphaMasks)
			{
				if (mask == null) continue;

				var existing = materialController.alphaMasks?.FirstOrDefault(x => (int)x.type == (int)mask.type);
				if (existing == null)
				{
					var newAlphaMask = new AlphaMaskTextureInfo
					{
						type = (AlphaMaskLocation)(int)mask.type,
						texture = mask.texture,
					};

					Array.Resize(ref materialController.alphaMasks, materialController.alphaMasks.Length + 1);
					materialController.alphaMasks[materialController.alphaMasks.Length - 1] = newAlphaMask;
				}
				else
				{
					existing.texture = mask.texture;
				}
			}
		}
		#endregion

		private TextureChange[] GetDefaultTextureChanges()
		{
			var info = GetBaseGearInfo();
			if (info != null)
			{
				return info.textureChanges;
			}

			return null;
		}

		public async Task<GameObject> GetBaseObject()
		{
			var info = GetBaseGearInfo();
			if (info == null) return null;

			string path = BoardMetadata != null ? GearDatabase.Instance.DeckTemplateForID[info.type].path : GearDatabase.Instance.CharGearTemplateForID[info.type].path;
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
		public static void AddGearPrefabController(this GameObject gameObject)
		{
			var gearPrefabController = gameObject.AddComponent<GearPrefabController>();
			gearPrefabController.PreparePrefab();
		}

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
				if (baseGearTemplate != null)
				{
					newGearTemplate.alphaMasks = baseGearTemplate.alphaMasks;
					newGearTemplate.category = baseGearTemplate.category;
				}
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

				var existing = template.alphaMasks.FirstOrDefault(x => (int)x.MaskLocation == (int)mask.MaskLocation);
				if (existing == null)
				{
					var alphaMaskConfig = new GearAlphaMaskConfig
					{
						MaskLocation = (AlphaMaskLocation)(int)mask.MaskLocation,
						Threshold = mask.Threshold,
					};

					template.alphaMasks.Add(alphaMaskConfig);
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
			if (materialController.PropertyNameSubstitutions == null)
				materialController.PropertyNameSubstitutions = new Dictionary<string, string>();

			var traverse = Traverse.Create(materialController);
			var propNameSubs = traverse.Field("m_propertyNameSubstitutions").GetValue<List<PropertyNameSubstitution>>() ?? new List<PropertyNameSubstitution>();
			propNameSubs.Add(new PropertyNameSubstitution { oldName = "_texture2D_color", newName = "_BaseColorMap" });
			materialController.PropertyNameSubstitutions = propNameSubs.ToDictionary(s => s.oldName, s => s.newName);

			traverse.Field("m_propertyNameSubstitutions").SetValue(propNameSubs);
		}
		#endregion
	}
}
