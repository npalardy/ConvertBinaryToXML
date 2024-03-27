#tag Class
Protected Class ConsoleApp
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  #If debugbuild 
		    Redim args(3)
		    args(0) = app.ExecutableFile.NativePath
		    args(1) = "text"
		    
		    // API 1 project
		    args(2) = "/Users/npalardy/Great White Software/Xojo Converter/Converter Samples/2023r1/desktop/toConvert.xojo_binary_project" 
		    args(3) = "/Users/npalardy/Great White Software/Xojo Converter/Converter Samples/2023r1/desktop/Converted.Xojo_project"
		    
		    // API 2 project
		    // args(2) = "/Users/npalardy/Great White Software/Xojo Converter/Converter Samples/2023r1/desktop/toConvertAPI2.xojo_binary_project" 
		    // args(3) = "/Users/npalardy/Great White Software/Xojo Converter/Converter Samples/2023r1/desktop/ConvertedAPI2.Xojo_project"
		    
		    
		    // args(1) = "xml"
		    
		    // API 1 project
		    // args(2) = "/Users/npalardy/Great White Software/Xojo Converter/Converter Samples/2023r1/desktop/toConvert.xojo_binary_project" 
		    // args(3) = "/Users/npalardy/Great White Software/Xojo Converter/Converter Samples/2023r1/desktop/Converted.Xojo_xml_project"
		    
		    // API 2 project
		    // args(2) = "/Users/npalardy/Great White Software/Xojo Converter/Converter Samples/2023r1/desktop/toConvertAPI2.xojo_binary_project" 
		    // args(3) = "/Users/npalardy/Great White Software/Xojo Converter/Converter Samples/2023r1/desktop/ConvertedAPI2.Xojo_project"
		    
		    
		  #EndIf
		  
		  If args.Ubound < 1 Then
		    help
		    Return kSuccess
		  End If
		  
		  If args.Ubound < 1 Then
		    Help
		    Return kSuccess
		  End If
		  
		  args.remove 0
		  
		  If args(0) = "text" Then
		    args.remove 0
		    Return DoConvertToText(args)
		  Elseif args(0) = "xml" Then
		    args.remove 0
		    Return DoConvertToXML(args)
		  Else
		    Help
		    Return kSuccess
		  End If
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function DoConvertToText(args() as string) As Integer
		  
		  Print("Convert to TEXT format is not complete")
		  Return 0
		  
		  Dim infile As folderitem
		  Dim outfile As folderitem
		  
		  // requires inputfile & outputDir
		  If args.Ubound < 1 Then
		    Help
		    Return kSuccess
		  End If
		  
		  If Left(args(0), Len("file://")) = "file://" Then
		    infile = New folderitem(args(0), FolderItem.PathTypeURL)
		  Else
		    infile = New folderitem(args(0), FolderItem.PathTypeNative)
		  End If
		  
		  If Left(args(1), Len("file://")) = "file://" Then
		    outfile = New folderitem(args(1), FolderItem.PathTypeURL)
		  Else
		    outfile = New folderitem(args(1), FolderItem.PathTypeNative)
		  End If
		  
		  Dim converter As New RBBFConversion.RBBFToTextConverter
		  
		  Return converter.ConvertFile(infile, outfile)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoConvertToXML(args() as string) As Integer
		  If args.Ubound < 0 Then
		    help
		    Return kSuccess
		  End If
		  
		  Dim infile As folderitem
		  Dim outfile As folderitem
		  
		  infile = New folderitem(args(0), FolderItem.PathTypeNative)
		  
		  If Left(args(0), Len("file://")) = "file://" Then
		    infile = New folderitem(args(0), FolderItem.PathTypeURL)
		  Else
		    infile = New folderitem(args(0), FolderItem.PathTypeNative)
		  End If
		  
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
		  If infile.isRBBFFile <> True Then
		    Print("inputfile is not an rbbf file")
		    Return kFail
		  End If
		  
		  Dim outputstream As writeable = stdout
		  
		  If args.Ubound >= 1 Then
		    
		    If Left(args(1), Len("file://")) = "file://" Then
		      outfile = New folderitem(args(1), FolderItem.PathTypeURL)
		    Else
		      outfile = New folderitem(args(1), FolderItem.PathTypeNative)
		    End If
		    
		    If outfile.Directory = True Then 
		      Print("output file is a directory - cant overwrite")
		      Return kFail
		    ElseIf outfile.exists = True Then 
		      Print("output file already exists")
		      Return kFail
		    Else
		      outputstream = TextOutputStream.Create(outfile)
		    End If
		    
		  End If
		  
		  
		  If args.ubound > 1 Then
		    Print("extraneous arguments ignored")
		  End If
		  
		  Dim converter As New RBBFConversion.RBBFToXMLConverter
		  
		  Return converter.ConvertFile(infile, outputstream)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Help()
		  
		  Print("converter : a tool to convert Xojo binary projects to XML or TEXT format")
		  Print("")
		  Print("usage : converter [text|xml] infile [outfile]")
		  Print("")
		  Print("        text|xml - the destination type to convert to")
		  Print("                   if NOT specificed the default is XML")
		  Print("                   when converting to TEXT the output parameter must be a directory")
		  Print("")
		  Print("        infile - A file specified either by a file:// URL or by a native path")
		  Print("                 infile MUST be a binary project file")
		  Print("")
		  Print("        outfile - optional for XML output only. REQUIRED FOR TEXT.")
		  Print("                  For XML  - A file specified either by a file:// URL or by a native path")
		  Print("                             outfile must not already exist and cannot be a directory")
		  Print("                             It will be created as part of the conversion process")
		  Print("                  For TEXT - A directory specified either by a file:// URL or by a native path")
		  Print("                             outfile must not already exist")
		  Print("                             It will be created as part of the conversion process")
		  Print("                             and all conversion results placed in the new directory")
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kFail, Type = Double, Dynamic = False, Default = \"-1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kSuccess, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant


	#tag Enum, Name = ConvertToTypes, Type = Integer, Flags = &h0
		XML
		Text
	#tag EndEnum


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
