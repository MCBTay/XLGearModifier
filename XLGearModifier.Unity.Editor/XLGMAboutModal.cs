using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
#if UNITY_EDITOR
    public class XLGMAboutModal : EditorWindow
    {
        [MenuItem("XLGM/About", false, 100)]
        static void About()
        {
            var window = CreateInstance(typeof(XLGMAboutModal)) as XLGMAboutModal;
            window.maxSize = new Vector2(300, 100);
            window.titleContent = new GUIContent
            {
                text = "About XLGM SDK"
            };
            window.ShowModalUtility();
        }

        void OnGUI()
        {
            GUIStyle centeredStyle = new GUIStyle
            {
                alignment = TextAnchor.MiddleCenter,
                richText = true,
            };
            centeredStyle.normal.textColor = GUI.color;

            GUILayout.BeginVertical();

            GUILayout.FlexibleSpace();

        GUILayout.Label("This version of the XLGM SDK is built to be used for:", centeredStyle);
        GUILayout.Label("XLGearModifier <b>2.0.1</b>", centeredStyle);
        GUILayout.Label("SkaterXL <b>1.2.5.5</b>", centeredStyle);

            GUILayout.FlexibleSpace();

            GUILayout.EndVertical();

            if (GUILayout.Button("Close"))
                Close();
        }

        void OnInspectorUpdate()
        {
            Repaint();
        }
    }
#endif
}