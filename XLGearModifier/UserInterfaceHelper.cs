using System.Linq;
using UnityEngine;
using XLGearModifier.Unity;
using Object = UnityEngine.Object;

namespace XLGearModifier
{
	public class UserInterfaceHelper
	{
		private static UserInterfaceHelper _instance;
		public static UserInterfaceHelper Instance => _instance ?? (_instance = new UserInterfaceHelper());

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
				var spriteIndex = AssetBundleHelper.GearModifierUISpriteSheet.spriteCharacterTable[GetSpriteIndex(template)].glyphIndex;
				var sprite = AssetBundleHelper.GearModifierUISpriteSheetSprites.FirstOrDefault(x => x.name == "GearModifierUISpriteSheet_" + spriteIndex);

				whatsEquipped.AddToList(clothingGear.type, clothingGear.name, sprite);
			}
		}

		private int GetSpriteIndex(CharacterGearTemplate template)
		{
			int spriteIndex = 0;

			switch (template.category)
			{
				case ClothingGearCategory.Shoes:
					
					spriteIndex = AssetBundleHelper.GearModifierUISpriteSheet.GetSpriteIndexFromName("Shoes");
					break;
				case ClothingGearCategory.Hoodie:
				case ClothingGearCategory.LongSleeve:
				case ClothingGearCategory.Shirt:
				case ClothingGearCategory.TankTop:
					spriteIndex = AssetBundleHelper.GearModifierUISpriteSheet.GetSpriteIndexFromName("Top");
					break;
				case ClothingGearCategory.Pants:
				case ClothingGearCategory.PantsRolledUp:
				case ClothingGearCategory.Shorts:
					spriteIndex = AssetBundleHelper.GearModifierUISpriteSheet.GetSpriteIndexFromName("Bottom");
					break;
				case ClothingGearCategory.Socks:
					spriteIndex = AssetBundleHelper.GearModifierUISpriteSheet.GetSpriteIndexFromName("Socks");
					break;
				case ClothingGearCategory.Hat:
					spriteIndex = AssetBundleHelper.GearModifierUISpriteSheet.GetSpriteIndexFromName("Headwear");
					break;
				default:
					spriteIndex = AssetBundleHelper.GearModifierUISpriteSheet.GetSpriteIndexFromName("Other");
					break;
			}

			return spriteIndex;
		}
	}
}
