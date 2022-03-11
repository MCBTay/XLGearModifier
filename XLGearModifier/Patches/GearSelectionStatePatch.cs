﻿using GameManagement;
using HarmonyLib;

namespace XLGearModifier.Patches
{
    public class GearSelectionStatePatch
	{
		[HarmonyPatch(typeof(GearSelectionState), nameof(GearSelectionState.OnEnter))]
		static class OnEnterPatch
		{
			static void Postfix()
			{
				UserInterfaceHelper.Instance.CreateWhatsEquippedUserInterface();
			}
		}

		[HarmonyPatch(typeof(GearSelectionState), nameof(GearSelectionState.OnExit))]
		static class OnExitPatch
		{
			static void Postfix()
			{
				UserInterfaceHelper.Instance.DestroyWhatsEquippedUserInterface();
			}
		}
	}
}
