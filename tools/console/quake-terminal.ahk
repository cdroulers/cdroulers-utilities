; Change your hotkey here. Currently is Ctrl + #
^#::

DetectHiddenWindows, on
IfWinExist ahk_class Console_2_Main
{
	IfWinActive ahk_class Console_2_Main
	{
		WinHide ahk_class Console_2_Main
		WinActivate ahk_class Shell_TrayWnd
	}
	else
	{
		WinShow ahk_class Console_2_Main
	    WinActivate ahk_class Console_2_Main
	}
}
else
{
	if FileExist("Console.exe")
		Run Console.exe
	else
		Run Console.exe.lnk
}
DetectHiddenWindows, off
return