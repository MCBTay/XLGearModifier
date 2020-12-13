using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace XLGearModifier.Unity
{
	public class XLGMSkaterMetadata : XLGMMetadata
	{
		public SkaterBase BasedOn;

		[Header("Materials")]
		public List<XLGMTextureSet> TextureSets;

		public override string GetBaseType() => BasedOn.ToString();
		public override string GetSprite() => null;
		public override string GetCategory() => null;
		public override bool BasedOnDefaultGear() => false;

		public override XLGMTextureSet GetMaterialInformation() => TextureSets?.FirstOrDefault();
	}
}
