using System;
using System.Collections.Generic;
using HarmonyLib;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using XLMenuMod.Utilities.Gear;

namespace XLGearModifier.Patches
{
	public class GearObjectPatch
	{
		[HarmonyPatch(typeof(GearObject), "LoadPrefab")]
		public static class LoadPrefabPatch
		{
			static bool Prefix(GearObject __instance, string path, ref Task<GameObject> __result)
			{
				if (!path.StartsWith("XLGearModifier")) return true;

				var customGear = GearManager.Instance.CustomGear.FirstOrDefault(x => x.GearInfo != null && x.GearInfo.type == __instance.gearInfo.type);
				if (customGear == null) return true;

				__result = Task.FromResult(customGear.Prefab);
				return false;
			}
		}

		[HarmonyPatch(typeof(GearObject), "ChangeTexturesOn")]
		public static class ChangeTexturesOnPatch
		{
			static bool Prefix(GearObject __instance, GameObject go, ref Dictionary<string, Texture> textures, ref string materialID)
			{
				materialID = GearObject.AdaptMaterialID(materialID);
				foreach (MaterialController materialController in GetMaterialControllers(go, materialID))
				{
					if (__instance.gearInfo is CustomCharacterGearInfo custom)
					{
						if (custom.Info.ParentObject is CustomGear)
						{
							if (textures.ContainsKey("_texture2D_normal"))
							{
								textures.Add("_NormalMap", textures["_texture2D_normal"]);
								textures.Remove("_texture2D_normal");
							}

							if (textures.ContainsKey("_texture2D_maskPBR"))
							{
								textures.Add("_MaskMap", textures["_texture2D_maskPBR"]);
								textures.Remove("_texture2D_maskPBR");
							}
						}
					}

					Material materialWithChanges = materialController.GenerateMaterialWithChanges(textures);
					Traverse.Create(__instance).Field("instantiatedMaterials").GetValue<List<Material>>().Add(materialWithChanges);

					if (materialWithChanges.shader.name == "HDRP/Lit")
					{
						if (!materialWithChanges.shaderKeywords.Contains("_NORMALMAP"))
						{
							materialWithChanges.EnableKeyword("_NORMALMAP");
						}

						if (!materialWithChanges.shaderKeywords.Contains("_NORMALMAP_TANGENT_SPACE"))
						{
							materialWithChanges.EnableKeyword("_NORMALMAP_TANGENT_SPACE");
						}

						if (!materialWithChanges.shaderKeywords.Contains("_DOUBLESIDED_ON"))
						{
							materialWithChanges.EnableKeyword("_DOUBLESIDED_ON");
						}

						if (!materialWithChanges.shaderKeywords.Contains("_MASKMAP"))
						{
							materialWithChanges.EnableKeyword("_MASKMAP");
						}

						materialWithChanges.SetFloat("_Smoothness", 0.5f);
						materialWithChanges.SetFloat("_SmoothnessRemapMax", 1f);
						materialWithChanges.SetFloat("_SmoothnessRemapMin", 0f);
					}

					materialController.SetMaterial(materialWithChanges);
				}

				return false;
			}

			private static IEnumerable<MaterialController> GetMaterialControllers(
				GameObject gearGO,
				string materialID = null)
			{
				if (gearGO == null) return new MaterialController[0];
				MaterialController[] componentsInChildren = gearGO.GetComponentsInChildren<MaterialController>();
				return materialID == null ? componentsInChildren : componentsInChildren.Where(mc => mc.materialID == materialID);
			}
		}
	}
}
