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

        public void AddMaterialController(Renderer renderer)
        {
            var materialController = renderer.gameObject.GetComponent<MaterialController>();
            if (materialController == null)
            {
                materialController = renderer.gameObject.AddComponent<MaterialController>();
            }
            else
            {
                Debug.LogWarning("MaterialController already exists!");
            }
            materialController.FindTargets();
        }

        public void AddGearPrefabController(Renderer renderer)
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
        }
    }
}
