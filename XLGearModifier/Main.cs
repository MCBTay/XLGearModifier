using HarmonyLib;
using System.Linq;
using System.Reflection;
using UnityModManagerNet;
using XLMenuMod.Utilities.UserInterface;

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

		static bool Load(UnityModManager.ModEntry modEntry)
		{
			Settings.Instance = UnityModManager.ModSettings.Load<Settings>(modEntry);
			Settings.ModEntry = modEntry;

			modEntry.OnToggle = OnToggle;
#if DEBUG
			modEntry.OnUnload = Unload;
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
				AssetBundleHelper.LoadGearBundle();
				PlayerController.Instance.StartCoroutine(AssetBundleHelper.LoadUserBundles());
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
