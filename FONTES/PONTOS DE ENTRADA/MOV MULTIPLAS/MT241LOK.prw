//Fun��o do Usu�rio
User Function MT241LOK()
	Local lRet       := .T.
	Local aArea      := GetArea()
	Local aAreaD3    := SD3->(GetArea())
	Local nPosCont   := 0
	Local cD3_COD  := ""
	Local cD3_LOCAL := ""
	//Local cConteudo3 := ""
	//Local _cValCLVL  := ""

	//Pegando a posi��o e o conte�do do campo
	nPosCont   := aScan(aHeader, {|x| AllTrim(Upper(x[2])) == "D3_COD"})
	cD3_COD := aCols[n][nPosCont]
	nPosCont   := aScan(aHeader, {|x| AllTrim(Upper(x[2])) == "D3_LOCAL"})
	cD3_LOCAL  := aCols[n][nPosCont]	
	/*nPosCont   := aScan(aHeader, {|x| AllTrim(Upper(x[2])) == "D3_CLVL"})
	cConteudo3 := aCols[n][nPosCont]*/
	

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
	/*
    //Se o Campo estiver em branco
	If Empty(cConteudo2) .and. lRet
		lRet := .F.
		Help(,, 'ATEN��O!',,"A Classe de Valor n�o foi preenchida ", 1, 0,,,,,.F.,{" Preencha o campo Cod Cl Val"})
    EndIf

/*
    //Valida TM com CLVL
  If ALLTRIM(CTM) =="508" //.and. !EMPTY( cConteudo2)
		_cValCLVL := aCOLS[1,aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D3_CLVL" })]
   If _cValCLVL <> "0105996"
      //ApMsgInfo("Aten�ao !!! n�o � permitido o uso de classe de valor para movimenta��es de sa�da.","Aten��o")
      Help(,, 'ATEN��O!',,"Classe de valor incorreta para a TM 508 ", 1, 0,,,,,.F.,{" Preencha o campo Cod Cl Val com a classe de valor 0105996"})
      lRet := .F.
      else
      lRet := .T.
  EndIf
    EndIf*/


	RestArea(aAreaD3)
	RestArea(aArea)

Return lRet
