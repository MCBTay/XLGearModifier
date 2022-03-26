using SkaterXL.Gear;
using System;
using UnityEngine;

namespace XLGearModifier.Unity
{
    [Serializable]
	public class XLGMClothingGearMetadata : XLGMMetadata
    {
        [Tooltip("This is the name of the creator that will be displayed in the menu.")]
        public string CreatorName;

        [Tooltip("This defines which skater the gear is intended for.  This is used to determine which items show up in the gear menu based on which skater you are customizing.")]
        public SkaterBase Skater;
        
        [Tooltip("This is the sprite that will be used in the menu.")]
		public SpriteCategory Sprite;
		
        [Tooltip("This is the Category of the gear and will dictate which category folder the mesh shows up in.")]
		public ClothingGearCategory Category;

		[Header("Template")]
        public CharacterGearTemplate CharacterGearTemplate;

		[Header("Other Category")]
		[Tooltip("This checkbox allows a mesh to be 'layerable' over it's own gear slot.  For example, you could apply two separate shirt meshes at the same time if they're both layerable.")]
		public bool IsLayerable;
		
		

        [HideInInspector]
        [Tooltip("This is a prefix aliases that the mesh can use.  A prefix defined here should be able to be applied to the mesh in game. For example, if you create 5 hoodie variations with similar UVs, you could set this field to the same value for all 5 prefabs and they'd be able to share textures.")]
        public string PrefixAlias;

        [HideInInspector]
        public CharacterGearTemplate AliasCharacterGearTemplate;

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
        public override string GetTemplateId() => CharacterGearTemplate.id.ToLower();

        /// <summary>
        /// An editor only function that gets called when this changes in inspector.  This allows us
        /// to hide path/category name from the user while ensuring they get populated as we expect.
        /// </summary>
        public void OnValidate()
        {
            if (CharacterGearTemplate == null) return;

            #region CharacterGearTemplate
            CharacterGearTemplate.id = CharacterGearTemplate.id.ToLower();
			CharacterGearTemplate.path = $"XLGearModifier/{CharacterGearTemplate.id}";
            CharacterGearTemplate.categoryName = MapCategory(Category).ToString();
            #endregion

            #region PrefixAlias
            PrefixAlias = PrefixAlias?.ToLower();

            if (string.IsNullOrEmpty(PrefixAlias))
            {
                AliasCharacterGearTemplate = null;
            }
            else
            {
                AliasCharacterGearTemplate = new CharacterGearTemplate
                {
                    alphaMasks = CharacterGearTemplate.alphaMasks,
                    category = MapCategory(Category),
                    id = PrefixAlias.ToLower(),
                    path = $"XLGearModifier/alias/{PrefixAlias}"
                };
            }
            #endregion
        }

        public SkaterXL.Gear.ClothingGearCategory MapCategory(ClothingGearCategory category)
        {
            switch (category)
            {
                case ClothingGearCategory.Hair:
                case ClothingGearCategory.FacialHair:
                case ClothingGearCategory.Headwear:
                    return SkaterXL.Gear.ClothingGearCategory.Hat;
                case ClothingGearCategory.Shoes:
                case ClothingGearCategory.Socks:
                    return SkaterXL.Gear.ClothingGearCategory.Shoes;
                case ClothingGearCategory.Bottom:
                    return SkaterXL.Gear.ClothingGearCategory.Pants;
                default:
                case ClothingGearCategory.Top:
                    return SkaterXL.Gear.ClothingGearCategory.Shirt;
            }
        }
	}
}