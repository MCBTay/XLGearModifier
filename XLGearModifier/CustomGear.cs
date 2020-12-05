﻿using HarmonyLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using XLGearModifier.Unity;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;

namespace XLGearModifier
{
	public class CustomGear : CustomInfo
	{
		public XLGearModifierMetadata Metadata;
		public GameObject Prefab;
		public CustomCharacterGearInfo GearInfo;
		public GearCategory Category;
		public string Type;
		public string Sprite;
		public bool IsLayerable;

		public CustomGear(XLGearModifierMetadata metadata, GameObject prefab)
		{
			Metadata = metadata;
			Category = metadata.Category;
			Type = string.IsNullOrEmpty(metadata.Prefix) ? GetBaseType() : metadata.Prefix;
			Prefab = prefab;
			Sprite = metadata.Sprite.ToString();
			if (metadata.IsLayerable)
			{
				Sprite += "_Layerable";
			}
			IsLayerable = metadata.IsLayerable;

			GearInfo = new CustomCharacterGearInfo(string.IsNullOrEmpty(metadata.DisplayName) ? Prefab.name : metadata.DisplayName, Type, false, GetDefaultTextureChanges(), new string[0]);

			if (Category == GearCategory.Shoes)
			{
				AddGearPrefabControllers();
				AddShoeMaterialControllers();
			}
			else
			{
				AddGearPrefabController(Prefab);
				AddMaterialController();
			}
		}

		public CustomGear(CustomGear gearToClone, CustomCharacterGearInfo gearInfo) : this(gearToClone.Metadata, gearToClone.Prefab)
		{
			GearInfo = gearInfo;
		}

		private void AddGearPrefabControllers()
		{
			foreach (Transform child in Prefab.transform)
			{
				AddGearPrefabController(child.gameObject);
			}
		}

		private void AddGearPrefabController(GameObject gameObject)
		{
			var gearPrefabController = gameObject.AddComponent<GearPrefabController>();
			gearPrefabController.PreparePrefab();
		}

		private async Task AddShoeMaterialControllers()
		{
			var origMaterialController = await GetDefaultGearMaterialController();

			if (origMaterialController != null)
			{
				foreach (Transform child in Prefab.transform)
				{
					CreateNewMaterialController(child.gameObject, origMaterialController);
				}
			}
		}

		private async Task AddMaterialController()
		{
			if (Metadata.BaseOnDefaultGear)
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
			}
		}

		private void CreateNewMaterialController(GameObject prefab, MaterialController origMaterialController = null)
		{
			var newMaterialController = prefab.AddComponent<MaterialController>();

			if (origMaterialController != null)
			{
				newMaterialController.PropertyNameSubstitutions = origMaterialController.PropertyNameSubstitutions;
				newMaterialController.targets = new List<MaterialController.TargetMaterialConfig>();
				foreach (var target in origMaterialController.targets)
				{
					var config = new MaterialController.TargetMaterialConfig
					{
						renderer = prefab.GetComponentInChildren<SkinnedMeshRenderer>(),
						materialIndex = target.materialIndex,
						sharedMaterial = target.sharedMaterial
					};
					config.renderer.sharedMaterials = target.renderer.sharedMaterials;

					newMaterialController.targets.Add(config);
				}

				newMaterialController.alphaMasks = origMaterialController.alphaMasks;
				newMaterialController.materialID = origMaterialController.materialID;
			}
			else
			{
				newMaterialController.targets = new List<MaterialController.TargetMaterialConfig>();

				var mat = Metadata.Material;
				mat.shader = Shader.Find("MasterShaderCloth_v2");
				mat.SetTexture("_texture2D_color", Metadata.TextureColor);
				mat.SetTexture("_texture2D_normal", Metadata.TextureNormalMap);
				mat.SetTexture("_texture2D_maskPBR", Metadata.TextureMaskPBR);
				mat.SetFloat("_scalar_minspecular", Metadata.MinSpecular);
				mat.SetFloat("_scalar_maxspecular", Metadata.MaxSpecular);
				mat.SetFloat("_scalar_minrg", Metadata.MinRoughness);
				mat.SetFloat("_scalar_maxrg", Metadata.MaxRoughness);

				newMaterialController.targets.Add(new MaterialController.TargetMaterialConfig
				{
					renderer = prefab.GetComponentInChildren<SkinnedMeshRenderer>(),
					materialIndex = 0,
					sharedMaterial = mat,
				});
			}

			Traverse.Create(newMaterialController).Field("_originalMaterial").SetValue(Traverse.Create(origMaterialController).Field("originalMaterial").GetValue<Material>());
		}

