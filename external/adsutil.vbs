''''''''''''''''''''''''''''''''''''
'
' ADSUTIL.VBS
'
' Date:   7/24/97
' Revision History:
'     Date         Comment
'    7/24/97       Initial version started
'    5/8/98        Bug fixes and ENUM_ALL
'    12/1/98       Fixed display error on list data.
'    7/27/99       AppCreate2 fix
'    8/5/99        Dont display encrypted data
''''''''''''''''''''''''''''''''''''
Option Explicit
On Error Resume Next

Const StrRes0	=	"COPY is not yet supported.  It will be soon."
Const StrRes1	=	"Command not recognized: "
Const StrRes2	=	"For help, just type ""Cscript.exe adsutil.vbs""."
Const StrRes3	=	"Usage:"
Const StrRes4	=	"      ADSUTIL.VBS <cmd> [<path> [<value>]]"
Const StrRes6	=	"Description:"
Const StrRes7	=	"IIS administration utility that enables the configuration of metabase properties."
Const StrRes9	=	"Supported Commands:"
Const StrRes12	=	"Samples:"
Const StrRes18	=	"For Extended Help type:"
Const StrRes19	=	"  adsutil.vbs HELP"
Const StrRes21	=	"      ADSUTIL.VBS CMD [param param]"
Const StrRes23	=	"Description:"
Const StrRes24	=	"IIS administration utility that enables the manipulation with ADSI parameters"
Const StrRes26	=	"Standard Commands:"
Const StrRes27	=	" adsutil.vbs GET      path             - display chosen parameter"
Const StrRes28	=	" adsutil.vbs SET      path value ...   - assign the new value"
Const StrRes29	=	" adsutil.vbs ENUM     path [""/P"" ]   - enumerate all parameters for given path"
Const StrRes30	=	" adsutil.vbs DELETE   path             - delete given path or parameter"
Const StrRes31	=	" adsutil.vbs CREATE   path [KeyType]   - create given path and assigns it the given KeyType"
Const StrRes32	=	" adsutil.vbs APPCREATEINPROC  w3svc/1/root - Create an in-proc application"
Const StrRes33	=	" adsutil.vbs APPCREATEOUTPROC w3svc/1/root - Create an out-proc application"
Const StrRes34	=	" adsutil.vbs APPCREATEPOOLPROC w3svc/1/root- Create a pooled-proc application"
Const StrRes35	=	" adsutil.vbs APPDELETE        w3svc/1/root - Delete the application if there is one"
Const StrRes36	=	" adsutil.vbs APPUNLOAD        w3svc/1/root - Unload an application from w3svc runtime lookup table."
Const StrRes37	=	" adsutil.vbs APPDISABLE       w3svc/1/root - Disable an application - appropriate for porting to another machine."
Const StrRes38	=	" adsutil.vbs APPENABLE        w3svc/1/root - Enable an application - appropriate for importing from another machine."
Const StrRes39	=	" adsutil.vbs APPGETSTATUS     w3svc/1/root - Get status of the application"
Const StrRes40	=	"New ADSI Options:"
Const StrRes41	=	" /P - Valid for ENUM only.  Enumerates the paths only (no data)"
Const StrRes42	=	" KeyType - Valide for CREATE only.  Assigns the valid KeyType to the path"
Const StrRes43	=	"Extended ADSUTIL Commands:"
Const StrRes44	=	" adsutil.vbs FIND             path     - find the paths where a given parameter is set"
Const StrRes45	=	" adsutil.vbs CREATE_VDIR      path     - create given path as a Virtual Directory"
Const StrRes46	=	" adsutil.vbs CREATE_VSERV     path     - create given path as a Virtual Server"
Const StrRes47	=	" adsutil.vbs START_SERVER     path     - starts the given web site"
Const StrRes48	=	" adsutil.vbs STOP_SERVER      path     - stops the given web site"
Const StrRes49	=	" adsutil.vbs PAUSE_SERVER     path     - pauses the given web site"
Const StrRes50	=	" adsutil.vbs CONTINUE_SERVER  path     - continues the given web site"
Const StrRes52	=	"  adsutil.vbs GET W3SVC/1/ServerBindings"
Const StrRes53	=	"  adsutil.vbs SET W3SVC/1/ServerBindings "":81:"""
Const StrRes54	=	"  adsutil.vbs CREATE W3SVC/1/Root/MyVdir ""IIsWebVirtualDir"""
Const StrRes55	=	"  adsutil.vbs START_SERVER W3SVC/1"
Const StrRes56	=	"  adsutil.vbs ENUM /P W3SVC"
Const StrRes57	=	"Extended ADSUTIL Commands:"
Const StrRes58	=	" adsutil.vbs FIND             path     - find the paths where a given parameter is set"
Const StrRes59	=	" adsutil.vbs CREATE_VDIR      path     - create given path as a Virtual Directory"
Const StrRes60	=	" adsutil.vbs CREATE_VSERV     path     - create given path as a Virtual Server"
Const StrRes61	=	" adsutil.vbs START_SERVER     path     - starts the given web site"
Const StrRes62	=	" adsutil.vbs STOP_SERVER      path     - stops the given web site"
Const StrRes63	=	" adsutil.vbs PAUSE_SERVER     path     - pauses the given web site"
Const StrRes64	=	" adsutil.vbs CONTINUE_SERVER  path     - continues the given web site"
Const StrRes65	=	"Samples:"
Const StrRes66	=	"  adsutil.vbs GET W3SVC/1/ServerBindings"
Const StrRes67	=	"  adsutil.vbs SET W3SVC/1/ServerBindings "":81:"""
Const StrRes68	=	"  adsutil.vbs CREATE W3SVC/1/Root/MyVdir ""IIsWebVirtualDir"""
Const StrRes69	=	"  adsutil.vbs START_SERVER W3SVC/1"
Const StrRes70	=	"  adsutil.vbs ENUM /P W3SVC"
Const StrRes71	=	"This script does not work with WScript."
Const StrRes72	=	"To run this script using CScript, type: ""CScript.exe "
Const StrRes73	=	"Error Trying to write the registry settings!"
Const StrRes74	=	"Successfully registered CScript"
Const StrRes75	=	"To run this script type: ""CScript.Exe adsutil.vbs <cmd> <params>"""
Const StrRes76	=	"Error: Wrong number of Args for the SET command"
Const StrRes77	=	"Error Trying To Get the Object: "
Const StrRes78	=	"Error Trying To GET the Schema of the property: "
Const StrRes79	=	"Error: Unknown data type in schema: "
Const StrRes80	=	"Error Trying To SET the Property: "
Const StrRes81	=	"Error: Wrong number of Args for the GET command"
Const StrRes82	=	"Error Trying To GET the Object (GetObject Failed): "
Const StrRes83	=	"Error Trying To GET the Schema of the property: "
Const StrRes84	=	"Error Trying To GET the property: (Get Method Failed) "
Const StrRes85	=	"  (This property is probably not allowed at this node)"
Const StrRes86	=	"The parameter """
Const StrRes87	=	" is not set at this node."
Const StrRes90	=	" Items)"
Const StrRes91	=	"Error Trying To GET the Property: "
Const StrRes92	=	"Error: Invalid arguments for the ENUM command"
Const StrRes93	=	"Error: Wrong number of Args for the ENUM command"
Const StrRes94	=	"Error Trying To ENUM the Object (GetObject Failed): "
Const StrRes95	=	"Error Trying To GET the Schema of the class: "
Const StrRes96	=	"Error trying to get the list of properties: "
Const StrRes97	=	"Warning: The optionalproperties list is of an invalid type"
Const StrRes98	=	"Warning: The OptionalProperties list for this node is empty."
Const StrRes99	=	"Error trying to enumerate the Optional properties (Couldn't Get Property Information): "
Const StrRes100	=	"Last Property Name: "
Const StrRes102	=	" Items)"
Const StrRes103	=	"DataType: "
Const StrRes104	=	" Not Yet Supported on property: "
Const StrRes105	=	"Error trying to enumerate the Optional properties (Error trying to get property value): "
Const StrRes108	=	"Continuing..."
Const StrRes109	=	"Error trying to enumerate the properties lists:"
Const StrRes111	=	"Error trying to enumerate the child nodes"
Const StrRes112	=	"Error: Wrong number of Args for the CREATE command"
Const StrRes120	=	"Error accessing the object: "
Const StrRes121	=	"Error creating the object: "
Const StrRes123	=	"WARNING: The parent path ("
Const StrRes124	=	") was not already created."
Const StrRes125	=	"    This means that some of the intermediate objects will not have an accurate"
Const StrRes126	=	"    Object Type. You should fix this by setting the KeyType on the intermediate"
Const StrRes127	=	"    objects."
Const StrRes128	=	"WARNING: The Object Type of this object was not specified or was specified as"
Const StrRes129	=	"    IIsObject.  This means that you will not be able to set or get properties"
Const StrRes130	=	"    on the object until the KeyType property is set."
Const StrRes131	=	"created """
Const StrRes132	=	"Error: Wrong number of Args for the DELETE command"
Const StrRes133	=	"Error deleting the object: "
Const StrRes134	=	"deleted property """
Const StrRes135	=	"Error deleting the object: "
Const StrRes136	=	"deleted path """
Const StrRes137	=	"ENUM_ALL Command not yet supported"
Const StrRes138	=	"Error: Wrong number of Args for the Copy/Move command"
Const StrRes139	=	"Error trying to open the object: "
Const StrRes140	=	"Error trying to Copy/Move Source to Dest."
Const StrRes141	=	"copied from "
Const StrRes142	=	" to "
Const StrRes143	=	"moved from "
Const StrRes145	=	"Error: Wrong number of Args for the START_SERVER command"
Const StrRes146	=	"Error trying to open the object: "
Const StrRes147	=	"Error trying to START the server: "
Const StrRes148	=	"Server "
Const StrRes149	=	" Successfully STARTED"
Const StrRes150	=	"Error: Wrong number of Args for the STOP_SERVER command"
Const StrRes151	=	"Error trying to open the object: "
Const StrRes152	=	"Error trying to STOP the server: "
Const StrRes154	=	" Successfully STOPPED"
Const StrRes155	=	"Error: Wrong number of Args for the PAUSE_SERVER command"
Const StrRes156	=	"Error trying to open the object: "
Const StrRes157	=	"Error trying to PAUSE the server: "
Const StrRes159	=	" Successfully PAUSED"
Const StrRes160	=	"Error: Wrong number of Args for the CONTINUE_SERVER command"
Const StrRes161	=	"Error trying to open the object: "
Const StrRes162	=	"Error trying to CONTINUE the server: "
Const StrRes164	=	" Successfully CONTINUED"
Const StrRes165	=	"Error: Wrong number of Args for the FIND_DATA command"
Const StrRes166	=	"Error trying to find data paths for the Object (GetObject Failed): "
Const StrRes167	=	"Error trying to get a path list (GetDataPaths Failed): "
Const StrRes168	=	"Property "
Const StrRes169	=	" was not found at any node beneath "
Const StrRes171	=	" found at:"
Const StrRes172	=	"Error listing the data paths (_newEnum Failed): "
Const StrRes173	=	"Error trying to get the Object: "
Const StrRes175	=	"Error trying to Create the Mime Map List."
Const StrRes176	=	"Error: Wrong number of Args for the Set MIMEMAP command"
Const StrRes177	=	"Error trying to get the Object: "
Const StrRes179	=	"Error Trying to set the Object's ""MimeMap"" property to the new mimemap list."
Const StrRes180	=	"Error Trying To Get the Object: "
Const StrRes181	=	"Can't set ServerCommand on a non-IIsWebServer object."
Const StrRes182	=	"Error Trying To Start the server: "
Const StrRes184	=	" Successfully STARTED"
Const StrRes185	=	"Error Trying To Stop the server: "
Const StrRes187	=	" Successfully STOPPED"
Const StrRes188	=	"Error Trying To Pause the server: "
Const StrRes190	=	" Successfully PAUSED"
Const StrRes191	=	"Error Trying To Continue the server: "
Const StrRes193	=	" Successfully Continued"
Const StrRes194	=	"Invalid ServerCommand: "
Const StrRes195	=	"Error Trying To Get the Object: "
Const StrRes196	=	"Can't set AppPoolCommand on a non-IIsApplicationPool object."
Const StrRes197	=	"Error Trying To Start the application pool: "
Const StrRes198	=	"Application pool "
Const StrRes199	=	" Successfully STARTED"
Const StrRes200	=	"Error Trying To Stop the application pool: "
Const StrRes202	=	" Successfully STOPPED"
Const StrRes203	=	"Invalid AppPoolCommand: "
Const StrRes204	=	"Error Trying To Get the Object: "
Const StrRes205	=	"Error: Setting not supported: "
Const StrRes206	=	"Error Trying To Set data on the Object: "
Const StrRes208	=	"Error Trying To Get the Object: "
Const StrRes215	=	"Note: Your parameter """
Const StrRes216	=	" is being mapped to AccessFlags"
Const StrRes217	=	"      Check individual perms using ""GET AccessRead"", ""GET AccessWrite"", etc."
Const StrRes221	=	" is being mapped to AuthFlags"
Const StrRes222	=	"      Check individual auths using ""GET AuthNTLM"", ""GET AuthBasic"", etc."
Const StrRes223	=	"ErrNumber: "
Const StrRes225	=	"Error trying to Split the parameter from the object: "
Const StrRes234	=	"Error trying to split the left part of the path: "
Const StrRes235	=	"Error Trying To Sanitize the path: "
Const StrRes236	=	"Error: Wrong number of Args for the APPCREATE command"
Const StrRes237	=	"Error trying to get the path of the application: "
Const StrRes238	=	"Error trying to create the application: "
Const StrRes239	=	"Application Created."
Const StrRes240	=	"Error: Wrong number of Args for the APPDELETE command"
Const StrRes242	=	"Error trying to DELETE the application: "
Const StrRes243	=	"Application Deleted."
Const StrRes244	=	"Error: Wrong number of Args for the APPUNLOAD command"
Const StrRes246	=	"Error trying to UNLOAD the application: "
Const StrRes247	=	"Application Unloaded."
Const StrRes248	=	"Error: Wrong number of Args for the APPDISABLE command"
Const StrRes251	=	"Error trying to disable the application: "
Const StrRes253	=	"Application Disabled."
Const StrRes254	=	"Error: Wrong number of Args for the APPENABLE command"
Const StrRes257	=	"Error trying to Enable the application: "
Const StrRes259	=	"Application Enabled."
Const StrRes260	=	"Error: Wrong number of Args for the APPGETSTATUS command"
Const StrRes262	=	"Error trying to retrieve the application STATUS: "
Const StrRes263	=	"Application Status: "
Const StrRes264	=	"Error trying to get the property: "
Const StrRes265	=	"Would you like to register CScript as your default host for VBscript?"
Const StrRes266	=	"Register CScript"
Const StrRes267 =   "The path requested could not be found."
Const StrRes268 =   "Access is denied for the requested path or property."
Const StrRes269 =   "The requested path is being used by another application."
Const StrRes270 =   "Authorization"
Const StrRes271 =   " Anonymous"
Const StrRes272 =   " Basic"
 
Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
Const vbSpace = " "

