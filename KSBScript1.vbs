Dim WshShell
Set WshShell = CreateObject("WScript.Shell")

Function Online()
	Dim AllProcess 
	Dim Process 
	Set AllProcess = getobject("winmgmts:") 'create object 

	kff=False
	ksb=False
	Online=1

	For Each Process In AllProcess.InstancesOf("Win32_process") 
		If (ksb=false AND (Instr (Ucase(Process.ExecutablePath),"C:\KSB\BIN\WRAPPER.EXE") = 1)) Then 
			ksb = True
		ElseIf  (kff=false AND Instr (Ucase(Process.ExecutablePath),"C:\JDK\BIN\JAVA") = 1) Then
			kff = True
		 
		End If	
	Next 

	Set AllProcess = nothing

	If (kff = True AND ksb = False ) Then
		Online =0
  		RunCommand "net start kff_ksb(2.2.1)", True
	End If
End Function


Function Open()
	Open = 0
End Function


Function Offline()
	RunCommand "net stop kff_ksb(2.2.1)", True
  	offline = 0
End Function


Function Close()
	Close = 0
End Function


Function LooksAlive()
	LooksAlive = 0
End Function


Function IsAlive()
	Dim AllProcess 
	Dim Process 
	Set AllProcess = getobject("winmgmts:") 'create object 

	kff=False
	ksb=False
	IsAlive=1

	For Each Process In AllProcess.InstancesOf("Win32_process") 
		If (ksb=false AND (Instr (Ucase(Process.ExecutablePath),"C:\KSB\BIN\WRAPPER.EXE") = 1)) Then 
			ksb = True
		ElseIf  (kff=false AND Instr (Ucase(Process.ExecutablePath),"C:\JDK\BIN\JAVA") = 1) Then
			kff = True
		 
		End If	
	Next 
	Set AllProcess = nothing

	If (kff = True AND ksb = True) Then
		IsAlive =0
	End If
End Function



Function Terminate( )
	RunCommand "net stop kff_ksb(2.2.1)", True
	Terminate = 0
End Function


Function RunCommand(command, wait)
	RunCommand = WshShell.Run(command, 1, wait)
End Function






