using HarmonyLib;
using Newtonsoft.Json;
using SkaterXL.Data;
using System;
using System.Linq;
using XLGearModifier.CustomGear;

namespace XLGearModifier.Patches
{
    public class CustomizedPlayerDataV2Patch
	{
		[HarmonyPatch(typeof(CustomizedPlayerDataV2), nameof(CustomizedPlayerDataV2.GetBuiltInSkater))]
		static class GetBuiltInSkaterPatch
		{
			static void Postfix(string skaterName, ref CustomizedPlayerDataV2 __result)
			{
				if (__result != null) return;

                __result = GetRandomBoard(skaterName);
            }

            private static CustomizedPlayerDataV2 GetRandomBoard(string skaterName)
            {
                var customizedPlayerDataV2 = CustomizedPlayerDataV2.Default;

                customizedPlayerDataV2.clothingGear = Array.Empty<CharacterGearInfo>();
                customizedPlayerDataV2.body = GearManager.Instance.CustomGear[skaterName]?.GearInfo as CharacterBodyInfo;

                for (int index = 0; index < customizedPlayerDataV2.boardGear.Length; ++index)
                {
                    if (customizedPlayerDataV2.boardGear[index].type.ToLower() != "deck") continue;

                    var array = GearDatabase.Instance.boardGear.Where(b => b.type.ToLower() == "deck" && !b.tags.Contains("ProOnly")).ToArray();
                    if (array.Length == 0) continue;

                    customizedPlayerDataV2.boardGear[index] = array[UnityEngine.Random.Range(0, array.Length)];
                    return customizedPlayerDataV2;
                }

                return customizedPlayerDataV2;
			}
		}

        /// <summary>
        /// Patching into <see cref="CustomizedPlayerDataV2.FromString"/> in order to be able to deserialize the player JSON file
        /// into our own class, <see cref="XLGMCustomizedPlayerData"/>.
        /// </summary>
        [HarmonyPatch(typeof(CustomizedPlayerDataV2), nameof(CustomizedPlayerDataV2.FromString))]
        public static class FromStringPatch
        {
            static void Postfix(string json, CustomizedPlayerDataV2 __result)
            {
                __result = JsonConvert.DeserializeObject<XLGMCustomizedPlayerData>(json);
            }
        }
	}
}
