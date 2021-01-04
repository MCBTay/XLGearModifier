using System;
using System.Collections.Generic;
using UnityEngine;


namespace XLGearModifier.Unity.ScriptableObjects
{
	[CreateAssetMenu(fileName = "New XLGM Texture Set", menuName = "XLGM Texture Set")]
	[Serializable]
	public class XLGMTextureSet : ScriptableObject
	{
		public XLGMTextureInfo DefaultTexture;

		[Tooltip("Alternative textures for a mesh.")]
		public List<XLGMTextureInfo> AlternativeTextures;
	}
}
