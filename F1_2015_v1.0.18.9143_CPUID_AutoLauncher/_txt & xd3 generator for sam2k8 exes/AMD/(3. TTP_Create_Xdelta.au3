#include <array.au3>
#include <file.au3>

$F1_original = @ScriptDir & "\Xdelta\F1_Original"
$F1_update = @ScriptDir & "\Bin_AMD"
$F1_xdelta = @ScriptDir & "\Xdelta\F1_xdelta\Bin_AMD"

$xdelta_exe = @ScriptDir & "\Xdelta\xdelta3-x86-32.exe"

$F1_original = $F1_original & "\F1_2015.exe"

$F1_update_array = _FileListToArray($F1_update, "*", 2)
$F1_update_array_count = UBound($F1_update_array)-1

$CPUTxt = @ScriptDir & "\Xdelta\F1_xdelta\AMD_Supported_CPUs.txt"
;$CheckCPUTxt = _CheckCPUTxt()
Local $CPU_array[1]

For $i = 1 To $F1_update_array_count

	$F1_update_name = FileReadLine($F1_update & '\' & $F1_update_array[$i] & "\" & $F1_update_array[$i] & ".txt", 1)
	DirCreate($F1_xdelta & '\' & $F1_update_name)
	RunWait($xdelta_exe & ' -e -9 -s ' & '"' & $F1_original & '"' & ' ' & '"' & $F1_update & '\' & $F1_update_array[$i] & '\F1_2015.exe' & '"' & ' ' & '"' & $F1_xdelta & '\' & $F1_update_name & '\F1_2015 - ' & $F1_update_name & '.xd3' & '"', @ScriptDir, @SW_HIDE)
	$hFile = FileOpen($CPUTxt, 1) ; open 'cpu.txt' in WRITE mode (append to end of file)
	FileWriteLine($CPUTxt, $F1_update_name)
	FileClose($hFile)
Next

MsgBox(64, "F1", "Finished")

#cs
If Not StringInStr(FileGetAttrib(@AutoItExe), "R") Then
	If Not FileExists($CPUTxt) Then
		$hFile = FileOpen($CPUTxt, 1) ; open 'cpu.txt' in WRITE mode (append to end of file)
		For $i=1 To $F1_update_array_count
			FileWriteLine($CPUTxt, $F1_update_array[$i])
		Next
		FileClose($hFile)
	Else
		If $CheckCPUTxt == "INVALID" Then
			$hFile = FileOpen($CPUTxt, 2) ; open 'cpu.txt' in WRITE mode (erase previous contents)
			For $i=1 To $F1_update_array_count
				FileWriteLine($CPUTxt, $F1_update_array[$i])
			Next
			FileClose($hFile)
		EndIf
	EndIf
Else
	; do nothing
EndIf

Func _CheckCPUTxt()
	$hFile = FileOpen($CPUTxt, 0) ; open 'cpu.txt' in READ mode
	For $i=1 to $F1_update_array_count
		If FileReadLine($CPUTxt, $i) <> $F1_update_array[$i] Then
			FileClose($hFile)
			Return "INVALID"
		EndIf
	Next
	FileClose($hFile)
	Return "VALID"
EndFunc
#ce
