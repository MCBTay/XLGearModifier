using System;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using Object = UnityEngine.Object;

namespace XLGearModifier.Unity
{
	[Serializable]
	public class XLGMWhatsEquippedUserInterface : MonoBehaviour
	{
		public GameObject listContent;
		public GameObject listItemPrefab;

		public void ClearList()
		{
			for (var i = listContent.transform.childCount - 1; i >= 0; i--)
			{
				var objectA = listContent.transform.GetChild(i);
				objectA.transform.SetParent(null, false);

				//objectA.gameObject.GetComponent<Button>().onClick.RemoveAllListeners();
				//objectA.gameObject.GetComponent<ObjectSelectionListItem>().onSelect.RemoveAllListeners();

				Destroy(objectA.gameObject);
			}

			//EventSystem.current.SetSelectedGameObject(null);
		}

		public GameObject AddToList(string meshName, string textureName, string creatorName, Sprite sprite, UnityAction objectClicked = null, UnityAction objectSelected = null)
		{
			var listItem = Instantiate(listItemPrefab, listContent.transform);

			var whatsEquipped = listItem.GetComponent<XLGMWhatsEquippedLineItem>();
			if (whatsEquipped != null)
			{
				whatsEquipped.image.sprite = sprite;
				whatsEquipped.meshName.SetText(meshName);
				whatsEquipped.textureName.SetText(textureName);
				whatsEquipped.creatorName.SetText(creatorName);
			}
			//if (objectClicked != null)
			//{
			//	listItem.GetComponent<Button>().onClick.AddListener(objectClicked);
			//}

			//if (objectSelected != null)
			//{
			//	listItem.GetComponent<ObjectSelectionListItem>().onSelect.AddListener(objectSelected);
			//}
			listItem.SetActive(true);

			return listItem;
		}

		public void RemoveFromList(string type)
		{
			foreach (Transform child in listContent.transform)
			{
				//if (child.GetComponent<XLGMWhatsEquippedLineItem>().meshName.text.ToLower() == type.ToLower())
				//{
				//	DestroyImmediate(child);
				//	break;
				//}
			}
		}
	}
}