' Get the overridden UI language.
Function GetLangID()
	Dim args, lang

	Set args = WScript.Arguments.Named
	If args.Exists("lang") Then
		lang = args.Item("lang")
		GetLangID = CInt(lang)
	Else
		GetLangID = GetUILanguage()
	End If

End Function

' Get a localized resources for 'resourceID' if available;
' otherwise, get the neutral resource.
Function GetLocalizedResource(resourceID)
	Const ForReading = 1, TristateUseDefault = -2
	Dim lang, value, ini
		
	lang = GetLangID()
	ini = fso.GetParentFolderName(WScript.ScriptFullName) & "\" _
			& ToHex(lang) & "\" & fso.GetBaseName(WScript.ScriptName) &  ".ini"

	If fso.FileExists(ini) Then
		Dim stream, file

		Set file = fso.GetFile(ini)
		Set stream = file.OpenAsTextStream(ForReading, TristateUseDefault)
		value = ReadResource(stream, resourceID)
	End If

	If Not IsEmpty(value) Then
		GetLocalizedResource = value
	Else
		GetLocalizedResource = Eval(resourceID)
	End If
End Function

' Read a resource ID from the TextStream
Function ReadResource(stream, resourceID)
	Const ERROR_FILE_NOT_FOUND = 2
	Dim ln, arr, key, value

	If Not IsObject(stream) Then Err.Raise ERROR_FILE_NOT_FOUND

	Do Until stream.AtEndOfStream
		ln = stream.ReadLine

		arr = Split(ln, "=", 2, 1)
		If UBound(arr, 1) = 1 Then
			' Trim the key and the value first before trimming quotes
			key = arr(0)
			key = TrimSpace(key)
			'key = Replace(key, String(1, vbTab), "")

			If StrComp(resourceID, key, 1) = 0 Then
				value = TrimChar(TrimSpace(arr(1)), """")
				ReadResource = value
				Exit Do
			End If
		End If
	Loop

	stream.Close
End Function

Function TrimSpace(s)
	Dim c
	do
		c = Left(s, 1)
		if c <> vbTab and c <> vbSpace then
			exit do
		end if
		s = Right(s, len(s) - 1)
	loop	

	do
		c = Right(s, 1)
		if c <> vbTab and c <> vbSpace then
			exit do
		end if
		s = Left(s, len(s) - 1)
	loop	

	TrimSpace = s
End Function

' Trim a character from the text string
Function TrimChar(s, c)
	Dim a
	do
		a = Left(s, 1)
		if a <> c then
			exit do
		end if
		s = Right(s, len(s) - 1)
	loop	

	do
		a = Right(s, 1)
		if a <> c then
			exit do
		end if
		s = Left(s, len(s) - 1)
	loop	

	TrimChar = s
End Function

Function ToHex(n)
	Dim s : s = Hex(n)
	ToHex = String(4 - Len(s), "0") & s
End Function
	
''''''''''''''''''
' Main Script Code
''''''''''''''''''
Dim ArgObj ' Object which contains the command line argument
Dim Result ' Result of the command function call
Dim Args(999) ' Array that contains all of the non-global arguments
Dim ArgCount ' Tracks the size of the Args array

' Used for string formatting
Dim Spacer
Dim SpacerSize

Const IIS_DATA_NO_INHERIT = 0
Const IIS_DATA_INHERIT = 1
Const GENERAL_FAILURE = 2
Const GENERAL_WARNING = 1
Const AppCreate_InProc = 0
Const AppCreate_OutOfProc = 1
Const AppCreate_PooledOutOfProc = 2

Const APPSTATUS_NOTDEFINED = 2
Const APPSTATUS_RUNNING = 1
Const APPSTATUS_STOPPED = 0

Spacer = "                                " ' Used to format the strings
SpacerSize = Len(Spacer)

' Note: The default execution mode may be under WScript.exe.
' That would be very annoying since WScript has popups for Echo.
' So, I want to detect that, and warn the user that it may cause
' problems.
DetectExeType

' Get the Arguments object
Set ArgObj = WScript.Arguments

' Test to make sure there is at least one command line arg - the command
If ArgObj.Count < 1 Then
        DisplayHelpMessage
        WScript.Quit (GENERAL_FAILURE)
End If

'*****************************************************
Dim TargetServer 'The server to be examined/modified
Dim I
For I = 0 To ArgObj.Count - 1
    If LCase(Left(ArgObj.Item(I), 3)) = "-s:" Then
        TargetServer = Right(ArgObj.Item(I), Len(ArgObj.Item(I)) - 3)
    Else
        Args(ArgCount) = ArgObj.Item(I)
        ArgCount = ArgCount + 1
    End If
Next
If Len(TargetServer) = 0 Then
    TargetServer = "localhost"
End If
'*****************************************************

' Call the function associated with the given command
Select Case UCase(Args(0))
    Case "SET"
        Result = SetCommand()
    Case "CREATE"
        Result = CreateCommand("")
    Case "DELETE"
        Result = DeleteCommand()
    Case "GET"
        Result = GetCommand()
    Case "ENUM"
        Result = EnumCommand(False, "")
    Case "ENUM_ALL"
        Result = EnumCommand(True, "")
    Case "ENUMALL"
        Result = EnumCommand(True, "")
    Case "COPY"
        Result = CopyMoveCommand(True)   ' The TRUE means COPY, not MOVE
    Case "MOVE"
        Result = CopyMoveCommand(False)   ' The FALSE means MOVE, not COPY
    Case "CREATE_VDIR"
        Result = CreateCommand("IIsWebVirtualDir")
    Case "CREATE_VSERV"
        Result = CreateCommand("IIsWebServer")
    Case "START_SERVER"
        Result = StartServerCommand()
    Case "STOP_SERVER"
        Result = StopServerCommand()
    Case "PAUSE_SERVER"
        Result = PauseServerCommand()
    Case "CONTINUE_SERVER"
        Result = ContinueServerCommand()
' New Stuff being added
    Case "FIND"
        Result = FindData()
    Case "COPY"
        WScript.Echo GetLocalizedResource("StrRes0")
    Case "APPCREATEINPROC"
        Result = AppCreateCommand(AppCreate_InProc)
    Case "APPCREATEOUTPROC"
        Result = AppCreateCommand(AppCreate_OutOfProc)
    Case "APPCREATEPOOLPROC"
        Result = AppCreateCommand(AppCreate_PooledOutOfProc)
    Case "APPDELETE"
        Result = AppDeleteCommand()
    Case "APPUNLOAD"
        Result = AppUnloadCommand()
    Case "APPDISABLE"
        Result = AppDisableCommand()
    Case "APPENABLE"
        Result = AppEnableCommand()
    Case "APPGETSTATUS"
        Result = AppGetStatusCommand()
    Case "HELP"
        DisplayHelpMessageEx

' End New Stuff

    Case Else
        WScript.Echo GetLocalizedResource("StrRes1") & Args(0)
        WScript.Echo GetLocalizedResource("StrRes2")
        Result = GENERAL_FAILURE

End Select

WScript.Quit (Result)

''''''''''
' End Main
''''''''''


''''''''''''''''''''''''''''
'
' Display Help Message
'
''''''''''''''''''''''''''''
Sub DisplayHelpMessage()
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes3")
    WScript.Echo GetLocalizedResource("StrRes4")
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes6")
    WScript.Echo GetLocalizedResource("StrRes7")
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes9")
    WScript.Echo "  GET, SET, ENUM, DELETE, CREATE, COPY, "
    WScript.Echo "  APPCREATEINPROC, APPCREATEOUTPROC, APPCREATEPOOLPROC, APPDELETE, APPUNLOAD, APPGETSTATUS "
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes12")
    WScript.Echo "  adsutil.vbs GET W3SVC/1/ServerBindings"
    WScript.Echo "  adsutil.vbs SET W3SVC/1/ServerBindings "":81:"""
    WScript.Echo "  adsutil.vbs CREATE W3SVC/1/Root/MyVdir ""IIsWebVirtualDir"""
    WScript.Echo "  adsutil.vbs START_SERVER W3SVC/1"
    WScript.Echo "  adsutil.vbs ENUM /P W3SVC"
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes18")
    WScript.Echo "  adsutil.vbs HELP"
End Sub



''''''''''''''''''''''''''''
'
' Display Help Message
'
''''''''''''''''''''''''''''
Sub DisplayHelpMessageEx()

    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes3")
    WScript.Echo GetLocalizedResource("StrRes21")
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes23")
    WScript.Echo GetLocalizedResource("StrRes24")
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes26")
    WScript.Echo GetLocalizedResource("StrRes27")
    WScript.Echo GetLocalizedResource("StrRes28")
    WScript.Echo GetLocalizedResource("StrRes29")
    WScript.Echo GetLocalizedResource("StrRes30")
    WScript.Echo GetLocalizedResource("StrRes31")
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes32")
    WScript.Echo GetLocalizedResource("StrRes33")
    WScript.Echo GetLocalizedResource("StrRes34")
    WScript.Echo GetLocalizedResource("StrRes35")
    WScript.Echo GetLocalizedResource("StrRes36")
    WScript.Echo GetLocalizedResource("StrRes37")
    WScript.Echo GetLocalizedResource("StrRes38")
    WScript.Echo GetLocalizedResource("StrRes39")
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes40")
    WScript.Echo GetLocalizedResource("StrRes41")
    WScript.Echo GetLocalizedResource("StrRes42")
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes43")
    WScript.Echo GetLocalizedResource("StrRes44")
    WScript.Echo GetLocalizedResource("StrRes45")
    WScript.Echo GetLocalizedResource("StrRes46")
    WScript.Echo GetLocalizedResource("StrRes47")
    WScript.Echo GetLocalizedResource("StrRes48")
    WScript.Echo GetLocalizedResource("StrRes49")
    WScript.Echo GetLocalizedResource("StrRes50")
    WScript.Echo
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes12")
    WScript.Echo GetLocalizedResource("StrRes52")
    WScript.Echo GetLocalizedResource("StrRes53")
    WScript.Echo GetLocalizedResource("StrRes54")
    WScript.Echo GetLocalizedResource("StrRes55")
    WScript.Echo GetLocalizedResource("StrRes56")

    WScript.Echo GetLocalizedResource("StrRes57")
    WScript.Echo GetLocalizedResource("StrRes58")
    WScript.Echo GetLocalizedResource("StrRes59")
    WScript.Echo GetLocalizedResource("StrRes60")
    WScript.Echo GetLocalizedResource("StrRes61")
    WScript.Echo GetLocalizedResource("StrRes62")
    WScript.Echo GetLocalizedResource("StrRes63")
    WScript.Echo GetLocalizedResource("StrRes64")
    WScript.Echo
    WScript.Echo
    WScript.Echo GetLocalizedResource("StrRes65")
    WScript.Echo GetLocalizedResource("StrRes66")
    WScript.Echo GetLocalizedResource("StrRes67")
    WScript.Echo GetLocalizedResource("StrRes68")
    WScript.Echo GetLocalizedResource("StrRes69")
    WScript.Echo GetLocalizedResource("StrRes70")

' adsutil.vbs ENUM_ALL path             - recursively enumerate all parameters
' adsutil.vbs COPY     pathsrc pathdst  - copy all from pathsrc to pathdst (will create pathdst)
' adsutil.vbs SCRIPT   scriptname       - runs the script

'  -path has format: {computer}/{service}/{instance}/{URL}/{Parameter}

End Sub






'''''''''''''''''''''''''''
'
' DetectExeType
'
' This can detect the type of exe the
' script is running under and warns the
' user of the popups.
'
'''''''''''''''''''''''''''
Sub DetectExeType()
    Dim ScriptHost
    Dim ShellObject

    Dim CurrentPathExt
    Dim EnvObject

    Dim RegCScript
    Dim RegPopupType ' This is used to set the pop-up box flags.
                                            ' I couldn't find the pre-defined names
    RegPopupType = 32 + 4

    On Error Resume Next

    ScriptHost = WScript.FullName
    ScriptHost = Right(ScriptHost, Len(ScriptHost) - InStrRev(ScriptHost, "\"))

    If (UCase(ScriptHost) = "WSCRIPT.EXE") Then
        WScript.Echo GetLocalizedResource("StrRes71")

        ' Create a pop-up box and ask if they want to register cscript as the default host.
        Set ShellObject = WScript.CreateObject("WScript.Shell")
        ' -1 is the time to wait.  0 means wait forever.
        RegCScript = ShellObject.PopUp(GetLocalizedResource("StrRes265"), 0, GetLocalizedResource("StrRes266"), RegPopupType)

        If (Err.Number <> 0) Then
            ReportError ()
            WScript.Echo GetLocalizedResource("StrRes72") & WScript.ScriptName & """"
            WScript.Quit (GENERAL_FAILURE)
            WScript.Quit (Err.Number)
        End If

        ' Check to see if the user pressed yes or no.  Yes is 6, no is 7
        If (RegCScript = 6) Then
            ShellObject.RegWrite "HKEY_CLASSES_ROOT\VBSFile\Shell\Open\Command\", "%WINDIR%\System32\CScript.exe //nologo ""%1"" %*", "REG_EXPAND_SZ"
            ShellObject.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\VBSFile\Shell\Open\Command\", "%WINDIR%\System32\CScript.exe //nologo ""%1"" %*", "REG_EXPAND_SZ"
            ' Check if PathExt already existed
            CurrentPathExt = ShellObject.RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\PATHEXT")
            If Err.Number = &H80070002 Then
                Err.Clear
                Set EnvObject = ShellObject.Environment("PROCESS")
                CurrentPathExt = EnvObject.Item("PATHEXT")
            End If

            ShellObject.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\PATHEXT", CurrentPathExt & ";.VBS", "REG_SZ"

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes73")
                WScript.Quit (Err.Number)
            Else
                WScript.Echo GetLocalizedResource("StrRes74")
            End If
        Else
            WScript.Echo GetLocalizedResource("StrRes75")
        End If

        Dim ProcString
        Dim ArgIndex
        Dim ArgObj
        Dim Result

        ProcString = "Cscript //nologo " & WScript.ScriptFullName

        Set ArgObj = WScript.Arguments

        For ArgIndex = 0 To ArgCount - 1
            ProcString = ProcString & " " & Args(ArgIndex)
        Next

        'Now, run the original executable under CScript.exe
        Result = ShellObject.Run(ProcString, 0, True)

        WScript.Quit (Result)
    End If

End Sub


''''''''''''''''''''''''''
'
' SetCommand Function
'
' Sets the value of a property in the metabase.
'
''''''''''''''''''''''''''
Function SetCommand()
    Dim IIsObject
    Dim IIsObjectPath
    Dim IIsSchemaObject
    Dim IIsSchemaPath
    Dim ObjectPath
    Dim ObjectParameter
    Dim MachineName
    Dim ValueIndex
    Dim ValueList
    Dim ValueDisplay
    Dim ValueDisplayLen
    Dim ValueDataType

    Dim ValueData

    Dim ObjectDataType

    On Error Resume Next

    SetCommand = 0 ' Assume Success

    If ArgCount < 3 Then
        WScript.Echo GetLocalizedResource("StrRes76")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)
    ObjectParameter = SplitParam(ObjectPath)

    ' Some Property Types have special needs - like ServerCommand.
    ' Check to see if this is a special command.  If it is, then process it special.
    If (IsSpecialSetProperty(ObjectParameter)) Then
        SetCommand = DoSpecialSetProp(ObjectPath, ObjectParameter, MachineName)
        Exit Function
    End If

    If ObjectPath = "" Then
        IIsObjectPath = "IIS://" & MachineName
    Else
        IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath
    End If
    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes77") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    ' Get the Schema of the property and determine if it's multivalued
    IIsSchemaPath = "IIS://" & MachineName & "/Schema/" & ObjectParameter
    Set IIsSchemaObject = GetObject(IIsSchemaPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes78") & IIsSchemaPath
        WScript.Quit (Err.Number)
    End If

    ObjectDataType = UCase(IIsSchemaObject.Syntax)
    SanitizePath ObjectDataType

    Select Case (ObjectDataType)

    Case "STRING"
        ValueList = Args(2)
        IIsObject.Put ObjectParameter, (ValueList)

    Case "EXPANDSZ"
        ValueList = Args(2)
        IIsObject.Put ObjectParameter, (ValueList)

    Case "INTEGER"
        ' Added to convert hex values to integers
        ValueData = Args(2)

        If (UCase(Left(ValueData, 2))) = "0X" Then
                ValueData = "&h" & Right(ValueData, Len(ValueData) - 2)
        End If

        ValueList = StringTo32BitUnsignedInteger(ValueData)
        IIsObject.Put ObjectParameter, (ValueList)

    Case "BOOLEAN"
        ValueList = CBool(Args(2))
        IIsObject.Put ObjectParameter, (ValueList)

    Case "LIST"
        ReDim ValueList(ArgCount - 3)
        For ValueIndex = 2 To ArgCount - 1
                ValueList(ValueIndex - 2) = Args(ValueIndex)
        Next

        IIsObject.Put ObjectParameter, (ValueList)

    Case Else
        WScript.Echo GetLocalizedResource("StrRes79") & IIsSchemaObject.Syntax

    End Select

    IIsObject.Setinfo

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes80") & ObjectParameter
        WScript.Quit (Err.Number)
    End If

    ' The function call succeeded, so display the output
    ' Set up the initial part of the display - the property name and data type
    ValueDisplay = ObjectParameter
    ValueDisplayLen = Len(ValueDisplay)

    If (ValueDisplayLen < SpacerSize) Then
        ValueDisplay = ValueDisplay & (Right(Spacer, SpacerSize - ValueDisplayLen)) & ": " & "(" & ObjectDataType & ") "
Else
        ValueDisplay = ValueDisplay & ": " & "(" & TypeName(ValueList) & ") "
    End If

    ' Create the rest of the display - The actual data
    If (IIsSchemaObject.MultiValued) Then
        For ValueIndex = 0 To UBound(ValueList)
            ValueDisplay = ValueDisplay & """" & ValueList(ValueIndex) & """ "
        Next
    Else
        If (UCase(IIsSchemaObject.Syntax) = "STRING") Then
            If (IsSecureProperty(ObjectParameter,MachineName) = True) Then
                ValueDisplay = ValueDisplay & """" & "**********" & """"
            Else
                ValueDisplay = ValueDisplay & """" & ValueList & """"
            End If
        ElseIf (UCase(IIsSchemaObject.Syntax) = "INTEGER") Then
            ValueDisplay = ValueDisplay & UnsignedIntegerToString(ValueList)
        Else
            ValueDisplay = ValueDisplay & ValueList
        End If
    End If

    ' Display the output
    WScript.Echo ValueDisplay

    SetCommand = 0 ' Success

End Function


''''''''''''''''''''''''''
'
' GetCommand Function
'
' Gets the value of a property in the metabase.
'
''''''''''''''''''''''''''
Function GetCommand()

    Dim IIsObject
    Dim IIsObjectPath
    Dim IIsSchemaObject
    Dim IIsSchemaPath
    Dim ObjectPath
    Dim ObjectParameter
    Dim MachineName
    Dim ValueIndex
    Dim ValueList
    Dim ValueListArray
    Dim ValueDisplay
    Dim ValueDisplayLen
    Dim NewObjectparameter

    Dim DataPathList
    Dim DataPath

    On Error Resume Next

    GetCommand = 0 ' Assume Success

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes81")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)

    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)
    ObjectParameter = SplitParam(ObjectPath)

    NewObjectparameter = MapSpecGetParamName(ObjectParameter)
    ObjectParameter = NewObjectparameter

    If (IsSpecialGetProperty(ObjectParameter)) Then
        GetCommand = DoSpecialGetProp(ObjectPath, ObjectParameter, MachineName)
        Exit Function
    End If

    If ObjectPath = "" Then
        IIsObjectPath = "IIS://" & MachineName
    Else
        IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath
    End If

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes82") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    ' Get the Schema of the property and determine if it's multivalued
    IIsSchemaPath = "IIS://" & MachineName & "/Schema/" & ObjectParameter
    Set IIsSchemaObject = GetObject(IIsSchemaPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes83") & IIsSchemaPath
        WScript.Quit (Err.Number)
    End If

    ' First, attempt to retrieve the property - this will tell us
    ' if you are even allowed to set the property at this node.
    ' Retrieve the property
    ValueList = IIsObject.Get(ObjectParameter)
    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes84") & ObjectParameter
        WScript.Echo GetLocalizedResource("StrRes85")
        WScript.Quit (Err.Number)
    End If

    ' Test to see if the property is ACTUALLY set at this node
    DataPathList = IIsObject.GetDataPaths(ObjectParameter, IIS_DATA_INHERIT)
    If Err.Number <> 0 Then DataPathList = IIsObject.GetDataPaths(ObjectParameter, IIS_DATA_NO_INHERIT)
    Err.Clear

    ' If the data is not set anywhere, then stop the madness
    If (UBound(DataPathList) < 0) Then
        WScript.Echo GetLocalizedResource("StrRes86") & ObjectParameter & GetLocalizedResource("StrRes87")
        WScript.Quit (&H80005006) ' end with property not set error
    End If

    DataPath = DataPathList(0)
    SanitizePath DataPath

    ' Test to see if the item is actually set HERE
    If UCase(DataPath) <> UCase(IIsObjectPath) Then
        WScript.Echo GetLocalizedResource("StrRes86") & ObjectParameter & GetLocalizedResource("StrRes87")
        WScript.Quit (&H80005006) ' end with property not set error
    End If

    ' Set up the initial part of the display - the property name and data type
    ValueDisplay = ObjectParameter
    ValueDisplayLen = Len(ValueDisplay)

    If (ValueDisplayLen < SpacerSize) Then
        ValueDisplay = ValueDisplay & (Right(Spacer, SpacerSize - ValueDisplayLen)) & ": " & "(" & UCase(IIsSchemaObject.Syntax) & ") "
    Else
        ValueDisplay = ValueDisplay & ": " & "(" & TypeName(ValueList) & ") "
    End If

    ' Create the rest of the display - The actual data
    If (IIsSchemaObject.MultiValued) Then
        WScript.Echo ValueDisplay & " (" & UBound (ValueList) + 1 & GetLocalizedResource("StrRes90")

        For ValueIndex = 0 To UBound(ValueList)
            WScript.Echo "  """ & ValueList(ValueIndex) & """"
        Next
    Else
        If (UCase(IIsSchemaObject.Syntax) = "STRING") Then
            If (IsSecureProperty(ObjectParameter,MachineName) = True) Then
                ValueDisplay = ValueDisplay & """" & "**********" & """"
            Else
                ValueDisplay = ValueDisplay & """" & ValueList & """"
            End If

        ElseIf (UCase(IIsSchemaObject.Syntax) = "BINARY") Then
            ValueListArray = IIsObject.Get(ObjectParameter)

            ValueList = "0x"

            For ValueIndex = 0 To UBound(ValueListArray)
                ValueList = ValueList & ValueListArray(ValueIndex) & " "
            Next

            ValueDisplay = ValueDisplay & ValueList

        ElseIf (UCase(IIsSchemaObject.Syntax) = "INTEGER") Then
            ValueDisplay = ValueDisplay & UnsignedIntegerToString(ValueList)
        Else
            'WScript.Echo ValueList
            ValueDisplay = ValueDisplay & ValueList
        End If

        ' Display the output
        WScript.Echo ValueDisplay
    End If

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes91") & ObjectParameter
        WScript.Quit (Err.Number)
    End If

    GetCommand = 0 ' Success

End Function


''''''''''''''''''''''''''
'
' EnumCommand Function
'
' Enumerates all properties at a path in the metabase.
'
''''''''''''''''''''''''''
Function EnumCommand(Recurse, StartPath)

    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim IIsSchemaObject
    Dim IIsSchemaPath
    Dim ObjectPath
    Dim MachineName
    Dim ValueIndex
    Dim ValueList
    Dim ValueListArray
    Dim ValueString
    Dim PropertyName
    Dim PropertyAttribObj
    Dim PropertyListSet
    Dim PropertyList
    Dim PropertyObjPath
    Dim PropertyObject
    Dim ChildObject
    Dim ChildObjectName
    Dim EnumPathsOnly
    Dim EnumAllData
    Dim ErrMask
    Dim IsInherit

    Dim PropertyDataType

    Dim SpecialResult

    Dim PathOnlyOption
    PathOnlyOption = "/P"

    EnumCommand = 0 ' Assume Success
    EnumPathsOnly = False ' Assume that the user wants all of the data items
    EnumAllData = False ' Assume that the user wants only the actual data items

    If (ArgCount = 1) Then
        ObjectPath = ""
        EnumPathsOnly = False
        ArgCount = 2
    ElseIf (ArgCount = 2) Then
        If UCase(Args(1)) = PathOnlyOption Then
            ObjectPath = ""
            EnumPathsOnly = True
        Else
            ObjectPath = Args(1)
            EnumPathsOnly = False
        End If
    ElseIf (ArgCount = 3) Then

        If UCase(Args(1)) = PathOnlyOption Then
            ObjectPath = Args(2)
            EnumPathsOnly = True
        ElseIf UCase(Args(2)) = PathOnlyOption Then
            ObjectPath = Args(1)
            EnumPathsOnly = True
        Else
            WScript.Echo GetLocalizedResource("StrRes92")
            WScript.Quit (GENERAL_FAILURE)
        End If
    Else
        WScript.Echo GetLocalizedResource("StrRes93")
        WScript.Quit (GENERAL_FAILURE)
    End If

    If StartPath <> "" Then ObjectPath = StartPath

    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)

    IIsObjectPath = "IIS://" & MachineName
    If (ObjectPath <> "") Then
        IIsObjectPath = IIsObjectPath & "/" & ObjectPath
    End If

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        WScript.Echo
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes94") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    ' Get the Schema of the object and enumerate through all of the properties
    IIsSchemaPath = IIsObject.Schema
    Set IIsSchemaObject = GetObject(IIsSchemaPath)

    If (Err.Number <> 0) Then
        WScript.Echo
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes95") & IIsSchemaPath
        WScript.Quit (Err.Number)
    End If

    ReDim PropertyListSet(1)
    PropertyListSet(0) = IIsSchemaObject.MandatoryProperties
    PropertyListSet(1) = IIsSchemaObject.OptionalProperties

    If (Err.Number <> 0) Then
        WScript.Echo
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes96") & IIsSchemaPath
        WScript.Quit (Err.Number)
    End If

     ' This now checks for an empty OptionalProperties list
    If TypeName (PropertyListSet(1)) <> "Variant()" Then
        WScript.Echo
        WScript.Echo GetLocalizedResource("StrRes97")
        WScript.Echo
    ElseIf (UBound (PropertyListSet(1)) = -1) Then
        WScript.Echo
        WScript.Echo GetLocalizedResource("StrRes98")
        WScript.Echo
    End If

    If (Not EnumPathsOnly) Then
        For Each PropertyList In PropertyListSet

            For Each PropertyName In PropertyList
                If Err <> 0 Then
                    Exit For
                End If

                ' Test to see if the property is even set at this node
                IsInherit = False
                Err.Clear
                Set PropertyAttribObj = IIsObject.GetPropertyAttribObj(PropertyName)
                If (Err.Number = 0) Then

                    If (PropertyAttribObj.IsInherit) Then
                        IsInherit = True
                    End If
                    Err.Clear

                    If (IsInherit = False) Or (EnumAllData) Then
                    ' If the above statement is true, then the data exists here or the user wants it anyway.

                        PropertyObjPath = "IIS://" & MachineName & "/Schema/" & PropertyName
                        Set PropertyObject = GetObject(PropertyObjPath)

                        If (Err.Number <> 0) Then
                            WScript.Echo
                            ReportError ()
                            WScript.Echo GetLocalizedResource("StrRes99") & PropertyObjPath
                            WScript.Echo GetLocalizedResource("StrRes100") & PropertyName
                            WScript.Echo "PropertyObjPath: " & PropertyObjPath
                            WScript.Echo
                            EnumCommand = Err.Number
                            Err.Clear
                        End If

                        ValueList = ""
                        ValueListArray = ""

                        PropertyDataType = UCase(PropertyObject.Syntax)
                        Select Case PropertyDataType
                        Case "STRING"
                            ValueList = IIsObject.Get(PropertyName)
                            If (IsSecureProperty(PropertyName,MachineName) = True) Then
                                WScript.Echo PropertyName & Left(Spacer, Len(Spacer) - Len(PropertyName)) & ": " & "(" & PropertyDataType & ") " & """" & "**********" & """"
                            Else
                                If (Len(PropertyName) < SpacerSize) Then
                                    WScript.Echo PropertyName & Left(Spacer, Len(Spacer) - Len(PropertyName)) & ": " & "(" & PropertyDataType & ") """ & ValueList & """"
                                Else
                                    WScript.Echo PropertyName & " : " & "(" & PropertyDataType & ")" & """" & ValueList & """"
                                End If
                            End If

                        Case "EXPANDSZ"
                            ValueList = IIsObject.Get(PropertyName)
                            If (Len(PropertyName) < SpacerSize) Then
                                WScript.Echo PropertyName & Left(Spacer, Len(Spacer) - Len(PropertyName)) & ": " & "(" & PropertyDataType & ") """ & ValueList & """"
                            Else
                                WScript.Echo PropertyName & " : " & "(" & PropertyDataType & ") """ & ValueList & """"
                            End If

                        Case "BINARY"
                            ValueListArray = IIsObject.Get(PropertyName)

                            ValueList = "0x"

                            For ValueIndex = 0 To UBound(ValueListArray)
                                ValueList = ValueList & ValueListArray(ValueIndex) & " "
                            Next

                            If (Len(PropertyName) < SpacerSize) Then
                                WScript.Echo PropertyName & Left(Spacer, Len(Spacer) - Len(PropertyName)) & ": " & "(" & PropertyDataType & ") " & ValueList
                            Else
                                WScript.Echo PropertyName & " : " & "(" & PropertyDataType & ") " & ValueList
                            End If

                        Case "INTEGER"
                            ValueList = IIsObject.Get(PropertyName)
                            If (Len(PropertyName) < SpacerSize) Then
                                WScript.Echo PropertyName & Left(Spacer, Len(Spacer) - Len(PropertyName)) & ": " & "(" & PropertyDataType & ") " & UnsignedIntegerToString(ValueList)
                            Else
                                WScript.Echo PropertyName & " : " & "(" & PropertyDataType & ") " & UnsignedIntegerToString(ValueList)
                            End If

                        Case "BOOLEAN"
                            ValueList = IIsObject.Get(PropertyName)
                            If (Len(PropertyName) < SpacerSize) Then
                                WScript.Echo PropertyName & Left(Spacer, Len(Spacer) - Len(PropertyName)) & ": " & "(" & PropertyDataType & ") " & ValueList
                            Else
                                WScript.Echo PropertyName & " : " & "(" & PropertyDataType & ") " & ValueList
                            End If

                        Case "LIST"
                            ValueList = IIsObject.Get(PropertyName)
                            If (Len(PropertyName) < SpacerSize) Then
                                WScript.Echo PropertyName & _
                                    Left(Spacer, Len(Spacer) - Len(PropertyName)) & _
                                    ": " & "(" & PropertyDataType & ") (" & _
                                    (UBound (ValueList) + 1) & GetLocalizedResource("StrRes102")
                            Else
                                WScript.Echo PropertyName & " : " & "(" & PropertyDataType & ") (" & (UBound (ValueList) + 1) & GetLocalizedResource("StrRes102")
                            End If
                            ValueString = ""

                            For ValueIndex = 0 To UBound(ValueList)
                                WScript.Echo "  """ & ValueList(ValueIndex) & """"
                            Next
                            WScript.Echo

                        Case Else

                            If (IsSpecialGetProperty(PropertyName)) Then

                                SpecialResult = DoSpecialGetProp(ObjectPath, PropertyName, MachineName)
                                Err.Clear

                            Else
                                WScript.Echo
                                WScript.Echo GetLocalizedResource("StrRes103") & """" & PropertyObject.Syntax & """" & GetLocalizedResource("StrRes104") & PropertyName
                                ReportError
                                WScript.Echo
                            End If

                        End Select

                    End If ' End if data exists at the current node

                Else ' Error during GetPropertyAttribObj
                    Err.Clear 'ignore and go to the next property
                End If

                If (Err.Number <> 0) Then
                    WScript.Echo
                    ReportError ()
                    WScript.Echo GetLocalizedResource("StrRes105") & PropertyObjPath
                    WScript.Echo GetLocalizedResource("StrRes100") & PropertyName
                    WScript.Echo "PropertyObjPath: " & PropertyObjPath
                    ' If there is an ADS error, just ignore it and move on
                    ' otherwise, quit
                    If ((Err.Number) >= &H80005000) And ((Err.Number) < &H80006000) Then
                        Err.Clear
                        WScript.Echo GetLocalizedResource("StrRes108")
                    Else
                        WScript.Quit (Err.Number)
                    End If
                    WScript.Echo
                End If
            Next
        Next

        If (Err.Number <> 0) Then
            WScript.Echo GetLocalizedResource("StrRes109")
            ReportError ()
            WScript.Echo
            EnumCommand = Err.Number
            Err.Clear
        End If

    End If ' End if (Not EnumPathsOnly)

    ' Now, enumerate the data paths
    For Each ChildObject In IIsObject
        If (Err.Number <> 0) Then Exit For

        ChildObjectName = Right(ChildObject.AdsPath, Len(ChildObject.AdsPath) - 6)
        ChildObjectName = Right(ChildObjectName, Len(ChildObjectName) - InStr(ChildObjectName, "/") + 1)
        WScript.Echo "[" & ChildObjectName & "]"
        If (Recurse = True) And (ChildObjectName <> Args(1)) Then
            EnumCommand = EnumCommand(True, ChildObjectName)
        End If
    Next

    If (Err.Number <> 0) Then
        WScript.Echo GetLocalizedResource("StrRes111")
        ReportError ()
        WScript.Echo
        EnumCommand = Err.Number
        Err.Clear
    End If

    WScript.Echo ""

End Function


''''''''''''''''''''''''''
'
' Create Function
'
' Creates a path in the metabase.  An additional parameter that is
' not found in mdutil is optional.  That is the Object Type (KeyType)
' If this is not specified, the object type will be assumed to be
' IIsObject (which, of course, is useless).
'
''''''''''''''''''''''''''
Function CreateCommand(ObjectTypeParam)

    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim IIsObjectRelativePath
    Dim NewObject
    Dim ObjectTypeName
    Dim ParentObjPath
    Dim ParentObjSize
    Dim FullAdsParentPath
    Dim MachineName
    Dim OpenErr

    ' Set the return code - assume success
    CreateCommand = 0

    ' Setup the parameters
    If (ArgCount = 2) Then
        If (ObjectTypeParam = "") Then
            ObjectTypeName = "IIsObject"
        Else
            ObjectTypeName = ObjectTypeParam
        End If
    ElseIf (ArgCount = 3) Then
        ObjectTypeName = Args(2)
    Else
        WScript.Echo GetLocalizedResource("StrRes112")
        DisplayHelpMessage
        WScript.Quit (GENERAL_FAILURE)
    End If

    IIsObjectPath = Args(1)
    SanitizePath IIsObjectPath
    MachineName = SeparateMachineName(IIsObjectPath)

    ' Parse the path and determine if the parent exists.
    ParentObjSize = InStrRev(IIsObjectPath, "/")
    ParentObjPath = ""

    If ParentObjSize <> 0 Then
        ParentObjPath = Left(IIsObjectPath, ParentObjSize - 1)
        IIsObjectRelativePath = Right(IIsObjectPath, Len(IIsObjectPath) - ParentObjSize)
    Else
        IIsObjectRelativePath = IIsObjectPath
    End If

    If ParentObjPath <> "" Then
        FullAdsParentPath = "IIS://" & MachineName & "/" & ParentObjPath
    Else
        FullAdsParentPath = "IIS://" & MachineName
    End If
'debug
'WScript.Echo "Last Error: " & Err.Number
'WScript.Echo "MachineName: " & MachineName
'WScript.Echo "ParentObjPath: " & ParentObjPath
'WScript.Echo "FullAdsParentPath: " & FullAdsParentPath
'WScript.Echo "IIsObjectPath: " & IIsObjectPath
'WScript.Echo "IIsObjectRelativePath: " & IIsObjectRelativePath
'WScript.Echo "ObjectTypeName: " & ObjectTypeName

    ' First, attempt to open the parent path and add the new path.
    Set IIsObject = GetObject(FullAdsParentPath)
    If Err.Number <> 0 Then
        OpenErr = Err.Number
        OpenErrDesc = Err.Description
        Err.Clear
        ' Attempt to get the Computer Object (IIS://LocalHost)
        Set IIsObject = GetObject("IIS://" & MachineName)
        If Err.Number <> 0 Then
            WScript.Echo
            ReportError ()
            WScript.Echo GetLocalizedResource("StrRes120") & IIsObjectPath
            WScript.Quit (Err.Number)
        End If
    End If

    'Now, attempt to add the new object.
    If (OpenErr <> 0) Then
        Set NewObject = IIsObject.Create(ObjectTypeName, IIsObjectPath)
    Else
        Set NewObject = IIsObject.Create(ObjectTypeName, IIsObjectRelativePath)
    End If

    If Err.Number <> 0 Then
        WScript.Echo
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes121") & IIsObjectPath
        WScript.Quit (Err.Number)
    End If

    NewObject.Setinfo

    If Err.Number <> 0 Then
        WScript.Echo
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes121") & IIsObjectPath
        WScript.Quit (Err.Number)
    End If


    ' Now, if the parent object was not created, generate a warning.
    If OpenErr <> 0 Then
        WScript.Echo
        WScript.Echo GetLocalizedResource("StrRes123") & ParentObjPath & GetLocalizedResource("StrRes124")
        WScript.Echo GetLocalizedResource("StrRes125")
        WScript.Echo GetLocalizedResource("StrRes126")
        WScript.Echo GetLocalizedResource("StrRes127")
        WScript.Echo
        CreateCommand = GENERAL_WARNING
    End If

    If UCase(ObjectTypeName) = "IISOBJECT" Then
        WScript.Echo
        WScript.Echo GetLocalizedResource("StrRes128")
        WScript.Echo GetLocalizedResource("StrRes129")
        WScript.Echo GetLocalizedResource("StrRes130")
        WScript.Echo
        CreateCommand = GENERAL_WARNING
    End If

    WScript.Echo GetLocalizedResource("StrRes131") & IIsObjectPath & """"
End Function

''''''''''''''''''''''''''
'
' Delete Function
'
' Deletes a path in the metabase.
'
''''''''''''''''''''''''''
Function DeleteCommand()

    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath

    Dim ObjectPath
    Dim ObjectParam
    Dim MachineName

    Dim DummyVariant
    Dim DeletePathOnly
    ReDim DummyVariant(0)
    DummyVariant(0) = "Bogus"

    ' Set the return code - assume success
    DeleteCommand = 0

    ' Setup the parameters
    If (ArgCount <> 2) Then
        WScript.Echo GetLocalizedResource("StrRes132")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)

    ' Check and see if the user is specifically asking to delete the path
    DeletePathOnly = False
    If Right(ObjectPath, 1) = "/" Then
        DeletePathOnly = True
    End If

    ' Sanitize the path and split parameter and path
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)
    ObjectParam = SplitParam(ObjectPath)

    ' Open the parent object
    IIsObjectPath = "IIS://" & MachineName
    If ObjectPath <> "" Then
            IIsObjectPath = IIsObjectPath & "/" & ObjectPath
    End If

    Set IIsObject = GetObject(IIsObjectPath)

    If Err.Number <> 0 Then
        WScript.Echo
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes133") & ObjectPath & "/" & ObjectParam
        WScript.Quit (Err.Number)
    End If

    ' If they did not specifically ask to delete the path, then attempt to delete the property
    If Not DeletePathOnly Then
        ' Try to delete the property

        ' ADS_PROPERTY_CLEAR used to be defined, but it isn't anymore.
        'IIsObject.PutEx ADS_PROPERTY_CLEAR, ObjectParam, DummyVariant
        IIsObject.PutEx "1", ObjectParam, DummyVariant

        ' If it succeeded, then just return, else continue and try to delete the path
        If Err.Number = 0 Then
            IIsObject.SetInfo
            WScript.Echo GetLocalizedResource("StrRes134") & ObjectParam & """"
            Exit Function
        End If
        Err.Clear
    End If

    ' Try to just delete the path
    IIsObject.Delete "IIsObject", ObjectParam

    If Err.Number <> 0 Then
        WScript.Echo
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes135") & ObjectPath & "/" & ObjectParam
        WScript.Quit (Err.Number)
    End If

    WScript.Echo GetLocalizedResource("StrRes136") & ObjectPath & "/" & ObjectParam & """"

    Exit Function

End Function


''''''''''''''''''''''''''
'
' EnumAllCommand
'
' Enumerates all data and all properties in the metabase under the current path.
'
''''''''''''''''''''''''''
Function EnumAllCommand()
    On Error Resume Next

    WScript.Echo GetLocalizedResource("StrRes137")

End Function


''''''''''''''''''''''''''
'
' CopyMoveCommand
'
' Copies a path in the metabase to another path.
'
''''''''''''''''''''''''''
Function CopyMoveCommand(bCopyFlag)
    On Error Resume Next

    Dim SrcObjectPath
    Dim DestObjectPath
    Dim DestObject

    Dim ParentObjectPath
    Dim ParentRelativePath
    Dim ParentObject

    Dim MachineName

    Dim TmpDestLeftPath
    Dim TmpSrcLeftPath

    CopyMoveCommand = 0 ' Assume Success

    If ArgCount <> 3 Then
            WScript.Echo GetLocalizedResource("StrRes138")
            WScript.Quit (GENERAL_FAILURE)
    End If

    SrcObjectPath = Args(1)
    DestObjectPath = Args(2)

    SanitizePath SrcObjectPath
    SanitizePath DestObjectPath
    MachineName = SeparateMachineName(SrcObjectPath)
    ParentObjectPath = "IIS://" & MachineName

    ' Extract the left part of the paths until there are no more left parts to extract
    Do
        TmpSrcLeftPath = SplitLeftPath(SrcObjectPath)
        TmpDestLeftPath = SplitLeftPath(DestObjectPath)

        If (SrcObjectPath = "") Or (DestObjectPath = "") Then
            SrcObjectPath = TmpSrcLeftPath & "/" & SrcObjectPath
            DestObjectPath = TmpDestLeftPath & "/" & DestObjectPath
            Exit Do
        End If

        If (TmpSrcLeftPath <> TmpDestLeftPath) Then
            SrcObjectPath = TmpSrcLeftPath & "/" & SrcObjectPath
            DestObjectPath = TmpDestLeftPath & "/" & DestObjectPath
            Exit Do
        End If

        ParentObjectPath = ParentObjectPath & "/" & TmpSrcLeftPath
        ParentRelativePath = ParentRelativePath & "/" & TmpSrcLeftPath

    Loop

    SanitizePath SrcObjectPath
    SanitizePath DestObjectPath
    SanitizePath ParentObjectPath

    ' Now, open the parent object and Copy/Move the objects
    Set ParentObject = GetObject(ParentObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes139") & ParentObjectPath
        WScript.Quit (Err.Number)
    End If

    If (bCopyFlag) Then
        Set DestObject = ParentObject.CopyHere(SrcObjectPath, DestObjectPath)
    Else
        Set DestObject = ParentObject.MoveHere(SrcObjectPath, DestObjectPath)
    End If

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes140")
        WScript.Quit (Err.Number)
    End If

    If (bCopyFlag) Then
        WScript.Echo GetLocalizedResource("StrRes141") & ParentRelativePath & "/" & SrcObjectPath & GetLocalizedResource("StrRes142") & ParentRelativePath & "/" & DestObjectPath
    Else
        WScript.Echo GetLocalizedResource("StrRes143") & ParentRelativePath & "/" & SrcObjectPath & GetLocalizedResource("StrRes142") & ParentRelativePath & "/" & DestObjectPath
    End If

End Function

''''''''''''''''''''''''''
'
' StartServerCommand
'
' Starts a server in the metabase.
'
''''''''''''''''''''''''''
Function StartServerCommand()

    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim ObjectPath
    Dim MachineName

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes145")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)
    IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes146") & ObjectPath
        WScript.Quit (Err.Number)
    End If
'debug
'WScript.echo "About to start server.  Last Error: " & Err.Number
    IIsObject.Start
'WScript.echo "After starting server.  Last Error: " & Err.Number
    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes147") & ObjectPath
        WScript.Quit (Err.Number)
    End If
    WScript.Echo GetLocalizedResource("StrRes148") & ObjectPath & GetLocalizedResource("StrRes149")

End Function

''''''''''''''''''''''''''
'
' StopServerCommand
'
' Stops a server in the metabase.
'
''''''''''''''''''''''''''
Function StopServerCommand()

    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim ObjectPath
    Dim MachineName

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes150")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)
    IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes151") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    IIsObject.Stop
    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes152") & ObjectPath
        WScript.Quit (Err.Number)
    End If
    WScript.Echo GetLocalizedResource("StrRes148") & ObjectPath & GetLocalizedResource("StrRes154")

End Function

''''''''''''''''''''''''''
'
' PauseServerCommand
'
' Pauses a server in the metabase.
'
''''''''''''''''''''''''''
Function PauseServerCommand()

    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim ObjectPath
    Dim MachineName

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes155")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)
    IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes156") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    IIsObject.Pause
    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes157") & ObjectPath
        WScript.Quit (Err.Number)
    End If
    WScript.Echo GetLocalizedResource("StrRes148") & ObjectPath & GetLocalizedResource("StrRes159")

End Function

''''''''''''''''''''''''''
'
' ContinueServerCommand
'
' Continues a server in the metabase.
'
''''''''''''''''''''''''''
Function ContinueServerCommand()

    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim ObjectPath
    Dim MachineName

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes160")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)
    IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes161") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    IIsObject.Continue
    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes162") & ObjectPath
        WScript.Quit (Err.Number)
    End If
    WScript.Echo GetLocalizedResource("StrRes148") & ObjectPath & GetLocalizedResource("StrRes164")

End Function


Function FindData()
    ' FindData will accept 1 parameter from the command line - the node and
    ' property to search for (i.e. w3svc/1/ServerComment)

    On Error Resume Next

    Dim ObjectPath
    Dim ObjectParameter
    Dim NewObjectparameter
    Dim MachineName

    Dim IIsObjectPath
    Dim IIsObject

    Dim Path
    Dim PathList
    Dim I

    FindData = 0 ' Assume Success

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes165")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)

    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)
    ObjectParameter = SplitParam(ObjectPath)

    ' Since people may still want to use MDUTIL parameter names
    ' we should still do the GET translation of parameter names.
    NewObjectparameter = MapSpecGetParamName(ObjectParameter)
    ObjectParameter = NewObjectparameter

    If ObjectPath = "" Then
        IIsObjectPath = "IIS://" & MachineName
    Else
        IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath
    End If

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes166") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    ' Now, list out all the places where this property exists.
    PathList = IIsObject.GetDataPaths(ObjectParameter, IIS_DATA_INHERIT)
    If Err.Number <> 0 Then PathList = IIsObject.GetDataPaths(ObjectParameter, IIS_DATA_NO_INHERIT)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes167") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    If UBound(PathList) < 0 Then
        WScript.Echo GetLocalizedResource("StrRes168") & ObjectParameter & GetLocalizedResource("StrRes169") & ObjectPath
    Else
        WScript.Echo GetLocalizedResource("StrRes168") & ObjectParameter & GetLocalizedResource("StrRes171")

        For Each Path In PathList
            Path = Right(Path, Len(Path) - 6)
            Path = Right(Path, Len(Path) - InStr(Path, "/"))
            WScript.Echo "  " & Path
        Next
    End If

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes172") & ObjectPath
        WScript.Quit (Err.Number)
    End If

End Function

'''''''''''''''''''''
'
' MimeMapGet
'
' Special function for displaying a MimeMap property
'
'''''''''''''''''''''
Function MimeMapGet(ObjectPath, MachineName)
    On Error Resume Next

    Dim MimePath

    Dim MimeMapList
    Dim MimeMapObject
    Dim MimeEntry
    Dim MimeEntryIndex

    Dim MimeStr
    Dim MimeOutPutStr

    Dim DataPathList
    Dim DataPath

    MimeMapGet = 0 ' Assume Success

    MimePath = "IIS://" & MachineName
    If ObjectPath <> "" Then MimePath = MimePath & "/" & ObjectPath

    ' Get the object that contains the mimemap
    Set MimeMapObject = GetObject(MimePath)
    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes173") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    ' Test to see if the property is ACTUALLY set at this node
    DataPathList = MimeMapObject.GetDataPaths("MimeMap", IIS_DATA_INHERIT)
    If Err.Number <> 0 Then DataPathList = IIsObject.GetDataPaths(MimeMap, IIS_DATA_NO_INHERIT)
    Err.Clear

    ' If the data is not set anywhere, then stop the madness
    If (UBound(DataPathList) < 0) Then
        MimeMapGet = &H80005006  ' end with property not set error
        Exit Function
    End If

    DataPath = DataPathList(0)
    SanitizePath DataPath

    ' Test to see if the item is actually set HERE
    If UCase(DataPath) <> UCase(MimePath) Then
        MimeMapGet = &H80005006  ' end with property not set error
        Exit Function
    End If

    ' Get the mime map list from the object
    MimeMapList = MimeMapObject.Get("MimeMap")
    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes173") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    MimeOutPutStr = "MimeMap                         : (MimeMapList) "

    ' Enumerate the Mime Entries
    For MimeEntryIndex = 0 To UBound(MimeMapList)
        Set MimeEntry = MimeMapList(MimeEntryIndex)
        MimeOutPutStr = MimeOutPutStr & """" & MimeEntry.Extension & "," & MimeEntry.MimeType & """ "
    Next

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes175")
        WScript.Quit (Err.Number)
    End If

    WScript.Echo MimeOutPutStr

End Function



Function MimeMapSet(ObjectPath, ObjectParameter, MachineName)
    On Error Resume Next

    Dim MimePath

    Dim MimeEntryIndex
    Dim MimeMapList()
    Dim MimeMapObject
    Dim MimeEntry

    Dim MimeStr
    Dim MimeOutPutStr

    MimeMapSet = 0 ' Assume Success

    ' First, check the number of args
    If ArgCount < 3 Then
        WScript.Echo GetLocalizedResource("StrRes176")
        WScript.Quit (GENERAL_FAILURE)
    End If


    MimePath = "IIS://" & MachineName
    If ObjectPath <> "" Then MimePath = MimePath & "/" & ObjectPath

    ' Get the object that contains the mimemap
    Set MimeMapObject = GetObject(MimePath)
    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes177") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    ' Create a new MimeMapList of Mime Entries
    ReDim MimeMapList(ArgCount - 3)

    MimeOutPutStr = "MimeMap                         : (MimeMapList) "

    ' Fill the list with mime entries
    For MimeEntryIndex = 0 To UBound(MimeMapList)

        MimeStr = Args(2 + MimeEntryIndex)
        MimeOutPutStr = MimeOutPutStr & """" & MimeStr & """ "

        Set MimeEntry = CreateObject("MimeMap")

        MimeEntry.MimeType = Right (MimeStr, Len(MimeStr) - InStr(MimeStr, ","))
        MimeEntry.Extension = Left(MimeStr, InStr(MimeStr, ",") - 1)

        Set MimeMapList(MimeEntryIndex) = MimeEntry
    Next

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes175")
        WScript.Quit (Err.Number)
    End If

    MimeMapObject.MimeMap = MimeMapList
    MimeMapObject.Setinfo

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes179")
        WScript.Quit (Err.Number)
    End If

    WScript.Echo MimeOutPutStr

End Function

''''''''''''''''''''''''''
'
' IsSpecialGetProperty
'
' Checks to see if the property requires special processing in order to
' display its contents.
'
''''''''''''''''''''''''''
Function IsSpecialGetProperty(ObjectParameter)

    On Error Resume Next

    Select Case UCase(ObjectParameter)
        Case "MIMEMAP"
            IsSpecialGetProperty = True
        Case Else
            IsSpecialGetProperty = False
    End Select

End Function

''''''''''''''''''''''''''
'
' DoSpecialGetProp
'
' Checks to see if the property requires special processing in order to
' display its contents.
'
''''''''''''''''''''''''''
Function DoSpecialGetProp(ObjectPath, ObjectParameter, MachineName)

    On Error Resume Next

    Select Case UCase(ObjectParameter)
        Case "MIMEMAP"
            DoSpecialGetProp = MimeMapGet(ObjectPath, MachineName)
        Case Else
            DoSpecialGetProp = False
    End Select

End Function



''''''''''''''''''''''''''
'
' IsSpecialSetProperty
'
' Checks to see if the property is a type that needs to be handled
' specially for compatibility with mdutil
'
''''''''''''''''''''''''''
Function IsSpecialSetProperty(ObjectParameter)

    On Error Resume Next

    Select Case UCase(ObjectParameter)
        Case "APPPOOLCOMMAND"
            IsSpecialSetProperty = True
        Case "SERVERCOMMAND"
            IsSpecialSetProperty = True
        Case "ACCESSPERM"
            IsSpecialSetProperty = True
        Case "VRPATH"
            IsSpecialSetProperty = True
        Case "AUTHORIZATION"
            IsSpecialSetProperty = True
        Case "MIMEMAP"
            IsSpecialSetProperty = True
        Case Else
            IsSpecialSetProperty = False
    End Select
End Function

''''''''''''''''''''''''''
'
' DoSpecialSetProp
'
' Handles datatypes that need to be handled
' specially for compatibility with mdutil
'
''''''''''''''''''''''''''
Function DoSpecialSetProp(ObjectPath, ObjectParameter, MachineName)
    Dim IIsObjectPath
    Dim IIsObject
    Dim ValueList
    Dim ValueDisplay
    Dim PermIndex

    On Error Resume Next

    DoSpecialSetProp = 0 ' Assume Success
    Select Case UCase(ObjectParameter)
        Case "SERVERCOMMAND"

            IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath
            Set IIsObject = GetObject(IIsObjectPath)

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes180") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            If (IIsObject.KeyType <> "IIsWebServer") Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes181")
                WScript.Quit (GENERAL_FAILURE)
            End If

            ValueList = CLng(Args(2))
            Select Case ValueList
                Case 1
                    IIsObject.Start
                    If (Err.Number <> 0) Then
                        ReportError ()
                        WScript.Echo GetLocalizedResource("StrRes182") & ObjectPath
                        WScript.Quit (Err.Number)
                    End If
                    WScript.Echo GetLocalizedResource("StrRes148") & ObjectPath & GetLocalizedResource("StrRes184")
                Case 2
                    IIsObject.Stop
                    If (Err.Number <> 0) Then
                        ReportError ()
                        WScript.Echo GetLocalizedResource("StrRes185") & ObjectPath
                        WScript.Quit (Err.Number)
                    End If
                    WScript.Echo GetLocalizedResource("StrRes148") & ObjectPath & GetLocalizedResource("StrRes187")
                Case 3
                    IIsObject.Pause
                    If (Err.Number <> 0) Then
                        ReportError ()
                        WScript.Echo GetLocalizedResource("StrRes188") & ObjectPath
                        WScript.Quit (Err.Number)
                    End If
                    WScript.Echo GetLocalizedResource("StrRes148") & ObjectPath & GetLocalizedResource("StrRes190")
                Case 4
                    IIsObject.Continue
                    If (Err.Number <> 0) Then
                        ReportError ()
                        WScript.Echo GetLocalizedResource("StrRes191") & ObjectPath
                        WScript.Quit (Err.Number)
                    End If
                    WScript.Echo GetLocalizedResource("StrRes148") & ObjectPath & GetLocalizedResource("StrRes193")
                Case Else
                    WScript.Echo GetLocalizedResource("StrRes194") & ValueList
                    DoSpecialSetProp = GENERAL_FAILURE
            End Select
            Exit Function

        Case "APPPOOLCOMMAND"

            IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath
            Set IIsObject = GetObject(IIsObjectPath)

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes195") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            If (IIsObject.KeyType <> "IIsApplicationPool") Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes196")
                WScript.Quit (GENERAL_FAILURE)
            End If

            ValueList = CLng(Args(2))
            Select Case ValueList
                Case 1
                    IIsObject.Start
                    If (Err.Number <> 0) Then
                            ReportError ()
                            WScript.Echo GetLocalizedResource("StrRes197") & ObjectPath
                            WScript.Quit (Err.Number)
                    End If
                    WScript.Echo GetLocalizedResource("StrRes198") & ObjectPath & GetLocalizedResource("StrRes199")
                Case 2
                    IIsObject.Stop
                    If (Err.Number <> 0) Then
                            ReportError ()
                            WScript.Echo GetLocalizedResource("StrRes200") & ObjectPath
                            WScript.Quit (Err.Number)
                    End If
                    WScript.Echo GetLocalizedResource("StrRes198") & ObjectPath & GetLocalizedResource("StrRes201")
                Case Else
                    WScript.Echo GetLocalizedResource("StrRes203") & ValueList
                    DoSpecialSetProp = GENERAL_FAILURE
            End Select
            Exit Function

        Case "ACCESSPERM"
            IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath
            Set IIsObject = GetObject(IIsObjectPath)

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes204") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            ' Set the access flags to None, first, and then add them back, as necessary
            IIsObject.AccessFlags = 0

            ' Set up the display output
            ValueDisplay = "AccessFlags (AccessPerm)" & (Right(Spacer, SpacerSize - Len("AccessFlags (AccessPerm)")) & ": " & "(" & TypeName(IIsObject.AccessFlags) & ") ")

            ' Attempt to convert parameter to number
            Dim APValue
            Dim TempValStr

            TempValStr = Args(2)

            ' Check for Hex
            If (UCase(Left(Args(2), 2)) = "0X") Then
                TempValStr = "&H" & Right(TempValStr, Len(TempValStr) - 2)
            End If

            APValue = CLng(TempValStr)

            If (Err.Number = 0) Then
                IIsObject.AccessFlags = APValue
                ValueDisplay = ValueDisplay & " " & APValue & " (0x" & Hex(APValue) & ")"
            Else
                Err.Clear
                For PermIndex = 2 To ArgCount - 1
                    Select Case UCase(Args(PermIndex))
                        Case "READ"
                            IIsObject.AccessRead = True
                            ValueDisplay = ValueDisplay & " Read"
                        Case "WRITE"
                            IIsObject.AccessWrite = True
                            ValueDisplay = ValueDisplay & " Write"
                        Case "EXECUTE"
                            IIsObject.AccessExecute = True
                            ValueDisplay = ValueDisplay & " Execute"
                        Case "SCRIPT"
                            IIsObject.AccessScript = True
                            ValueDisplay = ValueDisplay & " Script"
                        Case Else
                            WScript.Echo GetLocalizedResource("StrRes205") & Args(PermIndex)
                            WScript.Quit (GENERAL_FAILURE)
                    End Select
                Next
            End If

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes206") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            IIsObject.Setinfo

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes206") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            ' Send the current settings to the screen
            WScript.Echo ValueDisplay

        Case "VRPATH"
            IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath
            Set IIsObject = GetObject(IIsObjectPath)

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes208") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            ' Set the access flags to None, first, and then add them back, as necessary
            IIsObject.Path = Args(2)

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes206") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            ' Set up the display output
            ValueDisplay = "Path (VRPath)" & (Right(Spacer, SpacerSize - Len("Path (VRPath)")) & ": " & "(" & TypeName(IIsObject.Path) & ") " & IIsObject.Path)

            IIsObject.Setinfo

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes206") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            ' Send the current settings to the screen
            WScript.Echo ValueDisplay

        Case "AUTHORIZATION"
            IIsObjectPath = "IIS://" & MachineName & "/" & ObjectPath
            Set IIsObject = GetObject(IIsObjectPath)

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes208") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            ' Set the auth flags to None, first, and then add them back, as necessary
            IIsObject.AuthFlags = 0

            ' Set up the display output
            ValueDisplay = GetLocalizedResource("StrRes270") & (Right(Spacer, SpacerSize - Len(GetLocalizedResource("StrRes270"))) & ": " & "(" & TypeName(IIsObject.AuthFlags) & ") ")

            For PermIndex = 2 To ArgCount - 1
                Select Case UCase(Args(PermIndex))
                    Case "NT"
                        IIsObject.AuthNTLM = True
                        ValueDisplay = ValueDisplay & " NT"
                    Case "ANONYMOUS"
                        IIsObject.AuthAnonymous = True
                        ValueDisplay = ValueDisplay & GetLocalizedResource("StrRes271")
                    Case "BASIC"
                        IIsObject.AuthBasic = True
                        ValueDisplay = ValueDisplay & GetLocalizedResource("StrRes272")
                    Case Else
                        WScript.Echo GetLocalizedResource("StrRes205") & Args(PermIndex)
                        WScript.Quit (GENERAL_FAILURE)
                End Select
            Next

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes206") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            IIsObject.Setinfo

            If (Err.Number <> 0) Then
                ReportError ()
                WScript.Echo GetLocalizedResource("StrRes206") & ObjectPath
                WScript.Quit (Err.Number)
            End If

            ' Send the current settings to the screen
            WScript.Echo ValueDisplay

        Case "MIMEMAP"
            DoSpecialSetProp = MimeMapSet(ObjectPath, ObjectParameter, MachineName)
