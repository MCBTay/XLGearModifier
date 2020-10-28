using System;
using System.Collections.Generic;
using UnityEngine;

namespace XLGearModifier
{
	public class GearManager
	{
		private static GearManager __instance;
		public static GearManager Instance => __instance ?? (__instance = new GearManager());

		public Dictionary<GearCategory, List<CustomGear>> CustomGear;

		public GearManager()
		{
			CustomGear = new Dictionary<GearCategory, List<CustomGear>>();

			foreach (GearCategory category in Enum.GetValues(typeof(GearCategory)))
			{
				CustomGear.Add(category, new List<CustomGear>());
			}
		}

		public void LoadAssets(AssetBundle bundle)
		{
			LoadAsset(bundle, "Assets/Meshes/Hair/Long-Hair-Beanie--Hair.fbx", GearCategory.Hair, HairStyles.MHairCounterpart.ToString());
		}

		private void LoadAsset(AssetBundle bundle, string path, GearCategory category, string type)
		{
			var prefab = bundle.LoadAsset<GameObject>(path);
			CustomGear[category].Add(new CustomGear(category, type, prefab));
		}
	}
}
