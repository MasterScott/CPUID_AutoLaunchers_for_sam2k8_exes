#include<array.au3>
#include<file.au3>

$TTP_Crack = _FileListToArray(@ScriptDir, "*.7z", 1)
$TTP_Crack_count = UBound($TTP_Crack)-1

For $i=1 To $TTP_Crack_count
	If Not FileExists(@ScriptDir & "\" & StringTrimRight($TTP_Crack[$i], 3) & ".txt") Then
		$hFile = FileOpen(@ScriptDir & "\" & StringTrimRight($TTP_Crack[$i], 3) & ".txt", 1)
		FileWriteLine(@ScriptDir & "\" & StringTrimRight($TTP_Crack[$i], 3) & ".txt", StringTrimRight($TTP_Crack[$i], 3))
		FileClose($hFile)
	EndIf
Next