'       Case "FILTER"
'           DoSpecialSetProp = FiltersSet()
        Case Else
            DoSpecialSetProp = GENERAL_FAILURE
    End Select
End Function

''''''''''''''''''''''''''''''
'
' Function SeparateMachineName
'
' This function will get the machine name from the Path parameter
' that was passed into the script.  It will also alter the passed in
' path so that it contains only the rest of the path - not the machine
' name.  If there is no machine name in the path, then the script
' will assume LocalHost.
'
''''''''''''''''''''''''''''''
Function SeparateMachineName(Path)
    On Error Resume Next

    ' Temporarily, just return LocalHost
    ' SeparateMachineName = "LocalHost"

    SeparateMachineName = TargetServer

    Exit Function
End Function

''''''''''''''''''''''''''''''
'
' Function MapSpecGetParamName
'
' Some parameters in MDUTIL are named differently in ADSI.
' This function maps the improtant parameter names to ADSI
' names.
'
''''''''''''''''''''''''''''''
Function MapSpecGetParamName(ObjectParameter)
    On Error Resume Next

    Select Case UCase(ObjectParameter)
        Case "ACCESSPERM"
            WScript.Echo GetLocalizedResource("StrRes215") & ObjectParameter & GetLocalizedResource("StrRes216")
            WScript.Echo GetLocalizedResource("StrRes217")
            MapSpecGetParamName = "AccessFlags"
        Case "VRPATH"
            MapSpecGetParamName = "Path"
        Case "AUTHORIZATION"
            WScript.Echo GetLocalizedResource("StrRes215") & ObjectParameter & GetLocalizedResource("StrRes221")
            WScript.Echo GetLocalizedResource("StrRes222")
            MapSpecGetParamName = "AuthFlags"
        Case Else
            ' Do nothing - the parameter doesn't map to anything special
            MapSpecGetParamName = ObjectParameter
    End Select
