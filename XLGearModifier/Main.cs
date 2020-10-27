using HarmonyLib;
using System.Reflection;
using UnityEngine;
using UnityModManagerNet;
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

				PlayerController.Instance.characterCustomizer.LoadLastPlayer();

				AssetBundleHelper.LoadGearBundle();
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
