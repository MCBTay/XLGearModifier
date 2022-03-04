using GameManagement;
using HarmonyLib;
using System;
using System.IO;
using System.Linq;
using UnityEngine;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.ResourceManagement.ResourceProviders;

namespace XLGearModifier.Patches
{
    /// <summary>
    /// Patching into LoadSceneAdditive in order to provide custom texturing capability to the "skateshop" or character editing scene.
    /// </summary>
    static class LevelManagerPatch
    {
        [HarmonyPatch(typeof(LevelManager), nameof(LevelManager.LoadSceneAdditive))]
        static class LoadSceneAdditivePatch
        {
            static void Prefix(LevelManager __instance, string sceneName, ref Action completion)
            {
                if (sceneName != GameStateMachine.Instance.GearSelectorScene) return;

                completion = () =>
                {
                    // This was something being done by Easy Day, since we're overwriting this Action, we should do it too.
                    Time.timeScale = 1f;

                    var renderer = GetSkateshopRenderer(__instance);
                    SkateShopTextureManager.Instance.SetSkateshopTextures(renderer);
                };
            }

            /// <summary>
            /// References the loaded additive scene and searches for a specific game object in that scene called "root".  This was determined by looking at the assets via Asset Studio.
            /// It then looks for a particular mesh renderer, "SS_WallsandFloors_01", as that's the renderer of the mesh you see, and returns that mesh renderer.
            /// </summary>
            /// <returns></returns>
            private static MeshRenderer GetSkateshopRenderer(LevelManager __instance)
            {
                var sceneHandle = new Traverse(__instance).Field("LoadedAdditiveSceneHandle").GetValue<AsyncOperationHandle<SceneInstance>>();
                var rootGO = sceneHandle.Result.Scene.GetRootGameObjects().FirstOrDefault(x => x.name == "root");

                var meshRenderers = rootGO.GetComponentsInChildren<MeshRenderer>();
                if (meshRenderers == null || !meshRenderers.Any()) return null;

                return meshRenderers.FirstOrDefault(x => x.name == "SS_WallsandFloors_01"); ;
            }
        }
    }
}
