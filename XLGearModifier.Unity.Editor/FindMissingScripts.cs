﻿using System;
using System.IO;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;
using XLGearModifier.Unity;
using XLGearModifier.Unity.Editor.Upgrade;

public class FindMissingScriptsEditor : EditorWindow
{
    [MenuItem("XLGM/Upgrade From 1.5/Upgrade Prefabs")]
    public static void FindMissingScripts()
    {
        EditorUtility.DisplayProgressBar("Searching Prefabs", "", 0.0f);

        string[] files = Directory.GetFiles(Application.dataPath, "*.prefab", SearchOption.AllDirectories);
        EditorUtility.DisplayCancelableProgressBar("Searching Prefabs", "Found " + files.Length + " prefabs", 0.0f);

        var newGuid = AssetDatabase.AssetPathToGUID("Assets/XLGM_SDK/XLGearModifier.Unity.dll");

        PrefabReader reader = new PrefabReader();

        for (int i = 0; i < files.Length; i++)
        {
            string prefabPath = files[i].Replace(Application.dataPath, "Assets");
            if (EditorUtility.DisplayCancelableProgressBar("Processing Prefabs " + i + "/" + files.Length, prefabPath, i / (float)files.Length))
                break;

            var metadata = reader.Read(prefabPath);
            metadata.Path = prefabPath;

            var missingMonoBehaviours = metadata.GetMissingMonoBehaviours();

            foreach (var monoBehaviour in missingMonoBehaviours)
            {
                if (!string.IsNullOrEmpty(monoBehaviour.Script.FullName) && !monoBehaviour.Script.FullName.StartsWith("XLGearModifier")) continue;

                ReplaceGuid(monoBehaviour.Script, newGuid, prefabPath);
                ReplacePrefix(monoBehaviour.Script, prefabPath);
            }
        }

        EditorUtility.DisplayProgressBar("Cleanup", "Cleaning up", 1.0f);

        EditorUtility.UnloadUnusedAssetsImmediate(true);
        GC.Collect();

        EditorUtility.ClearProgressBar();
    }

    [MenuItem("XLGM/Upgrade From 1.5/Clear Progress Bar")]
    public static void ClearProgressbar()
    {
        EditorUtility.ClearProgressBar();
    }

    private static void ReplaceGuid(ScriptMetadata script, string newGuid, string fileName)
    {
        Debug.Log($"Replacing guid from '{script.Guid}' to '{newGuid}' on file '{fileName}'...");

        var content = File.ReadAllText(fileName);
        var regex = new Regex($@"(\{{fileID: {script.FileId}, guid: )({script.Guid})(, type: 3)", RegexOptions.Compiled | RegexOptions.IgnoreCase);

        content = regex.Replace(content, m => $"{m.Groups[1].Value}{newGuid}{m.Groups[3].Value}");

        File.WriteAllText(fileName, content);
    }

    private static void ReplacePrefix(ScriptMetadata script, string prefabPath)
    {
        if (string.IsNullOrEmpty(script.Prefix)) return;

        var prefab = PrefabUtility.LoadPrefabContents(prefabPath);
        var clothingMetadata = prefab?.GetComponentInChildren<XLGMClothingGearMetadata>();

        if (clothingMetadata == null) return;

        clothingMetadata.CharacterGearTemplate.id = script.Prefix;
        clothingMetadata.Prepare();

        PrefabUtility.SaveAsPrefabAsset(prefab, prefabPath);
    }
}