End Function

Sub ReportError()
'   On Error Resume Next

    Dim ErrorDescription

    Select Case (Err.Number)
        Case &H80070003
            ErrorDescription = GetLocalizedResource("StrRes267")
        Case &H80070005
            ErrorDescription = GetLocalizedResource("StrRes268")
        Case &H80070094
            ErrorDescription = GetLocalizedResource("StrRes269")
        Case Else
            ErrorDescription = Err.Description
    End Select

    WScript.Echo ErrorDescription
    WScript.Echo GetLocalizedResource("StrRes223") & Err.Number & " (0x" & Hex(Err.Number) & ")"
End Sub




Function SplitParam(ObjectPath)
' Note: Assume the string has been sanitized (no leading or trailing slashes)
    On Error Resume Next

    Dim SlashIndex
    Dim TempParam
    Dim ObjectPathLen

    SplitParam = ""  ' Assume no parameter
    ObjectPathLen = Len(ObjectPath)

    ' Separate the path of the node from the parameter
    SlashIndex = InStrRev(ObjectPath, "/")

    If (SlashIndex = 0) Or (SlashIndex = ObjectPathLen) Then
        TempParam = ObjectPath
        ObjectPath = "" ' ObjectParameter is more important
    Else
        TempParam = ObjectPath
        ObjectPath = Left(ObjectPath, SlashIndex - 1)
        TempParam = Right(TempParam, Len(TempParam) - SlashIndex)
    End If

    SplitParam = TempParam

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes225") & ObjectPath
        WScript.Quit (Err.Number)
    End If

