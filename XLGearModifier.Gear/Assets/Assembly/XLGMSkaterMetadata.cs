using System;
using SkaterXL.Gear;
using UnityEngine;

namespace XLGearModifier.Unity
{
    [Serializable]
	public class XLGMSkaterMetadata : XLGMMetadata
	{
		public SkaterBase BasedOn;

		[Header("Template")]
        public CharacterBodyTemplate CharacterBodyTemplate;

		public override string GetBaseType() => BasedOn.ToString();
		public override string GetSprite() => null;
		public override string GetCategory() => null;
		public override bool BasedOnDefaultGear() => false;
        public override string GetTemplateId() => CharacterBodyTemplate.id.ToLower();

        /// <summary>
        /// An editor only function that gets called when this changes in inspector.  This allows us
        /// to hide path and eye position settings.
        /// </summary>
        public void OnValidate()
        {
            if (CharacterBodyTemplate == null) return;

            CharacterBodyTemplate.id = CharacterBodyTemplate.id.ToLower();
            CharacterBodyTemplate.path = $"XLGearModifier/{CharacterBodyTemplate.id}";
        }
    }
}
