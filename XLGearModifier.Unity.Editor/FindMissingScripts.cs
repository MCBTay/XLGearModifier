using System;
using System.IO;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using XLGearModifier.Unity.Editor.Upgrade;

public class FindMissingScriptsEditor : EditorWindow
{
    [MenuItem("XLGM/Upgrade From 1.5/Upgrade Prefabs")]
    public static void FindMissingScripts()
    {
        EditorUtility.DisplayProgressBar("Searching Prefabs", "", 0.0f);

        string[] files = Directory.GetFiles(Application.dataPath, "*.prefab", SearchOption.AllDirectories);
        EditorUtility.DisplayCancelableProgressBar("Searching Prefabs", "Found " + files.Length + " prefabs", 0.0f);

        Scene currentScene = SceneManager.GetActiveScene();
        string scenePath = currentScene.path;
        EditorSceneManager.NewScene(NewSceneSetup.EmptyScene);

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
                Debug.Log($"Prefab {prefabPath} has an empty script attached.  Attempting to add new XLGMClothingGearMetadata");

                ReplaceGuid(monoBehaviour.Script, newGuid, prefabPath);
            }

            EditorUtility.UnloadUnusedAssetsImmediate(true);
        }

        EditorUtility.DisplayProgressBar("Cleanup", "Cleaning up", 1.0f);
        if (!string.IsNullOrEmpty(scenePath))
        {
            EditorSceneManager.OpenScene(scenePath, OpenSceneMode.Single);
        }

        EditorUtility.UnloadUnusedAssetsImmediate(true);
        GC.Collect();

        EditorUtility.ClearProgressBar();
    }

    [MenuItem("XLGM/Upgrade From 1.5/Clear Progressbar")]
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
}