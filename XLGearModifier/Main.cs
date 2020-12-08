using System.Linq;
using HarmonyLib;
using System.Reflection;
using UnityEngine;
using UnityModManagerNet;
using XLMenuMod.Utilities.UserInterface;
using Object = UnityEngine.Object;

namespace XLGearModifier
{
#if DEBUG
	[EnableReloading]
#endif
	static class Main
	{
		public static bool Enabled { get; private set; }
		private static Harmony Harmony { get; set; }
		private static GameObject UserInterfaceGameObject { get; set; }
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

				UserInterfaceGameObject = new GameObject();
				UserInterfaceGameObject.AddComponent<UserInterface>();
				Object.DontDestroyOnLoad(UserInterfaceGameObject);

				var xlMenuMod = UnityModManager.modEntries.FirstOrDefault(x => x.Info.Id == "XLMenuMod");
				if (xlMenuMod != null)
				{
					XLMenuModEnabled = xlMenuMod.Enabled;
				}

				UserInterfaceHelper.Instance.LoadAssets();
				AssetBundleHelper.LoadGearBundle();
				PlayerController.Instance.StartCoroutine(AssetBundleHelper.LoadUserBundles());

				PlayerController.Instance.characterCustomizer.LoadLastPlayer();
			}
			else
			{
				Object.DestroyImmediate(UserInterfaceGameObject);
				Harmony.UnpatchAll(Harmony.Id);
			}

			return true;
		}

#if DEBUG
		static bool Unload(UnityModManager.ModEntry modEntry)
		{
			Object.DestroyImmediate(UserInterfaceGameObject);

			Harmony?.UnpatchAll();
			return true;
		}
#endif
	}
}
