using SkaterXL.Data;
using SkaterXL.Gear;
using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using XLGearModifier.CustomGear;
using XLGearModifier.Unity;
using ClothingGearCategory = SkaterXL.Gear.ClothingGearCategory;
using Object = UnityEngine.Object;

namespace XLGearModifier
{
    public class UserInterfaceHelper
	{
		private static UserInterfaceHelper _instance;
		public static UserInterfaceHelper Instance => _instance ?? (_instance = new UserInterfaceHelper());

        public TMP_SpriteAsset GearModifierUISpriteSheet;
        public List<Sprite> GearModifierUISpriteSheetSprites;

		public GameObject WhatsEquippedUserInterfacePrefab;

		public GameObject whatsEquippedUI;
		public XLGMWhatsEquippedUserInterface whatsEquipped;

		public void CreateWhatsEquippedUserInterface()
		{
			if (whatsEquippedUI != null && whatsEquippedUI.activeInHierarchy) return;

			if (whatsEquippedUI == null)
			{
				whatsEquippedUI = Object.Instantiate(WhatsEquippedUserInterfacePrefab);
				Object.DontDestroyOnLoad(whatsEquippedUI);
			}

			whatsEquippedUI.SetActive(true);
			whatsEquipped = whatsEquippedUI.GetComponentInChildren<XLGMWhatsEquippedUserInterface>(true);
		}

		public void DestroyWhatsEquippedUserInterface()
		{
			if (whatsEquippedUI == null) return;

			whatsEquippedUI.SetActive(false);
			Object.DestroyImmediate(whatsEquippedUI);
			whatsEquippedUI = null;
		}

		public void RefreshWhatsEquippedList(CustomizedPlayerDataV2[] ___skaterCustomizations, IndexPath index)
		{
			whatsEquipped.ClearList();

			var customizations = ___skaterCustomizations[index[0]];
			foreach (var clothingGear in customizations.clothingGear)
            {
                var template = GearDatabase.Instance.CharGearTemplateForID[clothingGear.type];
				
				var spriteName = GetSpriteName(template);
                var sprite = GearModifierUISpriteSheetSprites.FirstOrDefault(x => x.name == spriteName);

                ClothingGear mesh = GearManager.Instance.CustomGear.ContainsKey(clothingGear.type) ?
                    GearManager.Instance.CustomGear[clothingGear.type] as ClothingGear :
                    null;

                var creatorName = mesh?.ClothingMetadata?.CreatorName ?? "N/A";

				whatsEquipped.AddToList("Prefix: " + clothingGear.type, clothingGear.name, "Creator: " + creatorName, sprite);
			}
		}

		private string GetSpriteName(CharacterGearTemplate template)
        {
			if (GearManager.Instance.CustomGear.ContainsKey(template.id) &&
                GearManager.Instance.CustomGear[template.id] is ClothingGear customGear)
            {
                return customGear.Metadata.GetSprite();
            }

            if (template.id == "eyes")
            {
                return "Eyes";
			}

			switch (template.category)
			{
				case ClothingGearCategory.Shoes:
                    return "Shoes";
                case ClothingGearCategory.Hoodie:
				case ClothingGearCategory.LongSleeve:
				case ClothingGearCategory.Shirt:
				case ClothingGearCategory.TankTop:
					return "Top";
                case ClothingGearCategory.Pants:
				case ClothingGearCategory.PantsRolledUp:
				case ClothingGearCategory.Shorts:
					return "Bottom";
                case ClothingGearCategory.Socks:
					return "Socks";
                case ClothingGearCategory.Hat:
                    var hairStyles = Enum.GetNames(typeof(HairStyles)).Select(x => x.ToLower());
                    return hairStyles.Contains(template.id.ToLower()) ? "Hair" : "Headwear";
                default:
					return "Other";
            }
        }
	}
}
