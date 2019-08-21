#include<array.au3>
#include<file.au3>

$TTP_Txt = _FileListToArray(@ScriptDir, "*.txt", 1)
$TTP_Txt_count = UBound($TTP_Txt)-1

$7z_dir = "C:\Users\Alex47\AppData\Local\SalFisher47\7za"

For $i=1 To $TTP_Txt_count
	$TTP_7z = StringTrimRight($TTP_Txt[$i], 4) & ".7z"
	$hFile = FileOpen(@ScriptDir & "\" & $TTP_Txt[$i], 0)
	$TTP_name = FileReadLine($hFile, 1)
	FileClose($hFile)
	If Not FileExists(@ScriptDir & "\Bin_AMD\" & $TTP_name) Then
		$7z_unpack_talos = ' x -y -o' & '"' & @ScriptDir & '\Bin_AMD\' & $TTP_name & '"' & ' ' & '"' & @ScriptDir & '\' & $TTP_7z & '"' & ' ' & '"' & '*.exe' & '"'
		ShellExecuteWait("7za.exe", $7z_unpack_talos, $7z_dir, "", @SW_HIDE)
		FileDelete(@ScriptDir & "\Bin_AMD\" & $TTP_name & "\TalosLauncher.exe")
		FileMove(@ScriptDir & "\Bin_AMD\" & $TTP_name & "\Talos.exe", @ScriptDir & "\Bin_AMD\" & $TTP_name & "\Talos - " & $TTP_name & ".exe")
		FileMove(@ScriptDir & "\Bin_AMD\" & $TTP_name & "\Talos_Unrestricted.exe", @ScriptDir & "\Bin_AMD\" & $TTP_name & "\Talos_Unrestricted - " & $TTP_name & ".exe")
		;$7z_unpack_talos_unrestricted = ' x -y -o' & '"' & @ScriptDir & "\Bin_AMD\" & $TTP_name & '"' & ' ' & '"' & $TTP_7z & '"' & ' ' & '"' & '\Talos_Unrestricted.exe' & '"'
		;ShellExecuteWait("7za.exe", $7z_unpack_talos_unrestricted, $7z_dir)
		$yFile = FileOpen(@ScriptDir & "\Bin_AMD\AMD - Supported CPUs.txt", 1)
		FileWriteLine(@ScriptDir & "\Bin_AMD\AMD - Supported CPUs.txt", $TTP_name)
		FileClose($yFile)
	EndIf
Next

MsgBox(64, "TTP", "Finished")
