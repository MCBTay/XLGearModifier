using HarmonyLib;
using SkaterXL.Data;
using SkaterXL.Gear;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using XLGearModifier.CustomGear;
using XLGearModifier.Unity;
using XLGearModifier.Unity.EditAsset;
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

        public GameObject EditAssetUserInterfacePrefab;
        public GameObject editAssetUI;
        public XLGMAssetEdit editAsset;

		#region What's Equipped
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
				var spriteIndex = GearModifierUISpriteSheet.spriteCharacterTable[GetSpriteIndex(template)].glyphIndex;
				var sprite = GearModifierUISpriteSheetSprites.FirstOrDefault(x => x.name == "GearModifierUISpriteSheet_" + spriteIndex);

				var mesh = GearManager.Instance.CustomGear.FirstOrDefault(x => x.GearInfo != null && x.GearInfo.type == clothingGear.type) as ClothingGear;

				var creatorName = mesh?.ClothingMetadata?.CreatorName ?? "N/A";

				whatsEquipped.AddToList("Prefix: " + clothingGear.type, clothingGear.name, "Creator: " + creatorName, sprite);
			}
		}

		private int GetSpriteIndex(CharacterGearTemplate template)
		{
			int spriteIndex = 0;

			switch (template.category)
			{
				case ClothingGearCategory.Shoes:
					
					spriteIndex = GearModifierUISpriteSheet.GetSpriteIndexFromName("Shoes");
					break;
				case ClothingGearCategory.Hoodie:
				case ClothingGearCategory.LongSleeve:
				case ClothingGearCategory.Shirt:
				case ClothingGearCategory.TankTop:
					spriteIndex = GearModifierUISpriteSheet.GetSpriteIndexFromName("Top");
					break;
				case ClothingGearCategory.Pants:
				case ClothingGearCategory.PantsRolledUp:
				case ClothingGearCategory.Shorts:
					spriteIndex = GearModifierUISpriteSheet.GetSpriteIndexFromName("Bottom");
					break;
				case ClothingGearCategory.Socks:
					spriteIndex = GearModifierUISpriteSheet.GetSpriteIndexFromName("Socks");
					break;
				case ClothingGearCategory.Hat:
					spriteIndex = GearModifierUISpriteSheet.GetSpriteIndexFromName("Headwear");
					break;
				default:
					spriteIndex = GearModifierUISpriteSheet.GetSpriteIndexFromName("Other");
					break;
			}

			return spriteIndex;
		}
		#endregion

		#region Asset Edit
		public void CreateAssetEditUserInterface()
        {
            if (editAssetUI != null && editAssetUI.activeInHierarchy) return;

            if (editAssetUI == null)
            {
                editAssetUI = Object.Instantiate(EditAssetUserInterfacePrefab);
                Object.DontDestroyOnLoad(editAssetUI);
            }

            editAssetUI.SetActive(true);
            editAsset = editAssetUI.GetComponentInChildren<XLGMAssetEdit>(true);
        }

        public void DestroyAssetEditUserInterface()
        {
            if (editAssetUI == null) return;

            editAssetUI.SetActive(false);
            Object.DestroyImmediate(editAssetUI);
            editAssetUI = null;
        }

        public void RefreshAssetEdit(CharacterCustomizer characterCustomizer, ClothingGear clothingGear)
        {
            editAsset.ClearList();

            if (clothingGear.BlendShapeController == null) return;
            if (clothingGear.BlendShapeController.SkinnedMesh == null) return;
			if (clothingGear.BlendShapeController.SkinnedMeshRenderer == null) return;
            if (clothingGear.BlendShapeController.BlendShapes == null) return;
            if (!clothingGear.BlendShapeController.BlendShapes.Any()) return;

            foreach (var blendShape in clothingGear.BlendShapeController.BlendShapes)
            {
                editAsset.AddSlider(blendShape.name, blendShape.weight, x => SliderValueChanged(characterCustomizer, clothingGear, blendShape, x));
            }
        }

        private void SliderValueChanged(CharacterCustomizer characterCustomizer, ClothingGear clothingGear, XLGMBlendShapeData blendShape, float value)
        {
            var traverse = Traverse.Create(characterCustomizer);
			var equippedGear = traverse.Field("equippedGear").GetValue<List<ClothingGearObjet>>();

            var clothingGearObject = equippedGear.FirstOrDefault(x => x.gearInfo.type == clothingGear.GearInfo.type);

            var gear = clothingGearObject?.gameObject;
            if (gear == null) return;

            var renderers = gear.GetComponentsInChildren<SkinnedMeshRenderer>();

            foreach (var renderer in renderers)
            {
                renderer.SetBlendShapeWeight(blendShape.index, value);

                var gearInfo = clothingGearObject.gearInfo as XLGMCustomCharacterGearInfo;
                if (gearInfo == null) continue;

                var found = gearInfo.blendShapes.FirstOrDefault(x => x.index == blendShape.index);
                if (found == null) continue;

                found.weight = value;
            }
		}
		#endregion
	}
}
