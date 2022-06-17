using UnityEditor;
using UnityEngine;
using XLGearModifier.Unity;

namespace XLGearModifier.Assets.Editor
{
    [CustomEditor(typeof(XLGMBlendShapeController))]
    public class XLGMBlendShapeControllerEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            var item = target as XLGMBlendShapeController;

            if (GUILayout.Button("Get BlendShape Data"))
            {
                item.GetBlendShapeData(item.gameObject);
                EditorUtility.SetDirty(item);
            }

            if (GUILayout.Button("Clear BlendShape Data"))
            {
                item.ClearBlendShapeData();
                EditorUtility.SetDirty(item);
            }

            serializedObject.ApplyModifiedProperties();

            this.DrawDefaultInspector();
        }
    }
}
