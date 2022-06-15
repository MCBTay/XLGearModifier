// Code inspired, taken, and modified from these two repositories:
// https://github.com/giacomelli/Giacomelli.Unity.EditorToolbox
// https://github.com/giacomelli/Giacomelli.Unity.Metadata

using System;

namespace XLGearModifier.Unity.Editor.Upgrade
{
    public class ScriptMetadata
    {
        public int FileId { get; set; }

        public string FullName { get; set; }

        public string Name
        {
            get
            {
                if (String.IsNullOrEmpty(FullName))
                {
                    return FullName;
                }

                var parts = FullName.Split('.');
                return parts[parts.Length - 1];
            }
        }

        public string Guid { get; set; }

        /// <summary>
        /// XLGM specific, attempting to read in the prefix such that we can "retain" it during upgrade.
        /// </summary>
        public string Prefix { get; set; }
    }
}
