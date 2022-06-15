// Code inspired, taken, and modified from these two repositories:
// https://github.com/giacomelli/Giacomelli.Unity.EditorToolbox
// https://github.com/giacomelli/Giacomelli.Unity.Metadata

using System;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;

namespace XLGearModifier.Unity.Editor.Upgrade
{
    public class PrefabReader
    {
        private static readonly Regex ScriptFileIdRegex = new Regex(@"\{fileID: (?<fileId>[\-0-9]+), guid: [a-z0-9]+, type: 3", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        private static readonly Regex ScriptGuidRegex = new Regex(@"\{fileID: [\-0-9]+, guid: (?<guid>[a-z0-9]+), type: 3", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        private static readonly Regex ScriptPrefixRegex = new Regex(@"\'Prefix: (?<prefix>[a-z0-9]+)", RegexOptions.Compiled | RegexOptions.IgnoreCase);

        private readonly ScriptMetadataService m_scriptMetadataService;

        public PrefabReader()
        {
            m_scriptMetadataService = new ScriptMetadataService();
        }

        public PrefabMetadata Read(string fileName)
        {
            var metadata = new PrefabMetadata();
            var content = File.ReadAllText(fileName);
            ReadMonoBehaviours(metadata, content);

            return metadata;
        }

        private void ReadMonoBehaviours(PrefabMetadata metadata, string content)
        {
            var documents = content.Split(new string[] { "--- !u!114" }, StringSplitOptions.RemoveEmptyEntries);

            for (int i = 1; i < documents.Length; i++)
            {
                var document = documents[i];
                var monoBehaviour = new MonoBehaviourMetadata();
                var script = new ScriptMetadata
                {
                    FileId = ReadFileId(document, ScriptFileIdRegex),
                    Guid = ReadString(document, ScriptGuidRegex, "guid"),
                    Prefix = ReadString(document, ScriptPrefixRegex, "prefix")
                };

                script.FullName = m_scriptMetadataService.GetFullNameByFileId(script.FileId);

                if (String.IsNullOrEmpty(script.FullName))
                {
                    script.FullName = MetaFileService.GetFileNameByGuid(script.Guid);
                }

                monoBehaviour.Script = script;

                metadata.MonoBehaviours.Add(monoBehaviour);
            }
        }

        private static int ReadFileId(string document, Regex regex)
        {
            try
            {
                return Convert.ToInt32(regex.Match(document).Groups["fileId"].Value, CultureInfo.InvariantCulture);
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"Error reading file id from '{document}': {ex.Message}");
            }
        }

        private static string ReadString(string document, Regex regex, string group)
        {
            return regex.Match(document).Groups[group].Value;
        }
    }
}
