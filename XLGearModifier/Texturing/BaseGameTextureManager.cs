using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SkaterXL.Gear;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using XLGearModifier.Unity;

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
            MasterShaderCloth_v2 = await LoadBaseGameAssetShader(TopTypes.MShirt.ToString().ToLower());
        }

        private async Task LoadHairShader()
        {
            MasterShaderHair_AlphaTest_v1 = await LoadBaseGameAssetShader(HairStyles.MHairSidepart.ToString().ToLower());
        }

        /// <summary>
        /// Finds the shader being used by the specified TemplateId and returns it.  Has to load the prefab from the Addressables system in order to be able to get that reference to the shader.
        /// </summary>
        /// <param name="shaderPath">The path to the shader to load.</param>
        /// <returns>A reference to the shader being used by the mesh/template.</returns>
        private async Task<Shader> LoadBaseGameAssetShader(string templateId)
        {
            var template = GearDatabase.Instance.CharGearTemplateForID[templateId];
            if (template == null) return null;

            AsyncOperationHandle<GameObject> loadOp = Addressables.LoadAssetAsync<GameObject>(template.path);
            await new WaitUntil(() => loadOp.IsDone);
            GameObject result = loadOp.Result;
            if (result == null)
            {
                Debug.Log("XLGM: No prefab found for template at path '" + template.path + "'");
                return null;
            }

            var materialController = result.GetComponentInChildren<MaterialController>();
            if (materialController == null) return null;

            var target = materialController.targets?.FirstOrDefault();

            return target?.renderer?.material.shader;
        }
    }
}
