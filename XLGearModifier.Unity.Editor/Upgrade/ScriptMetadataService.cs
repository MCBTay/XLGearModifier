// Code inspired, taken, and modified from these two repositories:
// https://github.com/giacomelli/Giacomelli.Unity.EditorToolbox
// https://github.com/giacomelli/Giacomelli.Unity.Metadata

using System.Collections.Generic;
using System.Linq;

namespace XLGearModifier.Unity.Editor.Upgrade
{
    public class ScriptMetadataService
    {
        private readonly TypeService m_typeService;
        private List<ScriptMetadata> s_scripts;

        public ScriptMetadataService()
        {
            m_typeService = new TypeService();
        }

        public IList<ScriptMetadata> GetScripts()
        {
            if (s_scripts != null) return s_scripts;

            s_scripts = new List<ScriptMetadata>();
            var types = m_typeService.GetTypes();

            foreach (var t in types)
            {
                var fileId = FileIdUtil.FromType(t);

                s_scripts.Add(new ScriptMetadata
                {
                    FileId = fileId,
                    FullName = t.FullName
                });
            }

            return s_scripts;
        }

        public string GetFullNameByFileId(int fileId)
        {
            var script = GetScripts().FirstOrDefault(s => s.FileId == fileId);

            return script?.FullName;
        }
    }
}
