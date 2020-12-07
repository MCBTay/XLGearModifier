using System.Collections.Generic;
using UnityEngine;

namespace XLGearModifier.Unity
{
	public class XLGearModifierMetadata : MonoBehaviour
	{
		[Header("Menu")]
		[Tooltip("This is the name that will be displayed in the menu.  If left blank, we will use the prefab name.")]
		public string DisplayName;
		[Tooltip("This is the sprite that will be used in the menu.")]
		public SpriteCategory Sprite;
		[Tooltip("This is the Category of the gear and will dictate which category folder the mesh shows up in.")]
	    public GearCategory Category;
		[Tooltip("This checkbox allows a mesh to be 'layerable' over it's own gear slot.  For example, you could apply two separate shirt meshes at the same time if they're both layerable.")]
	    public bool IsLayerable;
		[Tooltip("This is the 'prefix' or 'type' associated with the mesh. This will be used in order for the mod to know which mesh to load but also to know which textures to load.  Arguably more important for meshes that are not based on default gear.  Examples from the base game would be MHatDad or FHatDad.")]
	    public string Prefix;

		#region Texturing
		[Header("Texturing")]
		public bool BaseOnDefaultGear;

		#region Base Styles
		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)GearCategory.Hair)]
		[Tooltip("This is the list of base hair styles in the game.")]
		public HairStyles BaseHairStyle;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)GearCategory.Headwear)]
		[Tooltip("This is the list of base headwear styles in the game.")]
		public HeadwearTypes BaseHeadwearType;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)GearCategory.Shoes)]
		[Tooltip("This is the list of base shoes in the game.")]
		public ShoeTypes BaseShoeType;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)GearCategory.Top)]
		[Tooltip("This is the list of base top styles in the game.")]
		public TopTypes BaseTopType;

		[HideIf(nameof(BaseOnDefaultGear), false)]
		[HideIfEnumValue(nameof(Category), HideIf.NotEqual, (int)GearCategory.Bottom)]
		[Tooltip("This is the list of base bottom styles in the game.")]
		public BottomTypes BaseBottomType;
		#endregion

		[HideIf(nameof(BaseOnDefaultGear), true)]
		public Material Material;

		#region MasterShaderCloth_v2 Properties, hidden when BaseOnDefaultGear is true
		[Header("Shader Properties")]

		[HideIf(nameof(BaseOnDefaultGear), true)]
		public Texture2D TextureNormalMap;

		[HideIf(nameof(BaseOnDefaultGear), true)]
		public Texture2D TextureMaskPBR;

		[HideIf(nameof(BaseOnDefaultGear), true)]
		public float MinRoughness = 0;
		[HideIf(nameof(BaseOnDefaultGear), true)]
		public float MaxRoughness = 1;

		[HideIf(nameof(BaseOnDefaultGear), true)]
		public float MinSpecular = 0;
		[HideIf(nameof(BaseOnDefaultGear), true)]
		public float MaxSpecular = 1;
		#endregion

		#region Alpha Masks
		[Header("Alpha Masks")]
		// TODO: For some reason these lists don't work, they come over as null on the mod end.
		public List<GearAlphaMaskConfig> AlphaMasks;
		public List<AlphaMaskTextureInfo> AlphaMaskTextures;
		#endregion
		#endregion
	}
}
