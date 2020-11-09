using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using XLGearModifier.Unity;

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
			var assets = bundle.LoadAllAssets<GameObject>();

			if (assets != null && assets.Any())
			{
				foreach (var asset in assets)
				{
					InitializeAsset(asset);
				}
			}
		}

		private void InitializeAsset(GameObject gameObject)
		{
			var metadata = gameObject.GetComponent<XLGearModifierMetadata>();
			if (metadata == null) return;

			CustomGear[metadata.Category].Add(new CustomGear(metadata, gameObject));
		}
	}
}
