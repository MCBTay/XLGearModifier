using SkaterXL.Gear;
using UnityEditor;
using UnityEngine;

namespace XLGearModifier.Unity
{
    [CustomPropertyDrawer(typeof(CharacterGearTemplate))]
    public class CharacterGearTemplatePropertyDrawer : PropertyDrawer
    {
        private bool foldout;

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            // Using BeginProperty / EndProperty on the parent property means that
            // prefab override logic works on the entire property.
            EditorGUI.BeginProperty(position, label, property);

            position.height = 16f;
            foldout = EditorGUI.Foldout(position, foldout, label);

            if (foldout)
            {
                EditorGUILayout.PropertyField(property.FindPropertyRelative("id"), new GUIContent("Prefix", "This is the 'prefix' or 'type' associated with the mesh. This will be used in order for the mod to know which mesh to load but also to know which textures to load.  Arguably more important for meshes that are not based on default gear.  Examples from the base game would be MHatDad or FHatDad."));
                EditorGUILayout.PropertyField(property.FindPropertyRelative("alphaMasks"), new GUIContent("Alpha Masks", "Set the threshold(s) for various alpha masks when this mesh is applied. It will add it to the gear template if it is not already defined, or override it if it is. Typically used for masking various areas of the body."));
            }
            
            EditorGUI.EndProperty();
        }
    }
}
