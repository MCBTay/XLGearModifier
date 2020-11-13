using UnityEngine;

namespace XLGearModifier.Unity
{
	public class XLGearModifierMetadata : MonoBehaviour
    {
	    public GearCategory Category;

	    public bool BaseOnDefaultGear;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)GearCategory.Hair)]
	    public HairStyles BaseHairStyle;

	    [HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)GearCategory.Headwear)]
		public HeadwearTypes BaseHeadwearType;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int) GearCategory.Shoes)]
		public ShoeTypes BaseShoeType;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int) GearCategory.Top)]
		public TopTypes BaseTopType;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)GearCategory.Bottom)]
		public BottomTypes BaseBottomType;
	}
}
