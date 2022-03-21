using SkaterXL.Data;
using XLGearModifier.Patches;

namespace XLGearModifier.CustomGear
{
    /// <summary>
    /// This class exists solely for the <see cref="CustomizedPlayerDataV2Patch.FromStringPatch"/>, such that we can deserialize the player.json file
    /// using our customized <see cref="XLGMCustomCharacterGearInfo"/>.
    /// </summary>
    public class XLGMCustomizedPlayerData : CustomizedPlayerDataV2
    {
        public new XLGMCustomCharacterGearInfo[] clothingGear { get; set; }
    }
}
