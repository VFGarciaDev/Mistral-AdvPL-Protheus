#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} vMVC1
    Função para criar um MVC do Modelo 1
    
    Possui todas as variáveis definidas com #Define,
    permitindo que sejam substituidas apenas uma vez ao
    invés de percorrer todo o fonte

	Dica, ao substituir o nome de qualquer palavra dentro
	do fonte, pressione CTRL + F2 após seleciona-la para
	garantir que estará substituindo todas as palavras iguais
	(Ex. Nome da Função, Nome de Objetos )

	Se preferir, trocar no nome do objeto 
	"oStrAA1" pelo nome do seu Alias

    @type Function
    @author Victor Garcia
    @since 25/09/2024
    @version 1.0
    @see https://terminaldeinformacao.com/2015/08/26/exemplos-de-rotinas-mvc-em-advpl/
/*/

//Constantes Estáticas
#Define cTitulo ""
#Define cAlias "AA1"
#Define cFormModel "AvMVC1"
#Define cModelField "FORMAA1"
#Define cViewField "VIEW_AA1"

/*/ vMVC1
Linha 46: Instânciando o FWMBrowse
Linha 47: Definindo a tabela de cadastro
Linha 48: Definindo a descrição da rotina
Linha 59: Ativa o Browse

Outras opções:
oBrowse:SetOnlyFields({"AA1_FILIAL","AA1_COD","AA1_NOME","AA1_STATUS"})
// Define quais Campos irão aparecer enquanto os demais ficarão ocultos

oBrowse:DisableDetails()
// Desabilita a seção de Detalhes do lado Inferior

oBrowse:AddLegend( <condição>, <cor>, <descrição> )
// Adição de Legendas
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
	Criação do Menu MVC (Campo de botões)

	Os 5 primeiros campos são reservados para
	as opções padrão do Protheus. Para adicionar
	um botão personalizado novo, recomendado utilizar
	OPERATION de número 6+

	#type Static Function
	#return aRotina, Array, Array de botões
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
	Linha 103: Criação da estrutura de dados utilizada na Modelo de Dados
	//:FWFormStruct(1=ModelDef;2=ViewDef, <cAlias>)
	Linha 105: Instânciando o Modelo
	//Não é possível utilizar mesmo nome da User Function,
	recomendado adicionar um letra a mais. Ex: vMVC1 => AvMVC1
	Linha 107: Atribuindo Campo para a Estrutura de Modelo
	Linha 108: Setando a chave primária do Modelo (Aparenta não funcionar)
	Linha 109: Adicionando a descrição do Modelo
	Linha 110: Adicionando a descrição do Campo

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
	oModel:GetModel(cModelField):SetDescription("Formulário: " + cTitulo)

Return oModel

/*/ ViewDef
	Linha 134: Carregamento do Modelo de Dados para Interface
	Linha 135: Criação da estrutura de dados utilizada na Interface
	//Pode usar um terceiro parâmetro para filtrar os Campos Exibidos
	(Ex. { |cCampo| cCampo $ 'AA1_NOME|AA1_DTAFAL|'})
	Linha 137: Instânciando o objeto da Interface que será o retorno da função
	Linha 139: Definindo o Modelo de Dados com a Interface
	Linha 140: Adicionando um Campo, ligado ao Model, para Interface
	Linha 141: Criando um Container com Nome e Tamanho
	Linha 142: Adicionando o Título do Formulário a Interface
	Linha 143: Conexão entre a Interface e o Container criado
	Linha 144: Força o fechamento da janela na Confirmação

	#type Static Function
	#return oView, Object, Objeto para Visualização do MVC
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
