User Function MA261LIN()

Local lRet        := .T.
Local aArea       := GetArea()
Local aAreaD3     := SD3->(GetArea())
Local cD3_COD  := ""
Local cD3_LOCAL := ""


//Pegando a posição e o conteúdo do campo
nPosCont   := aScan(aHeader, {|x| AllTrim(Upper(x[2])) == "D3_COD"})
cD3_COD := aCols[n][nPosCont]
nPosCont   := aScan(aHeader, {|x| AllTrim(Upper(x[2])) == "D3_LOCAL"})
cD3_LOCAL  := aCols[n][nPosCont]	


	//Se for produto que inicia com cód. 01
	IF  Left(cD3_COD, LEN(AllTrim("01") ) ) == AllTrim("01") //Se for Produto que inicia 01
		    lRet  := .F.
		        Help(,, 'ATENÇÃO!',,"Você selecionou o produto com o código 01", 1, 0,,,,,.F.,{"Selecione o produto com o código Correto!"})

		//Se for armazém 66
		ELseIf (cD3_LOCAL) =="66" 
			lRet  := .F.
				Help(,, 'ATENÇÃO!',,"Você selecionou o produto do Armazém 66", 1, 0,,,,,.F.,{"Selecione o produto do Armazém correto!"})

		//Se for armazém 01	
		ElseIf (cD3_LOCAL) =="01" 
			lRet  := .F.
				Help(,, 'ATENÇÃO!',,"Você selecionou o produto do Armazém 01", 1, 0,,,,,.F.,{"Selecione o produto do Armazém correto!"})
	
    EndIf
    
RestArea(aAreaD3)
RestArea(aArea)

Return lRet
