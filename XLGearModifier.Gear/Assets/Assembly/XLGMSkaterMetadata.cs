using System;
using SkaterXL.Gear;

namespace XLGearModifier.Unity
{
    [Serializable]
	public class XLGMSkaterMetadata : XLGMMetadata
	{
		public SkaterBase BasedOn;

        public CharacterBodyTemplate CharacterBodyTemplate;

		public override string GetBaseType() => BasedOn.ToString();
		public override string GetSprite() => null;
		public override string GetCategory() => null;
		public override bool BasedOnDefaultGear() => false;
        public override string GetTemplateId() => CharacterBodyTemplate.id.ToLower();
    }
}
