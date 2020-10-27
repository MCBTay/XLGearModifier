using UnityEngine;

namespace XLGearModifier
{
	public class UserInterface : MonoBehaviour
	{
		private static UserInterface _instance;
		public static UserInterface Instance => _instance ?? (_instance = new UserInterface());

		private bool UIIsOpen;

		private void Update()
		{
			if (!Input.GetKeyDown(KeyCode.Backslash)) return;

			UIIsOpen = !UIIsOpen;
			Cursor.visible = UIIsOpen;
			Cursor.lockState = CursorLockMode.None;
		}

		private void OnGUI()
		{
			if (!UIIsOpen) return;

			GUI.backgroundColor = Color.black;

			var style = new GUIStyle(GUI.skin.window)
			{
				contentOffset = new Vector2(0, -20),
				stretchHeight = false,
				stretchWidth = false
			};
            
			GUILayout.Window(823, new Rect(40, 40, 200, 50), DrawWindow, "XL Gear Modifier", style);
		}

		private void DrawWindow(int windowID)
		{
			GUI.DragWindow(new Rect(0.0f, 0.0f, 10000f, 20f));
			GUI.backgroundColor = Color.black;

			CreateToggleButton();
		}

		private void CreateToggleButton()
		{
			GUIStyle style = new GUIStyle(GUI.skin.button) { fontSize = 14, fixedHeight = 25 };
			style.normal.textColor = style.hover.textColor = style.active.textColor = Settings.Instance.AllowMultipleGearItemsPerSlot ? Color.green : Color.white;

			GUILayout.BeginHorizontal();

			if (GUILayout.Button(new GUIContent($"Allow Multiple Gear Items Per Slot: <b>{(Settings.Instance.AllowMultipleGearItemsPerSlot ? "Yes" : "No")}</b>"), style))
			{
				Settings.Instance.AllowMultipleGearItemsPerSlot = !Settings.Instance.AllowMultipleGearItemsPerSlot;
				Settings.Instance.Save();

				PlayerController.Instance.characterCustomizer.LoadLastPlayer();
			}
			
			GUILayout.EndHorizontal();
		}
	}
}
