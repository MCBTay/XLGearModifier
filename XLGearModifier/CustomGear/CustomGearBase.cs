using HarmonyLib;
using Newtonsoft.Json;
using SkaterXL.Data;
using SkaterXL.Gear;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using XLGearModifier.Unity;
using XLMenuMod.Utilities;

namespace XLGearModifier.CustomGear
{
    public abstract class CustomGearBase : CustomInfo
	{
		public XLGMMetadata Metadata;

        public GameObject Prefab;

		[JsonIgnore]
		public GearInfo GearInfo;

		protected CustomGearBase(XLGMMetadata metadata, GameObject prefab)
		{
			Metadata = metadata;
			Prefab = prefab;
		}

		protected CustomGearBase(CustomGearBase gearToClone, GearInfoSingleMaterial gearInfo) : this(gearToClone.Metadata, gearToClone.Prefab)
		{
			GearInfo = gearInfo;
		}

        public abstract void Instantiate();
        public abstract Task<GameObject> GetBaseObject();
        public abstract int GetCategoryIndex(int skaterIndex);

        protected async Task<IEnumerable<MaterialController>> GetDefaultGearMaterialControllers()
        {
            return (await GetBaseObject())?.GetComponentsInChildren<MaterialController>();
        }

        protected TextureChange[] GetDefaultTextureChanges()
		{
            return GetBaseGearInfo()?.textureChanges;
        }

        protected GearInfoSingleMaterial GetBaseGearInfo()
		{
			var gear = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();

			var skaterIndex = GetSkaterIndexForDefaultGear();
			GearInfo[] officialGear = gear[skaterIndex][GetCategoryIndex(skaterIndex)];
			return officialGear.Where(x => x.type.Equals(Metadata.GetBaseType(), StringComparison.InvariantCultureIgnoreCase)).Cast<GearInfoSingleMaterial>().FirstOrDefault();
		}

        /// <summary>
        /// Returns the skater index of a default gear item.  Only to be used for items that are based on default gear.
        /// </summary>
        /// <returns>The index of the skater that the gear belongs to.</returns>
        public int GetSkaterIndexForDefaultGear()
        {
            var skaterIndex = (int)XLMenuMod.Skater.MaleStandard;

            var type = Metadata.GetBaseType();

            if (string.IsNullOrEmpty(type)) return (int)XLMenuMod.Skater.MaleStandard;

            if (type.StartsWith("m", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)XLMenuMod.Skater.MaleStandard;
            }
            else if (type.StartsWith("f", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)XLMenuMod.Skater.FemaleStandard;
            }
            else if (type.StartsWith("es", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)XLMenuMod.Skater.EvanSmith;
            }
            else if (type.StartsWith("ta", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)XLMenuMod.Skater.TomAsta;
            }
            else if (type.StartsWith("bw", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)XLMenuMod.Skater.BrandonWestgate;
            }
            else if (type.StartsWith("tl", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)XLMenuMod.Skater.TiagoLemos;
            }

            return skaterIndex;
        }
    }
}
