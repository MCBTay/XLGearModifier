// Code inspired, taken, and modified from these two repositories:
// https://github.com/giacomelli/Giacomelli.Unity.EditorToolbox
// https://github.com/giacomelli/Giacomelli.Unity.Metadata

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace XLGearModifier.Unity.Editor.Upgrade
{
    public static class MetaFileService
    {
        private static List<MetaFileInfo> s_infos = new List<MetaFileInfo>();
        private static Regex s_guidRegex = new Regex(@"guid: (\S+)", RegexOptions.Compiled);

        /// <summary>
        /// Initialize the specified fileSystem.
        /// </summary>
        /// <param name="fileSystem">File system.</param>
        public static void Initialize()
        {
            s_infos = new List<MetaFileInfo>();
            var metaFiles = Directory.GetFiles("Assets", "*.meta", SearchOption.AllDirectories);

            foreach (var metaFile in metaFiles)
            {
                var content = File.ReadAllText(metaFile);
                s_infos.Add(new MetaFileInfo
                {
                    FileName = metaFile.Replace(".meta", string.Empty),
                    Guid = s_guidRegex.Match(content).Groups[1].Value
                });
            }
        }

        /// <summary>
        /// Gets the file name by GUID.
        /// </summary>
        /// <returns>The file name by GUID.</returns>
        /// <param name="guid">GUID.</param>
        public static string GetFileNameByGuid(string guid)
        {
            if (s_infos == null || s_infos.Count == 0) Initialize();

            var info = s_infos.FirstOrDefault(i => i.Guid.Equals(guid, StringComparison.Ordinal));

            return info == null ? null : info.FileName;
        }
    }
}
