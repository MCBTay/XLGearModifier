using UnityEngine;

namespace XLGearModifier.Unity
{
	public class XLGearModifierMetadata : MonoBehaviour
    {
	    public GearCategory Category;

		[HideIfEnumValue("Category", HideIf.NotEqual, (int)GearCategory.Hair)]
	    public HairStyles BaseHairStyle;

	    [HideIfEnumValue("Category", HideIf.NotEqual, (int)GearCategory.Headwear)]
		public HeadwearTypes BaseHeadwearType;
    }
}
