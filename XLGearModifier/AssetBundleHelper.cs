using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

namespace XLGearModifier
{
	public static class AssetBundleHelper
	{
		public static void LoadGearBundle()
		{
			AssetBundle bundle = AssetBundle.LoadFromMemory(ExtractResource("XLGearModifier.Assets.customgear"));
			GearManager.Instance.LoadAssets(bundle);
		}

		private static byte[] ExtractResource(string filename)
		{
			Assembly a = Assembly.GetExecutingAssembly();
			using (var resFilestream = a.GetManifestResourceStream(filename))
			{
				if (resFilestream == null) return null;
				byte[] ba = new byte[resFilestream.Length];
				resFilestream.Read(ba, 0, ba.Length);
				return ba;
			}
		}
	}
}
