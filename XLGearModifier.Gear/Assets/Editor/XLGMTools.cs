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

            Debug.Log("Reserialize All Prefabs completed.");
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

            Debug.Log("Ensure Prefab Meshes Have Material Controllers completed.");
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

            Debug.Log("Ensure Prefab Meshes Have Gear Prefabs Controllers completed.");
        }

        [MenuItem("Tools/XLGM Tools/Find Missing or Invalid Material Controllers")]
        private static void onClick_FindMissingMaterialControllers()
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
                        Debug.LogWarning($"{go.name} is missing MaterialController on it's mesh(s).");
                        continue;
                    }

                    if (materialController.targets == null || !materialController.targets.Any())
                    {
                        Debug.LogWarning($"{go.name} has a MaterialController, but it has not had targets found.  Go click Find Targets.");
                        continue;
                    }
                }
            }

            Debug.Log("Find Missing or Invalid Material Controllers completed.");
        }

        [MenuItem("Tools/XLGM Tools/Find Missing or Invalid Gear Prefab Controllers")]
        private static void onClick_FindMissingGearPrefabControllers()
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
                        Debug.LogWarning($"{go.name} is missing GearPrefabController on it's mesh(s).");
                        continue;
                    }

                    if (string.IsNullOrEmpty(gearPrefabController.rootBoneName) || !gearPrefabController.boneNames.Any())
                    {
                        Debug.LogWarning($"{go.name} has a GearPrefabController, but is missing bone information.  Go click Prepare Prefab.");
                        continue;
                    }
                }
            }

            Debug.Log("Find Missing or Invalid Gear Prefab Controllers completed.");
        }
    }
}
