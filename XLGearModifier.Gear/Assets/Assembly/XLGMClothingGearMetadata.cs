using System;
using System.Collections.Generic;
using SkaterXL.Gear;
using UnityEngine;
using XLGearModifier.Unity.ScriptableObjects;

namespace XLGearModifier.Unity
{
    [Serializable]
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

        [HideInInspector]
        [Tooltip("This is a prefix aliases that the mesh can use.  A prefix defined here should be able to be applied to the mesh in game. For example, if you create 5 hoodie variations with similar UVs, you could set this field to the same value for all 5 prefabs and they'd be able to share textures.")]
        public string PrefixAlias;

        #region Alpha Masks
        [Tooltip("Set the threshold(s) for various alpha masks when this mesh is applied. It will add it to the gear template if it is not already defined, or override it if it is. Typically used for masking various areas of the body.")]
        [SerializeField]
        public List<GearAlphaMaskConfig> AlphaMaskThresholds;
        #endregion

		[HideInInspector]
		[Tooltip("This will enable the use of textures from default gear.  For example, if you've modified MShirt but the UV is still pretty close to the original, you can leverage existing MShirt textures by checking this and setting BaseTopType to MShirt.")]
        public bool BaseOnDefaultGear;

        [HideInInspector]
		[Tooltip("The base hair style to use textures from.")]
        public HairStyles BaseHairStyle;

		[HideInInspector]
        [Tooltip("The base headwear to use textures from.")]
		public HeadwearTypes BaseHeadwearType;

		[HideInInspector]
        [Tooltip("The base shoe to use textures from.")]
		public ShoeTypes BaseShoeType;

		[HideInInspector]
        [Tooltip("The base top to use textures from.")]
		public TopTypes BaseTopType;
        
        [HideInInspector]
        [Tooltip("The base bottom to use textures from.")]
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