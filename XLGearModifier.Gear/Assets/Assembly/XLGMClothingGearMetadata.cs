using System.Collections.Generic;
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

		[Header("Texturing")]
		[Tooltip("Use this for a mesh that has a close UV to one of the original meshes. Allows you to re-use the existing textures/prefixes associated with the base mesh.")]
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
		[SerializeField]
		public XLGMTextureSet TextureSet;

		#region Alpha Masks
		[Tooltip("Set the threshold(s) for various alpha masks when this mesh is applied. It will add it to the gear template if it is not already defined, or override it if it is. Typically used for masking various areas of the body.")]
		[SerializeField] 
		public List<XLGMGearAlphaMaskConfig> AlphaMaskThresholds;

		[Tooltip("Set the alpha masks on this mesh's material.  The one that makes the most sense here is likely PantsWaist as the other types are meant to apply to the body.")]
		[SerializeField]
		public List<XLGMAlphaMaskTextureInfo> MaterialAlphaMasks;
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