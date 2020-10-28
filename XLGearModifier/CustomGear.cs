using System;
using HarmonyLib;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;

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
			GearInfo = new CharacterGearInfo(prefab.name, type, true, new TextureChange[0], new string[0]);

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
			var origMaterialController = await GetDefaultGearMaterialController(Type);

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

		private async Task<MaterialController> GetDefaultGearMaterialController(string type)
		{
			var gear = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();
			var officialMaleHair = gear[0][1];

			var charGearInfo = officialMaleHair.Where(x => x.type.Equals(type, StringComparison.InvariantCultureIgnoreCase)).Cast<CharacterGearInfo>().FirstOrDefault();
			if (charGearInfo != null)
			{
				var clothingGearObj = new ClothingGearObjet(charGearInfo, PlayerController.Instance.characterCustomizer);
				var defaultGearPrefab = await Traverse.Create(clothingGearObj).Method("LoadPrefab", clothingGearObj.template.path).GetValue<Task<GameObject>>();
				return defaultGearPrefab.GetComponentInChildren<MaterialController>();
			}

			return null;
		}
	}
}
