using System;
using System.IO;
using UnityEngine;

namespace XLGearModifier.Utilities
{
    public class DebugLogHandler : ILogHandler
    {
        private FileStream m_FileStream;
        private StreamWriter m_StreamWriter;
        private ILogHandler m_DefaultLogHandler = Debug.unityLogger.logHandler;

        public DebugLogHandler()
        {
            string filePath = Application.persistentDataPath + "/DebugLogs.log";

            m_FileStream = new FileStream(filePath, FileMode.OpenOrCreate, FileAccess.ReadWrite);
            m_StreamWriter = new StreamWriter(m_FileStream);

            // Replace the default debug log handler
            Debug.unityLogger.logHandler = this;
            Debug.unityLogger.logEnabled = true;
        }

        public void LogFormat(LogType logType, UnityEngine.Object context, string format, params object[] args)
        {
            m_StreamWriter.WriteLine(format, args);
            m_StreamWriter.Flush();
            m_DefaultLogHandler.LogFormat(logType, context, format, args);
        }

        public void LogException(Exception exception, UnityEngine.Object context)
        {
            m_DefaultLogHandler.LogException(exception, context);
        }
    }
}