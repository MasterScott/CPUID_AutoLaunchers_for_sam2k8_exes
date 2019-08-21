#include <array.au3>
#include <file.au3>

$DRT_original = @ScriptDir & "\Xdelta\DRT_Original"
$DRT_update = @ScriptDir & "\Bin_AMD"
$DRT_xdelta = @ScriptDir & "\Xdelta\DRT_xdelta\Bin_AMD"

$xdelta_exe = @ScriptDir & "\Xdelta\xdelta3-x86-32.exe"

$drt_original = $DRT_original & "\drt.exe"

$DRT_update_array = _FileListToArray($DRT_update, "*", 2)
$DRT_update_array_count = UBound($DRT_update_array)-1

$CPUTxt = @ScriptDir & "\Xdelta\DRT_xdelta\AMD_Supported_CPUs.txt"
;$CheckCPUTxt = _CheckCPUTxt()
Local $CPU_array[1]

For $i = 1 To $DRT_update_array_count

	$DRT_update_name = FileReadLine($DRT_update & '\' & $DRT_update_array[$i] & "\" & $DRT_update_array[$i] & ".txt", 1)
	DirCreate($DRT_xdelta & '\' & $DRT_update_name)
	RunWait($xdelta_exe & ' -e -9 -s ' & '"' & $drt_original & '"' & ' ' & '"' & $DRT_update & '\' & $DRT_update_array[$i] & '\drt.exe' & '"' & ' ' & '"' & $DRT_xdelta & '\' & $DRT_update_name & '\drt - ' & $DRT_update_name & '.xd3' & '"', @ScriptDir, @SW_HIDE)
	$hFile = FileOpen($CPUTxt, 1) ; open 'cpu.txt' in WRITE mode (append to end of file)
	FileWriteLine($CPUTxt, $DRT_update_name)
	FileClose($hFile)
Next

MsgBox(64, "DRT", "Finished")

#cs
If Not StringInStr(FileGetAttrib(@AutoItExe), "R") Then
	If Not FileExists($CPUTxt) Then
		$hFile = FileOpen($CPUTxt, 1) ; open 'cpu.txt' in WRITE mode (append to end of file)
		For $i=1 To $DRT_update_array_count
			FileWriteLine($CPUTxt, $DRT_update_array[$i])
		Next
		FileClose($hFile)
	Else
		If $CheckCPUTxt == "INVALID" Then
			$hFile = FileOpen($CPUTxt, 2) ; open 'cpu.txt' in WRITE mode (erase previous contents)
			For $i=1 To $DRT_update_array_count
				FileWriteLine($CPUTxt, $DRT_update_array[$i])
			Next
			FileClose($hFile)
		EndIf
	EndIf
Else
	; do nothing
EndIf

Func _CheckCPUTxt()
	$hFile = FileOpen($CPUTxt, 0) ; open 'cpu.txt' in READ mode
	For $i=1 to $DRT_update_array_count
		If FileReadLine($CPUTxt, $i) <> $DRT_update_array[$i] Then
			FileClose($hFile)
			Return "INVALID"
		EndIf
	Next
	FileClose($hFile)
	Return "VALID"
EndFunc
#ce
