namespace XLGearModifier.Utilities
{
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
    /// Commonly used texture type names throughout the code.
    /// </summary>
    public class TextureTypes
    {
        public const string Albedo = "albedo";
        public const string Normal = "normal";
        public const string MaskPBR = "maskpbr";
    }
}