End Function



Function SplitLeftPath(ObjectPath)
' Note: Assume the string has been sanitized (no leading or trailing slashes)
    On Error Resume Next

    Dim SlashIndex
    Dim TmpLeftPath
    Dim ObjectPathLen

    SplitLeftPath = ""  ' Assume no LeftPath
    ObjectPathLen = Len(ObjectPath)

    ' Separate the left part of the path from the remaining path
    SlashIndex = InStr(ObjectPath, "/")

    If (SlashIndex = 0) Or (SlashIndex = ObjectPathLen) Then
        TmpLeftPath = ObjectPath
        ObjectPath = ""
    Else
        TmpLeftPath = Left(ObjectPath, SlashIndex - 1)
        ObjectPath = Right(ObjectPath, Len(ObjectPath) - SlashIndex)
    End If

    SplitLeftPath = TmpLeftPath

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes234") & ObjectPath
        WScript.Quit (Err.Number)
    End If

End Function




Sub SanitizePath(ObjectPath)
    On Error Resume Next

    ' Remove WhiteSpace
    Do While (Left(ObjectPath, 1) = " ")
        ObjectPath = Right(ObjectPath, Len(ObjectPath) - 1)
    Loop

    Do While (Right(ObjectPath, 1) = " ")
        ObjectPath = Left(ObjectPath, Len(ObjectPath) - 1)
    Loop

    ' Replace all occurrences of \ with /
    ObjectPath = Replace(ObjectPath, "\", "/")

    ' Remove leading and trailing slashes
    If Left(ObjectPath, 1) = "/" Then
        ObjectPath = Right(ObjectPath, Len(ObjectPath) - 1)
    End If

    If Right(ObjectPath, 1) = "/" Then
        ObjectPath = Left(ObjectPath, Len(ObjectPath) - 1)
    End If

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes235") & ObjectPath
        WScript.Quit (Err.Number)
    End If

End Sub


'''''''''''''''''''''''''''''
' AppCreateCommand
'''''''''''''''''''''''''''''
Function AppCreateCommand(InProcFlag)
    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim ObjectPath
    Dim MachineName

    AppCreateCommand = 0 ' Assume Success

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes236")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)

    IIsObjectPath = "IIS://" & MachineName
    If ObjectPath <> "" Then
        IIsObjectPath = IIsObjectPath & "/" & ObjectPath
    End If

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes237") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    IIsObject.AppCreate2 (InProcFlag)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes238") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    WScript.Echo GetLocalizedResource("StrRes239")

