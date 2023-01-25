#tag Module
Protected Module FolderitemExtensions
	#tag Method, Flags = &h0
		Function NameWithoutExtension(extends f as FolderItem) As String
		  
		  Dim parts() As String
		  
		  parts = Split(f.Name, ".")
		  
		  If parts.ubound < 1 Then
		    Return join(parts, ".")
		  End If
		  
		  parts.remove parts.ubound
		  
		  Return Join(parts," .")
		  
		  
		End Function
	#tag EndMethod


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
