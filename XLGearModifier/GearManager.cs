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

		public List<CustomGear> CustomGear;

		public GearManager()
		{
			CustomGear = new List<CustomGear>();
		}

		public void LoadAssets(AssetBundle bundle)
		{
			var assets = bundle.LoadAllAssets<GameObject>();

			if (assets != null && assets.Any())
			{
				foreach (var asset in assets)
				{
					AddPrefab(asset);
				}
			}
		}

		public void AddPrefab(GameObject gameObject)
		{
			var metadata = gameObject.GetComponent<XLGearModifierMetadata>();
			if (metadata == null) return;

			CustomGear.Add(new CustomGear(metadata, gameObject));
		}
	}
}
