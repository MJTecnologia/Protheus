//Bibliotecas
#Include "Totvs.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} xRteaqua
  Relat�rio - Transferencia de Estoque      
  @author Mauro
  @since 02/12/2023
  @version 1.0
/*/

//Static nCorCinza := RGB(110, 110, 110)
//Static nCorAzul  := RGB(193, 231, 253)

User Function xRteaqua()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""

	//Defini��es da pergunta
	cPerg := "XRTE      "

	//Se a pergunta n�o existir, zera a vari�vel
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If !SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf

	// Carrega a pergunta na memoria sem exibir;
	Pergunte(cPerg,.F.)

	//Cria as defini��es do relat�rio
	oReport := fReportDef()

	//Ser� enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Sen�o, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf

	RestArea(aArea)
Return

/*/{Protheus.doc} fReportDef 
    Fun��o que monta a defini��o do relat�rio
    @type  Static Function
  @author Mauro
  @since 02/12/2023
  @version 1.0
/*/ 

Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	Local nAltLinha := 120 //pixel dados impressos no cabe�alho
	
	//Cria��o do componente de impress�o - oReport := TReport():New("Fonte","TITULO","",{|oReport| PrintReport(oReport)}
	oReport := TReport():New(	"xRteaqua",;		//Nome do Relat�rio
	"Transferencia de Estoque",;		//T�tulo
	cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
	{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
	)		//Descri��o

	//oReport:SetTitle('Protheus Report Utility') //Define o t�tulo do relat�rio
	//oReport:LoadLayout("TI")//Chamando layout personalizado n�o funciona
	oReport:SetTotalInLine(.F.) //Define se os totalizadores ser�o impressos em linha ou coluna
	oReport:SetLineHeight(30) //Define a altura da linha na impress�o
	//oReport:SetColSpace(1)    //Define o espa�amento entre as colunas
	//oReport:SetLeftMargin(0)  //Define a margem � esquerda do relat�rio
	oReport:cFontBody := 'Courier New' //Define a fonte
	oReport:nFontBody := 7 //Defina tamanho da fonte
	oReport:lBold := .T. //Imprime a fonte em negrito
	//oReport:lUnderLine := .F. //Aponta se a fonte � sublinhada
	//oReport:lHeaderVisible := .T. //Habilita a impress�o do cabe�alho
	//oReport:lFooterVisible := .T. //Habilita a impress�o do rodap�
	oReport:lParamPage := .F. //Existe par�metros para impress�o
	oReport:oPage:SetPaperSize(9) //Folha A4
	//oReport:oPage:SetPaperSize(DMPAPER_A4) //Folha A4
	oReport:SetPortrait()
	oReport:SetLandscape(.T.) //Relat�rio em paisagem

	//Montando dados que ser� impresso cabe�alho
	oReport:SetPageFooter(10, {|| ;
		oReport:Say(oReport:Row(),                 10, "Impresso por:" + UsrRetName(RetCodUsr()), , , , ),;
		oReport:Say(oReport:Row() + nAltLinha,     10, "______________________________________________________"          , , , , ),;
		oReport:Say(oReport:Row() + (nAltLinha*2), 10, "               Assinatura do Recebedor"  , , , , ),;
		oReport:Say(oReport:Row() + (nAltLinha*2), 10, "                                                                                                                                                                                  T.I.C - Thermas Acqualinda"  , , , , );
		})

	//Criando a se��o de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
	"Dados",;		//Descri��o da se��o
	{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha

	//Colunas do relat�rio
	TRCell():New(oSectDad, "NNS_COD", "QRY_AUX", "C�digo", /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NNT_PROD", "QRY_AUX", "Produto", /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B1_DESC", "QRY_AUX", "Descricao", /*Picture*/, 37, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NNT_QUANT", "QRY_AUX", "1� Qtd", /*Picture*/, 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NNT_UM", "QRY_AUX", " ", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSectDad, "NNT_QUANT", "QRY_AUX", "Quantidade", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NNT_QTSEG", "QRY_AUX", "2� Qtd", /*Picture*/, 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSectDad, "NNT_QTSEG", "QRY_AUX", "Quant 2�. Un", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B1_SEGUM", "QRY_AUX", " ", /*Picture*/, 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NNT_LOCAL", "QRY_AUX", "Amz", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSectDad, "NNR_DESCRI", "QRY_AUX", "Desc_Org", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRI1", "QRY_AUX", "Origem", /*Picture*/, 17, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NNT_LOCLD", "QRY_AUX", "Amz", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRI2", "QRY_AUX", "Destino", /*Picture*/, 25, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NNT_OBS", "QRY_AUX", "Observa��o", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NNS_XSOLIC", "QRY_AUX", "Solicitante", "@X"/*Picture*/, 35, /*lPixel*/,/*{|| code-block de impressao }*/,"left",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    
	//Definindo a quebra
	oBreak := TRBreak():New(oSectDad,{|| QRY_AUX->(NNS_COD) },{|| "SEPARACAO DO RELATORIO" },.T.)
	oSectDad:SetHeaderBreak(.T.)

