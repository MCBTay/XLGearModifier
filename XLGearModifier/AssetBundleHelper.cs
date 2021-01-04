using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using TMPro;
using UnityEngine;
using XLGearModifier.Unity;

namespace XLGearModifier
{
	public static class AssetBundleHelper
	{
		public static string AssetPacksPath;

		public static TMP_SpriteAsset GearModifierUISpriteSheet;
		public static List<Sprite> GearModifierUISpriteSheetSprites;
		public static Texture2D emptyAlbedo;
		public static Texture2D emptyMaskPBR;
		public static Texture2D emptyNormalMap;

		public static async Task LoadGearBundle()
		{
			// We're solely making a call here to ensure that the unity assembly is loaded up prior to loading assets.  else we'll get a bunch of errors about things missing.
			var test = GearModifierTab.CustomMeshes;

			AssetBundle bundle = AssetBundle.LoadFromMemory(ExtractResource("XLGearModifier.Assets.customgear"));

			emptyAlbedo = bundle.LoadAsset<Texture2D>("Empty_Albedo.png");
			emptyMaskPBR = bundle.LoadAsset<Texture2D>("Empty_Maskpbr_Map.png");
			emptyNormalMap = bundle.LoadAsset<Texture2D>("Empty_Normal_Map.png");
			GearModifierUISpriteSheet = bundle.LoadAsset<TMP_SpriteAsset>("GearModifierUISpriteSheet");
			GearModifierUISpriteSheetSprites = bundle.LoadAllAssets<Sprite>().Where(x => x.name.StartsWith("GearModifierUISpriteSheet")).ToList();

			Debug.Log("XLGearModifier: Loading " + bundle.name);
			await GearManager.Instance.LoadAssets(bundle);
			Debug.Log("XLGearModifier: Loaded " + GearManager.Instance.CustomGear.Count + " assets");
			
			await PlayerController.Instance.characterCustomizer.LoadLastPlayer();
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
