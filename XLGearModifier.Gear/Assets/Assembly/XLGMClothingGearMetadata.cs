using System.Collections.Generic;
using SkaterXL.Gear;
using UnityEngine;
using XLGearModifier.Unity.ScriptableObjects;

namespace XLGearModifier.Unity
{
	public class XLGMClothingGearMetadata : XLGMMetadata
	{
		[Tooltip("This is the sprite that will be used in the menu.")]
		public SpriteCategory Sprite;
		[Tooltip("This is the Category of the gear and will dictate which category folder the mesh shows up in.")]
		public ClothingGearCategory Category;
		[Tooltip("This checkbox allows a mesh to be 'layerable' over it's own gear slot.  For example, you could apply two separate shirt meshes at the same time if they're both layerable.")]
		public bool IsLayerable;
		[Tooltip("This defines which skater the gear is intended for.  This is used to determine which items show up in the gear menu based on which skater you are customizing.")]
		public SkaterBase Skater;
		[Tooltip("This is the name of the creator that will be displayed in the menu.")]
		public string CreatorName;

        #region Alpha Masks
        [Tooltip("Set the threshold(s) for various alpha masks when this mesh is applied. It will add it to the gear template if it is not already defined, or override it if it is. Typically used for masking various areas of the body.")]
        [SerializeField]
        public List<GearAlphaMaskConfig> AlphaMaskThresholds;
        #endregion

		[HideInInspector]
        public bool BaseOnDefaultGear;

        [HideInInspector]
        public HairStyles BaseHairStyle;

		[HideInInspector]
        public HeadwearTypes BaseHeadwearType;

		[HideInInspector]
        public ShoeTypes BaseShoeType;

		[HideInInspector]
        public TopTypes BaseTopType;
        
        [HideInInspector]
        public BottomTypes BaseBottomType;

		[HideInInspector]
        [SerializeField]
		public XLGMTextureSet TextureSet;

        public override string GetBaseType()
		{  
			switch (Category)
			{
				case ClothingGearCategory.Hair: return BaseHairStyle.ToString();
				case ClothingGearCategory.Headwear: return BaseHeadwearType.ToString();
				case ClothingGearCategory.Top: return BaseTopType.ToString();
				case ClothingGearCategory.Bottom: return BaseBottomType.ToString();
				case ClothingGearCategory.Shoes: return BaseShoeType.ToString();
				default: return string.Empty;
			}
		}

		public override string GetSprite()
		{
			string sprite = Sprite.ToString();

			if (IsLayerable) 
				sprite += "_Layerable";

			return sprite;
		}

		public override string GetCategory() => Category.ToString();
		public override bool BasedOnDefaultGear() => BaseOnDefaultGear;
		public override XLGMTextureSet GetMaterialInformation() => TextureSet;
	}
}