Return oReport

/*/{Protheus.doc} fRepPrint 
    Fun��o que imprime o Logo relat�rio 
    @type  Static Function
  @author Mauro
  @since 02/12/2023
  @version 1.0
/*/ 

STATIC FUNCTION CABIMP(nTitulo)

	Local nLin    := 50
	Local nCol    := 100
	Local oFontA  := TFont():New( "Arial",,-16,,.T.)
	Local oFontB  := TFont():New( "Arial",,-10,,.T.)
//Local clogoMC := "lgrl"+PADR(cEmpAnt,2)+".bmp"
	Local clogoMC := "lgrl"+cEmpAnt+cFilAnt+".bmp"
//���������������������ͻ
//�     StartPage       �
//���������������������ͼ
	oPrint:StartPage()
	oPrint:Box( nLin, nCol-10, nLin+150, nCol+2200 ) 	// box do cabecalho
	oPrint:SayBitmap( nLin+10,nCol,clogoMC, 300, 100 )
	oPrint:Say(nLin, nCol+2000, "2.0", oFontB)
	nLin += 50
	oPrint:Say(nLin, nCol+600, nTitulo , oFontA)
	oPrint:Say(nLin, nCol+2000, DtoC(dDataBase), oFontB)
	nLin += 50
	oPrint:Say(nLin, nCol+2000, Time(), oFontB)
	nLin += 50

Return( nLin )