End Function


'''''''''''''''''''''''''''''
' AppDeleteCommand
'''''''''''''''''''''''''''''
Function AppDeleteCommand()
    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim ObjectPath
    Dim MachineName

    AppDeleteCommand = 0 ' Assume Success

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes240")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)

    IIsObjectPath = "IIS://" & MachineName
    If ObjectPath <> "" Then
        IIsObjectPath = IIsObjectPath & "/" & ObjectPath
    End If

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes237") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    IIsObject.AppDelete

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes242") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    WScript.Echo GetLocalizedResource("StrRes243")

End Function


'''''''''''''''''''''''''''''
' AppUnloadCommand
'''''''''''''''''''''''''''''
Function AppUnloadCommand()
    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim ObjectPath
    Dim MachineName

    AppUnloadCommand = 0 ' Assume Success

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes244")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)

    IIsObjectPath = "IIS://" & MachineName
    If ObjectPath <> "" Then
        IIsObjectPath = IIsObjectPath & "/" & ObjectPath
    End If

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes237") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    IIsObject.AppUnload

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes246") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    WScript.Echo GetLocalizedResource("StrRes247")

End Function


Function AppDisableCommand()
    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim ObjectPath
    Dim MachineName

    AppDisableCommand = 0 ' Assume Success

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes248")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)

