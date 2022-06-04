using SkaterXL.Gear;
using System;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using XLGearModifier.Unity;
using XLMenuMod;
using XLMenuMod.Utilities.Gear;

namespace XLGearModifier.CustomGear
{
    public class BoardGear : CustomGearBase
    {
        public XLGMBoardGearMetadata BoardMetadata => Metadata as XLGMBoardGearMetadata;

        public BoardGear(XLGMBoardGearMetadata metadata, GameObject prefab) 
            : base(metadata, prefab)
        {
        }

        public BoardGear(CustomGearBase customGearBase, CustomBoardGearInfo gearInfo)
            : base(customGearBase, gearInfo)
        {

        }

        //TODO: definitely broken, can come back to this
        public override void Instantiate()
        {
            var name = string.IsNullOrEmpty(BoardMetadata.DisplayName) ? Prefab.name : BoardMetadata.DisplayName;

            GearInfo = new CustomBoardGearInfo(name, BoardMetadata.BoardGearTemplate.id, false, GetDefaultTextureChanges(), new string[0]);

            if (BoardMetadata.Category == Unity.BoardGearCategory.Deck)
            {
                //await AddDeckMaterialControllers();
            }
            else
            {
                //SetTexturesAndShader(boardMetadata);
            }

            AddPrefixToGearFilters();
            AddBoardGearTemplate();
        }

        private async Task AddDeckMaterialControllers()
        {
            var materialControllers = await GetDefaultGearMaterialControllers();

            foreach (var materialController in materialControllers)
            {
                //CreateNewMaterialController(Prefab, materialController);
            }
        }

        // this needs updating for sure, hardcoded to male skater now
        private void AddPrefixToGearFilters()
        {
            var skaterIndex = (int)SkaterBase.Male;

            var typeFilter = GearDatabase.Instance.skaters[skaterIndex].GearFilters[GetCategoryIndex(skaterIndex)];

            if (!typeFilter.includedTypes.Contains(BoardMetadata.BoardGearTemplate.id))
            {
                typeFilter.includedTypes.Add(BoardMetadata.BoardGearTemplate.id);
            }
        }

        private void AddBoardGearTemplate()
        {
            if (BoardMetadata.Category != Unity.BoardGearCategory.Deck) return;
            if (GearDatabase.Instance.DeckTemplateForID.ContainsKey(BoardMetadata.BoardGearTemplate.id.ToLower())) return;

            var newGearTemplate = new DeckTemplate
            {
                id = string.Empty, 
                path = $"XLGearModifier/{Prefab.name}"
            };

            if (BoardMetadata.BaseOnDefaultGear)
            {
                var baseGearTemplate = GearDatabase.Instance.DeckTemplateForID.FirstOrDefault(x => x.Key == Metadata.GetBaseType().ToLower()).Value;
                if (baseGearTemplate != null)
                {
                    newGearTemplate.id = baseGearTemplate.id;
                }
            }

            GearDatabase.Instance.DeckTemplateForID.Add(BoardMetadata.BoardGearTemplate.id.ToLower(), newGearTemplate);
        }

        public override int GetCategoryIndex(int skaterIndex)
        {
            if (BoardMetadata == null) return 0;

            var categoryIndex = (int)BoardMetadata.Category;
            var category = BoardMetadata.Category.ToString();

            switch (skaterIndex)
            {
                case (int)XLMenuMod.Skater.EvanSmith:
                    Enum.TryParse(category, out EvanSmithGearCategory esCategory);
                    categoryIndex = (int)esCategory;
                    break;
                case (int)XLMenuMod.Skater.TomAsta:
                    Enum.TryParse(category, out TomAstaGearCategory taCategory);
                    categoryIndex = (int)taCategory;
                    break;
                case (int)XLMenuMod.Skater.BrandonWestgate:
                    Enum.TryParse(category, out BrandonWestgateGearCategory bwCategory);
                    categoryIndex = (int)bwCategory;
                    break;
                case (int)XLMenuMod.Skater.TiagoLemos:
                    Enum.TryParse(category, out TiagoLemosGearCategory tlCategory);
                    categoryIndex = (int)tlCategory;
                    break;
            }

            return categoryIndex;
        }

        public override async Task<GameObject> GetBaseObject()
        {
            var info = GetBaseGearInfo();
            if (info == null) return null;

            var path = GearDatabase.Instance.DeckTemplateForID[info.type].path;

            AsyncOperationHandle<GameObject> loadOp = Addressables.LoadAssetAsync<GameObject>(path);
            await new WaitUntil(() => loadOp.IsDone);
            GameObject result = loadOp.Result;
            if (result == null)
            {
                Debug.Log("XLGM: No prefab found for template at path '" + path + "'");
            }
            return result;
        }
    }
}
