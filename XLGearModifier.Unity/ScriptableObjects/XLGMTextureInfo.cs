using System;
using UnityEngine;

namespace XLGearModifier.Unity.ScriptableObjects
{
	[CreateAssetMenu(fileName = "New XLGM Texture Info", menuName = "XLGM Texture Info")]
	[Serializable]
	public class XLGMTextureInfo : ScriptableObject
	{
		public string textureName;
		[Tooltip("This is the texture the shader will use.  If left blank, it will fall back to the default albedo.")]
		public Texture2D textureColor;
		[Tooltip("This is the normal map the shader will use.  If left blank, it will fall back to the default normal map.")]
		public Texture2D textureNormalMap;
		[Tooltip("This is the mask map the shader will use.  If left blank, it will fall back to the default mask map.")]
		public Texture2D textureMaskPBR;
	}
}
