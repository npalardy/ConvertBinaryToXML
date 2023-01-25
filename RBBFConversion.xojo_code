#tag Module
Protected Module RBBFConversion
	#tag Method, Flags = &h0
		Function isRBBFFile(extends infile as folderitem) As boolean
		  If infile Is Nil Then
		    Return False
		  End If
		  If infile.Exists = False Then 
		    Return False
		  End If
		  If infile.Directory = True Then 
		    Return False
		  End If
		  
		  Try
		    Dim bis As BinaryStream = BinaryStream.Open(infile)
		    bis.LittleEndian = False
		    
		    Dim firstFour As String = bis.Read(4)
		    
		    If firstFour = "RbBF" Then
		      Return True
		    End If
		    
		  Catch iox As IOException
		    break
		  End Try
		  
		  Return False
		  
		End Function
	#tag EndMethod


	#tag Note, Name = From TT's RB Project Tools
		
		ACnm:ProjMgrUser
		ACsv:ProjMgrServer
		aivi:AutoIncVersion
		Alas:AliasName
		alis:FileAlias
		AltE:AlternateEditorID
		bApO:IsApplicationObject
		BbDd:BindDestBindData
		BbSd:BindSourceBindData
		BCar:BuildCarbonName
		bCls:IsClass
		BCMO:BuildCarbonMachOName
		BCXF:BuildCarbonExecutableFormat
		Bflg:BuildFlags
		bhlp:ItemHelp
		Bind:Binding
		BL86:BuildLinuxX86Name
		Blok:block
		BMac:BuildMacName
		BMDI:BuildWinMDI
		BMSS:BuildMinSizeAsString
		BMSz:BuildMinSize
		BnDd:BindDestData
		BnDs:BindDest
		BnSd:BindSourceData
		BnSr:BindSource
		bNtr:IsInterface
		bPEl:BrowserPositionElement
		bPGp:BrowserPositionGroup
		BSiz:BuildSize
		BSzS:BuildSizeAsString
		BunI:BundleIdentifier
		BWin:BuildWinName
		CBhv:ControlBehavior
		CBix:ControlIndex
		ccls:ControlClass
		ciID:ciID
		CIns:ConstantInstance
		CLan:CurrentLanguage
		Cnst:Constant
		Comp:Compatibility
		Cont:ObjContainerID
		CPal:ColorPalette
		CPif:InheritsFrom
		CPrg:GetAccessor
		CPrs:SetAccessor
		Ctrl:Control
		data:ItemData
		decl:ItemDeclaration
		defn:ItemDef
		DEnc:DefaultEncoding
		desc:ItemDescription
		dhlp:ItemDisabledHelp
		DLan:DefaultLanguage
		DVew:DefaultViewID
		elem:Element
		Enco:TextEncoding
		Enum:Enumeration
		eSpt:EditSplit
		FDef:FormDefn
		flag:ItemFlags
		fTyp:FileType
		HIns:HookInstance
		Hook:Hook
		Icon:Icon
		indx:ItemIndex
		Intr:Interfaces
		IVer:InfoVersion
		lang:ItemLanguage
		LsLc:LastLocation
		LSpt:EditSplit
		lstH:LastPositionH
		lstV:LastPositionV
		LVer:LongVersion
		MacC:MacCreator
		maEn:MenuAutoEnable
		mask:Mask
		MDIc:WinMDICaption
		Meth:Method
		MiAK:PCAltModifier
		MiAM:AlternateShortcutModifier
		MiKK:MacControlModifier
		MiMk:MenuShortcutModifier
		MiSK:MenuShortcut
		MItm:MenuItem
		MnuH:MenuHandler
		modd:LatestChange
		Mopt:MacOptionModifier
		Name,Cnst:ItemName
		name:ItemName
		Name:ObjName
		ndsc:EndSelCol
		ndsr:EndSelRow
		NnRl:NonRelease
		Note:Note
		ntln:NoteLine
		OTab:OpenTab
		parm:ItemParams
		path:FullPath
		pCur:Cursor
		pDBs:Database
		PDef:PropertyVal
		pEEx:ExtEncCode
		pExt:ExternalCode
		pFol:Folder
		pFTy:FileTypes
		pltf:ItemPlatform
		pMed:Movie
		pMnu:Menu
		pObj:Module
		pPic:Picture
		ppth:PartialPath
		pRes:Resources
		PrGp:PropertyGroup
		Proj:Project
		Prop:Property
		prTp:ProjectType
		pScp:Script
		PSIV:ProjectSavedInVers
		pTxt:AnyFile
		pUIs:UIState
		PVal:PropertyValue
		pVew:Window
		RbBF:RBProject
		rEdt:EditBounds
		Regn:Region
		Rels:Release
		rslt:ItemResult
		scKy:ScreenKey
		scut:ItemShortcut
		shrd:IsShared
		Size:ObjSize
		sorc:ItemSource
		spmu:ItemSpecialMenu
		srbp:SourceLineBreakpoint
		srcl:SourceLine
		Strx:Structure
		stsc:StartSelCol
		stsr:StartSelRow
		styl:ItemStyle
		Supr:Superclass
		SVer:ShortVersion
		SySF:SystemFlags
		text:ItemText
		tran:ItemTransparent
		type:ItemType
		vbET:EditorType
		Ver1:MajorVersion
		Ver2:MinorVersion
		Ver3:SubVersion
		Vsbl:Visible
		VwBh:ViewBehavior
		VwPr:ViewProperty
		WcmN:WcmN
		WiNm:WiNm
		WnSt:WindowState
		WpNm:WpNm
		
	#tag EndNote


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
