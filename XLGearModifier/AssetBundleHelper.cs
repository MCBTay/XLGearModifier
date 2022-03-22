using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using TMPro;
using UnityEngine;
using XLGearModifier.CustomGear;
using XLGearModifier.Texturing;
using XLGearModifier.Unity;
using Object = UnityEngine.Object;

namespace XLGearModifier
{
    public class AssetBundleHelper
	{
		private static AssetBundleHelper __instance;
		public static AssetBundleHelper Instance => __instance ?? (__instance = new AssetBundleHelper());

		public string AssetPacksPath;

        public async Task LoadBundles()
        {
            await BaseGameTextureManager.Instance.LoadGameMaterials();

            // We're solely making a call here to ensure that the unity assembly is loaded up prior to loading assets.  else we'll get a bunch of errors about things missing.
            var test = GearModifierTab.CustomMeshes;

            await PlayerController.Instance.StartCoroutine(LoadBuiltInBundles());
            PlayerController.Instance.StartCoroutine(LoadUserBundles());
        }

        private IEnumerator LoadBuiltInBundles()
        {
            var assembly = Assembly.GetExecutingAssembly();

            var assetBundles = assembly.GetManifestResourceNames();

            foreach (var assetBundle in assetBundles)
            {
                yield return LoadBuiltInBundle(assembly, assetBundle);
            }

            PlayerController.Instance.characterCustomizer.LoadLastPlayer();
            GearDatabase.Instance.FetchCustomGear();
        }

		private IEnumerator LoadBuiltInBundle(Assembly assembly, string bundleName)
		{
            Debug.Log("XLGearModifier: Loading " + bundleName);

            var bytes = ExtractResource(assembly, bundleName);

            var bundleLoadRequest = AssetBundle.LoadFromMemoryAsync(bytes);
            yield return bundleLoadRequest;

            var assetBundle = bundleLoadRequest.assetBundle;
            if (assetBundle == null)
            {
                yield break;
            }

            if (assetBundle.name == "user-interface")
            {
                yield return LoadUserInterface(assetBundle);
                assetBundle.Unload(false);
                yield break;
            }

            if (assetBundle.name == "default-empty-textures")
            {
                yield return LoadEmptyDefaultTextures(assetBundle);
                assetBundle.Unload(false);
                yield break;
            }

            yield return LoadPrefabBundle(assetBundle);

            assetBundle.Unload(false);
        }

        /// <summary>
        /// Loads an embedded resource into a byte array.
        /// </summary>
        /// <param name="assembly">The assembly to load the embedded resource from.</param>
        /// <param name="filename">The filename of the embedded resource to load.</param>
        /// <returns>The requested resource as a byte array.</returns>
        private byte[] ExtractResource(Assembly assembly, string filename)
        {
            using (var resFilestream = assembly.GetManifestResourceStream(filename))
            {
                if (resFilestream == null) return null;
                byte[] ba = new byte[resFilestream.Length];
                resFilestream.Read(ba, 0, ba.Length);
                return ba;
            }
        }

