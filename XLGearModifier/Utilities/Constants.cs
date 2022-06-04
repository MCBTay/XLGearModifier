namespace XLGearModifier.Utilities
{
    /// <summary>
    /// Filenames for our built-in default, empty textures.
    /// </summary>
    public class EmptyTextureConstants
    {
        public const string EmptyAlbedoFilename = "Empty_Albedo.png";
        public const string EmptyNormalFilename = "Empty_Normal_Map.png";
        public const string EmptyMaskFilename = "Empty_Maskpbr_Map.png";
    }

    /// <summary>
    /// Shader property names for the shader the eyes are using.
    /// </summary>
    public class EyeTextureConstants
    {
        public const string ColorTextureName = "Texture2D_4128E5C7";
        public const string NormalTextureName = "Texture2D_BEC07F52";
        public const string RgmtaoTextureName = "Texture2D_B56F9766";
    }

    /// <summary>
    /// Shader property names for MasterShaderCloth_v2.
    /// </summary>
    public class MasterShaderClothTextureConstants
    {
        public const string ColorTextureName = "_texture2D_color";
        public const string NormalTextureName = "_texture2D_normal";
        public const string RgmtaoTextureName = "_texture2D_maskpbr";
    }

    /// <summary>
    /// Shader property names for MasterShaderHair_AlphaTest_v1.
    /// </summary>
    public class MasterShaderHairTextureConstants
    {
        public const string ColorTextureName = "_texture_color";
        public const string NormalTextureName = "_texture_normal";
        public const string RgmtaoTextureName = "_texture_maskpbr";
    }

    /// <summary>
    /// Shader property names for HDRP/Lit.
    /// </summary>
    public class HDRPLitTextureConstants
    {
        public const string ColorTextureName = "_BaseColorMap";
        public const string NormalTextureName = "_NormalMap";
        public const string RgmtaoTextureName = "_MaskMap";
    }

    /// <summary>
    /// Shader property names for the shader the skateshop is using as well as the filenames the mod is looking for.
    /// </summary>
    public class SkateShopTextureConstants
    {
        public const string ColorTextureName = "Texture2D_694A07B4";
        public const string NormalTextureName = "Texture2D_BBD4D99B";
        public const string RgmtaoTextureName = "Texture2D_EDCB0FF8";

        public const string ColorTextureFileName = "Skateshop.png";
        public const string NormalTextureFileName = "Skateshop.normal.png";
        public const string RgmtaoTextureFileName = "Skateshop.rgmtao.png";
    }

    /// <summary>
    /// Commonly used texture type names throughout the code.
    /// </summary>
    public class TextureTypes
    {
        public const string Albedo = "albedo";
        public const string Normal = "normal";
        public const string MaskPBR = "maskpbr";
    }
}
