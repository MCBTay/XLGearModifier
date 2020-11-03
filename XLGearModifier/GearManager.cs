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

			CustomGear[metadata.Category].Add(new CustomGear(metadata.Category, GetBaseType(metadata), gameObject));
		}

		private string GetBaseType(XLGearModifierMetadata metadata)
		{
			switch (metadata.Category)
			{
				case GearCategory.SkinTone: break;
				case GearCategory.Hair:     return metadata.BaseHairStyle.ToString();
				case GearCategory.Headwear: return metadata.BaseHeadwearType.ToString();
				case GearCategory.Top:      return metadata.BaseTopType.ToString();
				case GearCategory.Bottom:   return metadata.BaseBottomType.ToString();
				case GearCategory.Shoes:    return metadata.BaseShoeType.ToString();
				case GearCategory.Deck:     break;
				case GearCategory.Griptape: break;
				case GearCategory.Trucks:   break;
				case GearCategory.Wheels:   break;
			}

			return string.Empty;
		}
	}
}
