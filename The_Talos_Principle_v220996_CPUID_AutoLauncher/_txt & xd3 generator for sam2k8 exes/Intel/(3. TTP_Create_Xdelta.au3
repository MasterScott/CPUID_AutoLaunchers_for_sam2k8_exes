#include <array.au3>
#include <file.au3>

$TTP_original = @ScriptDir & "\Xdelta\TTP_Original\Bin"
$TTP_update = @ScriptDir & "\Bin_Intel"
$TTP_xdelta = @ScriptDir & "\Xdelta\TTP_xdelta\Bin_Intel"

$xdelta_exe = @ScriptDir & "\Xdelta\xdelta3-x86-32.exe"

$Talos_original = $TTP_original & "\Talos.exe"
$Talos_Unrestricted_original = $TTP_original & "\Talos_Unrestricted.exe"

$TTP_update_array = _FileListToArray($TTP_update, "*", 2)
$TTP_update_array_count = UBound($TTP_update_array)-1

$CPUTxt = @ScriptDir & "\Xdelta\TTP_xdelta\Intel_Supported_CPUs.txt"
$CheckCPUTxt = _CheckCPUTxt()
Local $CPU_array[1]

For $i = 1 To $TTP_update_array_count

	DirCreate($TTP_xdelta & '\' & $TTP_update_array[$i])
	RunWait($xdelta_exe & ' -e -9 -s ' & '"' & $Talos_original & '"' & ' ' & '"' & $TTP_update & '\' & $TTP_update_array[$i] & '\Talos - ' & $TTP_update_array[$i] & '.exe' & '"' & ' ' & '"' & $TTP_xdelta & '\' & $TTP_update_array[$i] & '\Talos - ' & $TTP_update_array[$i] & '.xd3' & '"', @ScriptDir, @SW_HIDE)
	RunWait($xdelta_exe & ' -e -9 -s ' & '"' & $Talos_Unrestricted_original & '"' & ' ' & '"' & $TTP_update & '\' & $TTP_update_array[$i] & '\Talos_Unrestricted - ' & $TTP_update_array[$i] & '.exe' & '"' & ' ' & '"' & $TTP_xdelta & '\' & $TTP_update_array[$i] & '\Talos_Unrestricted - ' & $TTP_update_array[$i] & '.xd3' & '"', @ScriptDir, @SW_HIDE)

Next

MsgBox(64, "TTP", "Finished")

If Not StringInStr(FileGetAttrib(@AutoItExe), "R") Then
	If Not FileExists($CPUTxt) Then
		$hFile = FileOpen($CPUTxt, 1) ; open 'cpu.txt' in WRITE mode (append to end of file)
		For $i=1 To $TTP_update_array_count
			FileWriteLine($CPUTxt, $TTP_update_array[$i])
		Next
		FileClose($hFile)
	Else
		If $CheckCPUTxt == "INVALID" Then
			$hFile = FileOpen($CPUTxt, 2) ; open 'cpu.txt' in WRITE mode (erase previous contents)
			For $i=1 To $TTP_update_array_count
				FileWriteLine($CPUTxt, $TTP_update_array[$i])
			Next
			FileClose($hFile)
		EndIf
	EndIf
Else
	; do nothing
EndIf

Func _CheckCPUTxt()
	$hFile = FileOpen($CPUTxt, 0) ; open 'cpu.txt' in READ mode
	For $i=1 to $TTP_update_array_count
		If FileReadLine($CPUTxt, $i) <> $TTP_update_array[$i] Then
			FileClose($hFile)
			Return "INVALID"
		EndIf
	Next
	FileClose($hFile)
	Return "VALID"
EndFunc
