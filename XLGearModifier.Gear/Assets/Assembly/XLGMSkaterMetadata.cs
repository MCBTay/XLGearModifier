using XLGearModifier.Unity.ScriptableObjects;

namespace XLGearModifier.Unity
{
    public class XLGMSkaterMetadata : XLGMMetadata
	{
		public SkaterBase BasedOn;

		public override string GetBaseType() => BasedOn.ToString();
		public override string GetSprite() => null;
		public override string GetCategory() => null;
		public override bool BasedOnDefaultGear() => false;

        public override XLGMTextureSet GetMaterialInformation() => null;
    }
}
