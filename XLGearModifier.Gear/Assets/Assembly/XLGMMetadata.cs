using UnityEngine;

namespace XLGearModifier.Unity
{
	public abstract class XLGMMetadata : MonoBehaviour
	{
		[Header("Menu")]
		[Tooltip("This is the name that will be displayed in the menu.  If left blank, we will use the prefab name.")]
		public string DisplayName;
		[Tooltip("This is the 'prefix' or 'type' associated with the mesh. This will be used in order for the mod to know which mesh to load but also to know which textures to load.  Arguably more important for meshes that are not based on default gear.  Examples from the base game would be MHatDad or FHatDad.")]
		public string Prefix;

		public abstract string GetBaseType();
		public abstract string GetSprite();
		public abstract string GetCategory();
		public abstract bool BasedOnDefaultGear();
	}
}
