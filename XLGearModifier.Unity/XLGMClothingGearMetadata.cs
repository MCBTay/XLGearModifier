using UnityEngine;

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

		[Header("Texturing")]
		public bool BaseOnDefaultGear;

		#region Base Styles
		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)ClothingGearCategory.Hair)]
		[Tooltip("This is the list of base hair styles in the game.")]
		public HairStyles BaseHairStyle;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)ClothingGearCategory.Headwear)]
		[Tooltip("This is the list of base headwear styles in the game.")]
		public HeadwearTypes BaseHeadwearType;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)ClothingGearCategory.Shoes)]
		[Tooltip("This is the list of base shoes in the game.")]
		public ShoeTypes BaseShoeType;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)ClothingGearCategory.Top)]
		[Tooltip("This is the list of base top styles in the game.")]
		public TopTypes BaseTopType;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)ClothingGearCategory.Bottom)]
		[Tooltip("This is the list of base bottom styles in the game.")]
		public BottomTypes BaseBottomType;
		#endregion

		//[HideIf(nameof(BaseOnDefaultGear), true)]
		public XLGMTextureSet TextureSet;

		#region Alpha Masks
		//[Header("Alpha Masks")]
		// TODO: For some reason these lists don't work, they come over as null on the mod end.
		//public List<GearAlphaMaskConfig> AlphaMasks;
		//public List<AlphaMaskTextureInfo> AlphaMaskTextures;
		#endregion

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