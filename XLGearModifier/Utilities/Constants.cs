namespace XLGearModifier.Utilities
{
    public class EmptyTextureConstants
    {
        public const string EmptyAlbedoFilename = "Empty_Albedo.png";
        public const string EmptyNormalFilename = "Empty_Normal_Map.png";
        public const string EmptyMaskFilename = "Empty_Maskpbr_Map.png";
    }

    public class EyeTextureConstants
    {
        public const string ColorTextureName = "Texture2D_4128E5C7";
        public const string NormalTextureName = "Texture2D_BEC07F52";
        public const string RgmtaoTextureName = "Texture2D_B56F9766";
    }

    public class MasterShaderClothTextureConstants
    {
        public const string ColorTextureName = "_texture2D_color";
        public const string NormalTextureName = "_texture2D_normal";
        public const string RgmtaoTextureName = "_texture2D_maskpbr";
    }

    public class MasterShaderHairTextureConstants
    {
        public const string ColorTextureName = "_texture_color";
        public const string NormalTextureName = "_texture_normal";
        public const string RgmtaoTextureName = "_texture_maskpbr";
    }

    public class HDRPLitTextureConstants
    {
        public const string ColorTextureName = "_BaseColorMap";
        public const string NormalTextureName = "_NormalMap";
        public const string RgmtaoTextureName = "_MaskMap";
    }
}
