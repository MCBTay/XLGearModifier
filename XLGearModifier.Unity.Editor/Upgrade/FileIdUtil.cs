// Code inspired, taken, and modified from these two repositories:
// https://github.com/giacomelli/Giacomelli.Unity.EditorToolbox
// https://github.com/giacomelli/Giacomelli.Unity.Metadata

using System;
using System.Text;

namespace XLGearModifier.Unity.Editor.Upgrade
{
    public static class FileIdUtil
    {
        /// <summary>
        /// Get the file id from specified type.
        /// </summary>
        /// <returns>The type.</returns>
        /// <param name="type">Type.</param>
        public static int FromType(Type type)
        {
            // http://forum.unity3d.com/threads/yaml-fileid-hash-function-for-dll-scripts.252075/#post-1695479
            string toBeHashed = "s\0\0\0" + type.Namespace + type.Name;

            using (var hash = new MD4())
            {
                byte[] hashed = hash.ComputeHash(Encoding.UTF8.GetBytes(toBeHashed));

                int result = 0;

                for (int i = 3; i >= 0; --i)
                {
                    result <<= 8;
                    result |= hashed[i];
                }

                return result;
            }
        }
    }
}
