using UnityEditor;
using UnityEngine;
using XLGearModifier.Unity;

namespace XLGearModifier.Assets.Editor
{
    [CustomEditor(typeof(XLGMClothingGearMetadata))]
    public class XLGMClothingGearMetadataEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            var item = target as XLGMClothingGearMetadata;

            EditorGUILayout.Space(10);
            EditorGUILayout.LabelField("Texturing", EditorStyles.boldLabel);

            var guiContent = new GUIContent("Base on Default Gear", "Use this for a mesh that has a close UV to one of the original meshes. Allows you to re-use the existing textures/prefixes associated with the base mesh.");

            item.BaseOnDefaultGear = GUILayout.Toggle(item.BaseOnDefaultGear, guiContent);

            if (item.BaseOnDefaultGear)
            {
                switch (item.Category)
                {
                    case ClothingGearCategory.Bottom:
                        item.BaseBottomType = (BottomTypes)EditorGUILayout.EnumPopup(
                            new GUIContent("Base Bottom", "This is the list of base bottom styles in the game."),
                            item.BaseBottomType);
                        break;
                    case ClothingGearCategory.Hair:
                        item.BaseHairStyle = (HairStyles)EditorGUILayout.EnumPopup(
                            new GUIContent("Base Hair", "This is the list of base hair styles in the game."),
                            item.BaseHairStyle);
                        break;
                    case ClothingGearCategory.Headwear:
                        item.BaseHeadwearType = (HeadwearTypes)EditorGUILayout.EnumPopup(
                            new GUIContent("Base Headwear", "This is the list of base headwear styles in the game."),
                            item.BaseHeadwearType);
                        break;
                    case ClothingGearCategory.Shoes:
                        item.BaseShoeType = (ShoeTypes)EditorGUILayout.EnumPopup(
                            new GUIContent("Base Shoes", "This is the list of base shoes in the game."),
                            item.BaseShoeType);
                        break;
                    case ClothingGearCategory.Top:
                        item.BaseTopType = (TopTypes)EditorGUILayout.EnumPopup(
                            new GUIContent("Base Top", "This is the list of base top styles in the game."), 
                            item.BaseTopType);
                        break;
                    default:
                        break;
                }
            }
            else
            {
                var textureSetProperty = serializedObject.FindProperty(nameof(item.TextureSet));
                EditorGUILayout.PropertyField(textureSetProperty);
            }

            serializedObject.ApplyModifiedProperties();
        }
    }
}
