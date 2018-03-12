#Include Once "file.bi"

Const APPVERSION As String = "2018.03.12"

Function ReplaceFilenameUmlaute(ByVal ConvertString As String) As String
	Dim As String OutString=ConvertString
	For i As Integer=0 To Len(OutString)-1
		Select Case OutString[i]
			Case 129: OutString[i]= 252 ' ü
			Case 132: OutString[i]= 228 ' ä
			Case 142: OutString[i]= 196 ' Ä
			Case 148: OutString[i]= 246 ' ö
			Case 153: OutString[i]= 214 ' Ö
			Case 154: OutString[i]= 220 ' Ü
			Case 225: OutString[i]= 223 ' ß
		End Select
	Next i
	Return OutString
End Function

Sub sortStringArray(arr() As String)
	Dim As Integer i, j
	
	For i = LBound(arr) To UBound(arr) -1
		For j = i + 1 To UBound(arr)
			If arr(i) <> "" And arr(j) <> "" Then
				If arr(i) > arr(j) Then
					'Print i & ": SWAP(" & arr(i) & ", " & arr(j) & ")"
					Swap arr(i), arr(j)
				EndIf
			EndIf
		Next
	Next
End Sub

Dim As Integer f, p, do_create, do_check, grpIdx
Dim As String cmd, s, grpname, script, oldscript
Dim As String groupArray(99)

Print "GrpLogon by M. Lindner - Version " & APPVERSION
Print

Select Case LCase(Command())
	Case "help", "/help", "-help", "--help", "/?", "-?"
		Print "Usage  : GrpLogon <Option>"
		Print
		Print "Options: help   > this help"
		Print "         create > create empty scripts, if not exists"
		Print "         check  > check, if a script exists"
		Print
		Print "Example: GrpLogon /create"
		Print
		End
	
	Case "create", "/create", "-create"
		do_create = 1
	
	Case "check", "/check", "-check"
		do_check = 1
End Select

cmd = "net user %USERNAME% /domain"

f = FreeFile
Open Pipe cmd For Input As #f
	Do Until Eof(f)
	   Line Input #f, s
	   
	   If s <> "" Then
	   	p = InStr(s, "*")
	   	
	   	If p > 0 Then
	   		grpname = Trim(Mid(s, p + 1))
	   		
	   		groupArray(grpIdx) = grpname
	   		grpIdx += 1
	   	EndIf
	   EndIf
	Loop
Close #f

'##########

sortStringArray(groupArray())

'##########

For grpIdx = 0 To 99
	If groupArray(grpIdx) <> "" Then
		'Print grpIdx & " > " & groupArray(grpIdx)
		oldscript = ExePath & "\" & ReplaceFilenameUmlaute(groupArray(grpIdx)) & ".bat"
		script = ExePath & "\grp_" & ReplaceFilenameUmlaute(groupArray(grpIdx)) & ".bat"
		
		If FileExists(script) <= -1 Then
			If do_check = 1 Then
   			Color 6,0
   			Print "found    : " & script
   			Color 7,0
			Else
   			Color 6,0
   			Print "execute  : " & script
   			Color 7,0
   			Shell script
			EndIf
		Else
			If do_create = 1 Then
   			Color 6,0
   			Print "create   : " & script
   			Color 7,0
   			
   			Open script For Output As #22
   				Print #22, "@echo off"
   			Close #22
			Else
				Print "not found: " & script
			EndIf
		EndIf
		
		If FileExists(oldscript) <= -1 Then
			If do_check <> 1 Then
   			Color 12,0
   			Print "execute  : " & script
   			Color 7,0
   			Shell oldscript
			EndIf
		EndIf
	EndIf
Next

'Print
'Print "key..."
'Sleep 3000
