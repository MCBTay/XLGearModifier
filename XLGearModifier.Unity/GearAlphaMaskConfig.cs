using System;
using UnityEngine;

namespace XLGearModifier.Unity
{
	// This class pulled from SkaterXL.  Will get mapped over in mod code to the real version of this class.
	[Serializable]
	public class GearAlphaMaskConfig
	{
		public AlphaMaskLocation MaskLocation;
		[Range(0.0f, 255f)]
		public int Threshold;
	}
}
