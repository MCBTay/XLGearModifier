// Code inspired, taken, and modified from these two repositories:
// https://github.com/giacomelli/Giacomelli.Unity.EditorToolbox
// https://github.com/giacomelli/Giacomelli.Unity.Metadata

using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace XLGearModifier.Unity.Editor.Upgrade
{
    public class PrefabMetadata
    {
        private readonly TypeService m_TypeService;

        public PrefabMetadata()
        {
            m_TypeService = new TypeService();
            MonoBehaviours = new List<MonoBehaviourMetadata>();
        }

        public string Name { get; set; }

        public string Path { get; set; }

        public IList<MonoBehaviourMetadata> MonoBehaviours { get; private set; }

        public IEnumerable<MonoBehaviourMetadata> GetMissingMonoBehaviours()
        {
            var prefabInstance = AssetDatabase.LoadAssetAtPath<GameObject>(Path);
            var result = new List<MonoBehaviourMetadata>();

            foreach (var m in MonoBehaviours)
            {
                var type = m_TypeService.GetTypeByName(m.Script.FullName);

                if (prefabInstance.GetComponentInChildren(type) == null)
                {
                    result.Add(m);
                }
            }

            return result;
        }
    }
}
