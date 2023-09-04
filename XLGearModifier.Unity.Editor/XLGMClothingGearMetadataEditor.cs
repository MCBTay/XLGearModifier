using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using XLGearModifier.Unity;
using ClothingGearCategory = XLGearModifier.Unity.ClothingGearCategory;

namespace Assets.Editor
{
#if UNITY_EDITOR
    [CustomEditor(typeof(XLGMClothingGearMetadata))]
    public class XLGMClothingGearMetadataEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            var item = target as XLGMClothingGearMetadata;

            if (!item.ValidTemplateId())
            {
                var errorString = $"{item.CharacterGearTemplate?.id} is a known prefix for a default mesh.  Please change the name to something unique.";
                Debug.LogError(errorString);
                EditorGUILayout.HelpBox(errorString, MessageType.Error);
            }

            base.OnInspectorGUI();

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
                var prefixAliasContent = new GUIContent("Prefix Alias", "This is a prefix aliases that the mesh can use.  A prefix defined here should be able to be applied to the mesh in game. For example, if you create 5 hoodie variations with similar UVs, you could set this field to the same value for all 5 prefabs and they'd be able to share textures.");
                item.PrefixAlias = EditorGUILayout.TextField(prefixAliasContent, item.PrefixAlias);
            }

            serializedObject.ApplyModifiedProperties();

            GUILayout.Space(15);
            if (GUILayout.Button("Prepare XLGM Clothing"))
            {
                item.Prepare();
            }

            if (GUI.changed)
            {
                EditorUtility.SetDirty(item);
                EditorSceneManager.MarkSceneDirty(item.gameObject.scene);
            }
        }
    }
#endif
}
