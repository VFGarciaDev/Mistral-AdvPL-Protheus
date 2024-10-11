#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} vMVC1
    Fun��o para criar um MVC do Modelo 1
    
    Possui todas as vari�veis definidas com #Define,
    permitindo que sejam substituidas apenas uma vez ao
    inv�s de percorrer todo o fonte

	Dica, ao substituir o nome de qualquer palavra dentro
	do fonte, pressione CTRL + F2 ap�s seleciona-la para
	garantir que estar� substituindo todas as palavras iguais
	(Ex. Nome da Fun��o, Nome de Objetos )

	Se preferir, trocar no nome do objeto 
	"oStrAA1" pelo nome do seu Alias

    @type Function
    @author Victor Garcia
    @since 25/09/2024
    @version 1.0
    @see https://terminaldeinformacao.com/2015/08/26/exemplos-de-rotinas-mvc-em-advpl/
/*/

//Constantes Est�ticas
#Define cTitulo ""
#Define cAlias "AA1"
#Define cFormModel "AvMVC1"
#Define cModelField "FORMAA1"
#Define cViewField "VIEW_AA1"

/*/ vMVC1
Linha 46: Inst�nciando o FWMBrowse
Linha 47: Definindo a tabela de cadastro
Linha 48: Definindo a descri��o da rotina
Linha 59: Ativa o Browse

Outras op��es:
oBrowse:SetOnlyFields({"AA1_FILIAL","AA1_COD","AA1_NOME","AA1_STATUS"})
// Define quais Campos ir�o aparecer enquanto os demais ficar�o ocultos

oBrowse:DisableDetails()
// Desabilita a se��o de Detalhes do lado Inferior

oBrowse:AddLegend( <condi��o>, <cor>, <descri��o> )
// Adi��o de Legendas
/*/

User Function vMVC1()
	Local aArea := FWGetArea()
	Local oBrowse

	oBrowse     := FWMBrowse():New()

	oBrowse:SetAlias(cAlias)
	oBrowse:SetDescription(cTitulo)

	oBrowse:Activate()

	FWRestArea(aArea)
Return

/*/ MenuDef
	Cria��o do Menu MVC (Campo de bot�es)

	Os 5 primeiros campos s�o reservados para
	as op��es padr�o do Protheus. Para adicionar
	um bot�o personalizado novo, recomendado utilizar
	OPERATION de n�mero 6+

	#type Static Function
	#return aRotina, Array, Array de bot�es
/*/

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"  ACTION 'PesqBrw'       OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.vMVC1' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.vMVC1' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar' 	  ACTION 'VIEWDEF.vMVC1' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.vMVC1' OPERATION 5 ACCESS 0

Return aRotina

/*/ ModelDef
	Linha 103: Cria��o da estrutura de dados utilizada na Modelo de Dados
	//:FWFormStruct(1=ModelDef;2=ViewDef, <cAlias>)
	Linha 105: Inst�nciando o Modelo
	//N�o � poss�vel utilizar mesmo nome da User Function,
	recomendado adicionar um letra a mais. Ex: vMVC1 => AvMVC1
	Linha 107: Atribuindo Campo para a Estrutura de Modelo
	Linha 108: Setando a chave prim�ria do Modelo (Aparenta n�o funcionar)
	Linha 109: Adicionando a descri��o do Modelo
	Linha 110: Adicionando a descri��o do Campo

	#type Static Function
	#return oModel, Object, Objeto do Modelo de Dados MVC
/*/

Static Function ModelDef()
	Local oModel  := Nil
	Local oStrAA1 := FWFormStruct(1, cAlias)

	oModel        := MPFormModel():New(cFormModel, /*bPre*/, /*bPos*/, /*bCommit*/, /*bCancel*/)

	oModel:AddFields(cModelField,/*cOwner*/,oStrAA1)
	oModel:SetPrimaryKey({})
	oModel:SetDescription("Modelo de Dados: " + cTitulo)
	oModel:GetModel(cModelField):SetDescription("Formul�rio: " + cTitulo)

Return oModel

/*/ ViewDef
	Linha 134: Carregamento do Modelo de Dados para Interface
	Linha 135: Cria��o da estrutura de dados utilizada na Interface
	//Pode usar um terceiro par�metro para filtrar os Campos Exibidos
	(Ex. { |cCampo| cCampo $ 'AA1_NOME|AA1_DTAFAL|'})
	Linha 137: Inst�nciando o objeto da Interface que ser� o retorno da fun��o
	Linha 139: Definindo o Modelo de Dados com a Interface
	Linha 140: Adicionando um Campo, ligado ao Model, para Interface
	Linha 141: Criando um Container com Nome e Tamanho
	Linha 142: Adicionando o T�tulo do Formul�rio a Interface
	Linha 143: Conex�o entre a Interface e o Container criado
	Linha 144: For�a o fechamento da janela na Confirma��o

	#type Static Function
	#return oView, Object, Objeto para Visualiza��o do MVC
/*/

Static Function ViewDef()
	Local oView   := Nil
	Local oModel  := FWLoadModel(cFormModel)
	Local oStrAA1 := FWFormStruct(2, cAlias)

	oView         := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField(cViewField, oStrAA1, cModelField)
	oView:CreateHorizontalBox("TELA",100)
	oView:EnableTitleView(cViewField, 'Dados do' + cTitulo)
	oView:SetOwnerView(cViewField,"TELA")
	oView:SetCloseOnOk({||.T.})

Return oView
