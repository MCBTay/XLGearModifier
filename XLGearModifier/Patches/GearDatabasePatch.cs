using HarmonyLib;
using SkaterXL.Core;
using SkaterXL.Data;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEngine;
using XLGearModifier.CustomGear;
using XLGearModifier.Texturing;
using XLGearModifier.Unity;
using XLMenuMod.Utilities.Gear;
using XLMenuMod.Utilities.Interfaces;

namespace XLGearModifier.Patches
{
    public class GearDatabasePatch
    {
        [HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetGearListAtIndex), new[] { typeof(IndexPath), typeof(bool) }, new[] { ArgumentType.Normal, ArgumentType.Out })]
        public static class GetGearListAtIndexPatch
        {
            static void Postfix(GearDatabase __instance, IndexPath index, ref GearInfo[] __result)
            {
                if (index.depth < 2) return;

                if (!GearSelectionControllerPatch.IsOnXLGMTab(index[1]))
                {
                    var newResult = new List<GearInfo>(__result);
                    // check to see if custom meshes are in list, if so, remove
                    newResult.RemoveAll(x => GearManager.Instance.CustomGear.ContainsKey(x.type) && GearManager.Instance.CustomGear[x.type] is ClothingGear);
                    __result = newResult.ToArray();
                    return;
                }

                var sourceList = GetSourceList(index);
                if (sourceList == null) return;

                __result = sourceList.Select(x => x.GetParentObject() as GearInfo).ToArray();
            }

            private static List<ICustomInfo> GetSourceList(IndexPath index)
            {
                var isMale = index[0] == (int)XLMenuMod.Skater.MaleStandard;
                var isFemale = index[0] == (int)XLMenuMod.Skater.FemaleStandard;

                if (isMale || isFemale)
                {
                    switch (index[1])
                    {
                        case (int)GearModifierTab.CustomMeshes:
                            return isMale ? ChildrenOrSourceList(GearManager.Instance.CustomMeshes) : new List<ICustomInfo>();
                        case (int)GearModifierTab.CustomFemaleMeshes:
                            return isFemale ? ChildrenOrSourceList(GearManager.Instance.CustomFemaleMeshes) : new List<ICustomInfo>();
                        case (int)GearModifierTab.Eyes:
                            return EyeTextureManager.Instance.Eyes;
                        default:
                            return null;
                    }
                }

                var isCustom = index[0] >= Enum.GetNames(typeof(XLMenuMod.Skater)).Length;
                var allowsClothing = CustomSkaterAllowsClothing(index);

                if (!isCustom || !allowsClothing) return null;

                if (GetClothingGearFilters(index) == SkaterBase.Male && index[1] == (int)GearModifierTab.CustomMeshes)
                    return ChildrenOrSourceList(GearManager.Instance.CustomMeshes);

                if (GetClothingGearFilters(index) == SkaterBase.Female && index[1] == (int)GearModifierTab.CustomFemaleMeshes)
                    return ChildrenOrSourceList(GearManager.Instance.CustomFemaleMeshes);

                return null;
            }

            /// <summary>
            /// Returns either the CurrentFolder's children or the inputList.
            /// </summary>
            private static List<ICustomInfo> ChildrenOrSourceList(List<ICustomInfo> inputList)
            {
                return GearManager.Instance.CurrentFolder == null ? inputList : GearManager.Instance.CurrentFolder.Children;
            }

            /// <summary>
            /// Checks to see if a custom skater has the <see cref="XLGMSkaterMetadata.AllowClothing"/> checkbox enabled.
            /// </summary>
            /// <param name="index">The IndexPath of the custom skater to be evaluated.</param>
            /// <returns>True if the custom skater allows clothing, false otherwise.</returns>
            private static bool CustomSkaterAllowsClothing(IndexPath index)
            {
                var skater = GearDatabase.Instance.skaters[index[0]];

                if (!GearManager.Instance.CustomSkaters.ContainsKey(skater.customizations.body.type)) return false;

                var customSkater = GearManager.Instance.CustomSkaters[skater.customizations.body.type];

                return customSkater != null && customSkater.SkaterMetadata.AllowClothing;
            }

            private static SkaterBase GetClothingGearFilters(IndexPath index)
            {
                var skater = GearDatabase.Instance.skaters[index[0]];

                if (!GearManager.Instance.CustomSkaters.ContainsKey(skater.customizations.body.type)) return SkaterBase.Male;

                var customSkater = GearManager.Instance.CustomSkaters[skater.customizations.body.type];
                if (customSkater == null) return SkaterBase.Male;

                return customSkater.SkaterMetadata.ClothingGearFilters;
            }
        }

        [HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetGearAtIndex), new[] { typeof(IndexPath), typeof(bool) }, new[] { ArgumentType.Normal, ArgumentType.Out })]
        public static class GetGearAtIndexPatch
        {
            static void Postfix(IndexPath index, ref GearInfo __result)
            {
                if (index.depth < 3) return;
                if (!GearSelectionControllerPatch.IsOnXLGMTab(index[1]))
                {
                    // Since GetGearListAtIndex is now filtering out custom items from non xlgm tabs,
                    // we can use it to get each item such that they're labelled properly
                    var gearList = GearDatabase.Instance.GetGearListAtIndex(index.Up());
                    __result = gearList.ElementAt(index.LastIndex);
                    return;
                }

                var sourceList = GetSourceList(index[1]);

                if (index.depth == 3)
                {
                    if (index.LastIndex < 0 || index.LastIndex > sourceList.Count - 1) return;

                    switch (sourceList.ElementAt(index.LastIndex).GetParentObject())
                    {
                        case CustomGearFolderInfo customGearFolderInfo:
                            __result = customGearFolderInfo;
                            break;
                        case CustomCharacterGearInfo customCharacterGerInfo:
                            __result = customCharacterGerInfo;
                            break;
                    }
                }
                // mesh per type, you've already selected a type so current folder should be valid, regardless of whether or not XLMenuMod is installed
                else if (index.depth >= 4)
                {
                    var children = GearManager.Instance.CurrentFolder.Children;
                    if (index.LastIndex < 0 || index.LastIndex > children.Count - 1) return;

                    var parentObject = children.ElementAt(index.LastIndex).GetParentObject();
                    switch (parentObject)
                    {
                        case CustomCharacterGearInfo customCharacterGearInfo:
                            __result = customCharacterGearInfo;
                            break;
                        case CustomBoardGearInfo customBoardGearInfo:
                            __result = customBoardGearInfo;
                            break;
                        case CustomGearFolderInfo customGearFolderInfo:
                            __result = customGearFolderInfo;
                            break;
                        case CustomGearBase customGear:
                            __result = customGear.GearInfo;
                            break;
                    }
                }
            }
        }

        [HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.FetchCustomGear))]
        public static class FetchCustomGearPatch
        {
            static void Prefix(GearDatabase __instance)
            {
                var defaultSkaterTypes = Enum.GetNames(typeof(XLMenuMod.Skater)).Select(x => x.ToLower().Replace("standard", string.Empty)).ToList();

                foreach (var skater in __instance.skaters)
                {
                    CheckForAllowClothing(defaultSkaterTypes, skater);

                    foreach (var filter in skater.GearFilters)
                    {
                        filter.allowCustomGear = true;
                    }
                }

                Traverse.Create(__instance).Method("GenerateGearListSource").GetValue();
            }

            private static void CheckForAllowClothing(IEnumerable<string> defaultSkaterTypes, SkaterInfo currentSkater)
            {
                var type = currentSkater.customizations.body.type;

                if (defaultSkaterTypes.Contains(type)) return;

                if (!GearManager.Instance.CustomSkaters.ContainsKey(currentSkater.customizations.body.type)) return;

                var skater = GearManager.Instance.CustomSkaters[currentSkater.customizations.body.type];
                if (skater == null) return;

                if (!skater.SkaterMetadata.AllowClothing) return;

                currentSkater.GearFilters = CreateGearFilters(skater);
                currentSkater.GearFilters[0].includedTypes = new[] { skater.SkaterMetadata.CharacterBodyTemplate.id };
            }

            /// <summary>
            /// A method to create a copy of a base skater's GearFilters.  Doing a simple assignment of the skaters GearFilters to our custom skater,
            /// a reference was added thus we were inadvertently updating the base skater's GearFilters too.  
            /// </summary>
            /// <param name="skater">The current skater we're creating gear filters for.</param>
            /// <returns>A new TypeFilterList instance based on either male or female.</returns>
            private static TypeFilterList CreateGearFilters(Skater skater)
            {
                var baseGearFilters = GearDatabase.Instance.skaters[(int)skater.SkaterMetadata.ClothingGearFilters].GearFilters;

                var filters = new List<TypeFilter>();
                foreach (var gearFilter in baseGearFilters)
                {
                    var clone = new TypeFilter
                    {
                        allowCustomGear = gearFilter.allowCustomGear,
                        includedTypes = gearFilter.includedTypes,
                        cameraView = gearFilter.cameraView,
                        excludedTags = gearFilter.excludedTags,
                        label = gearFilter.label,
                        requiredTag = gearFilter.requiredTag
                    };

                    filters.Add(clone);
                }
                return new TypeFilterList(filters);
            }

            static void Postfix(GearDatabase __instance)
            {
                SkateShopTextureManager.Instance.LookForSkateshopTextures();
                EyeTextureManager.Instance.LookForEyeTextures();
                GearManager.Instance.LoadNestedItems();
            }
        }

        private static List<ICustomInfo> GetSourceList(int index)
        {
            switch ((GearModifierTab)index)
            {
                case GearModifierTab.CustomMeshes: return GearManager.Instance.CustomMeshes;
                case GearModifierTab.CustomFemaleMeshes: return GearManager.Instance.CustomFemaleMeshes;
                case GearModifierTab.Eyes: return EyeTextureManager.Instance.Eyes;
                default: return new List<ICustomInfo>();
            }
        }

        [HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetCamerView))]
        public static class GetCamerViewPatch
        {
            static void Postfix(IndexPath index, ref GearRoomCameraView __result)
            {
                if (index.depth < 2) return;
                if (index[1] != (int)GearModifierTab.Eyes) return;

                __result = GearRoomCameraView.Head;
            }
        }

        /// <summary>
        /// Currently patching into this to extend the functionality that was only looking for head/body/eyes material ids when it came to body
        /// textures.  Have asked/suggeseted some refactoring of this method to Easy Day with hopes of me not having to clone/own all of this code.
        /// </summary>
        [HarmonyPatch(typeof(GearDatabase), nameof(GearDatabase.GetGearIn), typeof(List<string>), typeof(bool), typeof(Func<string, bool>), typeof(Func<Match, bool>))]
        public static class GetGearInPatch
        {
            static bool Prefix(ref List<string> customGearFiles, bool isCustom, Func<string, bool> pathFilter, Func<Match, bool> matchFilter, ref IEnumerable<GearInfo> __result)
            {
                List<string> source1 = new List<string>();
                for (int index = 0; index < customGearFiles.Count; ++index)
                {
                    string withoutExtension = Path.GetFileNameWithoutExtension(customGearFiles[index]);
                    if (withoutExtension.Contains("..") || withoutExtension.Contains("(") || withoutExtension.Contains(")"))
                    {
                        source1.Add(customGearFiles[index]);
                        customGearFiles.RemoveAt(index);
                        --index;
                    }
                }
                List<string> list1 = source1.OrderByDescending(p => Path.GetFileNameWithoutExtension(p).Length).ToList();
                string pattern = "^(?<Type>[a-zA-Z0-9]+)_(?<Name>[^\\[\\]\\.#]+)(?<Tags>(#[^\\[\\]\\.#]+)+)?((\\[(?<TextureID>\\w+)?\\])?|(\\.(?<TextureID>(?i)(albedo|normal|maskpbr|rgmtao|rgmtsp))?)?)\\.(jpg|jpeg|png|tga)$";
                GearInfoSingleMaterial[] array = customGearFiles
                    .Where(pathFilter)
                    .Select(p => new
                    {
                        path = p,
                        match = Regex.Match(Path.GetFileName(p), pattern)
                    })
                    .Where(p => matchFilter(p.match))
                    .Where(file => file.match.Success)
                    .GroupBy(tuple => new
                    {
                        type = tuple.match.Groups["Type"].Value,
                        name = tuple.match.Groups["Name"].Value
                    }, 
                    (gearInfo, files) => new GearInfoSingleMaterial(gearInfo.name, gearInfo.type, isCustom, files.Select(f => new TextureChange(f.match.Groups["TextureID"].Value?.ToLower(), f.path)).ToArray(), files.Select(f =>
                    {
                        if (!f.match.Groups["Tags"].Success)
                            return new string[0];
                        return f.match.Groups["Tags"].Value.Trim('#').Split('#');
                    })
                    .Aggregate(new List<string>(), (list, tags) =>
                    {
                        foreach (string tag in tags)
                        {
                            if (!list.Contains(tag))
                                list.Add(tag);
                        }
                        return list;
                    })
                    .ToArray()))
                    .ToArray();

                string pattern1 = "^(?<Type>[a-zA-Z0-9]+)_(?<NamePattern>[^\\[\\]#]+)((\\[(?<TextureID>\\w+)?\\])|(\\.(?<TextureID>(?i)(albedo|normal|maskpbr|rgmtao|rgmtsp))?))\\.(jpg|jpeg|png)$$";
                foreach (string str1 in list1)
                {
                    Match match = Regex.Match(Path.GetFileName(str1), pattern1);
                    if (match.Success)
                    {
                        string str2 = match.Groups["NamePattern"].Value.Replace("..", "\\w+").Replace("&", "|");
                        string textureID = match.Groups["TextureID"].Value.ToLower();
                        string lower = match.Groups["Type"].Value.ToLower();
                        for (int index = 0; index < array.Length; ++index)
                        {
                            if (!(array[index].type.ToLower() != lower) && Regex.Match(array[index].name.EscapeForFileName(), "^" + str2).Success && array[index].textureChanges.FirstOrDefault(tc => tc.textureID == textureID) == null)
                            {
                                List<TextureChange> list2 = array[index].textureChanges.ToList();
                                string gearPath = str1;
                                list2.Add(new TextureChange(textureID, gearPath));
                                array[index].textureChanges = list2.ToArray();
                            }
                        }
                    }
                }

                List<GearInfo> source2 = new List<GearInfo>();
                foreach (GearInfoSingleMaterial infoSingleMaterial in array)
                {
                    GearInfoSingleMaterial gear = infoSingleMaterial;
                    if (GearDatabase.Instance.ContainsBoardTemplateWithID(gear.type))
                        source2.Add(new BoardGearInfo(gear));
                    else if (GearDatabase.Instance.ContainsClothingTemplateWithID(gear.type.ToLower()))
                    {
                        source2.Add(new CharacterGearInfo(gear));
                    }
                    else
                    {
                        string type = null;
                        string materialID = null;
                        if (gear.type.ToLower().EndsWith("head"))
                        {
                            materialID = "head";
                            type = gear.type.Remove(gear.type.Length - "head".Length);
                        }
                        else if (gear.type.ToLower().EndsWith("body"))
                        {
                            materialID = "body";
                            type = gear.type.Remove(gear.type.Length - "body".Length);
                        }
                        else if (gear.type.ToLower().EndsWith("eyes"))
                        {
                            materialID = "eyes";
                            type = gear.type.Remove(gear.type.Length - "eyes".Length);
                        }

                        // This is my added condition.  Ask Easy Day if we can refactor this method to make me extending this functionality easier.
                        var skater = GearManager.Instance.CustomSkaters.FirstOrDefault(x => gear.type.ToLower().StartsWith(x.Key) && x.Value.MaterialControllerTextures.ContainsKey(gear.type.ToLower().Remove(0, x.Key.Length)));
                        if (!string.IsNullOrEmpty(skater.Key) && skater.Value != null)
                        {
                            materialID = gear.type.ToLower().Remove(0, skater.Key.Length);
                            type = skater.Key;
                        }

                        if (type == null || materialID == null || !GearDatabase.Instance.ContainsBodyTemplateWithID(type.ToLower()))
                        {
                            Debug.LogWarning("No template found for gear " + gear.type + ", filepaths: " + string.Join(", ", gear.textureChanges.Select(tc => tc.texturePath)));
                        }
                        else
                        {
                            GearInfo gearInfo = source2.FirstOrDefault(g => g.type.ToLower() == type.ToLower() && g.name == gear.name);
                            if (gearInfo != null && gearInfo is CharacterBodyInfo)
                            {
                                CharacterBodyInfo characterBodyInfo = gearInfo as CharacterBodyInfo;
                                int index = characterBodyInfo.materialChanges.ToList().FindIndex(0, mc => mc.materialID == materialID);
                                if (index >= 0)
                                    characterBodyInfo.materialChanges[index].textureChanges = characterBodyInfo.materialChanges[index].textureChanges.Union(gear.textureChanges).ToArray();
                                else
                                    characterBodyInfo.materialChanges.Add(new MaterialChange(materialID, gear.textureChanges));
                                characterBodyInfo.tags = gear.tags.Aggregate(characterBodyInfo.tags.ToList(), (list, tag) =>
                                {
                                    if (!list.Contains(tag))
                                        list.Add(tag);
                                    return list;
                                }).ToArray();
                            }
                            else
                            {
                                string name = gear.name;
                                string type1 = type;
                                int num = isCustom ? 1 : 0;
                                List<MaterialChange> materialChanges = new List<MaterialChange>();
                                materialChanges.Add(new MaterialChange(materialID, gear.textureChanges));
                                string[] tags = gear.tags;
                                CharacterBodyInfo characterBodyInfo = new CharacterBodyInfo(name, type1, num != 0, materialChanges, tags);
                                source2.Add(characterBodyInfo);
                            }
                        }
                    }
                }
                __result = source2;

                return false;
            }
        }
    }
}
