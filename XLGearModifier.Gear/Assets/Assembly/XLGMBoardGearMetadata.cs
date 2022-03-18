using System;
using UnityEngine;

namespace XLGearModifier.Unity
{
	[Serializable]
	public class XLGMBoardGearMetadata : XLGMMetadata
	{
		[Tooltip("This is the Category of the gear and will dictate which category folder the mesh shows up in.")]
		public BoardGearCategory Category;

		[Header("Texturing")]
		public bool BaseOnDefaultGear;

		#region Base Styles
        [Tooltip("This is the list of base truck styles in the game.")]
		public TruckTypes BaseTruckStyle;
		#endregion

		public override string GetBaseType()
		{
			switch (Category)
			{
				case BoardGearCategory.Deck: return "Deck";
				case BoardGearCategory.Griptape: return "Griptape";
				case BoardGearCategory.Trucks: return BaseTruckStyle.ToString();
				case BoardGearCategory.Wheels: return "Wheels";
				default: return string.Empty;
			}
		}

		public override string GetSprite() => null;
		public override string GetCategory() => Category.ToString();
		public override bool BasedOnDefaultGear() => BaseOnDefaultGear;
    }
}