'debug
'WScript.Echo "Last Error: " & Err & " (" & Hex (Err) & "): " & Err.Description

    IIsObjectPath = "IIS://" & MachineName
    If ObjectPath <> "" Then
        IIsObjectPath = IIsObjectPath & "/" & ObjectPath
    End If

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes237") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    IIsObject.AppDisable

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes251") & ObjectPath
        WScript.Quit (Err.Number)
    End If

'debug
'WScript.Echo "Last Error: " & Err & " (" & Hex (Err) & "): " & Err.Description

    WScript.Echo GetLocalizedResource("StrRes253")

End Function

Function AppEnableCommand()
    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim ObjectPath
    Dim MachineName

    AppEnableCommand = 0 ' Assume Success

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes254")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)

'debug
'WScript.Echo "Last Error: " & Err & " (" & Hex (Err) & "): " & Err.Description

    IIsObjectPath = "IIS://" & MachineName
    If ObjectPath <> "" Then
        IIsObjectPath = IIsObjectPath & "/" & ObjectPath
    End If

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes237") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    IIsObject.AppEnable

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes257") & ObjectPath
        WScript.Quit (Err.Number)
    End If

'debug
'WScript.Echo "Last Error: " & Err & " (" & Hex (Err) & "): " & Err.Description

    WScript.Echo GetLocalizedResource("StrRes259")

