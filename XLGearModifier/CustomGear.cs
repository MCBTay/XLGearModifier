using HarmonyLib;
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using XLGearModifier.Unity;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;

namespace XLGearModifier
{
	public class CustomGear : CustomInfo
	{
		public XLGMMetadata Metadata;
		public XLGMClothingGearMetadata ClothingMetadata => Metadata as XLGMClothingGearMetadata;
		public XLGMBoardGearMetadata BoardMetdata => Metadata as XLGMBoardGearMetadata;
		public XLGMSkaterMetadata SkaterMetdata => Metadata as XLGMSkaterMetadata;

		public GameObject Prefab;
		public GearInfo GearInfo;

		public CustomGear(XLGMMetadata metadata, GameObject prefab)
		{
			Metadata = metadata;
			Prefab = prefab;

			var name = string.IsNullOrEmpty(metadata.DisplayName) ? Prefab.name : metadata.DisplayName;
			switch (metadata)
			{
				case XLGMClothingGearMetadata clothingMetadata:
					InstantiateCustomClothing(clothingMetadata);
					break;
				case XLGMSkaterMetadata skaterMetadata:
					InstantiateCustomSkater(skaterMetadata);
					break;
				case XLGMBoardGearMetadata boardMetadata:
					InstantiateCustomBoard(boardMetadata);	
					break;
			}
		}

		public CustomGear(CustomGear gearToClone, GearInfoSingleMaterial gearInfo) : this(gearToClone.Metadata, gearToClone.Prefab)
		{
			GearInfo = gearInfo;
		}

		#region Custom Clothing methods
		private void InstantiateCustomClothing(XLGMClothingGearMetadata clothingMetadata)
		{
			var name = string.IsNullOrEmpty(clothingMetadata.DisplayName) ? Prefab.name : clothingMetadata.DisplayName;

			GearInfo = new CustomCharacterGearInfo(name, clothingMetadata.Prefix, false, GetDefaultTextureChanges(), new string[0]);

			if (clothingMetadata.Category == Unity.ClothingGearCategory.Shoes)
			{
				AddShoePrefabControllers();
				AddShoeMaterialControllers(clothingMetadata);
			}
			else
			{
				Prefab.AddGearPrefabController();
				AddMaterialController(clothingMetadata);
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
				GearFilters = GearDatabase.Instance.skaters.First().GearFilters,
			});

			var materialChanges = new List<MaterialChange>()
			{
				new MaterialChange("head", new[] { new TextureChange("head", "XLGearModifier") }),
				new MaterialChange("body", new[] { new TextureChange("body", "XLGearModifier") }),
			};
			GearInfo = new CharacterBodyInfo(name, skaterMetadata.Prefix, false, materialChanges, new string[] { });

			Prefab.AddGearPrefabController();
			AddBodyMaterialControllers();

			this.AddBodyGearTemplate();
			GearDatabase.Instance.bodyGear.Add(GearInfo as CharacterBodyInfo);
		}

		private void AddBodyMaterialControllers()
		{
			CreateNewMaterialController(Prefab, "shaderStandard_wTexAlphaCut_DoubleSide", "head");
			CreateNewMaterialController(Prefab, "shaderStandard_wTexAlphaCut_DoubleSide", "body");
		}
		#endregion

		private void InstantiateCustomBoard(XLGMBoardGearMetadata boardMetadata)
		{
			var name = string.IsNullOrEmpty(boardMetadata.DisplayName) ? Prefab.name : boardMetadata.DisplayName;

			GearInfo = new CustomBoardGearInfo(name, boardMetadata.Prefix, false, GetDefaultTextureChanges(), new string[0]);

			if (boardMetadata.Category == Unity.BoardGearCategory.Deck)
			{
				AddDeckMaterialControllers();
			}
			else
			{
				Prefab.AddGearPrefabController();
				AddMaterialController(boardMetadata);
			}

			this.AddPrefixToGearFilters();
			this.AddBoardGearTemplate(boardMetadata);
		}

