using System;
using UnityEngine;

namespace XLGearModifier.Unity.ScriptableObjects
{
	// This class pulled from SkaterXL.  Will get mapped over in mod code to the real version of this class.
	[CreateAssetMenu(fileName = "New XLGM Alpha Mask Texture Info", menuName = "XLGM Alpha Mask Texture Info")]
	[Serializable]
	public class XLGMAlphaMaskTextureInfo : ScriptableObject
	{
		public AlphaMaskLocation type;
		public Texture2D texture;
	}
}
