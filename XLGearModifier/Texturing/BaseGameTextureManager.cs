using System;
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

        public const string ColorTextureName = "_texture2D_color";
        public const string NormalTextureName = "_texture2D_normal";
        public const string RgmtaoTextureName = "_texture2D_maskPBR";

        public const string HairColorTextureName = "_texture_color";
        public const string HairNormalTextureName = "_texture_normal";
        public const string HairRgmtaoTextureName = "_texture_mask";

        public BaseGameTextureManager()
        {
            BaseGameTextures = new Dictionary<string, Dictionary<string, Texture>>();
        }

        /// <summary>
        /// Loads materials from the base game.  Loads materials for tops, bottoms, shoes, headwear, and hair.
        /// </summary>
        public async Task LoadGameMaterials()
        {
            await Task.WhenAll(new List<Task>
            {
                LoadBaseMaterials<TopTypes>(),
                LoadBaseMaterials<BottomTypes>(),
                LoadBaseMaterials<ShoeTypes>(),
                LoadBaseMaterials<HeadwearTypes>(),
                LoadBaseMaterials<HairStyles>(true)
            });
        }

        private async Task LoadBaseMaterials<T>(bool isHair = false) where T : Enum
        {
            var names = Enum.GetNames(typeof(T)).Select(x => x.ToLower());

            foreach (var name in names)
            {
                var material = await LoadBaseGameAssetMaterial(name);
                if (material == null) continue;

                if (name == TopTypes.MShirt.ToString().ToLower() && MasterShaderCloth_v2 == null)
                {
                    MasterShaderCloth_v2 = material.shader;
                }

                if (name == HairStyles.MHairCounterpart.ToString().ToLower() && MasterShaderHair_AlphaTest_v1 == null)
                {
                    MasterShaderHair_AlphaTest_v1 = material.shader;
                }

                var textures = new Dictionary<string, Texture>
                {
                    { "normal", material.GetTexture(isHair ? HairNormalTextureName : NormalTextureName) },
                    { "maskpbr", material.GetTexture(isHair ? HairRgmtaoTextureName : RgmtaoTextureName) }
                };

                BaseGameTextures.Add(name, textures);
            }
        }

        /// <summary>
        /// Finds the material being used by the specified TemplateId and returns it.  Has to load the prefab from the Addressables system in order to be able to get that reference to the material.
        /// </summary>
        /// <param name="templateId">The template/mesh to get the shader for.</param>
        /// <returns>A reference to the shader being used by the mesh/template.</returns>
        private async Task<Material> LoadBaseGameAssetMaterial(string templateId)
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
            if (target == null) return null;

            return target.renderer?.material;
        }
    }
}
