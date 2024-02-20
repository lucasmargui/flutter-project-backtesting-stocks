<H1 align="center">Aplicativo de backtesting</H1>
<p align="center">🚀 Projeto de criação de uma estrutura de aplicativo utilizando flutter para referências futuras</p>

## Visão Geral
Este aplicativo foi projetado utilizando flutter para avaliar estratégias de negociação no mercado de ações através do método de Backtesting.


## Configuração

### Passo 1: Alterando a Versão do Flutter

É necessário alterar a versão do Flutter para uma versão específica, neste caso, para a versão 2.0.1. Mas antes de mudar para uma versão específica, é importante garantir que você esteja no canal correto do Flutter. Neste caso, vamos mudar para o canal master.

Digite o seguinte comando no seu terminal:

```
flutter channel master
```

### Passo 2: Abrir a Pasta do Flutter com Git e Realizar o Checkout
Navegue até a pasta onde o Flutter está instalado em seu sistema usando o terminal

```
cd E:\src\flutter
```
Agora, você precisa usar o Git para fazer o checkout para a versão desejada. No nosso caso, queremos a versão 2.0.1:
```
git checkout 2.0.1
```
Este comando fará com que você trabalhe com a versão 2.0.1 do Flutter, onde o aplicativo foi desenvolvido.

### Passo 3: Verificar a Instalação e Baixar Arquivos Necessários
Depois de mudar para a versão desejada, é importante verificar se tudo está configurado corretamente. Para isso, execute o seguinte comando:

```
flutter doctor -v
```

Isso verificará a instalação do Flutter e baixará quaisquer arquivos necessários para a versão selecionada.

Após executar esses passos, você estará pronto para desenvolver ou compilar seu aplicativo usando a versão 2.0.1 do Flutter.


### Passo 4 (Opcional): Solucionando erro de versão de compilação do Java no Flutter doctor para obter as licenças

```
flutter doctor --android-licenses
```

```
java.lang.UnsupportedClassVersionError: 
com/android/sdklib/tool/sdkmanager/SdkManagerCli has been compiled 
by a more recent version of the Java Runtime (class file version 61.0), 
this version of the Java Runtime only recognizes class file versions up to 52.0’
```

A mensagem de erro específica indica que o arquivo de classe SdkManagerCli foi compilado com uma versão mais recente do Java Runtime (class file version 61.0), enquanto a versão do Java Runtime que você está usando só reconhece versões de arquivos de classe até 52.0.

No caso a versão 52 é a necessária que é correspondente com a versão 8 com base na tabela de versões do Java.

<div align="center">
  <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/35cf45a7-f805-46d1-b101-788c67707930" style="width:50%">
</div>


Agorá vá até o SDK manager do Android Studio e baixe o SDK Command-line correspondente com a versão 52

<div align="center">
  <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/f2668f73-902d-458e-8392-3ecc2ff70605" style="width:50%">
</div>

Após baixar a versão correspondente navegue até a pasta onde SDK esta instalado e altere a versão baixada (8.0) para latest

<div align="center">
  <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/3fa35ce5-6ead-4295-869f-945a3c9cb6bf" style="width:50%">
</div>











## Funcionalidades Principais

### Importação de Dados Históricos
O aplicativo importa dados históricos de açõe. Os dados podem ser ajustados para refletir com precisão os preços de abertura, fechamento, máxima e mínima, bem como os volumes de negociação.


<div align="center">
  <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/b0654cec-0b54-4737-84eb-4de32324d435" style="width:35%">
</div>





### Configuração de Estratégias
Os usuários podem definir e configurar diferentes estratégias de negociação com base em indicadores técnicos, análise fundamentalista ou qualquer outro critério de sua preferência. As estratégias podem ser personalizadas de acordo com as preferências do usuário.

<div align="center">
  <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/0236d285-12a2-4693-8ba1-a7c2859e8dfa" style="width:35%">
  <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/2a2e95ea-4292-4524-a00f-ebc262203be4" style="width:35%">
</div>




### Execução de Backtesting
Uma vez configuradas as estratégias, o aplicativo realiza o BackTesting com base nos dados históricos fornecidos. Ele simula as negociações de acordo com as condições estabelecidas pelo usuário e fornece resultados detalhados sobre o desempenho da estratégia ao longo do período de tempo selecionado.

<div align="center">
  <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/b71c0923-cd16-4168-af28-33dcd8f70c7f" style="width:35%">
</div>




### Análise de Resultados
O aplicativo gera relatórios e gráficos detalhados que mostram o desempenho da estratégia durante o período de BackTesting. Isso inclui métricas como drawdowns, taxas de acerto, entre outros indicadores relevantes.

<div align="center">
  <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/b6eb5ac6-18cc-4464-b715-e407e9d4a566" style="width:35%">
</div>


### Otimização de Estratégias
Os usuários têm a capacidade de otimizar suas estratégias com base nos resultados do Backtesting. Eles podem ajustar os parâmetros da estratégia e executar novos testes para encontrar a combinação mais eficaz.

<div align="center">
  <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/e02e1db6-f874-4129-8d57-88ac5c99cd40" style="width:80%">
</div>












