using System.IO;
using System.Linq;
using UnityEngine;

namespace XLGearModifier
{
    public class SkateShopTextureManager
    {
        private static SkateShopTextureManager __instance;
        public static SkateShopTextureManager Instance => __instance ?? (__instance = new SkateShopTextureManager());

        private static Texture2D SkateshopTexture;
        private const string ColorTextureFilename = "Skateshop.png";
        private const string ColorTextureName = "Texture2D_694A07B4";

        private static Texture2D SkateshopNormal;
        private const string NormalTextureFilename = "Skateshop.normal.png";
        private const string NormalTextureName = "Texture2D_BBD4D99B";

        private static Texture2D SkateshopRgMtAo;
        private const string RgmtaoTextureFilename = "Skateshop.rgmtao.png";
        private const string RgmtaoTextureName = "Texture2D_EDCB0FF8";

        /// <summary>
        /// Attempts to find custom textures in the gear folder for color, normal, and rgmtao.
        /// </summary>
        public void LookForSkateshopTextures()
        {
            LookForSkateshopTexture(ColorTextureFilename);
            LookForSkateshopTexture(NormalTextureFilename);
            LookForSkateshopTexture(RgmtaoTextureFilename);
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
                case ColorTextureFilename:
                    SkateshopTexture = new Texture2D(2, 2);
                    if (SkateshopTexture.LoadImage(File.ReadAllBytes(texture))) return;
                    SkateshopTexture = null;
                    break;
                case NormalTextureFilename:
                    SkateshopNormal = new Texture2D(2, 2);
                    if (SkateshopNormal.LoadImage(File.ReadAllBytes(texture))) return;
                    SkateshopNormal = null;
                    break;
                case RgmtaoTextureFilename:
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
