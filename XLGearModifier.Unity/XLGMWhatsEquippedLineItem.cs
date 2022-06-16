using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

namespace XLGearModifier.Unity
{
    public class UnityEventString : UnityEvent<string>
    {
    }

    public class XLGMWhatsEquippedLineItem : MonoBehaviour
	{
		public Image image;
		public TMP_Text meshName;
        public TMP_Text aliasName;
        public TMP_Text textureName;
		public TMP_Text creatorName;

        public GameObject aliasLine;
        public GameObject creatorLine;

        [HideInInspector] 
        public UnityEventString equippedLineClicked;

        public XLGMWhatsEquippedLineItem()
        {
            equippedLineClicked = new UnityEventString();
        }

		public void OnClick()
        {
			equippedLineClicked.Invoke(meshName.text);
        }
	}
}
