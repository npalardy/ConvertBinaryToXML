#tag Class
Protected Class blockInfo
	#tag Method, Flags = &h0
		Sub Constructor()
		  code = New blockLines
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		code As blockLines
	#tag EndProperty

	#tag Property, Flags = &h0
		Compatibility As string
	#tag EndProperty

	#tag Property, Flags = &h0
		extension As string
	#tag EndProperty

	#tag Property, Flags = &h0
		id As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IsApplicationObject As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		isClass As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		IsInterface As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ItemFlags As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		name As string
	#tag EndProperty

	#tag Property, Flags = &h0
		ObjContainerID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ObjName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Superclass As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="name"
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
		#tag ViewProperty
			Name="id"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="isClass"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ObjContainerID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ObjName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Superclass"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ItemFlags"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInterface"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsApplicationObject"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compatibility"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
