using System;
using System.Collections;
using System.IO;
using System.Reflection;
using TMPro;
using UnityEngine;

namespace XLGearModifier
{
	public static class AssetBundleHelper
	{
		public static string AssetPacksPath;

		public static TMP_SpriteAsset GearModifierUISpriteSheet;

		public static void LoadGearBundle()
		{
			AssetBundle bundle = AssetBundle.LoadFromMemory(ExtractResource("XLGearModifier.Assets.customgear"));
			GearManager.Instance.LoadAssets(bundle);

			GearModifierUISpriteSheet = bundle.LoadAsset<TMP_SpriteAsset>("GearModifierUISpriteSheet");
		}

		public static IEnumerator LoadUserBundles()
		{
			AssetPacksPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Personal), "SkaterXL", "XLGearModifier", "Asset Packs");

			if (!Directory.Exists(AssetPacksPath))
			{
				Directory.CreateDirectory(AssetPacksPath);
			}

			foreach (var assetPack in Directory.GetFiles(AssetPacksPath, "*", SearchOption.AllDirectories))
			{
				if (Path.HasExtension(assetPack)) continue;

				yield return PlayerController.Instance.StartCoroutine(LoadBundleAsync(assetPack));
			}
		}

		static IEnumerator LoadBundleAsync(string name, bool isEmbedded = false)
		{
			AssetBundleCreateRequest abCreateRequest;

			if (isEmbedded)
			{
				abCreateRequest = AssetBundle.LoadFromMemoryAsync(ExtractResource(name));
			}
			else
			{
				abCreateRequest = AssetBundle.LoadFromFileAsync(name);
			}

			yield return abCreateRequest;

			var bundle = abCreateRequest?.assetBundle;
			if (bundle == null) yield break;

			GearManager.Instance.LoadAssets(bundle);

			bundle.Unload(false);
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
