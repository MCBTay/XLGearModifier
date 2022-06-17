using UnityEngine;
using UnityEngine.Events;
using XLGearModifier.Unity.UI.Controls;

namespace XLGearModifier.Unity.EditAsset
{
    public class XLGMAssetEdit : MonoBehaviour
    {
        public GameObject ListContent;
        
        public GameObject SliderPrefab;

        public GameObject AddSlider(
            string name,
            float value,
            UnityAction<float> onValueChanged = null)
        {
            var sliderItem = Instantiate(SliderPrefab, ListContent.transform);

            var slider = sliderItem.GetComponent<SliderControl>();
            if (slider != null)
            {
                slider.Label.SetText(name);
                slider.Slider.value = value;

                if (onValueChanged != null)
                {
                    slider.Slider.onValueChanged.AddListener(onValueChanged);
                }
            }

            sliderItem.SetActive(true);
            return sliderItem;
        }

        public void ClearList()
        {
            for (var i = ListContent.transform.childCount - 1; i >= 0; i--)
            {
                var objectA = ListContent.transform.GetChild(i);
                objectA.transform.SetParent(null, false);
                Destroy(objectA.gameObject);
            }
        }
    }
}
