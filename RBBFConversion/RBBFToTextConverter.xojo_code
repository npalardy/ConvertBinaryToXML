#tag Class
Protected Class RBBFToTextConverter
	#tag Method, Flags = &h0
		Function ConvertFile(infile as folderitem, outfile as folderitem) As integer
		  If infile Is Nil Then 
		    Print("inputfile is nil")
		    Return kFail
		  End If
		  If infile.exists = False Then 
		    Print("inputfile does not exist")
		    Return kFail
		  End If
		  If infile.Directory = True Then 
		    Print("inputfile is a directory")
		    Return kFail
		  End If
		  If isRBBFFile(infile) <> True Then
		    Print("inputfile is not an rbbf file")
		    Return kFail
		  End If
		  
		  If outfile Is Nil Then
		    Print("output directory can't be written to")
		    Return kFail
		  ElseIf outfile.exists = True Then 
		    Print("output directory already exists")
		    Return kFail
		  Else
		    outfile.CreateAsFolder
		    outputRoot = outfile
		  End If
		  
		  manifestStream = TextOutputStream.create( outputRoot.child("converted.xojo_project") )
		  
		  // file header
		  Dim bis As BinaryStream = BinaryStream.Open(infile)
		  bis.LittleEndian = False
		  
		  Dim header As format2header
		  header.StringValue(False) = bis.Read(format1header.Size)
		  If header.formatversion = 2 Then
		    bis.Position = 0
		    header.StringValue(False) = bis.Read(format2header.Size)
		  End If
		  
		  bis.Position = header.firstblock
		  
		  // now start reading blocks
		  
		  Try
		    
		    While True
		      
		      Dim blockTag As Int32 = bis.ReadInt32
		      Dim blockTagStr As String = fourCharAsString(blockTag)
		      
		      Select Case blockTag 
		      Case fourCharCode("Blok") 
		        If processBlocks( bis ) <> kSuccess Then
		          Return kFail
		        End If
		      Case fourCharCode("EOF!")
		        Exit While
		      Else
		        Print(" unhandled blok tag type " + blockTagStr )
		      End
		      
		    Wend
		    
		  End Try
		  
		  writeManifestBuffer
		  
		  Return kSuccess
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertRBBFBlockTagToXMLBlockTag(int32Tag as Int32) As String
		  Dim tagChars As String = fourCharAsString(int32Tag)
		  
		  Select Case int32Tag
		    
		  Case  fourCharCode("Proj") // project info block
		    Return "Project"
		    
		  Case fourCharCode("pObj") // module 
		    Return "Module"
		    
		  Case fourCharCode("pVew") // desktopwindow
		    Return "Window"
		    
		  Case fourCharCode("pMnu") // menu
		    Return "MenuBar"
		    
		  Case fourCharCode("pFolw") // folder
		    Return "Folder"
		    
		  Case fourCharCode("BSts") // main buildautomation entry
		    return "BuildAutomation"
		    
		  Case fourCharCode("Bsls") // each target
		    return "BuildStepsList"
		    
		  Case fourCharCode("BSbu") // build step
		    return "BuildProjectStep"
		    
		  Case fourCharCode("BScf") // copy files step
		    return "CopyFilesStep"
		    
		  Case fourCharCode("BSsc") // ide script steps
		    return "IDEScriptStep"
		    
		  Case fourCharCode("BSsn") // build step sign
		    return "SignProjectScriptStep"
		    
		  Case fourCharCode("IEsx") // external build script
		    return "ExternalScriptStep"
		    
		  Case fourCharCode("pRpt") // report
		    return "Report"
		    
		  Case fourcharCode("Aicn") // app icon
		    return "ApplicationIcon"
		    
		  Case fourcharCode("ioLS ") // ios launch screen
		    return "IOSLaunchScreen"
		    
		  Case fourCharCode("colr") // color group
		    return "ColorAsset"
		    
		  Case fourCharCode("Img ") // image
		    return "MultiImage"
		    
		  Case fourCharCode("pTbr") // toolbar
		    return "Toolbar"
		    
		  Case fourCharCode("WrKr") // worker
		    return "Worker"
		    
		  Case fourCharCode("pFTy") // filetype group
		    return "FileTypes"
		    
		  Case fourCharCode("pScn") // ios screen
		    return "IOSScreen"
		    
		  Case fourCharCode("iosv") // IOSView
		    return "IOSView"
		    
		  Case fourCharCode("Limg") // LaunchImages
		    return "LaunchImages"
		    
		  Case fourCharCode("pUIs") // ui state
		    return "UIState"
		    
		  Case fourcharCode("pWSe") //  Session
		    return "WebSession"
		    
		  Case fourcharCode("pWPg") //  Web page
		    return "WebPage"
		    
		  Case fourcharCode("pWSt") //  web style
		    Return "WebStyle"
		    
		  Case fourCharCode("pLay") // ios layout
		    Return "IOSLayout"
		    
		  Case fourcharCode("mobv") // mobile view ?
		    Return "MobileScreen"
		    
		  Case fourcharCode("xWSs") // web 2 session
		    Return "WebSession"
		    
		  Case fourcharCode("xWbV") // web 2 web page
		    Return "WebView"
		    
		  Case fourCharCode("pExt") // external item
		    Return "ExternalCode"
		    
		  Case fourCharCode("xWbC") // web 2 container
		    Return "WebContainer"
		    
		  Case fourCharCode("pDWn") // DesktopWindow
		    Return "DesktopWindow"
		    
		  Else
		    ' pasw
		    Dim unmappedTagStr As String
		    unmappedTagStr = tagChars
		    Print("**** ERROR **** unmapped rbbf BLOCK tag " + unmappedTagStr )
		    Break
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertRBBFTagToTextTag(rbbfTag as Int32) As String
		  Select Case rbbftag
		    
		  Case fourCharCode("aivi")
		    Return "AutoIncrementVersionInformation"
		  Case fourCharCode("Alas")
		    Return "AliasName"
		  Case fourCharCode("alis")
		    Return "FileAlias"
		  Case fourCharCode("Arch")
		    Return ""
		  Case fourCharCode("bApO")
		    Return "IsApplicationObject"
		  Case fourCharCode("bCls")
		    Return "IsClass"
		  Case fourCharCode("BCMO")
		    Return "MacCarbonMachName"
		  Case fourCharCode("bFAS")
		    Return "BuildForAppStore"
		  Case fourCharCode("Bflg")
		    Return "BuildFlags"
		  Case fourCharCode("bhlp")
		    Return "ItemHelp"
		  Case fourCharCode("binE")
		    Return "BinaryEnum"
		  Case fourCharCode("BL86")
		    Return "LinuxX86Name"
		  Case fourCharCode("BMDI")
		    Return "MDI"
		  Case fourCharCode("bNtr")
		    Return "IsInterface"
		  Case fourCharCode("BunI")
		    Return "OSXBundleID"
		  Case fourCharCode("BWin")
		    Return "WindowsName"
		  Case fourCharCode("CBix")
		    Return "ControlIndex"
		  Case fourCharCode("ccls")
		    Return "ControlClass"
		  Case fourCharCode("ccls")
		    Return "ControlClass"
		  Case fourCharCode("Ci1a")
		    Return "HLCItem1Attr"
		  Case fourCharCode("Ci2a")
		    Return "HLCItem2Attr"
		  Case fourCharCode("CLan")
		    Return "DebugLanguage"
		  Case fourCharCode("clr1")
		    Return "ColorLight"
		  Case fourCharCode("clr2")
		    Return "ColorDark"
		  Case fourCharCode("clrp")
		    Return "ColorPlatform"
		  Case fourCharCode("clrt")
		    Return "ColorType"
		  Case fourCharCode("cnfT")
		    Return "ConformsTo"
		  Case fourCharCode("Cni1")
		    Return "HLCItem1"
		  Case fourCharCode("Cni2")
		    Return "HLCItem2"
		  Case fourCharCode("CnLk")
		    Return "HLCEditable"
		  Case fourCharCode("CnMP")
		    Return "HLCScale"
		  Case fourCharCode("CnPr")
		    Return "HLCPriority"
		  Case fourCharCode("CnPv")
		    Return "HLCValue"
		  Case fourCharCode("CnRo")
		    Return "HLCRelOp"
		  Case fourCharCode("comM")
		    Return "Comment"
		  Case fourCharCode("Comp")
		    Return "Compatibility"
		  Case fourCharCode("Comp")
		    Return "Compatibility"
		  Case fourCharCode("Cont")
		    Return "ObjContainerID"
		  Case fourCharCode("cRDW")
		    Return "CopyRedistNextToWindowsEXE"
		  Case fourCharCode("data")
		    Return "ItemData"
		  Case fourcharcode("decl")
		    Return "ItemDeclaration"
		  Case fourCharCode("defn")
		    Return "ItemDef"
		  Case fourCharCode("defn")
		    Return "ItemDef"
		  Case fourCharCode("DEnc")
		    Return "DefaultEncoding"
		  Case fourCharCode("Dest")
		    Return "Subdirectory"
		  Case fourCharCode("deVi")
		    Return "Device"
		  Case fourCharCode("devT")
		    Return "DeviceType"
		  Case fourCharCode("DgCL")
		    Return "DebuggerCommandLine"
		  Case fourCharCode("dkmd")
		    Return "DarkMode"
		  Case fourCharCode("DLan")
		    Return "BuildLanguage"
		  Case fourCharCode("dscR")
		    Return "Description"
		  Case fourCharCode("DstR")
		    Return "Destination"
		  Case fourCharCode("DVew")
		    Return "DefaultWindow"
		  Case fourCharCode("Edpt")
		    Return "EditingPartID"
		  Case fourCharCode("enbl")
		    Return "Enabled"
		  Case fourCharCode("Enco")
		    Return "TextEncoding"
		  Case fourCharCode("Enco")
		    Return "TextEncoding"
		  Case fourCharCode("EnVv")
		    Return "EnvVars"
		  Case fourCharCode("flag")
		    Return "ItemFlags"
		  Case fourCharCode("flag")
		    Return "ItemFlags"
		  Case fourcharCode("FTpt")
		    Return "FilePhysicalType"
		  Case fourCharCode("FTRk")
		    Return "FileRank"
		  Case fourCharCode("GDIp")
		    Return "UseGDIPlus"
		  Case fourCharCode("HCla")
		    Return "HCLActive"
		  Case fourCharCode("HCnm")
		    Return "HLCName"
		  Case fourCharCode("hidp")
		    Return "HiDPI"
		  Case fourCharCode("iArc")
		    Return "IOSArchitecture"
		  Case fourCharCode("Icon")
		    Return "Icon"
		  Case fourCharCode("iDDv")
		    Return "IOSDebugDevice"
		  Case fourCharCode("IDEv")
		    Return "OrigIDEVersion"
		  Case fourCharCode("iLck")
		    Return "Locked"
		  Case fourCharCode("imPo")
		    Return "Imported"
		  Case fourCharCode("indx")
		    Return "ItemIndex"
		  Case fourCharCode("Intr")
		    Return "Interfaces"
		  Case fourcharCode("ioPP")
		    Return "ProvisioningProfileName"
		  Case fourCharCode("iOri")
		    Return "IOSLayoutEditorViewOrientation"
		  Case fourCharCode("iOsC")
		    Return "IOSCapabilities"
		  Case fourcharCode("isBn")
		    Return "BuildiOSName"
		  Case fourCharCode("itHd")
		    Return "HeightDouble"
		  Case fourCharCode("itHt")
		    Return "Height"
		  Case fourCharCode("itWd")
		    Return "Width"
		  Case fourcharcode("itwD")
		    Return "WidthDouble"
		  Case fourCharCode("IVer")
		    Return "InfoVersion"
		  Case fourCharCode("iVTy")
		    Return "IOSLayoutEditorViewType"
		  Case fourCharCode("kUTI")
		    Return "UTIType"
		  Case fourCharCode("lang")
		    Return "ItemLanguage"
		  Case fourCharCode("Lib ")
		    Return "LibraryName"
		  Case fourCharCode("linA")
		    Return "LinuxBuildArchitecture"
		  Case fourCharCode("lncs")
		    Return ""
		  Case fourCharCode("LVer")
		    Return "LongVersion"
		  Case fourCharCode("macA")
		    Return "MacBuildArchitecture"
		  Case fourCharCode("MacC")
		    Return "MacCreator"
		  Case fourCharCode("maEn")
		    Return "MenuAutoEnable"
		  Case fourCharCode("MaxW")
		    Return "WindowMaximized"
		  Case fourCharCode("MDIc")
		    Return "MDICaption"
		  Case fourCharCode("MiMk")
		    Return "MenuShortcutModifier"
		  Case fourCharCode("mimT")
		    Return "MimeType"
		  Case fourCharCode("MiSK")
		    Return "MenuShortcut"
		  Case fourCharCode("mVis")
		    Return "MenuItemVisible"
		  Case fourCharCode("name")
		    Return "ItemName"
		  Case fourCharCode("Name")
		    Return "ObjName"
		  Case fourCharCode("NnRl")
		    Return "NonRelease"
		  Case fourCharCode("ntln")
		    Return "NoteLine"
		  Case fourCharCode("objC")
		    Return "ObjectiveC"
		  Case fourCharCode("ocls")
		    Return "WebObjectClass"
		  Case fourCharCode("oPtL")
		    Return "OptimizationLevel"
		  Case fourCharCode("orie")
		    Return "Orientation"
		  Case fourCharCode("Padn")
		    Return ""
		  Case fourCharCode("parm")
		    Return "ItemParams"
		  Case fourCharCode("pasw")
		    Return ""
		  Case fourCharCode("path")
		    Return "FullPath"
		  Case fourCharCode("PDef")
		    Return "PropertyVal"
		  Case fourCharCode("plFM")
		    Return "Platform"
		  Case fourCharCode("pltf")
		    Return "ItemPlatform"
		  Case fourCharCode("ppth")
		    Return "PartialPath"
		  Case fourCharCode("PrGp")
		    Return "PropertyGroup"
		  Case fourCharCode("prTp")
		    Return "Type"
		  Case fourCharCode("prWA")
		    Return "IsWebProject"
		  Case fourCharCode("PSIV")
		    Return "RBProjectVersion"
		  Case fourCharCode("PtID")
		    Return "PartID"
		  Case fourCharCode("PtID")
		    Return "PartID"
		  Case fourCharCode("PVal")
		    Return "PropertyValue"
		  Case fourCharCode("rEdt")
		    Return "EditBounds"
		  Case fourCharCode("Regn")
		    Return "Region"
		  Case fourCharCode("Rels")
		    Return "Release"
		  Case fourCharCode("resZ")
		    Return "Resolution"
		  Case fourCharCode("rslt")
		    Return "ItemResult"
		  Case fourCharCode("runA")
		    Return "WindowsRunAs"
		  Case fourCharCode("SCtx")
		    Return "ScriptText"
		  Case fourCharCode("scut")
		    Return "ItemShortcut"
		  Case fourCharCode("SEdC")
		    Return "EditorCount"
		  Case fourCharCode("SEId")
		    Return "EditorIndex"
		  Case fourCharCode("SELn")
		    Return "EditorLocation"
		  Case fourCharCode("SEPt")
		    Return "EditorPath"
		  Case fourCharCode("shrd")
		    Return "IsShared"
		  Case fourCharCode("Soft")
		    Return "SoftLink"
		  Case fourCharCode("spmu")
		    Return "ItemSpecialMenu"
		  Case fourCharCode("srcl")
		    Return "SourceLine"
		  Case fourCharCode("StpA")
		    Return "StepAppliesTo"
		  Case fourCharCode("StST")
		    Return "SelectedTab"
		  Case fourCharCode("styl")
		    Return "ItemStyle"
		  Case fourCharCode("Supr")
		    Return "Superclass"
		  Case fourCharCode("Supr")
		    Return "SuperClass"
		  Case fourCharCode("SVer")
		    Return "ShortVersion"
		  Case fourCharCode("svin")
		    Return "SaveInfo"
		  Case fourCharCode("SySF")
		    Return "SystemFlags"
		  Case fourCharCode("Targ")
		    Return "Target"
		  Case fourCharCode("text")
		    Return "ItemText"
		  Case fourCharCode("TVew")
		    Return "DefaultTabletViewID"
		  Case fourCharCode("type")
		    Return "ItemType"
		  Case fourCharCode("type")
		    Return "ItemType"
		  Case fourCharCode("UsBF")
		    Return "UseBuildsFolder"
		  Case fourCharCode("Usin")
		    Return "GlobalUsingClauses"
		  Case fourCharCode("vbET")
		    Return "EditorType"
		  Case fourCharCode("Ver1")
		    Return "MajorVersion"
		  Case fourCharCode("Ver2")
		    Return "MinorVersion"
		  Case fourCharCode("Ver3")
		    Return "SubVersion" 
		  Case fourCharCode("Vsbl")
		    Return "Visible"
		  Case fourCharCode("Vsbl")
		    Return "Visible"
		  Case fourCharCode("VwBh")
		    Return "ViewBehavior"
		  Case fourCharCode("WbAn")
		    Return "WebHostingAppName"
		  Case fourCharCode("WbDS")
		    Return "WebDisconnectString"
		  Case fourCharCode("WbHd")
		    Return "WebHostingDomain"
		  Case fourCharCode("WbHI")
		    Return "WebHostingIdentifier"
		  Case fourCharCode("WbLS")
		    Return "WebLaunchString"
		  Case fourCharCode("WcmN")
		    Return "WinCompanyName"
		  Case fourCharCode("Wdpt")
		    Return "WebDebugPort"
		  Case fourCharCode("Web2")
		    Return "WebVersion"
		  Case fourCharCode("WHTM")
		    Return "WebHTMLHeader"
		  Case fourCharCode("WiFd")
		    Return "WinFileDescription"
		  Case fourCharCode("winA")
		    Return "WindowsArchitecture"
		  Case fourCharCode("WiNm")
		    Return "WinInternalName"
		  Case fourCharCode("wInV")
		    Return "WebControlInitialValue"
		  Case fourCharCode("WinV")
		    Return "WindowsVersions"
		  Case fourCharCode("Wpcl")
		    Return "WebProtocol"
		  Case fourCharCode("WpNm")
		    Return "WinProductName"
		  Case fourCharCode("Wprt")
		    Return "WebLivePort"
		  Case fourCharCode("WptS")
		    Return "WebSecurePort"
		  Case fourCharCode("WSSI")
		    Return "WebStyleStateID"
		  Case fourCharCode("IPDB")
		    Return "IncludePDB"
		  Case fourCharCode("WUI3")
		    Return "WinUIFramework"
		  Case fourCharCode("MacV")
		    Return "MacOSMinimumVersion"
		    
		  Else
		    ' pasw
		    Dim unmappedTagStr As String
		    unmappedTagStr = fourCharAsString(rbbfTag)  
		    Print("**** ERROR **** unmapped rbbf tag " + unmappedTagStr )
		    Break
		  End Select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertStringForTag(tag as Int32, value as String) As string
		  // certain tags treat their values specially
		  
		  Select Case tag
		    // project type
		  Case fourCharCode("prTp")
		    
		    Select Case value
		    Case "0"
		      Return "Desktop"
		    Case "1"
		      Return "Console"
		    Case "2"
		    Case "3"
		      Return "Web"
		    Case "4"
		      Return "iOS"
		    Else
		      Return value
		    End Select
		    
		    // buildFlags shoud be &h etc
		  Case fourCharCode("Bflg")
		    Dim v As Int32 = Val(value)
		    Return int32HexString(v)
		    
		  Case fourCharCode("prWA") // is web project
		    Dim v As Int32 = Val(value)
		    Return Int32BoolString(v)
		    
		  Case fourCharCode("DLan") // BuildLanguage
		    Dim v As Int32 = Val(value)
		    Return int32HexString(v)
		    
		  Case fourCharCode("cRDW") // copy redist
		    Dim v As Int32 = Val(value)
		    Return Int32BoolString(v)
		    
		  Case fourCharCode("DEnc") // defaultEncoding
		    Dim v As Int32 = Val(value)
		    Return int32HexString(v)
		    
		  Case fourCharCode("hidp") // hidpi
		    Dim v As Int32 = Val(value)
		    Return Int32BoolString(v)
		    
		  Else
		    Return value
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub eatPadding(bis as binarystream)
		  // now another tag
		  // size             4 bytes
		  // size * bytes     
		  
		  Dim size As Int32 = bis.ReadInt32
		  
		  bis.Position = bis.Position + size
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function fourCharAsString(fourChar as int32) As string
		  Dim mb As New memoryblock(4)
		  mb.LittleEndian = False
		  
		  mb.UInt32Value(0) = fourChar
		  
		  Return mb.StringValue(0,4)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function fourCharCode(param as string) As Int32
		  Dim mb As New memoryblock(4)
		  mb.LittleEndian = False
		  
		  mb.StringValue(0,4) = Left(param,4)
		  
		  Return mb.Int32Value(0)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function int32BoolString(i as int32) As string
		  Return Str(i  <> 0)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function int32HexString(i as int32) As string
		  Dim mb As New memoryblock(4)
		  mb.LittleEndian = False
		  
		  mb.Int32Value(0) = i
		  
		  Dim hexChars() As String = Split("0123456789ABCDEF","")
		  
		  Dim strResult() As String
		  strResult.append "&h"
		  strResult.append HexChars(ShiftRight( mb.UInt8Value(0) And &hF0, 4 ) )
		  strResult.append HexChars( mb.UInt8Value(0) And &h0F )
		  
		  strResult.append HexChars(ShiftRight( mb.UInt8Value(1) And &hF0, 4 ) )
		  strResult.append HexChars( mb.UInt8Value(1) And &h0F )
		  
		  strResult.append HexChars(ShiftRight( mb.UInt8Value(2) And &hF0, 4 ) )
		  strResult.append HexChars( mb.UInt8Value(2) And &h0F )
		  
		  strResult.append HexChars(ShiftRight( mb.UInt8Value(3) And &hF0, 4 ) )
		  strResult.append HexChars( mb.UInt8Value(3) And &h0F )
		  
		  Return Join(strResult, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Int32ToBool(i as int32) As Boolean
		  Return i <> 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function isRBBFFile(infile as folderitem) As boolean
		  Dim bis As BinaryStream = BinaryStream.Open(infile)
		  bis.LittleEndian = False
		  
		  Dim firstFour As Int32 = bis.ReadInt32
		  
		  If firstFour = fourCharCode("RbBF") Then
		    Return True
		  End If
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function MakeHexBytesValue(value as string) As string
		  Dim mb As MemoryBlock = value
		  Dim hexbytes As Integer = mb.Size
		  
		  Dim bytes() As String
		  For i As Integer = 0 To mb.size-1
		    bytes.append Right("00" + mb.UInt8Value(i).ToHex, 2)
		  next
		  
		  mb = Nil
		  
		  Return "<Hex bytes=""" + Str(hexbytes,"###0") + """>" + Join(bytes,"") + "</Hex>"
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function makeVerStr(param1 as Double) As String
		  // we get a double (usually like YYYY.RRB) 
		  // that we need to reformat as YYYYRRBB
		  
		  Dim verStr As String = Format(param1, "0000.000")
		  
		  Dim parts() As String = Split(verStr, ".")
		  
		  // YYYY only ?
		  If parts.Ubound < 1 Then
		    parts.append "01"
		  End If
		  
		  If Len(parts(1)) <= 2 Then
		    // YYYY.RR ????
		    Redim parts(2)
		    parts(2) = "00"
		  Else
		    Dim tmp As String = parts(1)
		    parts(1) = Left(tmp, 2)
		    Redim parts(2)
		    parts(2) = "0" + Mid(tmp,3,1)
		  End If
		  
		  Return Join(parts,"")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function makeXMLSafe(inStr as string) As string
		  Dim tmp As String = InStr
		  
		  If Left(tmp,6) = "&amp;h" Then
		    Return tmp
		  End If
		  If Left(tmp,6) = "&amp;c" Then
		    Return tmp
		  End If
		  
		  tmp = tmp.ReplaceAll("&", "&amp;")
		  tmp = tmp.ReplaceAll("<", "&lt;")
		  tmp = tmp.ReplaceAll(">", "&gt;")
		  tmp = tmp.ReplaceAll("'", "&apos;")
		  
		  Return tmp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub manifestWrite(line as String)
		  // manifest is a bunch of ordered line (the first 4 at least have to be in the right order)
		  // some things we patch AS they get written
		  
		  If Left(line,Len("RBProjectVersion=")) = "RBProjectVersion=" Then
		    mProjectVersion = Val(Trim(ReplaceAll(line,"RBProjectVersion=","")))
		  End If
		  
		  
		  mBufferedLines.append line
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub outputWrite(line as String)
		  // 
		  
		  return
		  outputstream.WriteLine(line)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function processBlocks(bis as BinaryStream) As integer
		  // block - Blok                    4 byte
		  //   type - Proj pObj pVew etc     4 bytes proj = project data, pObj may be class or module, pLay layout, mobv mobile view, Aicn app icon,
		  //   id                            4
		  //   ?                             4
		  //   size                          4 (from Blok to end) size - 32 ie remaining bytes to read (padded to multiple of 1024 ?)
		  //   ?                             4
		  //   ?                             4
		  //   ?                             4
		  // items*
		  
		  Dim blockHead As blockHeader
		  blockHead.StringValue(False) = bis.read(7 * sizeofInt32)
		  
		  Dim data As memoryblock 
		  data = bis.read( blockHead.blocksize - 32 )
		  data.LittleEndian = bis.LittleEndian
		  
		  Dim blockTypeStr As String = convertRBBFBlockTagToXMLBlockTag(blockHead.type)
		  
		  Dim retValue As Integer
		  
		  Select Case blockHead.type
		  Case fourCharCode("Proj")
		    retValue = processBlock_Project(blockTypeStr, blockHead,  data ) 
		  Else
		    retValue = processOneBlock(blockTypeStr, blockHead,  data ) 
		  end Select
		  
		  return retValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function processBlock_Project(blocktag as string, blockHead as blockHeader, data as memoryblock) As Integer
		  If blockHead.key1 <> 0 Or blockHead.key2 <> 0 Then
		    
		    Dim value As String
		    value = MakeHexBytesValue("Blok" + blockhead.StringValue(data.LittleEndian) + data.StringValue(0,data.Size) )
		    //outputWrite(value)
		    
		  Else
		    
		    // ok the mb we're handed we can use to back a binary stream !
		    Dim bis As New BinaryStream(data)
		    bis.LittleEndian = data.LittleEndian
		    
		    While bis.eof <> True
		      
		      // read a tag
		      Dim tag As Int32 = bis.ReadInt32
		      Dim tagStr As String
		      tagStr = fourCharAsString(tag)
		      
		      // certain tags are handled specially
		      If processGroupItem(tag, bis) = False Then
		        
		        // and its value type
		        Dim typetag As Int32 = bis.ReadInt32
		        Dim typeTagChars As String
		        typeTagChars = fourCharAsString(typeTag)
		        
		        Dim value As Variant = ReadType(bis, typetag)
		        // value = ConvertStringForTag(tag, value)
		        // 
		        // If value.containsLowBytes Then
		        // value = MakeHexBytesValue(value)
		        // Else
		        // // value = MakeXMLSafe(value)
		        // End If
		        
		        Dim key As String
		        
		        key = ConvertRBBFTagToTextTag(tag)
		        
		        If key <> "" Then
		          manifestWrite(key + "=" + value)
		        End If
		        
		      End
		      
		    Wend
		    
		  End If
		  
		  Return kSuccess
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function processGroupItem(tag as int32, bis as binarystream) As boolean
		  Dim tagChars As String
		  tagChars = fourCharAsString(tag)
		  
		  Select Case tag
		    
		  Case fourCharCode("Icon") // icon
		    Return readGroup(bis, "Icon")
		    
		  Case fourCharCode("CBhv") // control behaviour
		    Return readGroup(bis, "ControlBehavior")
		    
		  Case fourCharCode("Cnst") // constant
		    Return readGroup(bis, "Constant")
		    
		  Case fourCharCode("CIns") // constant instance
		    Return readGroup(bis, "ConstantInstance")
		    
		  Case fourCharCode("Ctrl") // control
		    Return readGroup(bis, "Control")
		    
		  Case fourCharCode("segC") // segmented control
		    Return readGroup(bis, "SegmentedControl")
		    
		  Case fourCharCode("PDef") // propval
		    Return processPropertyValue(bis)
		    
		  Case fourCharCode("VwBh") // view behaviour
		    Return readGroup(bis, "ViewBehavior")
		    
		  Case fourCharCode("Ctrl") // control
		    Return readGroup(bis, "Control")
		    
		  Case fourCharCode("MItm") // menuItem
		    Return readGroup(bis, "MenuItem")
		    
		  Case fourCharCode("USng") // using clause
		    Return readGroup(bis, "Using")
		    
		  Case fourCharCode("Rpsc") // report section
		    Return readGroup(bis, "ReportSection")
		    
		  Case fourCharCode("VwPr") // view prop
		    Return readGroup(bis, "ViewProperty")
		    
		  Case fourCharCode("Enum") // view prop enumerated values
		    Return readGroup(bis, "Enumeration")
		    
		  Case fourCharCode("HIns") // hook instance (event)
		    Return readGroup(bis, "HookInstance")
		    
		  Case fourCharCode("MnuH") // menu handler
		    Return readGroup(bis, "MenuHandler")
		    
		  Case fourCharCode("Meth") // method
		    Return readGroup(bis, "Method")
		    
		  Case fourCharCode("Dmth") // delegate
		    Return readGroup(bis, "DelegateDeclaration")
		    
		  Case fourCharCode("XMth") // external method
		    Return readGroup(bis, "ExternalMethod")
		    
		  Case fourCharCode("Hook") // event def
		    Return readGroup(bis, "Hook")
		    
		  Case fourcharcode("Note") // note
		    Return readGroup(bis, "Note")
		    
		  Case fourcharcode("Prop") // property
		    Return readGroup(bis, "Property")
		    
		  Case fourCharCode("CPrs") // computed property setter source
		    Return readGroup(bis, "SetAccessor")
		    
		  Case fourCharCode("CPrg") // computed property getter source
		    Return readGroup(bis, "GetAccessor")
		    
		  Case fourcharCode("Strx") // structure
		    Return readGroup(bis, "Structure")
		    
		  Case fourCharCode("sorc") // source lines
		    Return readGroup(bis, "ItemSource")
		    
		  Case fourCharCode("elem") // icon element
		    Return readGroup(bis, "Element")
		    
		  Case fourCharCode("ti  ") // toolbar items
		    Return readGroup(bis, "ToolItem")
		    
		  Case fourCharCode("ImgR") // image representation
		    Return readGroup(bis, "ImageRepresentation")
		    
		  Case fourCharCode("ImgS") // image spec
		    Return readGroup(bis, "ImageSpecification")
		    
		  Case fourCharCode("fTyp") // single type type entry
		    Return readGroup(bis, "FileType")
		    
		  Case fourcharCode("clrR") // single color repr in a color asset
		    Return readGroup(bis, "ColorRepresentation")
		    
		  Case fourcharCode("iSCI") // ScreenContentItem
		    Return readGroup(bis, "ScreenContentItem")
		    
		  Case fourCharCode("HLCn") // constraints
		    Return readGroup(bis, "HighLevelConstraint")
		    
		  Case fourCharCode("SwSt") // StudioWindowState
		    Return readGroup(bis, "StudioWindowState")
		    
		  Case fourcharcode("SEds") // ui state editors
		    Return readGroup(bis, "Editors")
		    
		  Case fourCharCode("SEdr") // ui state editor
		    Return readGroup(bis, "Editor")
		    
		  Case fourCharCode("WSSG") // web style state group
		    Return readGroup(bis, "WebStyleStateGroup")
		    
		  Case fourCharCode("Dseg") // 2021r3 desktop segmented ... yeah
		    Return readGroup(bis, "DesktopSegmentedButton")
		    
		  Else
		    
		    // Break
		    
		    Return False
		  End Select
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function processOneBlock(blocktag as string, blockHead as blockHeader, data as memoryblock) As Integer
		  // outputWrite("<block type=""" + blocktag + """ ID=""" + Str(blockHead.id,"#####0") + """>")
		  
		  Dim extension As String = "xojo_code"
		  Select Case blocktag
		    
		  Case "Window", "DesktopWindow"
		    extension = "xojo_window"
		    
		  Case "MenuBar"
		    extension = "xojo_menu"
		    
		  End Select
		  
		  // in a text project BLOCKS almost, without exception, turn into a single project file
		  
		  blockInfoStack.append New blockInfo
		  blockInfoStack(blockInfoStack.Ubound).Extension = extension
		  
		  If blockHead.key1 <> 0 Or blockHead.key2 <> 0 Then
		    
		    Dim value As String
		    value = MakeHexBytesValue("Blok" + blockhead.StringValue(data.LittleEndian) + data.StringValue(0,data.Size) )
		    // outputWrite(value)
		  Else
		    
		    blockInfoStack(blockInfoStack.Ubound).ID = blockHead.id
		    
		    // ok the mb we're handed we can use to back a binary stream !
		    Dim bis As New BinaryStream(data)
		    bis.LittleEndian = data.LittleEndian
		    
		    While bis.eof <> True
		      
		      // read a tag
		      Dim tag As Int32 = bis.ReadInt32
		      Dim tagStr As String
		      tagStr = fourCharAsString(tag)
		      
		      // certain tags are handled specially
		      If processGroupItem(tag, bis) = False Then
		        
		        // and its value type
		        Dim typetag As Int32 = bis.ReadInt32
		        Dim typeTagChars As String
		        typeTagChars = fourCharAsString(typeTag)
		        
		        Dim value As Variant = ReadType(bis, typetag)
		        // If value.containsLowBytes Then
		        // value = MakeHexBytesValue(value)
		        // Else
		        // value = MakeXMLSafe(value)
		        // End If
		        
		        Dim FileTag As String
		        
		        FileTag = ConvertRBBFTagToTextTag(tag)
		        
		        Select Case FileTag
		        Case "Name", "ObjName"
		          blockInfoStack(blockInfoStack.Ubound).ObjName = value
		        Case "IsClass"
		          blockInfoStack(blockInfoStack.Ubound).isClass = Int32ToBool(value)
		        Case "ObjContainerID"
		          blockInfoStack(blockInfoStack.Ubound).ObjContainerID = value
		        Case "Superclass"
		          blockInfoStack(blockInfoStack.Ubound).SuperClass = value
		        Case "ItemFlags"
		          blockInfoStack(blockInfoStack.Ubound).ItemFlags = value
		        Case "IsInterface"
		          blockInfoStack(blockInfoStack.Ubound).IsInterface = Int32ToBool(value)
		        Case "IsApplicationObject"
		          blockInfoStack(blockInfoStack.Ubound).IsApplicationObject = Int32ToBool(value)
		        Case "Compatibility"
		          blockInfoStack(blockInfoStack.Ubound).Compatibility = value
		          
		        Else
		          
		        End Select
		        
		      End
		      
		    Wend
		  End If
		  
		  // write this items entry to the manifest
		  Break
		  // Class=App;App.xojo_code;&h0000000013A767FF;&h0000000000000000;false
		  // a simple form
		  //
		  // ItemType=ItemName;ItemPath;ItemID;containerID;isEncrypted;[Transparency];[MaskID]
		  //
		  // So, for  example, if I had an encrypted class named Foobar
		  // whose ID was &h2156 and was inside a folder, it'd be written
		  // out like this:
		  //
		  // Class=Foobar;Foobar.bas;&h2156;&h1234;true
		  //
		  // If the item is a Picture object, then the last two fields may be
		  // present
		  //
		  // ItemPath is a relative path.  ".." means up one level
		  // and all path separators are assumed to be the "/"
		  // character, regardless of platform.
		  //
		  // All the fields are separated by a semi-colon
		  
		  If blockInfoStack(blockInfoStack.Ubound).IsApplicationObject Then
		    // class not module
		    manifestWrite("Class=" + blockInfoStack(blockInfoStack.Ubound).ObjName  ) // +_
		    // ";" + 
		  End If
		  
		  // pop the item as we wrote it
		  
		  Return kSuccess
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function processPropertyValue(bis as BinaryStream) As boolean
		  // and its value type
		  Dim grouptypetag As Int32 = bis.ReadInt32 // ALWAYS Grup !
		  Dim grouptypeTagChars As String
		  grouptypeTagChars = fourCharAsString(grouptypetag)
		  If grouptypetag <> fourCharCode("Grup") Then
		    bis.Position = bis.position - 4
		    Return False
		  End If
		  
		  Dim size As Int32 = bis.ReadInt32
		  Dim id As Int32 = bis.ReadInt32
		  Dim dataSize As Int32
		  dataSize = size - 4
		  
		  Dim name As String
		  Dim type As String
		  Dim group As String
		  Dim visible As boolean
		  Dim Encoding As Integer
		  Dim propValue As String
		  
		  Dim propNameTag As Int32 = bis.ReadInt32
		  Dim propNameTagChars As String = fourCharAsString(propNameTag)
		  
		  While propNameTag <> fourCharCode("EndG") 
		    
		    // and its value type
		    Dim typetag As Int32 = bis.ReadInt32
		    Dim typeTagChars As String
		    typeTagChars = fourCharAsString(typeTag)
		    
		    Dim value As String = ReadType(bis, typetag)
		    value = MakeXMLSafe(value)
		    
		    Select Case propNameTag
		      
		    Case fourCharCode("name")
		      name = value
		    Case fourCharCode("type")
		      type = value
		    Case fourCharCode("PrGp")
		      group = value
		    Case fourCharCode("visi")
		      visible = Val(value) = 0
		    Case fourCharCode("Enco")
		      Encoding = kUTF8
		    Case fourCharCode("PVal")
		      propValue = value
		    End Select
		    
		    propNameTag = bis.ReadInt32
		    propNameTagChars = fourCharAsString(propNameTag)
		    
		  Wend
		  
		  Dim endtype As Int32 = bis.ReadInt32
		  If endtype <> fourCharCode("Int ") Then
		    Break
		  End If
		  Dim endid As Int32 = bis.ReadInt32
		  If endId <> id Then
		    Break
		  End If
		  
		  If propValue.containsLowBytes Then
		    propValue = MakeHexBytesValue(propValue)
		  Else
		    propValue = MakeXMLSafe(propValue)
		  End If
		  
		  outputWrite("<PropertyVal Name=""" + name + """>" + propValue + "</PropertyVal>")
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function readGroup(bis as binarystream, groupName as string) As boolean
		  // and its value type
		  Dim grouptypetag As Int32 = bis.ReadInt32 // ALWAYS Grup !
		  Dim grouptypeTagChars As String
		  grouptypeTagChars = fourCharAsString(grouptypetag)
		  If grouptypetag <> fourCharCode("Grup") Then
		    bis.Position = bis.position - 4
		    Return False
		  End If
		  
		  Dim size As Int32 = bis.ReadInt32
		  Dim id As Int32 = bis.ReadInt32
		  Dim dataSize As Int32
		  dataSize = size - 4
		  
		  // outputWrite("<" + groupName + ">")
		  
		  Dim propNameTag As Int32 = bis.ReadInt32
		  Dim propNameTagChars As String = fourCharAsString(propNameTag)
		  
		  While propNameTag <> fourCharCode("EndG") 
		    
		    // certain tags are handled specially
		    If processGroupItem(propNameTag, bis) = False Then
		      
		      // and its value type
		      Dim typetag As Int32 = bis.ReadInt32
		      Dim typeTagChars As String
		      typeTagChars = fourCharAsString(typeTag)
		      
		      Dim value As variant = ReadType(bis, typetag)
		      
		      // If value.containsLowBytes Then
		      // value = MakeHexBytesValue(value)
		      // Elseif typeTag = fourCharCode("Rect") Then
		      // '
		      // Else
		      // value = MakeXMLSafe(value)
		      // End If
		      // 
		      // Dim xmlTag As String
		      // 
		      // xmlTag = ConvertRBBFTagToTextTag(propNameTag)
		      // 
		      // outputWrite("<" + xmlTag + ">" + value + "</" + xmlTag + ">")
		      
		    End 
		    
		    propNameTag = bis.ReadInt32
		    propNameTagChars = fourCharAsString(propNameTag)
		    
		  Wend
		  
		  Dim endtype As Int32 = bis.ReadInt32
		  If endtype <> fourCharCode("Int ") Then
		    Break
		  End If
		  Dim endid As Int32 = bis.ReadInt32
		  If endId <> id Then
		    Break
		  End If
		  
		  //outputWrite("</" + groupName + ">")
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function readStringFromStream(bis as BinaryStream) As string
		  Dim bytesToRead As Int32 = bis.ReadInt32
		  
		  Dim actualBytesToRead As Int32 = bytesToRead
		  
		  // we round this up to the nearest multiple of 4
		  If (actualBytesToRead Mod 4) <> 0 Then
		    actualBytesToRead = ((actualBytesToRead \ 4) + 1) * 4
		  End If
		  
		  Dim data As String = bis.read(actualBytesToRead)
		  
		  data = Left(data, bytesToRead)
		  
		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ReadType(bis as binarystream, inTag as Int32) As Variant
		  Select Case inTag
		    
		  Case fourCharCode("Strn")
		    Return readStringFromStream(bis)
		    
		  Case fourCharCode("Int ")
		    Dim tmpInt32 As Int32 = bis.ReadInt32
		    Return tmpInt32
		    
		  Case fourCharCode("Dbl ")
		    Dim tmpDbl As Double = bis.ReadDouble
		    Return tmpDbl
		    
		  Case fourCharCode("Padn")
		    eatPadding(bis)
		    
		  Case fourCharCode("Rect") 
		    Dim tmpInt32_1 As Int32 
		    Dim tmpInt32_2 As Int32 
		    Dim tmpInt32_3 As Int32 
		    Dim tmpInt32_4 As Int32 
		    tmpInt32_1 = bis.ReadInt32
		    tmpInt32_2 = bis.ReadInt32
		    tmpInt32_3 = bis.ReadInt32
		    tmpInt32_4 = bis.ReadInt32
		    
		    Return New REALbasic.Rect(tmpInt32_1,tmpInt32_2,tmpInt32_3,tmpInt32_4)
		    
		  Else
		    Dim unhandledTag As String
		    unhandledTag = fourCharAsString(inTag)
		    // Print("unhandled data type tag " + unhandledTag)
		    Break
		    
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function translatePSIVToVersion(psivString as String) As string
		  // we' hard wire a few just because
		  // Select Case psivString
		  // Case "2009.05"
		  // Return "2009r5"
		  // 
		  // Case "2019.011"
		  // Return "2019r1.1"
		  // 
		  // Case "2018.04"
		  // Return "2018r4"
		  // 
		  // Case "2020.021"
		  // Return "2020r2.1"
		  // 
		  // Case "2021.021"
		  // Return "2021r2.1"
		  // 
		  // End Select
		  
		  // in general they look like
		  // 2019.011 YYYY.RRB
		  //    YYYY year
		  //    RR   release
		  //    B    bug fix
		  Dim parts() As String = Split(psivString,".")
		  
		  If parts.Ubound < 1 Then
		    Return "2019r1.1"
		  End If
		  
		  Dim yearStr As String = parts(0)
		  Dim releaseStr As String = Left(parts(1), 2)
		  Dim bugStr As String = Left(Mid(parts(1), 3),1)
		  
		  Dim relParts() As String
		  relParts.Append Format(Val(yearStr),"0000")
		  relParts.Append "r"
		  relParts.Append Format(Val(releaseStr),"#0")
		  If Trim(bugStr) <> "" Then
		    relParts.Append "."
		    relParts.Append Format(Val(bugStr),"0")
		  End If
		  
		  Return Join(relParts,"")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub writeManifestBuffer()
		  Dim hasMinIDEVersion As Boolean
		  Dim hasOrigIDEVersion As Boolean
		  
		  // we need to sort a handful of lines
		  // and since it comes ouut of rbbf in an order different than required we chcek for other required tags as well
		  Dim sortOrder() As Integer 
		  Dim isWeb2 As Boolean
		  
		  For i As Integer = 0 To mBufferedLines.Ubound
		    
		    If Left(mBufferedLines(i),Len("Type=")) = "Type=" Then
		      
		      Select Case mBufferedLines(i)
		      Case "Type=0"
		        mBufferedLines(i) = "Type=Desktop"
		      Case "Type=1"
		        mBufferedLines(i) = "Type=Console"
		      Case "Type=3"
		        If mProjectVersion > 2020 Then
		          mBufferedLines(i) = "Type=Web2"
		          isWeb2 = True
		        Else
		          mBufferedLines(i) = "Type=Web"
		        End If
		      Case "Type=4"
		        mBufferedLines(i) = "Type=iOS"
		      End Select
		      sortorder.append 0
		      
		    ElseIf Left(mBufferedLines(i),Len("RBProjectVersion=")) = "RBProjectVersion=" Then
		      sortorder.Append 1
		      
		    ElseIf Left(mBufferedLines(i),Len("MinIDEVersion=")) = "MinIDEVersion=" Then
		      hasMinIDEVersion = True
		      sortorder.Append 2
		      
		    ElseIf Left(mBufferedLines(i),Len("OrigIDEVersion=")) = "OrigIDEVersion=" Then
		      hasOrigIDEVersion = True
		      sortorder.Append 3
		    Else
		      sortorder.Append i+10
		    End If
		    
		  Next
		  
		  If isWeb2 Then
		    // is web2 project ?
		    //    strip WebDisconnectString=The application has gone off-line. Please try again later.
		    //          WebLaunchString=Launching...
		    //          WebVersion=1
		    For  i As Integer = sortOrder.Ubound DownTo 0
		      If Left(mBufferedLines(i),Len("WebDisconnectString=")) = "WebDisconnectString=" Then
		        mBufferedLines.Remove i
		        sortOrder.Remove i
		      End If
		      If Left(mBufferedLines(i),Len("WebLaunchString=")) = "WebLaunchString=" Then
		        mBufferedLines.Remove i
		        sortOrder.Remove i
		      End If
		      If Left(mBufferedLines(i),Len("WebVersion=")) = "WebVersion=" Then
		        mBufferedLines.Remove i
		        sortOrder.Remove i
		      End If
		    Next
		  End If
		  
		  If hasMinIDEVersion = False Then
		    mBufferedLines.append "MinIDEVersion=" + makeVerStr(mProjectVersion)
		    sortorder.Append 2
		  End If
		  
		  If hasOrigIDEVersion = False Then
		    mBufferedLines.append "OrigIDEVersion=" + makeVerStr(mProjectVersion)
		    sortorder.Append 3
		  End If
		  
		  sortOrder.SortWith mBufferedLines
		  
		  
		  For i As Integer = 0 To mBufferedLines.Ubound
		    
		    manifestStream.WriteLine mBufferedLines(i)
		    
		  Next
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		blockInfoStack() As blockInfo
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected manifestStream As Writeable
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mBufferedLines() As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mProjectVersion As Double
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected outputRoot As Folderitem
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected outputstream As Writeable
	#tag EndProperty


	#tag Constant, Name = kFail, Type = Double, Dynamic = False, Default = \"-1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kSuccess, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kUTF8, Type = Double, Dynamic = False, Default = \"134217984", Scope = Public
	#tag EndConstant

	#tag Constant, Name = sizeofInt32, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant


	#tag Structure, Name = blockHeader, Flags = &h0
		type as Int32
		  id as int32
		  revision as int32
		  blocksize as int32
		  blockKeyFormat as int32
		  key1 as int32
		key2 as int32
	#tag EndStructure

	#tag Structure, Name = format1header, Flags = &h0
		signature as string*4
		  formatversion as int32
		  unknown1 as int32
		  unknown as int32
		firstblock as int32
	#tag EndStructure

	#tag Structure, Name = format2header, Flags = &h0
		signature as string*4
		  formatversion as int32
		  unknown1 as int32
		  unknown as int32
		  firstblock as int32
		  unknown3 as int32
		minversion as int32
	#tag EndStructure


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
