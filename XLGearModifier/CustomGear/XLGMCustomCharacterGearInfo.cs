using SkaterXL.Data;
using System.Collections.Generic;
using XLGearModifier.Unity;
using XLMenuMod.Utilities.Gear;

namespace XLGearModifier.CustomGear
{
    public class XLGMCustomCharacterGearInfo : CustomCharacterGearInfo
    {
        public List<XLGMBlendShapeData> blendShapes;

        public XLGMCustomCharacterGearInfo(string name, string type, bool isCustom, TextureChange[] textureChanges, string[] tags) : base(name, type, isCustom, textureChanges, tags)
        {

        }
    }
}
