using SkaterXL.Gear;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
#if UNITY_EDITOR
    [CustomPropertyDrawer(typeof(CharacterBodyTemplate))]
    public class CharacterBodyTemplatePropertyDrawer : PropertyDrawer
    {
        private bool foldout = true;

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            // Using BeginProperty / EndProperty on the parent property means that
            // prefab override logic works on the entire property.
            EditorGUI.BeginProperty(position, label, property);

            position.height = 16f;
            foldout = EditorGUI.Foldout(position, foldout, label);

            if (foldout)
            {
                EditorGUILayout.PropertyField(
                    property.FindPropertyRelative("id"),
                    new GUIContent("Prefix", "This is the 'prefix' or 'type' associated with the mesh. This will be used in order for the mod to know which mesh to load but also to know which textures to load.  Arguably more important for meshes that are not based on default gear.  Examples from the base game would be MHatDad or FHatDad."));
            }

            EditorGUI.EndProperty();
        }
    }
#endif
}
