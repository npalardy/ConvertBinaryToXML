#tag Class
Protected Class RBBFToXMLConverter
	#tag Method, Flags = &h0
		Function ConvertFile(infile as folderitem, outfile as writeable) As integer
		  
		  
		  outputstream = outfile
		  
		  // file header
		  Dim bis As BinaryStream = BinaryStream.Open(infile)
		  bis.LittleEndian = False
		  
		  Dim header As format2header
		  header.StringValue(False) = bis.Read(format1header.Size)
		  If header.formatversion = 2 Then
		    bis.Position = 0
		    header.StringValue(False) = bis.Read(format2header.Size)
		  End If
		  
		  headerFormat = header.formatversion
		  
		  bis.Position = header.firstblock
		  
		  // now start reading blocks
		  
		  Try
		    outputWrite("<?xml version=""1.0"" encoding=""UTF-8""?>")
		    outputWrite("<RBProject version=""\(mVersion)"" FormatVersion=""" + Str(header.formatversion,"0") + """ MinIDEVersion=""" + Str(header.minversion, "00000000") + """>")
		    
		    While True
		      
		      Dim blockTag As Int32 = bis.ReadInt32
		      Dim blockTagStr As String = fourCharAsString(blockTag)
		      
		      Select Case blockTag 
		        
		      Case fourCharCode("Blok") 
		        
		        If processBlocks( bis ) <> kSuccess Then
		          Break
		          Return kFail
		        End If
		        
		      Case fourCharCode("EOF!")
		        Break
		        Exit While
		      Else
		        // Print(" unhandled blok tag type " + blockTagStr )
		      End
		      
		    Wend
		    
		    outputWrite("</RBProject>")
		    
		  End Try
		  
		  
		  Return kSuccess
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function convertRBBFBlockTagToXMLBlockTag(int32Tag as Int32) As String
		  Dim tagChars As String = fourCharAsString(int32Tag)
		  
		  If BlockTags.HasKey(tagChars) Then
		    Return BlockTags.Value(tagChars) 
		  Else
		    Break
		    
		    Print "unknown block tag [" + tagChars + "]"
		    
		    Return ""
		  End
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertRBBFTagToXMLTag(rbbfTag as Int32) As string
		  
		  Dim tagChars As String = fourCharAsString(rbbftag)
		  
		  If Tags.HasKey(tagChars) Then
		    Return Tags.Value(tagChars) 
		  Else
		    Break
		    
		    If isUnprintable(tagChars) Then
		      tagchars = fourCharAsHex(rbbftag)
		    End If
		    
		    Print "unknown tag [" + tagChars + "]"
		    
		    Return ""
		  End
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ConvertTypeToString(bis as binarystream, inTag as Int32) As string
		  Select Case inTag
		    
		  Case fourCharCode("Strn")
		    Return readStringFromStream(bis)
		    
		  Case fourCharCode("Int ")
		    Dim tmpInt32 As Int32 = bis.ReadInt32
		    Return Str(tmpInt32,"-###########0")
		    
		  Case fourCharCode("Dbl ")
		    Dim tmpDbl As Double = bis.ReadDouble
		    Dim tmpStr As String = Str(tmpDbl,"-###########0.00####")
		    Return tmpStr
		    
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
		    
		    Return "<Rect left=""" + Str(tmpInt32_1,"-####0") + """ top=""" + Str(tmpInt32_2,"-####0") + """ width=""" + Str(tmpInt32_3,"-####0") + """ height=""" + Str(tmpInt32_4,"-####0") + """/>"
		    
		  Case fourCharCode("Grup") 
		    Return ""
		    
		  Case fourCharCode("brkG") 
		    Break
		    Return ""
		  Else
		    Dim unhandledTag As String
		    unhandledTag = fourCharAsString(inTag)
		    //Print("unhandled data type tag " + unhandledTag)
		    Break
		    
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
		Protected Function fourCharAsHex(fourChar as Int32) As string
		  Dim mb As New memoryblock(4)
		  mb.LittleEndian = False
		  
		  mb.UInt32Value(0) = fourChar
		  
		  dim retString as string = "0x"
		  
		  retString = retString + Right( "00" + Hex(mb.UInt8Value(0)), 2)
		  retString = retString + Right( "00" + Hex(mb.UInt8Value(1)), 2)
		  retString = retString + Right( "00" + Hex(mb.UInt8Value(2)), 2)
		  retString = retString + Right( "00" + Hex(mb.UInt8Value(3)), 2)
		  
		  Return retString
		  
		End Function
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
		Protected Function isUnprintable(s as String) As boolean
		  Dim chars() As String = Split(s,"")
		  
		  For i As Integer = 0 To chars.ubound
		    
		    If Asc(chars(i)) < 32 Then
		      Return True
		    End If
		    
		  Next
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub loadTagsToDict(tags as String, d as CaseSensitiveDictionary)
		  d.Clear
		  
		  Dim lines() As String = Split(ReplaceLineEndings(tags, EndOfLine), EndOfLine)
		  
		  For Each line As String In lines
		    
		    If Trim(line) = "" Then
		      Continue
		    End If
		    
		    Dim parts() As String = Split(line, "|" )
		    
		    If parts.ubound < 0 Then 
		      break
		    End If
		    If parts(0).Len <> 4 Then
		      Break
		    End If
		    If parts.ubound < 1 Then 
		      parts.append ""
		    End If
		    
		    d.value(parts(0)) = parts(1)
		    
		  Next
		  
		  If 1 = 2 Then
		    Break
		  End If
		  
		End Sub
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
		Protected Sub outputWrite(line as String)
		  // as long as we havent set the "version" property we buffer lines
		  If mVersion <> "" Then
		    outputstream.WriteLine(line)
		  Else
		    mBufferedLines.append line
		  End If
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
		  
		  If processOneBlock(blockTypeStr, blockHead,  data ) <> kSuccess Then
		    break
		    Return kfail
		  End If
		  
		  Return kSuccess
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function processGroupItem(tag as int32, bis as binarystream) As boolean
		  Dim tagChars As String
		  tagChars = fourCharAsString(tag)
		  
		  Select Case tag
		    
		  Case fourCharCode("brkG") // control behaviour
		    Return readGroup(bis, "BreakPointGroup")
		  Case fourCharCode("CBhv") // control behaviour
		    Return readGroup(bis, "ControlBehavior")
		  Case fourCharCode("CIns") // constant instance
		    Return readGroup(bis, "ConstantInstance")
		  Case fourcharCode("clrR") // single color repr in a color asset
		    Return readGroup(bis, "ColorRepresentation")
		  Case fourCharCode("Cnst") // constant
		    Return readGroup(bis, "Constant")
		  Case fourCharCode("CPal") // color palette
		    Return skipGroup(bis, "ColorPalette")
		  Case fourCharCode("CPrg") // computed property getter source
		    Return readGroup(bis, "GetAccessor")
		  Case fourCharCode("CPrs") // computed property setter source
		    Return readGroup(bis, "SetAccessor")
		  Case fourCharCode("Ctrl") // control
		    Return readGroup(bis, "Control")
		  Case fourCharCode("Ctrl") // control
		    Return readGroup(bis, "Control")
		  Case fourCharCode("Dmth") // delegate
		    Return readGroup(bis, "DelegateDeclaration")
		  Case fourCharCode("elem") // icon element
		    Return readGroup(bis, "Element")
		  Case fourCharCode("Enum") // view prop enumerated values
		    Return readGroup(bis, "Enumeration")
		  Case fourCharCode("fTyp") // single type type entry
		    Return readGroup(bis, "FileType")
		  Case fourCharCode("HIns") // hook instance (event)
		    Return readGroup(bis, "HookInstance")
		  Case fourCharCode("HLCn") // constraints
		    Return readGroup(bis, "HighLevelConstraint")
		  Case fourCharCode("Hook") // event def
		    Return readGroup(bis, "Hook")
		  Case fourCharCode("Icon") // control behaviour
		    Return readGroup(bis, "Icon")
		  Case fourCharCode("ImgR") // image representation
		    Return readGroup(bis, "ImageRepresentation")
		  Case fourCharCode("ImgS") // image spec
		    Return readGroup(bis, "ImageSpecification")
		  Case fourcharCode("iSCI") // ScreenContentItem
		    Return readGroup(bis, "ScreenContentItem")
		  Case fourCharCode("Meth") // method
		    Return readGroup(bis, "Method")
		  Case fourCharCode("MItm") // menuItem
		    Return readGroup(bis, "MenuItem")
		  Case fourCharCode("MnuH") // menu handler
		    Return readGroup(bis, "MenuHandler")
		  Case fourcharcode("Note") // note
		    Return readGroup(bis, "Note")
		  Case fourCharCode("PDef") // propval
		    Return processPropertyValue(bis)
		  Case fourcharcode("Prop") // property
		    Return readGroup(bis, "Property")
		  Case fourCharCode("Rpsc") // report section
		    Return readGroup(bis, "ReportSection")
		  Case fourCharCode("SEdr") // ui state editor
		    Return readGroup(bis, "Editor")
		  Case fourcharcode("SEds") // ui state editors
		    Return readGroup(bis, "Editors")
		  Case fourCharCode("segC") // segmented control
		    Return readGroup(bis, "SegmentedControl")
		  Case fourCharCode("sorc") // source lines
		    Return readGroup(bis, "ItemSource")
		  Case fourcharCode("Strx") // structure
		    Return readGroup(bis, "Structure")
		  Case fourCharCode("SwSt") // StudioWindowState
		    Return readGroup(bis, "StudioWindowState")
		  Case fourCharCode("ti  ") // toolbar items
		    Return readGroup(bis, "ToolItem")
		  Case fourCharCode("USng") // using clause
		    Return readGroup(bis, "Using")
		  Case fourCharCode("VwBh") // view behaviour
		    Return readGroup(bis, "ViewBehavior")
		  Case fourCharCode("VwPr") // view prop
		    Return readGroup(bis, "ViewProperty")
		  Case fourcharCode("WrnP")
		    Return readGroup(bis, "WarningPreferences")
		  Case fourCharCode("WSSG") // web style state group
		    Return readGroup(bis, "WebStyleStateGroup")
		  Case fourCharCode("XMth") // external method
		    Return readGroup(bis, "ExternalMethod")
		    
		  Case fourCharCode("FDef")
		    Return readGroup(bis, "") // this makes the tags for this item as a wrapper NOT get emitted
		    
		    
		  Case fourCharCode("Dseg") // 2021r3 desktop segmented ... yeah
		    Return readGroup(bis, "DesktopSegmentedButton")
		    
		  Else
		    Return False
		  End Select
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function processOneBlock(blocktag as string, blockHead as blockHeader, data as memoryblock) As Integer
		  outputWrite("<block type=""" + blocktag + """ ID=""" + Str(blockHead.id,"-#####0") + """>")
		  
		  If BlockTag = "Project" Then
		    blockHead.key1 = 0 
		    blockHead.key2 = 0
		  End If
		  
		  If blockHead.blockKeyFormat <> 0 Then // blockHead.key1 <> 0 Or blockHead.key2 <> 0 Then
		    
		    Dim value As String
		    value = MakeHexBytesValue("Blok" + blockhead.StringValue(data.LittleEndian) + data.StringValue(0,data.Size) )
		    outputWrite(value)
		    
		  Else
		    
		    Dim watchForPSIV As Boolean
		    
		    If BlockTag = "Project" Then
		      watchForPSIV = True
		    End If
		    
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
		        
		        Dim value As String = ConvertTypeToString(bis, typetag)
		        If value.containsLowBytes Then
		          value = MakeHexBytesValue(value)
		        Else
		          value = MakeXMLSafe(value)
		        End If
		        
		        Dim xmlTag As String
		        
		        xmlTag = ConvertRBBFTagToXMLTag(tag)
		        
		        If xmlTag <> "" Then
		          outputWrite("<" + xmlTag + ">" + value + "</" + xmlTag + ">")
		        End If
		        
		        If watchForPSIV = True And tag = fourCharCode("PSIV") Then
		          mVersion = translatePSIVToVersion(value)
		        End If
		      End
		      
		    Wend
		    
		    If watchForPSIV = True Then
		      mVersion = translatePSIVToVersion("2005.01.01")
		    End If
		    
		  End If
		  
		  outputWrite("</block>")
		  
		  Return kSuccess
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function processPropertyValue(bis as BinaryStream) As boolean
		  // and its value type
		  Dim grouptypetag As Int32 = bis.ReadInt32 // ALWAYS Grup !
		  Dim grouptypeTagChars As String
		  grouptypeTagChars = fourCharAsString(grouptypetag)
		  If grouptypetag = fourCharCode("brkG") Then
		    Break
		  End If
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
		    
		    Dim value As String = ConvertTypeToString(bis, typetag)
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
		  If grouptypetag = fourCharCode("brkG") Then
		    Break
		  End If
		  If grouptypetag <> fourCharCode("Grup") Then
		    bis.Position = bis.position - 4
		    Return False
		  End If
		  
		  Dim size As Int32 = bis.ReadInt32
		  Dim id As Int32 = bis.ReadInt32
		  Dim dataSize As Int32
		  dataSize = size - 4
		  
		  Dim suppressGroup As Boolean
		  
		  If groupName = "" Then
		    suppressGroup = true
		  end if
		  
		  If suppressGroup = False Then
		    outputWrite("<" + groupName + ">")
		  End If
		  
		  Dim propNameTag As Int32 = bis.ReadInt32
		  Dim propNameTagChars As String = fourCharAsString(propNameTag)
		  
		  While propNameTag <> fourCharCode("EndG") 
		    
		    // certain tags are handled specially
		    If processGroupItem(propNameTag, bis) = False Then
		      
		      // and its value type
		      Dim typetag As Int32 = bis.ReadInt32
		      Dim typeTagChars As String
		      typeTagChars = fourCharAsString(typeTag)
		      
		      Dim value As String = ConvertTypeToString(bis, typetag)
		      
		      If value.containsLowBytes Then
		        value = MakeHexBytesValue(value)
		      Elseif typeTag = fourCharCode("Rect") Then
		        '
		      Else
		        value = MakeXMLSafe(value)
		      End If
		      
		      Dim xmlTag As String
		      
		      xmlTag = ConvertRBBFTagToXMLTag(propNameTag)
		      
		      If suppressGroup = False And xmlTag <> "" Then
		        outputWrite("<" + xmlTag + ">" + value + "</" + xmlTag + ">")
		      End If
		      
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
		  
		  If suppressGroup = false then
		    outputWrite("</" + groupName + ">")
		  End If
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function readStringFromStream(bis as BinaryStream) As string
		  Dim readStart As Int64 = bis.Position
		  
		  Dim bytesToRead As Int32 = bis.ReadInt32
		  
		  Dim actualBytesToRead As Int32 = bytesToRead
		  
		  // we round this up to the nearest multiple of 4
		  If (actualBytesToRead Mod 4) <> 0 Then
		    actualBytesToRead = ((actualBytesToRead \ 4) + 1) * 4
		  End If
		  
		  Dim data As String = bis.read(actualBytesToRead)
		  
		  // If bis.Position >= 2097516 Then
		  // Break
		  // End If
		  
		  data = Left(data, bytesToRead)
		  
		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function skipGroup(bis as binarystream, groupName as string) As boolean
		  // and its value type
		  Dim grouptypetag As Int32 = bis.ReadInt32 // ALWAYS Grup !
		  Dim grouptypeTagChars As String
		  grouptypeTagChars = fourCharAsString(grouptypetag)
		  If grouptypetag = fourCharCode("brkG") Then
		    Break
		  End If
		  
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
		      
		      Dim value As String = ConvertTypeToString(bis, typetag)
		      
		      If value.containsLowBytes Then
		        value = MakeHexBytesValue(value)
		      Elseif typeTag = fourCharCode("Rect") Then
		        '
		      Else
		        value = MakeXMLSafe(value)
		      End If
		      
		      // Dim xmlTag As String
		      
		      // xmlTag = ConvertRBBFTagToXMLTag(propNameTag)
		      
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
		  
		  // outputWrite("</" + groupName + ">")
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function translatePSIVToVersion(psivString as String) As string
		  // we hard wire a few just because
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


	#tag Property, Flags = &h21
		Private BlockTags As CaseSensitiveDictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  return mHeaderFormat
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHeaderFormat = value
			  
			  blockTags = New CaseSensitiveDictionary
			  
			  If value = 1 Then
			    loadTagsToDict( format_1_RBBFBlockTags, BlockTags )
			  Elseif value = 2 Then
			    loadTagsToDict( format_2_RBBFBlockTags, BlockTags )
			  Else
			    Break
			  End If
			  
			  tags = New CaseSensitiveDictionary
			  
			  If value = 1 Then
			    loadTagsToDict( format_1_Tags, tags )
			  Elseif value = 2 Then
			    loadTagsToDict( format_2_Tags, tags )
			  Else
			    Break
			  End If
			  
			  
			  
			End Set
		#tag EndSetter
		Private headerFormat As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mBufferedLines() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeaderFormat As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mmVersion As string
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  return mmVersion
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mmVersion = value
			  
			  For i As Integer = 0 To mBufferedLines.Ubound
			    
			    outputstream.WriteLine ReplaceAll(mBufferedLines(i), "\(mVersion)", value)
			    
			  Next
			  
			  redim mBufferedLines(-1)
			End Set
		#tag EndSetter
		Protected mVersion As string
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected outputstream As Writeable
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Tags As CaseSensitiveDictionary
	#tag EndProperty


	#tag Constant, Name = format_1_RBBFBlockTags, Type = String, Dynamic = False, Default = \"Aicn|ApplicationIcon\nBSbu|BuildProjectStep\nBScf|CopyFilesStep\nBsls|BuildStepsList\nBSsc|IDEScriptStep\nBSsn|SignProjectScriptStep\nBSts|BuildAutomation\ncolr|ColorAsset\nIEsx|ExternalScriptStep\nImg |MultiImage\nioLS|IOSLaunchScreen\niosv|IOSView\nLimg|LaunchImages\nmobv|MobileScreen\npExt|ExternalCode\npFol|Folder\npFTy|FileTypes\npLay|IOSLayout\npMnu|Menu\npObj|Module\nProj|Project\npRpt|Report\npScn|IOSScreen\npTbr|Toolbar\npUIs|UIState\npVew|Window\npWPg|WebPage\npWSe|WebSession\npWSt|WebStyle\nWrKr|Worker\nxWbC|WebContainer\nxWbV|WebView\nxWSs|WebSession\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = format_1_Tags, Type = String, Dynamic = False, Default = \"aivi|AutoIncVersion\nAlas|AliasName\nalis|FileAlias\nArch|\nbApO|IsApplicationObject\nBCar|BuildCarbonMachOName\nbCls|IsClass\nBCMO|BuildCarbonMachOName\nbFAS|BuildForAppStore\nBflg|BuildFlags\nbhlp|ItemHelp\nbinE|BinaryEnum\nBL86|BuildLinuxX86Name\nBMac|\nBMDI|BuildWinMDI\nBMSz|\nbNtr|IsInterface\nBSiz|\nBunI|BundleIdentifier\nBWin|BuildWinName\nCBix|ControlIndex\nccls|ControlClass\nccls|ControlClass\nCi1a|HLCItem1Attr\nCi2a|HLCItem2Attr\nCLan|CurrentLanguage\nclr1|ColorLight\nclr2|ColorDark\nclrp|ColorPlatform\nclrt|ColorType\ncnfT|ConformsTo\nCni1|HLCItem1\nCni2|HLCItem2\nCnLk|HLCEditable\nCnMP|HLCScale\nCnPr|HLCPriority\nCnPv|HLCValue\nCnRo|HLCRelOp\ncomM|Comment\nComp|Compatibility\nComp|Compatibility\nCont|ObjContainerID\ncRDW|CopyWindowsRedist\ndata|ItemData\ndecl|ItemDeclaration\ndefn|ItemDef\ndefn|ItemDef\nDEnc|DefaultEncoding\nDest|Subdirectory\ndeVi|Device\ndevT|DeviceType\nDgCL|DebuggerCommandLine\ndhlp|\ndkmd|DarkMode\nDLan|DefaultLanguage\ndscR|Description\nDstR|Destination\nDVew|DefaultViewID\nEdpt|EditingPartID\nenbl|Enabled\nEnco|TextEncoding\nEnco|TextEncoding\nEnVv|EnvVars\neSpt|\nflag|ItemFlags\nflag|ItemFlags\nFTpt|FilePhysicalType\nFTRk|FileRank\nGDIp|UseGDIPlus\nHCla|HCLActive\nHCnm|HLCName\nhidp|HiDPI\niArc|IOSArchitecture\nIcon|Icon\niDDv|IOSDebugDevice\nIDEv|IDEVersion\niLck|Locked\nimPo|Imported\nindx|ItemIndex\nIntr|Interfaces\nioPP|ProvisioningProfileName\niOri|IOSLayoutEditorViewOrientation\niOsC|IOSCapabilities\nisBn|BuildiOSName\nitHd|HeightDouble\nitHt|Height\nitWd|Width\nitwD|WidthDouble\nIVer|InfoVersion\niVTy|IOSLayoutEditorViewType\nkUTI|UTIType\nlang|ItemLanguage\nLib |LibraryName\nlinA|LinuxArchitecture\nlncs|\nlstH|\nlstV|\nLVer|LongVersion\nmacA|MacArchitecture\nMacC|MacCreator\nmaEn|MenuAutoEnable\nMaxW|WindowMaximized\nMDIc|WinMDICaption\nMiMk|MenuShortcutModifier\nmimT|MimeType\nMiSK|MenuShortcut\nmVis|MenuItemVisible\nname|ItemName\nName|ObjName\nndsc|\nndsr|\nNnRl|NonRelease\nntln|NoteLine\nobjC|ObjectiveC\nocls|WebObjectClass\nOPSp|\noPtL|OptimizationLevel\norie|Orientation\nPadn|\nparm|ItemParams\npasw|\npath|FullPath\nPDef|PropertyVal\nplFM|Platform\npltf|ItemPlatform\nppth|PartialPath\nPrGp|PropertyGroup\nprTp|ProjectType\nprWA|WebApp\nPSIV|ProjectSavedInVers\nPtID|PartID\nPtID|PartID\nPVal|PropertyValue\nrEdt|EditBounds\nRegn|Region\nRels|Release\nresZ|Resolution\nrslt|ItemResult\nrunA|WindowsRunAs\nSCtx|ScriptText\nscut|ItemShortcut\nSEdC|EditorCount\nSEId|EditorIndex\nSELn|EditorLocation\nSEPt|EditorPath\nshrd|IsShared\nsize|\nSize|\nSoft|SoftLink\nspmu|ItemSpecialMenu\nsrcl|SourceLine\nStpA|StepAppliesTo\nstsc|\nstsr|\nStST|SelectedTab\nstyl|ItemStyle\nSupr|Superclass\nSupr|SuperClass\nSVer|ShortVersion\nsvin|SaveInfo\nSySF|SystemFlags\nTarg|Target\ntext|ItemText\nTVew|DefaultTabletViewID\ntype|ItemType\ntype|ItemType\nUsBF|UseBuildsFolder\nUsin|GlobalUsingClauses\nvbET|EditorType\nVer1|MajorVersion\nVer2|MinorVersion\nVer3|SubVersion\nVsbl|Visible\nVsbl|Visible\nVwBh|ViewBehavior\nWbAn|WebHostingAppName\nWbDS|WebDisconnectString\nWbHd|WebHostingDomain\nWbHI|WebHostingIdentifier\nWbLS|WebLaunchString\nWcmN|BuildWinCompanyName\nWdpt|WebDebugPort\nWeb2|WebVersion\nWHTM|WebHTMLHeader\nWiFd|BuildWinFileDescription\nwinA|WindowsArchitecture\nWiNm|BuildWinInternalName\nwInV|WebControlInitialValue\nWinV|WindowsVersions\nWpcl|WebProtocol\nWpNm|BuildWinProductName\nWprt|WebPort\nWptS|WebSecurePort\nWSSI|WebStyleStateID\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = format_2_RBBFBlockTags, Type = String, Dynamic = False, Default = \"Aicn|ApplicationIcon\nBSbu|BuildProjectStep\nBScf|CopyFilesStep\nBsls|BuildStepsList\nBSsc|IDEScriptStep\nBSsn|SignProjectScriptStep\nBSts|BuildAutomation\ncolr|ColorAsset\nIEsx|ExternalScriptStep\nImg |MultiImage\nioLS|IOSLaunchScreen\niosv|IOSView\nLimg|LaunchImages\nmobv|MobileScreen\npExt|ExternalCode\npFol|Folder\npFTy|FileTypes\npLay|IOSLayout\npMnu|Menu\npObj|Module\nProj|Project\npRpt|Report\npScn|IOSScreen\npTbr|Toolbar\npUIs|UIState\npVew|Window\npWPg|WebPage\npWSe|WebSession\npWSt|WebStyle\nWrKr|Worker\nxWbC|WebContainer\nxWbV|WebView\nxWSs|WebSession\n\npDWn|DesktopWindow\npDTb|DesktopToolbar", Scope = Private
	#tag EndConstant

	#tag Constant, Name = format_2_Tags, Type = String, Dynamic = False, Default = \"aivi|AutoIncVersion\nAlas|AliasName\nalis|FileAlias\nArch|\nbApO|IsApplicationObject\nBCar|BuildCarbonMachOName\nbCls|IsClass\nBCMO|BuildCarbonMachOName\nbFAS|BuildForAppStore\nBflg|BuildFlags\nbhlp|ItemHelp\nbinE|BinaryEnum\nBL86|BuildLinuxX86Name\nBMac|\nBMDI|BuildWinMDI\nBMSz|\nbNtr|IsInterface\nBSiz|\nBunI|BundleIdentifier\nBWin|BuildWinName\nCBix|ControlIndex\nccls|ControlClass\nccls|ControlClass\nCi1a|HLCItem1Attr\nCi2a|HLCItem2Attr\nCLan|CurrentLanguage\nclr1|ColorLight\nclr2|ColorDark\nclrp|ColorPlatform\nclrt|ColorType\ncnfT|ConformsTo\nCni1|HLCItem1\nCni2|HLCItem2\nCnLk|HLCEditable\nCnMP|HLCScale\nCnPr|HLCPriority\nCnPv|HLCValue\nCnRo|HLCRelOp\ncomM|Comment\nComp|Compatibility\nComp|Compatibility\nCont|ObjContainerID\ncRDW|CopyWindowsRedist\ndata|ItemData\ndecl|ItemDeclaration\ndefn|ItemDef\ndefn|ItemDef\nDEnc|DefaultEncoding\nDest|Subdirectory\ndeVi|Device\ndevT|DeviceType\nDgCL|DebuggerCommandLine\ndhlp|\ndkmd|DarkMode\nDLan|DefaultLanguage\ndscR|Description\nDstR|Destination\nDVew|DefaultViewID\nEdpt|EditingPartID\nenbl|Enabled\nEnco|TextEncoding\nEnco|TextEncoding\nEnVv|EnvVars\neSpt|\nflag|ItemFlags\nflag|ItemFlags\nFTpt|FilePhysicalType\nFTRk|FileRank\nGDIp|UseGDIPlus\nHCla|HCLActive\nHCnm|HLCName\nhidp|HiDPI\niArc|IOSArchitecture\nIcon|Icon\niDDv|IOSDebugDevice\nIDEv|IDEVersion\nIPDB|IncludePDB\niLck|Locked\nimPo|Imported\nindx|ItemIndex\nIntr|Interfaces\nioPP|ProvisioningProfileName\niOri|IOSLayoutEditorViewOrientation\niOsC|IOSCapabilities\nisBn|BuildiOSName\nitHd|HeightDouble\nitHt|Height\nitWd|Width\nitwD|WidthDouble\nIVer|InfoVersion\niVTy|IOSLayoutEditorViewType\nkUTI|UTIType\nlang|ItemLanguage\nLib |LibraryName\nlinA|LinuxArchitecture\nlncs|\nlnNM|lineNum\nlstH|\nlstV|\nLVer|LongVersion\nmacA|MacArchitecture\nMacC|MacCreator\nMacV|MacMinimumVersion\nmaEn|MenuAutoEnable\nMaxW|WindowMaximized\nMDIc|WinMDICaption\nMiMk|MenuShortcutModifier\nmimT|MimeType\nMiSK|MenuShortcut\nmVis|MenuItemVisible\nname|ItemName\nName|ObjName\nndsc|\nndsr|\nNnRl|NonRelease\nntln|NoteLine\nobjC|ObjectiveC\nocls|WebObjectClass\nOPSp|\noPtL|OptimizationLevel\norie|Orientation\nPadn|\nparm|ItemParams\npasw|\npath|FullPath\nPDef|PropertyVal\nplFM|Platform\npltf|ItemPlatform\nppth|PartialPath\nPrGp|PropertyGroup\nprTp|ProjectType\nprWA|WebApp\nPSIV|ProjectSavedInVers\nPtID|PartID\nPtID|PartID\nPVal|PropertyValue\nrEdt|EditBounds\nRegn|Region\nRels|Release\nresZ|Resolution\nrslt|ItemResult\nrunA|WindowsRunAs\nSCtx|ScriptText\nscut|ItemShortcut\nSEdC|EditorCount\nSEId|EditorIndex\nSELn|EditorLocation\nSEPt|EditorPath\nshrd|IsShared\nsize|\nSize|\nSoft|SoftLink\nspmu|ItemSpecialMenu\nsrcl|SourceLine\nStpA|StepAppliesTo\nstsc|\nstsr|\nStST|SelectedTab\nstyl|ItemStyle\nSupr|Superclass\nSVer|ShortVersion\nsvin|SaveInfo\nSySF|SystemFlags\nTarg|Target\ntext|ItemText\nTVew|DefaultTabletViewID\ntype|ItemType\ntype|ItemType\nunTY|UnitType\nunID|UnitID\nUsBF|UseBuildsFolder\nUsin|GlobalUsingClauses\nvbET|EditorType\nVer1|MajorVersion\nVer2|MinorVersion\nVer3|SubVersion\nVsbl|Visible\nVsbl|Visible\nVwBh|ViewBehavior\nWbAn|WebHostingAppName\nWbDS|WebDisconnectString\nWbHd|WebHostingDomain\nWbHI|WebHostingIdentifier\nWbLS|WebLaunchString\nWcmN|BuildWinCompanyName\nWdpt|WebDebugPort\nWeb2|WebVersion\nWHTM|WebHTMLHeader\nWiFd|BuildWinFileDescription\nwinA|WindowsArchitecture\nWiNm|BuildWinInternalName\nwInV|WebControlInitialValue\nWinV|WindowsVersions\nWpcl|WebProtocol\nWpNm|BuildWinProductName\nWprt|WebPort\nWptS|WebSecurePort\nWSSI|WebStyleStateID\nWUI3|WinUIFramework", Scope = Private
	#tag EndConstant

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
