using SkaterXL.Gear;
using System.Linq;
using UnityEditor;
using UnityEngine;
using XLGearModifier.Unity;
using ClothingGearCategory = XLGearModifier.Unity.ClothingGearCategory;

namespace XLGearModifier.Assets.Editor
{
    public class XLGMTools : EditorWindow
    {
        [MenuItem("Tools/XLGM Tools/Reserialize All Prefabs")]
        private static void onClick_ReserializeAllPrefabs()
        {
            string[] guids = AssetDatabase.FindAssets("t:Prefab");

            foreach (var guid in guids)
            {
                var path = AssetDatabase.GUIDToAssetPath(guid);
                GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(path);

                if (!PrefabUtility.IsPartOfImmutablePrefab(go))
                {
                    PrefabUtility.SavePrefabAsset(go);
                }
            }
        }

        [MenuItem("Tools/XLGM Tools/Ensure Prefab Meshes Have Material Controllers")]
        private static void onClick_UpdateMaterialControllers()
        {
            string[] guids = AssetDatabase.FindAssets("t:Prefab");

            foreach (var guid in guids)
            {
                var path = AssetDatabase.GUIDToAssetPath(guid);
                GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(path);

                var metadata = go.GetComponent<XLGMClothingGearMetadata>();
                if (metadata == null) continue;

                var renderers = go.GetComponentsInChildren<SkinnedMeshRenderer>();
                if (renderers == null || !renderers.Any()) continue;

                foreach (var renderer in renderers)
                {
                    var materialController = renderer.gameObject.GetComponent<MaterialController>();
                    
                    if (materialController == null)
                    {
                        materialController = renderer.gameObject.AddComponent<MaterialController>();
                    }

                    materialController.FindTargets();
                }

                if (!PrefabUtility.IsPartOfImmutablePrefab(go))
                {
                    PrefabUtility.SavePrefabAsset(go);
                }
            }
        }

        [MenuItem("Tools/XLGM Tools/Ensure Prefab Meshes Have Gear Prefab Controllers")]
        private static void onClick_UpdateGearPrefabControllers()
        {
            string[] guids = AssetDatabase.FindAssets("t:Prefab");

            foreach (var guid in guids)
            {
                var path = AssetDatabase.GUIDToAssetPath(guid);
                GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(path);

                var metadata = go.GetComponent<XLGMClothingGearMetadata>();
                if (metadata == null) continue;

                var renderers = go.GetComponentsInChildren<SkinnedMeshRenderer>();
                if (renderers == null || !renderers.Any()) continue;

                foreach (var renderer in renderers)
                {
                    var gearPrefabController = renderer.gameObject.GetComponent<GearPrefabController>();

                    if (gearPrefabController == null)
                    {
                        gearPrefabController = renderer.gameObject.AddComponent<GearPrefabController>();
                    }

                    gearPrefabController.PreparePrefab();
                }

                if (!PrefabUtility.IsPartOfImmutablePrefab(go))
                {
                    PrefabUtility.SavePrefabAsset(go);
                }
            }
        }

        private static SkaterXL.Gear.ClothingGearCategory MapCategory(ClothingGearCategory category)
        {
            switch (category)
            {
                case ClothingGearCategory.Hair:
                case ClothingGearCategory.FacialHair:
                case ClothingGearCategory.Headwear:
                    return SkaterXL.Gear.ClothingGearCategory.Hat;
                case ClothingGearCategory.Shoes:
                case ClothingGearCategory.Socks:
                    return SkaterXL.Gear.ClothingGearCategory.Shoes;
                case ClothingGearCategory.Bottom:
                    return SkaterXL.Gear.ClothingGearCategory.Pants;
                default:
                case ClothingGearCategory.Top:
                    return SkaterXL.Gear.ClothingGearCategory.Shirt;
            }
        }
    }
}
