using HarmonyLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using XLGearModifier.Unity;
using XLMenuMod.Utilities;

namespace XLGearModifier
{
	public class CustomGear : CustomInfo
	{
		public GameObject Prefab;
		public CharacterGearInfo GearInfo;
		public GearCategory Category;
		public string Type;

		public CustomGear(XLGearModifierMetadata metadata, GameObject prefab)
		{
			Category = metadata.Category;
			Type = GetBaseType(metadata);
			Prefab = prefab;

			GearInfo = new CharacterGearInfo(string.IsNullOrEmpty(metadata.DisplayName) ? Prefab.name : metadata.DisplayName, Type, true, GetDefaultTextureChanges(), new string[0]);

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
					CreateNewMaterialController(origMaterialController, child.gameObject);
				}
			}
		}

		private async Task AddMaterialController()
		{
			var origMaterialController = await GetDefaultGearMaterialController();

 			if (origMaterialController != null)
			{
				CreateNewMaterialController(origMaterialController, Prefab);
			}
		}

		private void CreateNewMaterialController(MaterialController origMaterialController, GameObject prefab)
		{
			var newMaterialController = prefab.AddComponent<MaterialController>();

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

			var officialGear = gear[0][(int)Category];
			return officialGear.Where(x => x.type.Equals(Type, StringComparison.InvariantCultureIgnoreCase)).Cast<CharacterGearInfo>().First();
		}

		private string GetBaseType(XLGearModifierMetadata metadata)
		{
			switch (metadata.Category)
			{
				case GearCategory.SkinTone: break;
				case GearCategory.Hair: return metadata.BaseHairStyle.ToString();
				case GearCategory.Headwear: return metadata.BaseHeadwearType.ToString();
				case GearCategory.Top: return metadata.BaseTopType.ToString();
				case GearCategory.Bottom: return metadata.BaseBottomType.ToString();
				case GearCategory.Shoes: return metadata.BaseShoeType.ToString();
				case GearCategory.Deck: break;
				case GearCategory.Griptape: break;
				case GearCategory.Trucks: break;
				case GearCategory.Wheels: break;
			}

			return string.Empty;
		}
	}
}
