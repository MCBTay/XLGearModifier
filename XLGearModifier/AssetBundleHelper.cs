using System.Collections.Generic;
using System.Reflection;
using HarmonyLib;
using UnityEngine;

namespace XLGearModifier
{
	public static class AssetBundleHelper
	{
		public static List<GameObject> Hair = new List<GameObject>();

		public static List<CharacterGearInfo> HairGearInfo = new List<CharacterGearInfo>();

		public static void LoadGearBundle()
		{
			AssetBundle bundle = AssetBundle.LoadFromMemory(ExtractResource("XLGearModifier.Assets.customgear"));

			var prefab = bundle.LoadAsset<GameObject>("Assets/Meshes/Hair/Long-Hair-Beanie--Hair.fbx");
			var gearPrefabController = prefab.AddComponent<GearPrefabController>();
			Traverse.Create(gearPrefabController).Field("_skinnedMeshRenderer").SetValue(prefab.GetComponentInChildren<SkinnedMeshRenderer>());
			gearPrefabController.PreparePrefab();
			Hair.Add(prefab);  //based on conterpart

			HairGearInfo.Add(new CharacterGearInfo(prefab.name, HairStyles.MHairCounterpart.ToString(), true, new TextureChange[0], new string[0] ));
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
