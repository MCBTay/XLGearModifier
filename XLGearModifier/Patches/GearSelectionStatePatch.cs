using GameManagement;
using HarmonyLib;

namespace XLGearModifier.Patches
{
    public class GearSelectionStatePatch
	{
		/// <summary>
		/// Patching into OnEnter in order to create the What's Equipped UI when we enter GearSelectionState.
		/// </summary>
		[HarmonyPatch(typeof(GearSelectionState), nameof(GearSelectionState.OnEnter))]
		static class OnEnterPatch
		{
			static void Postfix()
			{
				UserInterfaceHelper.Instance.CreateWhatsEquippedUserInterface();
                UserInterfaceHelper.Instance.CreateAssetEditUserInterface();
			}
		}

        /// <summary>
        /// Patching into OnExit in order to destroy the What's Equipped UI when we leave GearSelectionState.
        /// </summary>
		[HarmonyPatch(typeof(GearSelectionState), nameof(GearSelectionState.OnExit))]
		static class OnExitPatch
		{
			static void Postfix()
			{
				UserInterfaceHelper.Instance.DestroyWhatsEquippedUserInterface();
                UserInterfaceHelper.Instance.DestroyAssetEditUserInterface();
			}
		}
	}
}
