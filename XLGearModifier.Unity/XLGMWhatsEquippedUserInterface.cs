using System;
using TMPro;
using UnityEngine;
using UnityEngine.Events;

namespace XLGearModifier.Unity
{
    [Serializable]
	public class XLGMWhatsEquippedUserInterface : MonoBehaviour
	{
		public GameObject listContent;
		public GameObject listItemPrefab;
        
        public TMP_Text VersionLabel;

		public void ClearList()
		{
			for (var i = listContent.transform.childCount - 1; i >= 0; i--)
			{
				var objectA = listContent.transform.GetChild(i);
				objectA.transform.SetParent(null, false);

                Destroy(objectA.gameObject);
			}
        }

		public GameObject AddToList(
            string meshName, 
            string textureName, 
            string creatorName,
			string aliasName,
            Sprite sprite, 
            UnityAction objectClicked = null, 
            UnityAction objectSelected = null)
		{
			var listItem = Instantiate(listItemPrefab, listContent.transform);

			var whatsEquipped = listItem.GetComponent<XLGMWhatsEquippedLineItem>();
			if (whatsEquipped != null)
			{
				whatsEquipped.image.sprite = sprite;
				whatsEquipped.meshName.SetText(meshName);
				whatsEquipped.textureName.SetText(textureName);

                whatsEquipped.creatorLine.SetActive(!string.IsNullOrEmpty(creatorName));
				whatsEquipped.creatorName.SetText(creatorName ?? string.Empty);

                whatsEquipped.aliasLine.SetActive(!string.IsNullOrEmpty(aliasName));
				whatsEquipped.aliasName.SetText(aliasName ?? string.Empty);
            }

			listItem.SetActive(true);

			return listItem;
		}
    }
}