End Function

'''''''''''''''''''''''''''''
' AppGetStatusCommand
'''''''''''''''''''''''''''''
Function AppGetStatusCommand()
    On Error Resume Next

    Dim IIsObject
    Dim IIsObjectPath
    Dim ObjectPath
    Dim MachineName
    Dim Status

    AppGetStatusCommand = 0 ' Assume Success

    If ArgCount <> 2 Then
        WScript.Echo GetLocalizedResource("StrRes260")
        WScript.Quit (GENERAL_FAILURE)
    End If

    ObjectPath = Args(1)
    SanitizePath ObjectPath
    MachineName = SeparateMachineName(ObjectPath)

    IIsObjectPath = "IIS://" & MachineName
    If ObjectPath <> "" Then
        IIsObjectPath = IIsObjectPath & "/" & ObjectPath
    End If

    Set IIsObject = GetObject(IIsObjectPath)

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes237") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    Status = IIsObject.AppGetStatus2

    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes262") & ObjectPath
        WScript.Quit (Err.Number)
    End If

    WScript.Echo GetLocalizedResource("StrRes263") & Status

End Function



 ''''''''''''''''''''''''''
'
' IsSecureProperty
'
' Checks to see if the property requires special processing in order to
' display its contents.
'
''''''''''''''''''''''''''
Function IsSecureProperty(ObjectParameter,MachineName)

    On Error Resume Next
    Dim PropObj,Attribute
    Set PropObj = GetObject("IIS://" & MachineName & "/schema/" & ObjectParameter)
    If (Err.Number <> 0) Then
        ReportError ()
        WScript.Echo GetLocalizedResource("StrRes264") & err.number
        WScript.Quit (Err.Number)
    End If
    Attribute = PropObj.Secure
    If (Attribute = True) Then
        IsSecureProperty = True
    Else
        IsSecureProperty = False
    End If
End Function


' We want to be able to cope with 32-bit unsigned integers,
' but CLng works with 32-bit signed integers
Function StringTo32BitUnsignedInteger(ValueData)
    Dim numVal
    If (UCase(Left(ValueData, 2))) = "0X" Then
        ValueData = "&h" & Right(ValueData, Len(ValueData) - 2)
    End If

    numVal = Int(ValueData) ' Despite its name, this actually turns it into a double.

    If numVal < 0 Or numVal >= 4294967296 Then
        ' this number is out of the range of a 32-bit unsigned integer,
        Err.Raise 6 ' overflow
    ElseIf numVal >= 2147483648 Then
        ' bias downwards by -2^32
        numVal = numVal - 4294967296
    End If

    StringTo32BitUnsignedInteger = CLng(numVal)
End Function


Function UnsignedIntegerToString(ValueData)
    Dim numVal

    numVal = CLng(ValueData)
    numVal = Int(numVal)

    If numVal < 0 Then
        numVal = numVal + 4294967296
    End If

    UnsignedIntegerToString = CStr(numVal)
End Function
