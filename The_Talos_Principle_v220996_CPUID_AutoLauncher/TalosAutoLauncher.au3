#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=TalosAutoLauncher.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UPX_Parameters=-9 --strip-relocs=0 --compress-exports=0 --compress-icons=0
#AutoIt3Wrapper_Res_Description=The Talos Principle Launcher
#AutoIt3Wrapper_Res_Fileversion=1.0.0.47
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.47
#AutoIt3Wrapper_Res_LegalCopyright=2014, SalFisher47
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region ;**** Pragma Compile ****
#pragma compile(AutoItExecuteAllowed, true)
#pragma compile(Compression, 9)
#pragma compile(Compatibility, vista, win7, win8, win81, win10)
#pragma compile(InputBoxRes, true)
#pragma compile(CompanyName, 'SalFisher47')
#pragma compile(FileDescription, 'The Talos Principle Launcher')
#pragma compile(FileVersion, 1.0.0.47)
#pragma compile(InternalName, 'The Talos Principle Launcher')
#pragma compile(LegalCopyright, '2014, SalFisher47')
#pragma compile(OriginalFilename, TalosAutoLauncher.exe)
#pragma compile(ProductName, 'The Talos Principle Launcher')
#pragma compile(ProductVersion, 1.0.0.47)
#EndRegion ;**** Pragma Compile ****
; === UniCrack Installer.au3 =======================================================================================================
; Title .........: The Talos Principle Launcher
; Version .......: 1.0.0.47
; AutoIt Version : 3.3.10.2
; Language ......: English
; Description ...: The Talos Principle Launcher
; Author(s) .....: SalFisher47
; Last Modified .: December 27, 2014
; ==================================================================================================================================

#include <array.au3>
#include <file.au3>
#include <stringconstants.au3>

If Not FileExists(@AppDataCommonDir & "\SalFisher47\7za") Then DirCreate(@AppDataCommonDir & "\SalFisher47\7za")
FileInstall("TalosAutoLauncher\RequiredSoftware\7za.exe", @AppDataCommonDir & "\SalFisher47\7za\7za.exe", 0)
FileInstall("TalosAutoLauncher\RequiredSoftware\7-Zip.chm", @AppDataCommonDir & "\SalFisher47\7za\7-Zip.chm", 0)
FileInstall("TalosAutoLauncher\RequiredSoftware\License.txt", @AppDataCommonDir & "\SalFisher47\7za\License.txt", 0)
FileInstall("TalosAutoLauncher\RequiredSoftware\Readme.txt", @AppDataCommonDir & "\SalFisher47\7za\Readme.txt", 0)

If Not FileExists(@AppDataCommonDir & "\SalFisher47\xd3") Then DirCreate(@AppDataCommonDir & "\SalFisher47\xd3")
FileInstall("TalosAutoLauncher\RequiredSoftware\xd3.exe", @AppDataCommonDir & "\SalFisher47\xd3\xd3.exe", 0)

FileInstall("TalosLauncher.exe", @ScriptDir & "\TalosLauncher.exe", 0)
FileInstall("TalosAutoLauncher.ini", @ScriptDir & "\TalosAutoLauncher.ini", 0)

$7z_amd = @ScriptDir & "\TalosAutoLauncher\Bin_AMD.7z"
$7z_intel = @ScriptDir & "\TalosAutoLauncher\Bin_Intel.7z"
$7z_backup = @ScriptDir & "\TalosAutoLauncher\Bin_Backup.7z"

