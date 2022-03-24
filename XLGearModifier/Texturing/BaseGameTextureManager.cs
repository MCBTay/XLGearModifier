using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;

namespace XLGearModifier.Texturing
{
    public class BaseGameTextureManager
    {
        private static BaseGameTextureManager __instance;
        public static BaseGameTextureManager Instance => __instance ?? (__instance = new BaseGameTextureManager());

        public Shader MasterShaderCloth_v2;
        public Shader MasterShaderHair_AlphaTest_v1;

        public Dictionary<string, Dictionary<string, Texture>> BaseGameTextures;

        public BaseGameTextureManager()
        {
            BaseGameTextures = new Dictionary<string, Dictionary<string, Texture>>();
        }

        public IEnumerator LoadEasyDayTextures(AssetBundle bundle)
        {
            var assetLoadRequest = bundle.LoadAllAssetsAsync<Texture2D>();
            yield return assetLoadRequest;

            var textures = assetLoadRequest.allAssets.Cast<Texture2D>();

            foreach (var texture in textures)
            {
                var textureName = texture.name.ToLower();

                var split = textureName.Split('.');
                var templateId = split[0];
                var textureType = split[1];

                if (!BaseGameTextures.ContainsKey(templateId))
                {
                    BaseGameTextures.Add(templateId, new Dictionary<string, Texture>());
                }

                if (!BaseGameTextures[templateId].ContainsKey(textureType))
                {
                    BaseGameTextures[templateId].Add(textureType, texture);
                }
            }
        }

        public async Task LoadGameShaders()
        {
            await Task.WhenAll(new List<Task>
            {
                LoadClothingShader(),
                LoadHairShader()
            });
        }

        private async Task LoadClothingShader()
        {
            MasterShaderCloth_v2 = await LoadBaseGameAssetShader("Assets/Materials/Shader/MasterShaderCloth_v2.ShaderGraph");
        }

        private async Task LoadHairShader()
        {
            MasterShaderHair_AlphaTest_v1 = await LoadBaseGameAssetShader("Assets/Materials/Shader/MasterShaderHair_AlphaTest_v1.shadergraph");
        }

        /// <summary>
        /// Finds the shader being used by the specified TemplateId and returns it.  Has to load the prefab from the Addressables system in order to be able to get that reference to the shader.
        /// </summary>
        /// <param name="shaderPath">The path to the shader to load.</param>
        /// <returns>A reference to the shader being used by the mesh/template.</returns>
        private async Task<Shader> LoadBaseGameAssetShader(string shaderPath)
        {
            AsyncOperationHandle<Shader> loadOp = Addressables.LoadAssetAsync<Shader>(shaderPath);
            await new WaitUntil(() => loadOp.IsDone);
            Shader result = loadOp.Result;
            if (result == null)
            {
                Debug.Log("XLGM: No shader found for template at path '" + shaderPath + "'");
                return null;
            }

            return result;
        }
    }
}
