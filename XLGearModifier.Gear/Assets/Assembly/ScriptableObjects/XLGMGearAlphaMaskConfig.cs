using System;
using UnityEngine;

namespace XLGearModifier.Unity.ScriptableObjects
{
	// This class pulled from SkaterXL.  Will get mapped over in mod code to the real version of this class.
	[CreateAssetMenu(fileName = "New XLGM Gear Alpha Mask Config", menuName = "XLGM Gear Alpha Mask Config")]
	[Serializable]
	public class XLGMGearAlphaMaskConfig : ScriptableObject
	{
		public AlphaMaskLocation MaskLocation;
		[Range(0.0f, 255f)]
		public int Threshold;

		public Texture2D AlphaMask;
	}
}
