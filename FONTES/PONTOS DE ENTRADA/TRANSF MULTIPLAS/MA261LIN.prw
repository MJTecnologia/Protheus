User Function MA261LIN()

Local lRet        := .T.
Local aArea       := GetArea()
Local aAreaD3     := SD3->(GetArea())
Local cD3_COD  := ""
Local cD3_LOCAL := ""


//Pegando a posi��o e o conte�do do campo
nPosCont   := aScan(aHeader, {|x| AllTrim(Upper(x[2])) == "D3_COD"})
cD3_COD := aCols[n][nPosCont]
nPosCont   := aScan(aHeader, {|x| AllTrim(Upper(x[2])) == "D3_LOCAL"})
cD3_LOCAL  := aCols[n][nPosCont]	


	//Se for produto que inicia com c�d. 01
	IF  Left(cD3_COD, LEN(AllTrim("01") ) ) == AllTrim("01") //Se for Produto que inicia 01
		    lRet  := .F.
		        Help(,, 'ATEN��O!',,"Voc� selecionou o produto com o c�digo 01", 1, 0,,,,,.F.,{"Selecione o produto com o c�digo Correto!"})

		//Se for armaz�m 66
		ELseIf (cD3_LOCAL) =="66" 
			lRet  := .F.
				Help(,, 'ATEN��O!',,"Voc� selecionou o produto do Armaz�m 66", 1, 0,,,,,.F.,{"Selecione o produto do Armaz�m correto!"})

		//Se for armaz�m 01	
		ElseIf (cD3_LOCAL) =="01" 
			lRet  := .F.
				Help(,, 'ATEN��O!',,"Voc� selecionou o produto do Armaz�m 01", 1, 0,,,,,.F.,{"Selecione o produto do Armaz�m correto!"})
	
    EndIf
    
RestArea(aAreaD3)
RestArea(aArea)

Return lRet
