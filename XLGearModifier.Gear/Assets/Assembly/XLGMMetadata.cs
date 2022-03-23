using UnityEngine;

namespace XLGearModifier.Unity
{
	public abstract class XLGMMetadata : MonoBehaviour
	{
		[Header("Menu")]
		[Tooltip("This is the name that will be displayed in the menu.  If left blank, we will use the prefab name.")]
		public string DisplayName;

        public abstract string GetBaseType();
		public abstract string GetSprite();
		public abstract string GetCategory();
		public abstract bool BasedOnDefaultGear();
        public abstract string GetTemplateId();
    }
}
