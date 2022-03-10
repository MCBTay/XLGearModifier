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
    public abstract class CustomGear : CustomInfo
	{
		public XLGMMetadata Metadata;

        public GameObject Prefab;
		[JsonIgnore]
		public GearInfo GearInfo;

		public CustomGear(XLGMMetadata metadata, GameObject prefab)
		{
			Metadata = metadata;
			Prefab = prefab;
		}

		public CustomGear(CustomGear gearToClone, GearInfoSingleMaterial gearInfo) : this(gearToClone.Metadata, gearToClone.Prefab)
		{
			GearInfo = gearInfo;
		}

        public abstract void Instantiate();

        #region Custom Skater methods
        private void CreateMaterialWithTexturesOnProperShader(MaterialController materialController, XLGMSkaterMetadata metadata)
        {
            if (materialController == null) return;

            var renderer = materialController.targets.FirstOrDefault()?.renderer;
			if (renderer == null) return;

            var textures = new Dictionary<string, Texture>();

            var target = materialController.targets.FirstOrDefault();
			if (target == null) return;

            var material = renderer.materials[target.materialIndex];

			textures.Add("albedo", material.GetTexture("_BaseColorMap") ?? AssetBundleHelper.Instance.emptyAlbedo);
			textures.Add("normal", material.GetTexture("_NormalMap") ?? AssetBundleHelper.Instance.emptyNormalMap);
			textures.Add("maskpbr", material.GetTexture("_MaskMap") ?? AssetBundleHelper.Instance.emptyMaskPBR);

			var newMaterial = materialController.GenerateMaterialWithChanges(textures);
            //material.shader = Shader.Find("MasterShaderCloth_v1");
            materialController.SetMaterial(newMaterial);
        }

        private void AddBodyGearTemplate()
        {
            if (GearDatabase.Instance.CharBodyTemplateForID.ContainsKey(Metadata.Prefix.ToLower())) return;

            var newBodyTemplate = new CharacterBodyTemplate
            {
                id = Metadata.Prefix.ToLower(),
                path = $"XLGearModifier/{Prefab.name}",
                leftEyeLocalPosition = new Vector3(1, 0, 0),
                rightEyeLocalPosition = new Vector3(-1, 0, 0)
            };
            GearDatabase.Instance.CharBodyTemplateForID.Add(Metadata.Prefix.ToLower(), newBodyTemplate);
        }
        #endregion

        #region Custom BoardGear methods
        protected async Task<IEnumerable<MaterialController>> GetDefaultGearMaterialControllers()
        {
            return (await GetBaseObject())?.GetComponentsInChildren<MaterialController>();
        }

        
        #endregion

        protected TextureChange[] GetDefaultTextureChanges()
		{
            return GetBaseGearInfo()?.textureChanges;
        }

        public abstract Task<GameObject> GetBaseObject();

        protected GearInfoSingleMaterial GetBaseGearInfo()
		{
			var gear = Traverse.Create(GearDatabase.Instance).Field("gearListSource").GetValue<GearInfo[][][]>();

			var skaterIndex = GetSkaterIndex();
			GearInfo[] officialGear = gear[skaterIndex][GetCategoryIndex(skaterIndex)];
			return officialGear.Where(x => x.type.Equals(Metadata.GetBaseType(), StringComparison.InvariantCultureIgnoreCase)).Cast<GearInfoSingleMaterial>().FirstOrDefault();
		}

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

        public abstract int GetCategoryIndex(int skaterIndex);
    }
}
