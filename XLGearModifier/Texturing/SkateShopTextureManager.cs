using System.IO;
using System.Linq;
using UnityEngine;
using XLGearModifier.Utilities;

namespace XLGearModifier.Texturing
{
    public class SkateShopTextureManager
    {
        private static SkateShopTextureManager __instance;
        public static SkateShopTextureManager Instance => __instance ?? (__instance = new SkateShopTextureManager());

        private static Texture2D SkateshopTexture;
        private static Texture2D SkateshopNormal;
        private static Texture2D SkateshopRgMtAo;

        /// <summary>
        /// Attempts to find custom textures in the gear folder for color, normal, and rgmtao.
        /// </summary>
        public void LookForSkateshopTextures()
        {
            LookForSkateshopTexture(SkateShopTextureConstants.ColorTextureFileName);
            LookForSkateshopTexture(SkateShopTextureConstants.NormalTextureFileName);
            LookForSkateshopTexture(SkateShopTextureConstants.RgmtaoTextureFileName);
        }

        /// <summary>
        /// Recursively searches the gear folder for a particular filename.  If found, it will load the appropriate texture (SkateshopTexture, SkateshopNormal, or SkateshopRgMtAo) from the texture found on disk
        /// </summary>
        /// <param name="textureFilename">The filename of the texture being searched for.</param>
        private void LookForSkateshopTexture(string textureFilename)
        {
            var texture = Directory.GetFiles(SaveManager.Instance.CustomGearDir, textureFilename, SearchOption.AllDirectories).FirstOrDefault();
            if (string.IsNullOrEmpty(texture)) return;
            if (!File.Exists(texture)) return;

            switch (textureFilename)
            {
                case SkateShopTextureConstants.ColorTextureFileName:
                    SkateshopTexture = new Texture2D(2, 2);
                    if (SkateshopTexture.LoadImage(File.ReadAllBytes(texture))) return;
                    SkateshopTexture = null;
                    break;
                case SkateShopTextureConstants.NormalTextureFileName:
                    SkateshopNormal = new Texture2D(2, 2);
                    if (SkateshopNormal.LoadImage(File.ReadAllBytes(texture))) return;
                    SkateshopNormal = null;
                    break;
                case SkateShopTextureConstants.RgmtaoTextureFileName:
                    SkateshopRgMtAo = new Texture2D(2, 2);
                    if (SkateshopRgMtAo.LoadImage(File.ReadAllBytes(texture))) return;
                    SkateshopRgMtAo = null;
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// Applies SkateshopTexture, SkateshopNormal, and/or SkateshopRgMtAo to the passed in MeshRenderer if they are not null.
        /// </summary>
        /// <param name="renderer">The renderer to apply the textures to.</param>
        public void SetSkateshopTextures(MeshRenderer renderer)
        {
            if (renderer?.material == null) return;

            if (SkateshopTexture != null)
            {
                renderer.material.SetTexture(SkateShopTextureConstants.ColorTextureName, SkateshopTexture);
            }

            if (SkateshopNormal != null)
            {
                renderer.material.SetTexture(SkateShopTextureConstants.NormalTextureName, SkateshopNormal);
            }

            if (SkateshopRgMtAo != null)
            {
                renderer.material.SetTexture(SkateShopTextureConstants.RgmtaoTextureName, SkateshopRgMtAo);
            }
        }
    }
}