/*/{Protheus.doc} fRepPrint 
    Fun��o que imprime o relat�rio 
    @type  Static Function
  @author Mauro
  @since 02/12/2023
  @version 1.0
/*/ 

Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	Local lZebrad  := .T. //Utilizado para zebrado
	//Zebrado
	//Vari�veis usadas no brush, documenta��es no TDN - https://tdn.totvs.com/display/public/framework/TReport
	Local nLinAtu    := 0
	Local nColIni    := oReport:LeftMargin() //Margem da esquerda, vai ser a coluna inicial
	Local nColFin    := oReport:PageWidth()  //Largura da p�gina, vai ser a coluna final
	Local nEspLin    := oReport:LineHeight() //Espa�amento entre as linahs, para saber a altura que ir� pintar
	Local oBrushLin  := TBrush():New(, RGB(193, 231, 253)) //Pincel em um tom de claro RGB(193, 231, 253)Azul RGB(215, 245, 243)Tom Claro


	//Pegando as se��es do relat�rio
	oSectDad := oReport:Section(1)

	//Montando consulta de dados SQL
	cQryAux := "SELECT"		     + CRLF
	cQryAux += "NNS_COD,"		   + CRLF
	cQryAux += "NNT_PROD,"		  + CRLF
	cQryAux += "B1_DESC,"		   + CRLF
	cQryAux += "NNT_QUANT,"		 + CRLF
	cQryAux += "NNT_UM,"		    + CRLF
	cQryAux += "NNT_QTSEG,"		 + CRLF
	cQryAux += "B1_SEGUM,"		 + CRLF
	cQryAux += "NNT_LOCAL,"		 + CRLF
	cQryAux += "NNL.NNR_DESCRI DESCRI1,"		+ CRLF
	//cQryAux += "NNR_DESCRI,"		+ CRLF
	cQryAux += "NNT_LOCLD,"		 + CRLF
	cQryAux += "NND.NNR_DESCRI DESCRI2,"		+ CRLF
	cQryAux += "NNT_OBS,"		   + CRLF
	cQryAux += "NNS_XSOLIC"		 + CRLF
	cQryAux += "FROM  "+RetSqlName("NNT")+" NNT "		+ CRLF
	cQryAux += "JOIN  "+RetSqlName("NNS")+" NNS ON NNS.D_E_L_E_T_ = ' ' AND NNS_FILIAL = NNT_FILIAL  AND NNS_COD = NNT_COD"		+ CRLF
	//cQryAux += "JOIN  "+RetSqlName("NNR")+" NNR ON NNR.D_E_L_E_T_ = ' ' AND NNR_FILIAL='"+xFilial("NNR")+"'  AND NNR_CODIGO = NNT_LOCAL"		+ CRLF
	cQryAux += "JOIN  "+RetSqlName("NNR")+" NNL ON NNL.D_E_L_E_T_ = ' ' AND NNL.NNR_FILIAL=SUBSTRING(NNT_FILIAL,1,2)  AND NNL.NNR_CODIGO = NNT_LOCAL"		+ CRLF
	cQryAux += "JOIN  "+RetSqlName("NNR")+" NND ON NND.D_E_L_E_T_ = ' ' AND NND.NNR_FILIAL=SUBSTRING(NNT_FILIAL,1,2)  AND NND.NNR_CODIGO = NNT_LOCLD"		+ CRLF
	cQryAux += "JOIN  "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_ = ' ' AND NNT_PROD = B1_COD"		+ CRLF
	cQryAux += "WHERE NNT.D_E_L_E_T_ = ' ' "		+ CRLF
	cQryAux += "AND NNT_FILIAL='"+xFilial("NNT")+"' "+CRLF
	cQryAux += "AND NNS_COD BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "+ CRLF //Pergunte (XRTE)
	cQryAux += "AND NNS_STATUS ='"+ CVALTOCHAR(MV_PAR03) +"' "+ CRLF //Convers�o do pergunte numerico x string (XRTE)
	cQryAux += "ORDER BY NNS_COD "+ CRLF

	cQryAux := ChangeQuery(cQryAux)

	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)

   	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While !QRY_AUX->(Eof())

		// - Nesse ponto armazena o codigo atual s� para realizar a valida��o apos dbSkip e verificar se trocou o codigo,
		// se trocou ent�o finaliza a pagina e inicia uma nova. (para imprimir um codigo por pagina)
		cCodOLD := QRY_AUX->(NNS_COD)

		//Incrementando a r�gua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()

//Zebrado
		//Se for uma linha Par (cuidado ao usar o �mpar, pois ele pode encavalar no header)
		//If nAtual % 2 == 0
		If lZebrad .AND. nAtual>1
			nLinAtu := oReport:Row() //Pega a linha atual no relat�rio
			oReport:FillRect({nLinAtu, nColIni, nLinAtu + nEspLin, nColFin}, oBrushLin)
		EndIf

		If nAtual>1
			If lZebrad
				lZebrad := .F.
			Else
				lZebrad := .T.
			EndIF
		EndIF

		//Imprimindo a linha atual
		oSectDad:PrintLine()

		QRY_AUX->(DbSkip())

		// Se o proximo registro for diferente (Finaliza pagina e pula para proxima)
		If QRY_AUX->(NNS_COD)<>cCodOLD
			oReport:EndPage()
			oReport:StartPage()
			nAtual  := 0 //utilizado para zebrado
			lZebrad := .T. //Retorna valor para .T.
		EndIF

	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())

	RestArea(aArea)
Return
