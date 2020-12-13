using System;
using UnityEngine;

namespace XLGearModifier.Unity.ScriptableObjects
{
	[CreateAssetMenu(fileName = "New XLGM Texture Set", menuName = "XLGM Texture Set")]
	[Serializable]
	public class XLGMTextureSet : ScriptableObject
	{
		[Tooltip("This is the default texture the shader will use unless the user supplies an override in the Gear folder.  If left blank, an empty albedo will be used.")]
		public Texture2D textureColor;
		[Tooltip("This is the default normal map the shader will use unless the user supplies an override in the Gear folder.  If left blank, an empty normal map will be used.")]
		public Texture2D textureNormalMap;
		[Tooltip("This is the default mask map the shader will use unless the user supplies an override in the Gear folder.  If left blank, an empty mask map will be used.")]
		public Texture2D textureMaskPBR;
	}
}