		#region TextureSet Controller methods
		private void AddShoeMaterialControllers(XLGMClothingGearMetadata clothingMetadata)
		{
			if (clothingMetadata.BaseOnDefaultGear)
			{
				var origMaterialController = GetDefaultGearMaterialController();
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

		private void AddDeckMaterialControllers()
		{
			var materialControllers = GetDefaultGearMaterialControllers();

			foreach (var materialController in materialControllers)
			{
				CreateNewMaterialController(Prefab, materialController);
			}
		}

		private void AddMaterialController(XLGMMetadata metadata)
		{
			var clothingMetadata = metadata as XLGMClothingGearMetadata;
			var boardMetadata = metadata as XLGMBoardGearMetadata;

			if ((clothingMetadata != null && clothingMetadata.BaseOnDefaultGear) ||
			    (boardMetadata != null && boardMetadata.BaseOnDefaultGear))
			{
				var origMaterialController = GetDefaultGearMaterialController();
				if (origMaterialController != null)
				{
					CreateNewMaterialController(Prefab, origMaterialController);
				}
			}
			else
			{
				CreateNewMaterialController(Prefab, "MasterShaderCloth_v2");
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
			if (clothingMetdata != null && clothingMetdata.Category == Unity.ClothingGearCategory.Hair)
			{
				newMaterialController.UpdateMaterialControllerPropertyNameSubstitutions();
			}
			UpdateMaterialControllerAlphaMasks(newMaterialController);

			Traverse.Create(newMaterialController).Field("_originalMaterial").SetValue(Traverse.Create(origMaterialController).Field("originalMaterial").GetValue<Material>());
		}

		private void CreateNewMaterialController(GameObject prefab, string shaderName, string materialId = null)
		{
			var newMaterialController = prefab.AddComponent<MaterialController>();
			newMaterialController.targets = new List<MaterialController.TargetMaterialConfig>();

			if (!string.IsNullOrEmpty(materialId))
			{
				newMaterialController.materialID = materialId;
			}

			Material mat;
			var renderer = prefab.GetComponentInChildren<Renderer>(true);
			if (renderer?.material == null) return;
			mat = renderer.material;

			mat.shader = Shader.Find(shaderName);
			mat.SetTexture("_texture2D_color", Metadata.GetMaterialInformation()?.textureColor ?? AssetBundleHelper.emptyAlbedo);
			mat.SetTexture("_texture2D_normal", Metadata.GetMaterialInformation()?.textureNormalMap ?? AssetBundleHelper.emptyNormalMap);
			mat.SetTexture(shaderName == "MasterShaderCloth_v2" ? "_texture2D_maskPBR" : "_texture2D_rgmtao", Metadata.GetMaterialInformation()?.textureMaskPBR ?? AssetBundleHelper.emptyMaskPBR);

			newMaterialController.targets.Add(new MaterialController.TargetMaterialConfig
			{
				renderer = prefab.GetComponentInChildren<SkinnedMeshRenderer>(),
				materialIndex = 0,
				sharedMaterial = mat,
			});

			newMaterialController.UpdateMaterialControllerPropertyNameSubstitutions();
			UpdateMaterialControllerAlphaMasks(newMaterialController);

			Traverse.Create(newMaterialController).Field("_originalMaterial").SetValue(Traverse.Create(newMaterialController).Field("originalMaterial").GetValue<Material>());
		}

		private MaterialController GetDefaultGearMaterialController()
		{
			var baseObject = GetBaseObject();
			return baseObject != null ? baseObject.GetComponentInChildren<MaterialController>() : null;
		}

		private IEnumerable<MaterialController> GetDefaultGearMaterialControllers()
		{
			var baseObject = GetBaseObject();
			return baseObject != null ? baseObject.GetComponentsInChildren<MaterialController>() : null;
		}

		private void UpdateMaterialControllerAlphaMasks(MaterialController materialController)
		{
			if (ClothingMetadata?.ClothingAlphaMasks == null || !ClothingMetadata.ClothingAlphaMasks.Any()) return;

			if (materialController.alphaMasks == null)
			{
				materialController.alphaMasks = new AlphaMaskTextureInfo[] { };
			}

			foreach (var mask in ClothingMetadata.ClothingAlphaMasks)
			{
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

		private GameObject GetBaseObject()
		{
			var info = GetBaseGearInfo();
			if (info == null) return null;

			var skaterIndex = GetSkaterIndex();
			var categoryIndex = GetCategoryIndex(skaterIndex);

			string path = string.Empty;

			if (BoardMetdata != null)
			{
				path = "boardcustomization/prefabs/" + info.type;
			}
			else
			{
				var skaterName = ((Character)skaterIndex).ToString().ToLower().Replace("standard", "generic");
				path = $"charactercustomization/prefabs/{skaterName}/";

				if (skaterIndex == (int)Character.MaleStandard || skaterIndex == (int)Character.FemaleStandard)
				{
					switch (categoryIndex)
					{
						case (int)GearCategory.Hair:
							path += "hair/";
							break;
						case (int)GearCategory.Shoes:
							path += "clothings/shoes/";
							break;
						default:
							path += "clothings/";
							break;
					}

					path += info.type;
				}
				else
				{
					path += $"clothings/{info.type}";
				}
			}
			
			return Resources.Load<GameObject>(path);
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
			var skaterIndex = (int)Character.MaleStandard;

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

			if (string.IsNullOrEmpty(type)) return (int)Character.MaleStandard;

			if (type.StartsWith("m", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = (int)Character.MaleStandard;
			}
			else if (type.StartsWith("f", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = (int)Character.FemaleStandard;
			}
			else if (type.StartsWith("es", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = (int)Character.EvanSmith;
			}
			else if (type.StartsWith("ta", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = (int)Character.TomAsta;
			}
			else if (type.StartsWith("bw", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = (int)Character.BrandonWestgate;
			}
			else if (type.StartsWith("tl", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = (int)Character.TiagoLemos;
			}

			return skaterIndex;
		}

		public int GetCategoryIndex(int skaterIndex)
		{
			if (ClothingMetadata == null && BoardMetdata == null) return 0;

			var categoryIndex = ClothingMetadata != null ? (int)ClothingMetadata.Category : (int)BoardMetdata.Category;
			var category = ClothingMetadata != null ? ClothingMetadata.Category.ToString() : BoardMetdata.Category.ToString();

			switch (skaterIndex)
			{
				case (int)Character.EvanSmith:
					Enum.TryParse(category, out EvanSmithGearCategory esCategory);
					categoryIndex = (int)esCategory;
					break;
				case (int)Character.TomAsta:
					Enum.TryParse(category, out TomAstaGearCategory taCategory);
					categoryIndex = (int)taCategory;
					break;
				case (int)Character.BrandonWestgate:
					Enum.TryParse(category, out BrandonWestgateGearCategory bwCategory);
					categoryIndex = (int)bwCategory;
					break;
				case (int)Character.TiagoLemos:
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
				case Unity.ClothingGearCategory.Hair: return ClothingGearCategory.Hat;
				case Unity.ClothingGearCategory.Headwear: return ClothingGearCategory.Hat;
				case Unity.ClothingGearCategory.Shoes: return ClothingGearCategory.Shoes;
				case Unity.ClothingGearCategory.Bottom: return ClothingGearCategory.Pants;
				default:
				case Unity.ClothingGearCategory.Top:
					return ClothingGearCategory.Shirt;
			}
		}

		private static void AddOrUpdateTemplateAlphaMasks(XLGMClothingGearMetadata metadata, CharacterGearTemplate template)
		{
			if (metadata.BodyAlphaMasks == null || !metadata.BodyAlphaMasks.Any()) return;

			foreach (var mask in metadata.BodyAlphaMasks)
			{
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
			var propNameSubs = traverse.Field("m_propertyNameSubstitutions").GetValue<List<PropertyNameSubstitution>>();
			if (propNameSubs == null)
			{
				propNameSubs = new List<PropertyNameSubstitution>();
			}
			propNameSubs.Add(new PropertyNameSubstitution { oldName = "_texture2D_color", newName = "_BaseColorMap" });
			materialController.PropertyNameSubstitutions = propNameSubs.ToDictionary(s => s.oldName, s => s.newName);

			traverse.Field("m_propertyNameSubstitutions").SetValue(propNameSubs);
		}
		#endregion
	}
}