$ini_cpu_detected = IniRead(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_detected", "")
$ini_cpu_forced = IniRead(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_forced", "")
$ini_cpu_forced_orig = $ini_cpu_forced
$ini_cpu_patched = IniRead(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_patched", "")
$ini_msg = IniRead(@ScriptDir & "\TalosAutoLauncher.ini", "Optional", "msg", "")

Local $bin_amd_array[1], $bin_intel_array[1]

If $ini_cpu_forced <> $ini_cpu_patched Then
; cpu_forced <> cpu_patched (exes HAVEN'T BEEN patched for cpu_forced - have to be patched now)
	$reg_cpu = RegRead("HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "ProcessorNameString")
	$reg_cpu = StringReplace($reg_cpu, "(tm)", "-")
	$reg_cpu = StringReplace($reg_cpu, "™", "-")
	$reg_cpu = StringReplace($reg_cpu, "(r)", "-")
	$reg_cpu = StringReplace($reg_cpu, "®", "-")
	If StringInStr($reg_cpu, "AMD") Then
	; detected cpu is AMD
		$reg_cpu = StringReplace($reg_cpu, "+", "")
		$reg_cpu = StringReplace($reg_cpu, "-", " ")
		$reg_cpu = StringReplace($reg_cpu, "Genuine", "")
		$reg_cpu = StringReplace($reg_cpu, "Dual Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Triple Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Quad Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Six Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Eight Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Mobile", "")
		$reg_cpu = StringReplace($reg_cpu, "Processor", "")
		$reg_cpu = StringReplace($reg_cpu, "CPU", "")
		$reg_cpu = StringReplace($reg_cpu, "APU", "")
		$reg_cpu = StringReplace($reg_cpu, "with", "")
		$reg_cpu = StringReplace($reg_cpu, "Radeon", "")
		$reg_cpu = StringReplace($reg_cpu, "HD", "")
		$reg_cpu = StringReplace($reg_cpu, "Graphics", "")
		$reg_cpu = StringReplace($reg_cpu, "(ES)", "")
		$reg_cpu = StringReplace($reg_cpu, "    ", " ")
		$reg_cpu = StringReplace($reg_cpu, "   ", " ")
		$reg_cpu = StringReplace($reg_cpu, "  ", " ")
		If StringInStr($reg_cpu, " @ ") Then
			$reg_cpu = StringLeft($reg_cpu, StringInStr($reg_cpu, " @ ") + StringLen(" @ ") - 4) ; remove ' @ x.xx GHz' from cpu name
		EndIf
		If StringLeft($reg_cpu, 1) == " " Then
			$reg_cpu = StringTrimLeft($reg_cpu, 1)
		EndIf
		If StringRight($reg_cpu, 1) == " " Then
			$reg_cpu = StringTrimRight($reg_cpu, 1)
		EndIf
		;$reg_cpu_last6 = StringRight($reg_cpu, 6)
		;$reg_cpu_first3_of_last6 = StringLeft($reg_cpu_last6, 3)
		;If (StringLeft($reg_cpu_first3_of_last6, 1) == " ") And StringIsAlpha(StringTrimLeft(StringLeft($reg_cpu_first3_of_last6, 2), 1)) And (StringRight($reg_cpu_first3_of_last6, 1) == " ") Then
		;	If StringRight(StringTrimRight($reg_cpu, 6), 7) <> "Pentium" Then
		;		$reg_cpu = StringTrimRight($reg_cpu, 6) & " " & StringRight($reg_cpu_last6, 3) & StringTrimLeft(StringLeft($reg_cpu_first3_of_last6, 2), 1) ; replace ' M xyz' with ' xyzM'
		;	EndIf
		;EndIf
		; finished processing registry cpu name
		If $ini_cpu_detected <> $reg_cpu Then
			IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_detected", " " & $reg_cpu)
			$ini_cpu_detected = $reg_cpu
			$ini_cpu_forced = $ini_cpu_detected
		EndIf
		$cpu_count = _FileCountLines(@ScriptDir & "\TalosAutoLauncher\Bin_AMD.txt")
		$hFile = FileOpen(@ScriptDir & "\TalosAutoLauncher\Bin_AMD.txt")
		For $i = 1 to $cpu_count
			_ArrayAdd($bin_amd_array, FileReadLine($hFile, $i))
		Next
		FileClose($hFile)
		For $j = 1 to $cpu_count
			If StringInStr($bin_amd_array[$j], $ini_cpu_forced) Then
				For $k = 0 To 4
					$ini_cpu_forced_temp = $bin_amd_array[$j+$k]
					If StringInStr($ini_cpu_forced_temp, $ini_cpu_forced) Then
						$ini_cpu_forced_temp = $bin_amd_array[$j+$k]
						$bin_amd_number = $j+$k
						$cpu_status = 1 ; exes can be patched for this cpu
						ExitLoop
					EndIf
				Next
			Else
				$ini_cpu_forced_temp = "AMD FX 8350"
				$cpu_status = 2 ; exes can't be patched for this cpu
			EndIf
			If $cpu_status == 1 Then
				ExitLoop
			EndIf
		Next
		$ini_cpu_forced = $ini_cpu_forced_temp
		If $ini_cpu_forced_orig == "" Then
			$ini_cpu_forced_orig = $ini_cpu_detected
		EndIf
		If $cpu_status == 1 Then
		; exes CAN BE patched for this cpu
			IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_forced", " " & $ini_cpu_forced)
			; wrote cpu_forced to TalosAutoLauncher.ini
			$7z_unpack_line = ' x -y -o' & '"' & @ScriptDir & '"' & ' ' & '"' & $7z_backup & '"' & ' ' & '"' & '*' & '"'
			ShellExecuteWait("7za.exe", $7z_unpack_line, @AppDataCommonDir & "\SalFisher47\7za", "", @SW_HIDE)
			; unpacked exes to be patched by xdelta3
			If Not FileExists($7z_amd) Then
				MsgBox(64, "TalosAutoLauncher", "..\TalosAutoLauncher\Bin_AMD.7z NOT FOUND!")
			Else
				$7z_unpack_line = ' x -y -o' & '"' & @TempDir & '\TTP_xdelta' & '"' & ' ' & '"' & $7z_amd & '"' & ' ' & '"' & $ini_cpu_forced & '\*' & '"'
				ShellExecuteWait("7za.exe", $7z_unpack_line, @AppDataCommonDir & "\SalFisher47\7za", "", @SW_HIDE)
				$xdelta_patch_line_talos = ' -d -s ' & '"' & @ScriptDir & '\Talos.exe' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos - ' & $ini_cpu_forced & '.xd3' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos.exe' & '"'
				RunWait(@AppDataCommonDir & "\SalFisher47\xd3\xd3.exe" & $xdelta_patch_line_talos, @AppDataCommonDir & "\SalFisher47\xd3", @SW_HIDE)
				$xdelta_patch_line_talos_unrestricted = ' -d -s ' & '"' & @ScriptDir & '\Talos_Unrestricted.exe' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted - ' & $ini_cpu_forced & '.xd3' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted.exe' & '"'
				RunWait(@AppDataCommonDir & "\SalFisher47\xd3\xd3.exe" & $xdelta_patch_line_talos_unrestricted, @AppDataCommonDir & "\SalFisher47\xd3", @SW_HIDE)
				FileCopy(@TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos.exe', @ScriptDir & '\Talos.exe', 1)
				FileCopy(@TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted.exe', @ScriptDir & '\Talos_Unrestricted.exe', 1)
				DirRemove(@TempDir & '\TTP_xdelta', 1)
				IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_patched", " " & $ini_cpu_forced)
			EndIf
			; patched exes
			If StringInStr($ini_cpu_forced, $ini_cpu_detected) Then
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "Executables PATCHED for your CPU: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You should hear Elohim's voice and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			Else
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "Executables PATCHED for this CPU: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You might not hear Elohim's voice and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			EndIf
			If $MsgBox == 6 Then
				ShellExecute(@ScriptDir & "\TalosLauncher.exe", $CmdLineRaw, @ScriptDir)
				Exit
			ElseIf $MsgBox == 7 Then
				Exit
			EndIf
		ElseIf $cpu_status == 2 Then
		; exes CAN'T BE patched for this cpu
			IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_forced", " AMD FX 8350")
			; wrote cpu_forced to TalosAutoLauncher.ini
			$7z_unpack_line = ' x -y -o' & '"' & @ScriptDir & '"' & ' ' & '"' & $7z_backup & '"' & ' ' & '"' & '*' & '"'
			ShellExecuteWait("7za.exe", $7z_unpack_line, @AppDataCommonDir & "\SalFisher47\7za", "", @SW_HIDE)
			; unpacked exes to be patched by xdelta3
			If Not FileExists($7z_amd) Then
				MsgBox(64, "TalosAutoLauncher", "..\TalosAutoLauncher\Bin_AMD.7z NOT FOUND!")
			Else
				$7z_unpack_line = ' x -y -o' & '"' & @TempDir & '\TTP_xdelta' & '"' & ' ' & '"' & $7z_amd & '"' & ' ' & '"' & $ini_cpu_forced & '\*' & '"'
				ShellExecuteWait("7za.exe", $7z_unpack_line, @AppDataCommonDir & "\SalFisher47\7za", "", @SW_HIDE)
				$xdelta_patch_line_talos = ' -d -s ' & '"' & @ScriptDir & '\Talos.exe' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos - ' & $ini_cpu_forced & '.xd3' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos.exe' & '"'
				RunWait(@AppDataCommonDir & "\SalFisher47\xd3\xd3.exe" & $xdelta_patch_line_talos, @AppDataCommonDir & "\SalFisher47\xd3", @SW_HIDE)
				$xdelta_patch_line_talos_unrestricted = ' -d -s ' & '"' & @ScriptDir & '\Talos_Unrestricted.exe' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted - ' & $ini_cpu_forced & '.xd3' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted.exe' & '"'
				RunWait(@AppDataCommonDir & "\SalFisher47\xd3\xd3.exe" & $xdelta_patch_line_talos_unrestricted, @AppDataCommonDir & "\SalFisher47\xd3", @SW_HIDE)
				FileCopy(@TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos.exe', @ScriptDir & '\Talos.exe', 1)
				FileCopy(@TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted.exe', @ScriptDir & '\Talos_Unrestricted.exe', 1)
				DirRemove(@TempDir & '\TTP_xdelta', 1)
				IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_patched", " AMD FX 8350")
			EndIf
			; patched exes
			If StringInStr($ini_cpu_forced, $ini_cpu_detected) Then
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "It seems your CPU is not supported: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"Executables PATCHED for AMD FX 8350..." & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You won't hear Elohim's voce and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			Else
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "It seems this CPU is not supported: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"Executables PATCHED for AMD FX 8350..." & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You won't hear Elohim's voce and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			EndIf
			If $MsgBox == 6 Then
				ShellExecute(@ScriptDir & "\TalosLauncher.exe", $CmdLineRaw, @ScriptDir)
				Exit
			ElseIf $MsgBox == 7 Then
				Exit
			EndIf
		EndIf
	Else
	; detected cpu is Intel
		$reg_cpu = StringReplace($reg_cpu, "+", "")
		$reg_cpu = StringReplace($reg_cpu, "-", " ")
		$reg_cpu = StringReplace($reg_cpu, "Genuine", "")
		$reg_cpu = StringReplace($reg_cpu, "Dual Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Triple Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Quad Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Six Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Eight Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Mobile", "")
		$reg_cpu = StringReplace($reg_cpu, "Processor", "")
		$reg_cpu = StringReplace($reg_cpu, "CPU", "")
		$reg_cpu = StringReplace($reg_cpu, "APU", "")
		$reg_cpu = StringReplace($reg_cpu, "with", "")
		$reg_cpu = StringReplace($reg_cpu, "Radeon", "")
		$reg_cpu = StringReplace($reg_cpu, "HD", "")
		$reg_cpu = StringReplace($reg_cpu, "Graphics", "")
		$reg_cpu = StringReplace($reg_cpu, "(ES)", "")
		$reg_cpu = StringReplace($reg_cpu, "    ", " ")
		$reg_cpu = StringReplace($reg_cpu, "   ", " ")
		$reg_cpu = StringReplace($reg_cpu, "  ", " ")
		If StringInStr($reg_cpu, " @ ") Then
			$reg_cpu = StringLeft($reg_cpu, StringInStr($reg_cpu, " @ ") + StringLen(" @ ") - 4) ; remove ' @ x.xx GHz' from cpu name
		EndIf
		If StringLeft($reg_cpu, 1) == " " Then
			$reg_cpu = StringTrimLeft($reg_cpu, 1)
		EndIf
		If StringRight($reg_cpu, 1) == " " Then
			$reg_cpu = StringTrimRight($reg_cpu, 1)
		EndIf
		$reg_cpu_last6 = StringRight($reg_cpu, 6)
		$reg_cpu_first3_of_last6 = StringLeft($reg_cpu_last6, 3)
		If (StringLeft($reg_cpu_first3_of_last6, 1) == " ") And StringIsAlpha(StringTrimLeft(StringLeft($reg_cpu_first3_of_last6, 2), 1)) And (StringRight($reg_cpu_first3_of_last6, 1) == " ") Then
			If StringRight(StringTrimRight($reg_cpu, 6), 7) <> "Pentium" Then
				$reg_cpu = StringTrimRight($reg_cpu, 6) & " " & StringRight($reg_cpu_last6, 3) & StringTrimLeft(StringLeft($reg_cpu_first3_of_last6, 2), 1) ; replace ' M xyz' with ' xyzM'
			EndIf
		EndIf
		; finished processing registry cpu name
		If $ini_cpu_detected <> $reg_cpu Then
			IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_detected", " " & $reg_cpu)
			$ini_cpu_detected = $reg_cpu
			$ini_cpu_forced = $ini_cpu_detected
		EndIf
		$cpu_count = _FileCountLines(@ScriptDir & "\TalosAutoLauncher\Bin_Intel.txt")
		$hFile = FileOpen(@ScriptDir & "\TalosAutoLauncher\Bin_Intel.txt")
		For $i = 1 to $cpu_count
			_ArrayAdd($bin_intel_array, FileReadLine($hFile, $i))
		Next
		FileClose($hFile)
		For $j = 1 to $cpu_count
			If StringInStr($bin_intel_array[$j], $ini_cpu_forced) Then
				For $k = 0 To 4
					$ini_cpu_forced_temp = $bin_intel_array[$j+$k]
					If StringInStr($ini_cpu_forced_temp, $ini_cpu_forced) Then
						$ini_cpu_forced_temp = $bin_intel_array[$j+$k]
						$bin_intel_number = $j+$k
						$cpu_status = 1 ; exes can be patched for this cpu
						ExitLoop
					EndIf
				Next
			Else
				$ini_cpu_forced_temp = "AMD FX 8350"
				$cpu_status = 2 ; exes can't be patched for this cpu
			EndIf
			If $cpu_status == 1 Then
				ExitLoop
			EndIf
		Next
		$ini_cpu_forced = $ini_cpu_forced_temp
		If $ini_cpu_forced_orig == "" Then
			$ini_cpu_forced_orig = $ini_cpu_detected
		EndIf
		If $cpu_status == 1 Then
		; exes CAN BE patched for this cpu
			IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_forced", " " & $ini_cpu_forced)
			; wrote cpu_forced to TalosAutoLauncher.ini
			$7z_unpack_line = ' x -y -o' & '"' & @ScriptDir & '"' & ' ' & '"' & $7z_backup & '"' & ' ' & '"' & '*' & '"'
			ShellExecuteWait("7za.exe", $7z_unpack_line, @AppDataCommonDir & "\SalFisher47\7za", "", @SW_HIDE)
			; unpacked exes to be patched by xdelta3
			If Not FileExists($7z_intel) Then
				MsgBox(64, "TalosAutoLauncher", "..\TalosAutoLauncher\Bin_Intel.7z NOT FOUND!")
			Else
				$7z_unpack_line = ' x -y -o' & '"' & @TempDir & '\TTP_xdelta' & '"' & ' ' & '"' & $7z_intel & '"' & ' ' & '"' & $ini_cpu_forced & '\*' & '"'
				ShellExecuteWait("7za.exe", $7z_unpack_line, @AppDataCommonDir & "\SalFisher47\7za", "", @SW_HIDE)
				$xdelta_patch_line_talos = ' -d -s ' & '"' & @ScriptDir & '\Talos.exe' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos - ' & $ini_cpu_forced & '.xd3' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos.exe' & '"'
				RunWait(@AppDataCommonDir & "\SalFisher47\xd3\xd3.exe" & $xdelta_patch_line_talos, @AppDataCommonDir & "\SalFisher47\xd3", @SW_HIDE)
				$xdelta_patch_line_talos_unrestricted = ' -d -s ' & '"' & @ScriptDir & '\Talos_Unrestricted.exe' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted - ' & $ini_cpu_forced & '.xd3' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted.exe' & '"'
				RunWait(@AppDataCommonDir & "\SalFisher47\xd3\xd3.exe" & $xdelta_patch_line_talos_unrestricted, @AppDataCommonDir & "\SalFisher47\xd3", @SW_HIDE)
				FileCopy(@TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos.exe', @ScriptDir & '\Talos.exe', 1)
				FileCopy(@TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted.exe', @ScriptDir & '\Talos_Unrestricted.exe', 1)
				DirRemove(@TempDir & '\TTP_xdelta', 1)
				IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_patched", " " & $ini_cpu_forced)
			EndIf
			; patched exes
			If StringInStr($ini_cpu_forced, $ini_cpu_detected) Then
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "Executables PATCHED for your CPU: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You should hear Elohim's voice and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			Else
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "Executables PATCHED for this CPU: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You might not hear Elohim's voice and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			EndIf
			If $MsgBox == 6 Then
				ShellExecute(@ScriptDir & "\TalosLauncher.exe", $CmdLineRaw, @ScriptDir)
				Exit
			ElseIf $MsgBox == 7 Then
				Exit
			EndIf
		ElseIf $cpu_status == 2 Then
		; exes CAN'T BE patched for this cpu
			IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_forced", " AMD FX 8350")
			; wrote cpu_forced to TalosAutoLauncher.ini
			$7z_unpack_line = ' x -y -o' & '"' & @ScriptDir & '"' & ' ' & '"' & $7z_backup & '"' & ' ' & '"' & '*' & '"'
			ShellExecuteWait("7za.exe", $7z_unpack_line, @AppDataCommonDir & "\SalFisher47\7za", "", @SW_HIDE)
			; unpacked exes to be patched by xdelta3
			If Not FileExists($7z_intel) Then
				MsgBox(64, "TalosAutoLauncher", "..\TalosAutoLauncher\Bin_Intel.7z NOT FOUND!")
			Else
				$7z_unpack_line = ' x -y -o' & '"' & @TempDir & '\TTP_xdelta' & '"' & ' ' & '"' & $7z_intel & '"' & ' ' & '"' & $ini_cpu_forced & '\*' & '"'
				ShellExecuteWait("7za.exe", $7z_unpack_line, @AppDataCommonDir & "\SalFisher47\7za", "", @SW_HIDE)
				$xdelta_patch_line_talos = ' -d -s ' & '"' & @ScriptDir & '\Talos.exe' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos - ' & $ini_cpu_forced & '.xd3' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos.exe' & '"'
				RunWait(@AppDataCommonDir & "\SalFisher47\xd3\xd3.exe" & $xdelta_patch_line_talos, @AppDataCommonDir & "\SalFisher47\xd3", @SW_HIDE)
				$xdelta_patch_line_talos_unrestricted = ' -d -s ' & '"' & @ScriptDir & '\Talos_Unrestricted.exe' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted - ' & $ini_cpu_forced & '.xd3' & '"' & ' ' & '"' & @TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted.exe' & '"'
				RunWait(@AppDataCommonDir & "\SalFisher47\xd3\xd3.exe" & $xdelta_patch_line_talos_unrestricted, @AppDataCommonDir & "\SalFisher47\xd3", @SW_HIDE)
				FileCopy(@TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos.exe', @ScriptDir & '\Talos.exe', 1)
				FileCopy(@TempDir & '\TTP_xdelta\' & $ini_cpu_forced & '\Talos_Unrestricted.exe', @ScriptDir & '\Talos_Unrestricted.exe', 1)
				DirRemove(@TempDir & '\TTP_xdelta', 1)
				IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_patched", " AMD FX 8350")
			EndIf
			; patched exes
			If StringInStr($ini_cpu_forced, $ini_cpu_detected) Then
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "It seems your CPU is not supported: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"Executables PATCHED for AMD FX 8350..." & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You won't hear Elohim's voce and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			Else
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "It seems this CPU is not supported: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"Executables PATCHED for AMD FX 8350..." & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You won't hear Elohim's voce and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			EndIf
			If $MsgBox == 6 Then
				ShellExecute(@ScriptDir & "\TalosLauncher.exe", $CmdLineRaw, @ScriptDir)
				Exit
			ElseIf $MsgBox == 7 Then
				Exit
			EndIf
		EndIf
	EndIf
ElseIf $ini_cpu_forced == $ini_cpu_patched Then
; cpu_forced == cpu_patched (exes HAVE BEEN patched for cpu_forced - no need to be patched again)
	$reg_cpu = RegRead("HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "ProcessorNameString")
	$reg_cpu = StringReplace($reg_cpu, "(tm)", "-")
	$reg_cpu = StringReplace($reg_cpu, "™", "-")
	$reg_cpu = StringReplace($reg_cpu, "(r)", "-")
	$reg_cpu = StringReplace($reg_cpu, "®", "-")
	If StringInStr($reg_cpu, "AMD") Then
	; detected cpu is AMD
		$reg_cpu = StringReplace($reg_cpu, "+", "")
		$reg_cpu = StringReplace($reg_cpu, "-", " ")
		$reg_cpu = StringReplace($reg_cpu, "Genuine", "")
		$reg_cpu = StringReplace($reg_cpu, "Dual Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Triple Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Quad Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Six Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Eight Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Mobile", "")
		$reg_cpu = StringReplace($reg_cpu, "Processor", "")
		$reg_cpu = StringReplace($reg_cpu, "CPU", "")
		$reg_cpu = StringReplace($reg_cpu, "APU", "")
		$reg_cpu = StringReplace($reg_cpu, "with", "")
		$reg_cpu = StringReplace($reg_cpu, "Radeon", "")
		$reg_cpu = StringReplace($reg_cpu, "HD", "")
		$reg_cpu = StringReplace($reg_cpu, "Graphics", "")
		$reg_cpu = StringReplace($reg_cpu, "(ES)", "")
		$reg_cpu = StringReplace($reg_cpu, "    ", " ")
		$reg_cpu = StringReplace($reg_cpu, "   ", " ")
		$reg_cpu = StringReplace($reg_cpu, "  ", " ")
		If StringInStr($reg_cpu, " @ ") Then
			$reg_cpu = StringLeft($reg_cpu, StringInStr($reg_cpu, " @ ") + StringLen(" @ ") - 4) ; remove ' @ x.xx GHz' from cpu name
		EndIf
		If StringLeft($reg_cpu, 1) == " " Then
			$reg_cpu = StringTrimLeft($reg_cpu, 1)
		EndIf
		If StringRight($reg_cpu, 1) == " " Then
			$reg_cpu = StringTrimRight($reg_cpu, 1)
		EndIf
		;$reg_cpu_last6 = StringRight($reg_cpu, 6)
		;$reg_cpu_first3_of_last6 = StringLeft($reg_cpu_last6, 3)
		;If (StringLeft($reg_cpu_first3_of_last6, 1) == " ") And StringIsAlpha(StringTrimLeft(StringLeft($reg_cpu_first3_of_last6, 2), 1)) And (StringRight($reg_cpu_first3_of_last6, 1) == " ") Then
		;	If StringRight(StringTrimRight($reg_cpu, 6), 7) <> "Pentium" Then
		;		$reg_cpu = StringTrimRight($reg_cpu, 6) & " " & StringRight($reg_cpu_last6, 3) & StringTrimLeft(StringLeft($reg_cpu_first3_of_last6, 2), 1) ; replace ' M xyz' with ' xyzM'
		;	EndIf
		;EndIf
		; finished processing registry cpu name
		If $ini_cpu_detected <> $reg_cpu Then
			IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_detected", " " & $reg_cpu)
			$ini_cpu_detected = $reg_cpu
		EndIf
		If $ini_cpu_forced_orig == "" Then
			$ini_cpu_forced_orig = $ini_cpu_detected
		EndIf
		If $ini_msg == 1 Then
			If StringInStr($ini_cpu_forced, $ini_cpu_detected) Then
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "Executables COMPATIBLE with your CPU: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You should hear Elohim's voice and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			Else
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "Executables COMPATIBLE with this CPU: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You might not hear Elohim's voice and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			EndIf
			If $MsgBox == 6 Then
				ShellExecute(@ScriptDir & "\TalosLauncher.exe", $CmdLineRaw, @ScriptDir)
				Exit
			ElseIf $MsgBox == 7 Then
				Exit
			EndIf
		ElseIf $ini_msg == 0 Then
			ShellExecute(@ScriptDir & "\TalosLauncher.exe", $CmdLineRaw, @ScriptDir)
			Exit
		EndIf
	Else
	; detected cpu is Intel
		$reg_cpu = StringReplace($reg_cpu, "+", "")
		$reg_cpu = StringReplace($reg_cpu, "-", " ")
		$reg_cpu = StringReplace($reg_cpu, "Genuine", "")
		$reg_cpu = StringReplace($reg_cpu, "Dual Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Triple Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Quad Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Six Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Eight Core", "")
		$reg_cpu = StringReplace($reg_cpu, "Mobile", "")
		$reg_cpu = StringReplace($reg_cpu, "Processor", "")
		$reg_cpu = StringReplace($reg_cpu, "CPU", "")
		$reg_cpu = StringReplace($reg_cpu, "APU", "")
		$reg_cpu = StringReplace($reg_cpu, "with", "")
		$reg_cpu = StringReplace($reg_cpu, "Radeon", "")
		$reg_cpu = StringReplace($reg_cpu, "HD", "")
		$reg_cpu = StringReplace($reg_cpu, "Graphics", "")
		$reg_cpu = StringReplace($reg_cpu, "(ES)", "")
		$reg_cpu = StringReplace($reg_cpu, "    ", " ")
		$reg_cpu = StringReplace($reg_cpu, "   ", " ")
		$reg_cpu = StringReplace($reg_cpu, "  ", " ")
		If StringInStr($reg_cpu, " @ ") Then
			$reg_cpu = StringLeft($reg_cpu, StringInStr($reg_cpu, " @ ") + StringLen(" @ ") - 4) ; remove ' @ x.xx GHz' from cpu name
		EndIf
		If StringLeft($reg_cpu, 1) == " " Then
			$reg_cpu = StringTrimLeft($reg_cpu, 1)
		EndIf
		If StringRight($reg_cpu, 1) == " " Then
			$reg_cpu = StringTrimRight($reg_cpu, 1)
		EndIf
		$reg_cpu_last6 = StringRight($reg_cpu, 6)
		$reg_cpu_first3_of_last6 = StringLeft($reg_cpu_last6, 3)
		If (StringLeft($reg_cpu_first3_of_last6, 1) == " ") And StringIsAlpha(StringTrimLeft(StringLeft($reg_cpu_first3_of_last6, 2), 1)) And (StringRight($reg_cpu_first3_of_last6, 1) == " ") Then
			If StringRight(StringTrimRight($reg_cpu, 6), 7) <> "Pentium" Then
				$reg_cpu = StringTrimRight($reg_cpu, 6) & " " & StringRight($reg_cpu_last6, 3) & StringTrimLeft(StringLeft($reg_cpu_first3_of_last6, 2), 1) ; replace ' M xyz' with ' xyzM'
			EndIf
		EndIf
		; finished processing registry cpu name
		If $ini_cpu_detected <> $reg_cpu Then
			IniWrite(@ScriptDir & "\TalosAutoLauncher.ini", "Settings", "cpu_detected", " " & $reg_cpu)
			$ini_cpu_detected = $reg_cpu
		EndIf
		If $ini_cpu_forced_orig == "" Then
			$ini_cpu_forced_orig = $ini_cpu_detected
		EndIf
		If $ini_msg == 1 Then
			If StringInStr($ini_cpu_forced, $ini_cpu_detected) Then
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "Executables COMPATIBLE with your CPU: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You should hear Elohim's voice and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			Else
				$MsgBox = MsgBox(68, "TalosAutoLauncher", "Executables COMPATIBLE with this CPU: " & @CRLF & "---> " & $ini_cpu_forced_orig & @CRLF & @CRLF & _
								"To patch them for other CPUs, edit cpu_forced in TalosAutoLauncher.ini, then run this again..." & @CRLF & @CRLF & _
								"You might not hear Elohim's voice and see puzzle names..." & @CRLF & "Play The Talos Principle now?")
			EndIf
			If $MsgBox == 6 Then
				ShellExecute(@ScriptDir & "\TalosLauncher.exe", $CmdLineRaw, @ScriptDir)
				Exit
			ElseIf $MsgBox == 7 Then
				Exit
			EndIf
		ElseIf $ini_msg == 0 Then
			ShellExecute(@ScriptDir & "\TalosLauncher.exe", $CmdLineRaw, @ScriptDir)
			Exit
		EndIf
	EndIf
EndIf
