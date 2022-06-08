using System.Linq;
using SkaterXL.Gear;
using UnityEngine;

namespace XLGearModifier.Unity
{
	public abstract class XLGMMetadata : MonoBehaviour
	{
		[Header("Menu")]
		[Tooltip("This is the name that will be displayed in the menu.  If left blank, we will use the prefab name.")]
		public string DisplayName;

        public abstract string GetBaseType();
		public abstract string GetSprite();
		public abstract string GetCategory();
		public abstract bool BasedOnDefaultGear();
        public abstract string GetTemplateId();

        public MaterialController AddMaterialController(Renderer renderer, string materialId = null, int materialIndex = 0)
        {
            var materialController = string.IsNullOrEmpty(materialId) ?
                renderer.gameObject.GetComponent<MaterialController>() :
                renderer.gameObject.GetComponentsInChildren<MaterialController>()
                    .FirstOrDefault(x => x.materialID == materialId);

            if (materialController == null)
            {
                materialController = renderer.gameObject.AddComponent<MaterialController>();
            }
            else if (!string.IsNullOrEmpty(materialId))
            {
                Debug.LogError($"Duplicate materialID {materialId}, index {materialIndex} added to {DisplayName}");
                materialController = renderer.gameObject.AddComponent<MaterialController>();
            }

            materialController.FindTargets();

            materialController.materialID = materialId;

            var target = materialController.targets.FirstOrDefault();
            if (target != null)
            {
                target.materialIndex = materialIndex;
            }

            return materialController;
        }

        public GearPrefabController AddGearPrefabController(Renderer renderer)
        {
            var gearPrefabController = renderer.gameObject.GetComponent<GearPrefabController>();
            if (gearPrefabController == null)
            {
                gearPrefabController = renderer.gameObject.AddComponent<GearPrefabController>();
            }
            else
            {
                Debug.LogWarning("GearPrefabController already exists!");
            }

            gearPrefabController.PreparePrefab();

            return gearPrefabController;
        }

        public void ClearControllers(Renderer renderer)
        {
            var materialControllers = renderer.gameObject.GetComponentsInChildren<MaterialController>(true);
            foreach (var materialController in materialControllers)
            {
                DestroyImmediate(materialController, true);
            }

            var gearPrefabControllers = renderer.gameObject.GetComponentsInChildren<GearPrefabController>(true);
            foreach (var gearPrefabController in gearPrefabControllers)
            {
                DestroyImmediate(gearPrefabController, true);
            }
        }
    }
}
