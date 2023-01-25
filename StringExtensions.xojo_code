#tag Module
Protected Module StringExtensions
	#tag Method, Flags = &h0
		Function ContainsLowBytes(extends s as string) As boolean
		  
		  Dim mb As memoryblock = s
		  
		  For i As Integer = 0 To mb.Size - 1
		    
		    If mb.UInt8Value(i) < 32 Then
		      Return True
		    End If
		    
		  Next
		  
		  Return False
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