        private IEnumerator LoadUserInterface(AssetBundle bundle)
        {
            yield return LoadAsset<TMP_SpriteAsset>(bundle, "GearModifierUISpriteSheet", value => UserInterfaceHelper.Instance.GearModifierUISpriteSheet = value);
            yield return LoadAssets<Sprite>(bundle, "", value => UserInterfaceHelper.Instance.GearModifierUISpriteSheetSprites = value.ToList());

            var assets = new List<GameObject>();
            yield return LoadAssets<GameObject>(bundle, string.Empty, value => assets = value.ToList());

            foreach (var asset in assets)
            {
                var whatsEquippedPrefab = asset.GetComponent<XLGMWhatsEquippedUserInterface>();
                if (whatsEquippedPrefab == null) continue;

                UserInterfaceHelper.Instance.WhatsEquippedUserInterfacePrefab = asset;
                yield break;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="bundle"></param>
        private IEnumerator LoadEmptyDefaultTextures(AssetBundle bundle)
        {
            yield return LoadAsset<Texture2D>(bundle, GearManager.EmptyAlbedoFilename, value => GearManager.Instance.EmptyAlbedo = value);
            yield return LoadAsset<Texture2D>(bundle, GearManager.EmptyNormalFilename, value => GearManager.Instance.EmptyNormalMap = value);
            yield return LoadAsset<Texture2D>(bundle, GearManager.EmptyMaskFilename, value => GearManager.Instance.EmptyMaskPBR = value);
        }

        /// <summary>
        /// Loads a single asset of type T from bundle with name of assetName.  Sets result as destination.
        /// </summary>
        /// <typeparam name="T">The type of asset to load.</typeparam>
        /// <param name="bundle">The bundle to load the asset from.</param>
        /// <param name="assetName">The name of the asset to load.</param>
        /// <param name="callback"></param>
        /// <returns></returns>
        private IEnumerator LoadAsset<T>(AssetBundle bundle, string assetName, Action<T> callback) where T : Object
        {
            var assetLoadRequest = bundle.LoadAssetAsync<T>(assetName);
            yield return assetLoadRequest;

            callback(assetLoadRequest.asset as T);
        }

        /// <summary>
        /// Loads all assets of type T whose names start with startsWithName.  Sets the results to destination.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="bundle"></param>
        /// <param name="startsWithName"></param>
        /// <param name="callback"></param>
        public IEnumerator LoadAssets<T>(AssetBundle bundle, string startsWithName, Action<IList<T>> callback) where T : Object
        {
            var assetLoadRequest = bundle.LoadAllAssetsAsync<T>();
            yield return assetLoadRequest;

            if (!string.IsNullOrEmpty(startsWithName))
            {
                callback(assetLoadRequest.allAssets.Where(x => x.name.StartsWith(startsWithName, StringComparison.InvariantCultureIgnoreCase)).Cast<T>().ToList());
            }
            else
            {
                callback(assetLoadRequest.allAssets.Cast<T>().ToList());
            }
        }

        private IEnumerator LoadPrefabBundleFromDisk(string filepath)
        {
            var abCreateRequest = AssetBundle.LoadFromFileAsync(filepath);
            yield return abCreateRequest;

            var bundle = abCreateRequest.assetBundle;
            if (bundle == null) yield break;

            yield return LoadPrefabBundle(bundle);
        }

        private IEnumerator LoadPrefabBundle(AssetBundle bundle)
        {
            Debug.Log("XLGearModifier: Loading " + bundle.name);

            yield return LoadAssets<GameObject>(bundle, string.Empty, assets =>
            {
                foreach (var asset in assets)
                {
                    try
                    {
                        var metadata = asset.GetComponent<XLGMMetadata>();
                        if (metadata == null) continue;
                        if (string.IsNullOrEmpty(metadata.Prefix)) continue;

                        CustomGearBase customGearBase = null;

                        switch (metadata)
                        {
                            case XLGMClothingGearMetadata clothingMetadata:
                                customGearBase = new ClothingGear(clothingMetadata, asset);
                                break;
                            case XLGMSkaterMetadata skaterMetadata:
                                customGearBase = new Skater(skaterMetadata, asset);
                                break;
                            case XLGMBoardGearMetadata boardMetadata:
                                customGearBase = new BoardGear(boardMetadata, asset);
                                break;
                        }
                        if (customGearBase == null) continue;

                        customGearBase.Instantiate();

                        GearManager.Instance.CustomGear.Add(customGearBase);
                    }
                    catch (Exception ex)
                    {
                        Debug.Log("XLGM: Exception loading " + asset.name + " from " + bundle.name + Environment.NewLine + ex.Message + Environment.NewLine + ex.StackTrace);
                    }
                }

                Debug.Log("XLGearModifier: Loaded " + GearManager.Instance.CustomGear.Count + " assets");
            });
        }
        
        private IEnumerator LoadUserBundles()
		{
			AssetPacksPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Personal), "SkaterXL", "XLGearModifier", "Asset Packs");

			if (!Directory.Exists(AssetPacksPath))
			{
				Directory.CreateDirectory(AssetPacksPath);
			}

			foreach (var assetPack in Directory.GetFiles(AssetPacksPath, "*", SearchOption.AllDirectories))
			{
				if (Path.HasExtension(assetPack)) continue;

				yield return PlayerController.Instance.StartCoroutine(LoadPrefabBundleFromDisk(assetPack));
			}

            PlayerController.Instance.characterCustomizer.LoadLastPlayer();
            GearDatabase.Instance.FetchCustomGear();
        }
    }
}
