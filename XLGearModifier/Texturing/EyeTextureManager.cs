using SkaterXL.Data;
using System.IO;
using System.Linq;
using XLMenuMod.Utilities;
using XLMenuMod.Utilities.Gear;

namespace XLGearModifier.Texturing
{
    public  class EyeTextureManager
    {
        private static EyeTextureManager __instance;
        public static EyeTextureManager Instance => __instance ?? (__instance = new EyeTextureManager());


        public void LookForEyeTextures()
        {
            var eyeTextures = Directory.GetFiles(SaveManager.Instance.CustomGearDir, "Eyes_*.png", SearchOption.AllDirectories);
            if (!eyeTextures.Any()) return;

            CustomFolderInfo parent = null;

            foreach (var eyeTexture in eyeTextures)
            {
                var gearInfo = new CustomCharacterGearInfo(eyeTexture, "Eyes", true, new [] { new TextureChange("eyes", eyeTexture) }, new string[] { });
                GearManager.Instance.AddItem(gearInfo, GearManager.Instance.Eyes, ref parent);
            }


            //if (string.IsNullOrEmpty(texture)) return;
            //if (!File.Exists(texture)) return;

            //switch (textureFilename)
            //{
            //    case ColorTextureFilename:
            //        SkateshopTexture = new Texture2D(2, 2);
            //        if (SkateshopTexture.LoadImage(File.ReadAllBytes(texture))) return;
            //        SkateshopTexture = null;
            //        break;
            //    case NormalTextureFilename:
            //        SkateshopNormal = new Texture2D(2, 2);
            //        if (SkateshopNormal.LoadImage(File.ReadAllBytes(texture))) return;
            //        SkateshopNormal = null;
            //        break;
            //    case RgmtaoTextureFilename:
            //        SkateshopRgMtAo = new Texture2D(2, 2);
            //        if (SkateshopRgMtAo.LoadImage(File.ReadAllBytes(texture))) return;
            //        SkateshopRgMtAo = null;
            //        break;
            //    default:
            //        break;
            //}
        }
    }
}
