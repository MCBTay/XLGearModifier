using SkaterXL.Gear;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
#if UNITY_EDITOR
    [CustomEditor(typeof(GearPrefabController), true)]
    [CanEditMultipleObjects]
    public class GearPrefabControllerEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            if (GUILayout.Button("Prepare Prefab"))
            {
                foreach (GearPrefabController prefabController in targets)
                {
                    prefabController.PreparePrefab();
                    EditorUtility.SetDirty(prefabController);
                }
            }

            DrawDefaultInspector();
        }
    }
#endif
}
