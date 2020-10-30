using HarmonyLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using XLGearModifier.Unity;

namespace XLGearModifier
{
	public class CustomGear
	{
		public GameObject Prefab;
		public CharacterGearInfo GearInfo;
		public GearCategory Category;
		public string Type;

		public CustomGear(GearCategory category, string type, GameObject prefab)
		{
			Category = category;
			Type = type;
			Prefab = prefab;
			GearInfo = new CharacterGearInfo(prefab.name, type, true, GetDefaultTextureChanges(), new string[0]);

			AddGearPrefabController();
			AddMaterialController();
		}

		private void AddGearPrefabController()
		{
			var gearPrefabController = Prefab.AddComponent<GearPrefabController>();
			gearPrefabController.PreparePrefab();
		}

		private async Task AddMaterialController()
		{
			var origMaterialController = await GetDefaultGearMaterialController();

 			if (origMaterialController != null)
			{
				var newMaterialController = Prefab.AddComponent<MaterialController>();

				newMaterialController.PropertyNameSubstitutions = origMaterialController.PropertyNameSubstitutions;

				newMaterialController.targets = new List<MaterialController.TargetMaterialConfig>();
				foreach (var target in origMaterialController.targets)
				{
					var config = new MaterialController.TargetMaterialConfig
					{
						renderer = Prefab.GetComponentInChildren<SkinnedMeshRenderer>(),
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
	}
}
