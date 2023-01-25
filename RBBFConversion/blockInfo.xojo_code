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
		#tag ViewProperty
			Name="id"
			Group="Behavior"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isClass"
			Group="Behavior"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ObjContainerID"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ObjName"
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Superclass"
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ItemFlags"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInterface"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsApplicationObject"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compatibility"
			Group="Behavior"
			Type="string"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
