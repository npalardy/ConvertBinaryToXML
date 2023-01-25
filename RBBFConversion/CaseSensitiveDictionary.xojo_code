#tag Class
Protected Class CaseSensitiveDictionary
Inherits Dictionary
	#tag Method, Flags = &h0
		Function HasKey(keyString as string) As boolean
		  
		  // convert key to base64
		  Dim b64key As String =  EncodeBase64(keystring)
		  
		  // see if super has this
		  return Super.HasKey(b64key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(keyString as string) As variant
		  
		  // convert key to base64
		  Dim b64key As String =  EncodeBase64(keystring)
		  
		  // see if super has this
		  return Super.Value(b64key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(keyString as string, assigns value as Variant)
		  
		  // convert key to base64
		  Dim b64key As String =  EncodeBase64(keystring)
		  
		  // put it in super
		  Super.Value(b64key) = value
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="BinCount"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
