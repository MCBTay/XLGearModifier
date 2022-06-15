using SkaterXL.Gear;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
#if UNITY_EDITOR
    [CustomEditor(typeof(MaterialController), true)]
    [CanEditMultipleObjects]
    public class MaterialControllerEditor : UnityEditor.Editor
    {
        //test
        public override void OnInspectorGUI()
        {
            if (GUILayout.Button("Find Targets"))
            {
                foreach (MaterialController target in targets)
                {
                    target.FindTargets();
                }
            }

            DrawDefaultInspector();
        }
    }
#endif
}
