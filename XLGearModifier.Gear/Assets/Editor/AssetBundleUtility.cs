using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Assets.Editor
{
    public class AssetBundleUtility
    {
        public static void BuildFor(
          GameObject prefab,
          string outputDirectory,
          string bundleName = null,
          BuildAssetBundleOptions buildOptions = BuildAssetBundleOptions.ChunkBasedCompression)
        {
            string nearestInstanceRoot = PrefabUtility.GetPrefabAssetPathOfNearestInstanceRoot((Object)prefab);
            if (nearestInstanceRoot == null)
                Debug.LogError((object)"Prefab not found");
            else
                AssetBundleUtility.BuildFor(nearestInstanceRoot, outputDirectory, bundleName ?? prefab.name, buildOptions);
        }

        public static void BuildFor(
          string prefabAssetPath,
          string outputDirectory,
          string bundleName = null,
          BuildAssetBundleOptions buildOptions = BuildAssetBundleOptions.ChunkBasedCompression)
        {
            AssetBundleBuild abBuild = new AssetBundleBuild()
            {
                assetBundleName = bundleName ?? Path.GetFileNameWithoutExtension(prefabAssetPath),
                assetNames = new string[1] { prefabAssetPath },
                addressableNames = new string[1] { "prefab" }
            };
            outputDirectory = Path.Combine(outputDirectory, EditorUserBuildSettings.activeBuildTarget.ToString());
            AssetBundleUtility.Build(outputDirectory, abBuild, EditorUserBuildSettings.activeBuildTarget, buildOptions);
        }

        public static void BuildFor(
          Scene scene,
          string outputDirectory,
          string bundleName = null,
          BuildAssetBundleOptions buildOptions = BuildAssetBundleOptions.ChunkBasedCompression)
        {
            EditorSceneManager.SaveScene(scene);
            AssetBundleBuild abBuild = new AssetBundleBuild()
            {
                assetBundleName = bundleName ?? scene.name,
                assetNames = new string[1] { scene.path }
            };
            outputDirectory = Path.Combine(outputDirectory, EditorUserBuildSettings.activeBuildTarget.ToString());
            AssetBundleUtility.Build(outputDirectory, abBuild, EditorUserBuildSettings.activeBuildTarget, buildOptions);
            EditorSceneManager.OpenScene(scene.path);
        }

        public static AssetBundleManifest Build(
          string path,
          AssetBundleBuild abBuild,
          BuildTarget buildTarget,
          BuildAssetBundleOptions buildOptions)
        {
            return Build(path, new AssetBundleBuild[1]
            {
                abBuild
            }, buildTarget, buildOptions);
        }

        public static AssetBundleManifest Build(
          string path,
          AssetBundleBuild[] abBuilds,
          BuildTarget buildTarget,
          BuildAssetBundleOptions buildOptions)
        {
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);
            foreach (AssetBundleBuild abBuild in abBuilds)
            {
                string str1 = Path.Combine(path, abBuild.assetBundleName);
                if (File.Exists(str1))
                {
                    string str2 = str1 + "_Old_" + new FileInfo(str1).CreationTime.ToString("M/d/yyyy-H:mm-tt");
                    if (File.Exists(str2))
                        File.Delete(str2);
                    File.Move(str1, str2);
                }
            }
            return BuildPipeline.BuildAssetBundles(path, abBuilds, buildOptions, buildTarget);
        }
    }

}
