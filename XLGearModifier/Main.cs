using HarmonyLib;
using System.Linq;
using System.Reflection;
using UnityModManagerNet;
using XLGearModifier.Texturing;
using XLGearModifier.Utilities;

namespace XLGearModifier
{
#if DEBUG
    [EnableReloading]
#endif
	static class Main
	{
		public static bool Enabled { get; private set; }
		private static Harmony Harmony { get; set; }
		public static bool XLMenuModEnabled { get; private set; }

		private static DebugLogHandler LogHandler { get; set; }

		static bool Load(UnityModManager.ModEntry modEntry)
		{
			Settings.Instance = UnityModManager.ModSettings.Load<Settings>(modEntry);
			Settings.ModEntry = modEntry;

            modEntry.OnToggle = OnToggle;
#if DEBUG
			modEntry.OnUnload = Unload;
            LogHandler = new DebugLogHandler();
#endif

			return true;
		}

        private static bool OnToggle(UnityModManager.ModEntry modEntry, bool value)
		{
			if (Enabled == value) return true;
			Enabled = value;

			if (Enabled)
            {
				Harmony = new Harmony(modEntry.Info.Id);
				Harmony.PatchAll(Assembly.GetExecutingAssembly());

				var xlMenuMod = UnityModManager.modEntries.FirstOrDefault(x => x.Info.Id == "XLMenuMod");
				if (xlMenuMod != null)
				{
					XLMenuModEnabled = xlMenuMod.Enabled;
				}

				XLMenuMod.Utilities.UserInterface.UserInterfaceHelper.Instance.LoadAssets();

				//EyeTextureManager.Instance.AddEyeTemplate();
                AssetBundleHelper.Instance.LoadBundles();
            }
			else
			{
				Harmony.UnpatchAll(Harmony.Id);
			}

			return true;
		}

#if DEBUG
		static bool Unload(UnityModManager.ModEntry modEntry)
		{
			Harmony?.UnpatchAll();
			return true;
		}
#endif
	}
}
