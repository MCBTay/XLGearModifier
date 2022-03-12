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
using XLMenuMod;
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

		protected CustomGearBase(CustomGearBase gearBaseToClone, GearInfoSingleMaterial gearInfo) : this(gearBaseToClone.Metadata, gearBaseToClone.Prefab)
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

			var skaterIndex = GetSkaterIndex();
			GearInfo[] officialGear = gear[skaterIndex][GetCategoryIndex(skaterIndex)];
			return officialGear.Where(x => x.type.Equals(Metadata.GetBaseType(), StringComparison.InvariantCultureIgnoreCase)).Cast<GearInfoSingleMaterial>().FirstOrDefault();
		}

        /// <summary>
        /// Returns the object's Prefix.
        /// </summary>
        public virtual string GetTypeName()
        {
            return Metadata.Prefix;
        }
        
        public int GetSkaterIndex()
        {
            var skaterIndex = (int)Skater.MaleStandard;

            var type = GetTypeName();

            if (string.IsNullOrEmpty(type)) return (int)Skater.MaleStandard;

            if (type.StartsWith("m", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.MaleStandard;
            }
            else if (type.StartsWith("f", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.FemaleStandard;
            }
            else if (type.StartsWith("es", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.EvanSmith;
            }
            else if (type.StartsWith("ta", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.TomAsta;
            }
            else if (type.StartsWith("bw", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.BrandonWestgate;
            }
            else if (type.StartsWith("tl", StringComparison.InvariantCultureIgnoreCase))
            {
                skaterIndex = (int)Skater.TiagoLemos;
            }

            return skaterIndex;
        }
    }
}