		private async Task<MaterialController> GetDefaultGearMaterialController()
		{
			var baseObject = await GetBaseObject();

			if (baseObject != null)
			{
				return baseObject.GetComponentInChildren<MaterialController>();
			}

			return null;
		}

		private TextureChange[] GetDefaultTextureChanges()
		{
			var info = GetBaseGearInfo();
			if (info != null)
			{
				return info.textureChanges;
			}

			return null;
		}

		private async Task<GameObject> GetBaseObject()
		{
			var info = GetBaseGearInfo();
			if (info != null)
			{
				var tempGearObj = new ClothingGearObjet(info, PlayerController.Instance.characterCustomizer);
				return await Traverse.Create(tempGearObj).Method("LoadPrefab", tempGearObj.template.path).GetValue<Task<GameObject>>();
			}

			return null;
		}

		private CharacterGearInfo GetBaseGearInfo()
		{
			var gear = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();

			var skaterIndex = GetSkaterIndex();
			GearInfo[] officialGear = gear[skaterIndex][GetCategoryIndex(skaterIndex)];
			return officialGear.Where(x => x.type.Equals(GetBaseType(), StringComparison.InvariantCultureIgnoreCase)).Cast<CharacterGearInfo>().FirstOrDefault();
		}

		public int GetSkaterIndex()
		{
			var skaterIndex = 0;

			if (string.IsNullOrEmpty(Type)) return 0;

			if (Type.StartsWith("m", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = 0;
			}
			else if (Type.StartsWith("f", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = 1;
			}
			else if (Type.StartsWith("es", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = 2;
			}
			else if (Type.StartsWith("ta", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = 3;
			}
			else if (Type.StartsWith("bw", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = 4;
			}
			else if (Type.StartsWith("tl", StringComparison.InvariantCultureIgnoreCase))
			{
				skaterIndex = 5;
			}

			return skaterIndex;
		}

		public int GetCategoryIndex(int skaterIndex)
		{
			var categoryIndex = (int)Category;

			switch (skaterIndex)
			{
				case (int)Character.EvanSmith:
					Enum.TryParse(Category.ToString(), out EvanSmithGearCategory esCategory);
					categoryIndex = (int)esCategory;
					break;
				case (int)Character.TomAsta:
					Enum.TryParse(Category.ToString(), out TomAstaGearCategory taCategory);
					categoryIndex = (int)taCategory;
					break;
				case (int)Character.BrandonWestgate:
					Enum.TryParse(Category.ToString(), out BrandonWestgateGearCategory bwCategory);
					categoryIndex = (int)bwCategory;
					break;
				case (int)Character.TiagoLemos:
					Enum.TryParse(Category.ToString(), out TiagoLemosGearCategory tlCategory);
					categoryIndex = (int)tlCategory;
					break;
			}

			return categoryIndex;
		}

		public string GetBaseType()
		{
			switch (Metadata.Category)
			{
				case GearCategory.SkinTone: break;
				case GearCategory.Hair: return Metadata.BaseHairStyle.ToString();
				case GearCategory.Headwear: return Metadata.BaseHeadwearType.ToString();
				case GearCategory.Top: return Metadata.BaseTopType.ToString();
				case GearCategory.Bottom: return Metadata.BaseBottomType.ToString();
				case GearCategory.Shoes: return Metadata.BaseShoeType.ToString();
				case GearCategory.Deck: break;
				case GearCategory.Griptape: break;
				case GearCategory.Trucks: break;
				case GearCategory.Wheels: break;
			}

			return string.Empty;
		}
	}
}
