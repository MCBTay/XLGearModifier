// Code inspired, taken, and modified from these two repositories:
// https://github.com/giacomelli/Giacomelli.Unity.EditorToolbox
// https://github.com/giacomelli/Giacomelli.Unity.Metadata

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using UnityEngine;

namespace XLGearModifier.Unity.Editor.Upgrade
{
    public class TypeService
    {
        private static Regex s_guidRegex = new Regex(@"guid: (\S+)", RegexOptions.Compiled);
        private List<Type> s_types;

        public IEnumerable<Type> GetTypes()
        {
            if (s_types == null)
            {
                s_types = new List<Type>(Assembly.GetExecutingAssembly().GetTypes());
                s_types.AddRange(typeof(UnityEngine.MonoBehaviour).Assembly.GetTypes());

                var externalDlls = Directory.GetFiles("Assets", "*.dll", SearchOption.AllDirectories);

                foreach (var dll in externalDlls)
                {
                    try
                    {
                        var assembly = Assembly.LoadFrom(Path.GetFullPath(dll));
                        s_types.AddRange(assembly.GetTypes());
                    }
                    catch (BadImageFormatException bife)
                    {

                    }
                    catch (ReflectionTypeLoadException ex)
                    {
                        var loaderMsg = new StringBuilder();

                        foreach (var l in ex.LoaderExceptions)
                        {
                            loaderMsg.AppendFormat("{0}:{1}", l.GetType().Name, l.Message);
                            loaderMsg.AppendLine();
                        }

                        Debug.LogWarning($"Error trying to load assembly '{dll}':{ex.Message}. LoaderExceptions: {loaderMsg}");
                    }
                }
            }

            return s_types;
        }

        public Type GetTypeByName(string typeName)
        {
            var type = GetTypes().FirstOrDefault(t => t.FullName.Equals(typeName, StringComparison.OrdinalIgnoreCase));

            if (type == null)
            {
                throw new InvalidOperationException($"Could not find a type '{typeName}'.");
            }

            return type;
        }
    }
}
