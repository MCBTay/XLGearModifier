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
    static class LevelManagerPatch
    {
        [HarmonyPatch(typeof(LevelManager), nameof(LevelManager.LoadSceneAdditive))]
        static class LoadSceneAdditivePatch
        {
            private static Texture2D SkateshopTexture;
            private const string ColorTextureFilename = "Skateshop.png";
            private const string ColorTextureName = "Texture2D_694A07B4";

            private static Texture2D SkateshopNormal;
            private const string NormalTextureFilename = "Skateshop.normal.png";
            private const string NormalTextureName = "Texture2D_BBD4D99B";

            private static Texture2D SkateshopRgMtAo;
            private const string RgmtaoTextureFilename = "Skateshop.rgmtao.png";
            private const string RgmtaoTextureName = "Texture2D_EDCB0FF8";

            static void Prefix(LevelManager __instance, string sceneName, ref Action completion)
            {
                if (sceneName != GameStateMachine.Instance.GearSelectorScene) return;

                completion = () =>
                {
                    Time.timeScale = 1f;

                    var renderer = GetSkateshopRenderer(__instance);
                    if (renderer?.material == null) return;

                    LookForSkateshopTextures();

                    SetRendererTextures(renderer);
                };
            }

            private static MeshRenderer GetSkateshopRenderer(LevelManager __instance)
            {
                var sceneHandle = new Traverse(__instance).Field("LoadedAdditiveSceneHandle").GetValue<AsyncOperationHandle<SceneInstance>>();
                var rootGO = sceneHandle.Result.Scene.GetRootGameObjects().FirstOrDefault(x => x.name == "root");

                var meshRenderers = rootGO.GetComponentsInChildren<MeshRenderer>();
                if (meshRenderers == null || !meshRenderers.Any()) return null;

                var meshRenderer = meshRenderers.FirstOrDefault(x => x.name == "SS_WallsandFloors_01");
                if (meshRenderer == null) return null;

                return meshRenderer;
            }

            private static void LookForSkateshopTextures()
            {
                LookForSkateshopTexture(ColorTextureFilename);
                LookForSkateshopTexture(NormalTextureFilename);
                LookForSkateshopTexture(RgmtaoTextureFilename);
            }

            private static void LookForSkateshopTexture(string textureFilename)
            {
                var texture = Directory.GetFiles(SaveManager.Instance.CustomGearDir, textureFilename, SearchOption.AllDirectories).FirstOrDefault();
                if (string.IsNullOrEmpty(texture)) return;
                if (!File.Exists(texture)) return;

                switch (textureFilename)
                {
                    case ColorTextureFilename:
                        if (SkateshopTexture == null)
                        {
                            SkateshopTexture = new Texture2D(2, 2);
                            if (SkateshopTexture.LoadImage(File.ReadAllBytes(texture))) return;

                            SkateshopTexture = null;
                        }
                        break;
                    case NormalTextureFilename:
                        if (SkateshopNormal == null)
                        {
                            SkateshopNormal = new Texture2D(2, 2);
                            if (SkateshopNormal.LoadImage(File.ReadAllBytes(texture))) return;

                            SkateshopNormal = null;
                        }
                        break;
                    case RgmtaoTextureFilename:
                        if (SkateshopRgMtAo == null)
                        {
                            SkateshopRgMtAo = new Texture2D(2, 2);
                            if (SkateshopRgMtAo.LoadImage(File.ReadAllBytes(texture))) return;

                            SkateshopRgMtAo = null;
                        }
                        break;
                    default:
                        break;
                }
            }

            private static void SetRendererTextures(MeshRenderer renderer)
            {
                if (SkateshopTexture != null)
                {
                    renderer.material.SetTexture(ColorTextureName, SkateshopTexture);
                }

                if (SkateshopNormal != null)
                {
                    renderer.material.SetTexture(NormalTextureName, SkateshopNormal);
                }

                if (SkateshopRgMtAo != null)
                {
                    renderer.material.SetTexture(RgmtaoTextureName, SkateshopRgMtAo);
                }
            }
        }
    }
}
