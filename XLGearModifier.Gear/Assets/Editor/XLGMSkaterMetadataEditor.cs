﻿using System.Linq;
using SkaterXL.Gear;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace XLGearModifier.Unity
{
    [CustomEditor(typeof(XLGMSkaterMetadata))]
    public class XLGMSkaterMetadataEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            var item = target as XLGMSkaterMetadata;
            if (item == null) return;

            GUILayout.Space(15);
            if (GUILayout.Button("Prepare XLGM Skater"))
            {
                Debug.Log("Preparing XLGM Skater " + item.CharacterBodyTemplate.id);
                var renderers = item.gameObject.GetComponentsInChildren<SkinnedMeshRenderer>(true);

                foreach (var renderer in renderers)
                {
                    int i = 0;
                    foreach (var material in renderer.sharedMaterials)
                    {
                        item.AddMaterialController(renderer, material.name.ToLower(), i);
                        i++;
                    }

                    item.AddGearPrefabController(renderer);
                }

                Debug.Log("Successfully prepared XLGM Skater " + item.CharacterBodyTemplate.id);
            }

            if (GUI.changed)
            {
                EditorUtility.SetDirty(item);
                EditorSceneManager.MarkSceneDirty(item.gameObject.scene);
            }
        }
    }
}