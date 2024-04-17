
<H1 align="center">Backtesting application</H1>
<p align="center">🚀 Project to create an application structure using flutter for future references</p>

## Overview
This application was designed using flutter to evaluate stock market trading strategies through the Backtesting method.


## Main Features

### Importing Historical Data
The application imports historical stock data. Data can be adjusted to accurately reflect opening, closing, high and low prices as well as trading volumes.


<div align="center">
 <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/b0654cec-0b54-4737-84eb-4de32324d435" style="width:35%">
</div>





### Strategy Configuration
Users can define and configure different trading strategies based on technical indicators, fundamental analysis or any other criteria they prefer. Strategies can be customized according to user preferences.

<div align="center">
 <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/0236d285-12a2-4693-8ba1-a7c2859e8dfa" style="width:35%">
 <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/2a2e95ea-4292-4524-a00f-ebc262203be4" style="width:35%">
</div>




### Backtesting Execution
Once the strategies are configured, the application performs BackTesting based on the historical data provided. It simulates trades according to conditions set by the user and provides detailed results on the performance of the strategy over the selected time period.

<div align="center">
 <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/b71c0923-cd16-4168-af28-33dcd8f70c7f" style="width:35%">
</div>


### Results analysis
The application generates detailed reports and graphs that show the strategy's performance during the BackTesting period. This includes metrics such as drawdowns, success rates, among other relevant indicators.

<div align="center">
 <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/b6eb5ac6-18cc-4464-b715-e407e9d4a566" style="width:35%">
</div>


### Strategy Optimization
Users have the ability to optimize their strategies based on Backtesting results. They can adjust strategy parameters and run new tests to find the most effective combination.

<div align="center">
 <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/e02e1db6-f874-4129-8d57-88ac5c99cd40" style="width:80%">
</div>

## Settings

<details>
 <summary>Click to show content</summary>

### Step 1: Changing the Flutter channel

You need to change the Flutter version to a specific version, in this case to version 2.0.1. But before switching to a specific version, it's important to ensure you're in the correct Flutter channel. In this case, we will switch to the master channel.

Type the following command in your terminal:

```
flutter channel master
```

### Step 2: Changing the Flutter version
Navigate to the folder where Flutter is installed on your system using the terminal

```
cd E:\src\flutter
```
Now, you need to use Git to checkout to the desired version. In our case, we want version 2.0.1:
```
git checkout 2.0.1
```
This command will have you working with version 2.0.1 of Flutter, where the application was developed.

### Step 3: Verify Installation and download necessary files
After switching to the desired version, it is important to check that everything is configured correctly. To do this, run the following command:

```
flutter doctor -v
```

This will verify your Flutter installation and download any files required for the selected version.

After performing these steps, you are ready to develop or compile your application using Flutter version 2.0.1.


### Step 4 (Optional): Resolving Java compilation version error

```
flutter doctor --android-licenses
```

```
java.lang.UnsupportedClassVersionError:
com/android/sdklib/tool/sdkmanager/SdkManagerCli has been compiled
by a more recent version of the Java Runtime (class file version 61.0),
this version of the Java Runtime only recognizes class file versions up to 52.0’
```

The specific error message indicates that the SdkManagerCli class file was compiled with a newer version of the Java Runtime (class file version 61.0), while the version of the Java Runtime you are using only recognizes class file versions up to 52.0.

In this case, version 52 is required, which corresponds to version 8 based on the Java version table.

<div align="center">
 <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/35cf45a7-f805-46d1-b101-788c67707930" style="width:50%">
</div>


Now go to the Android Studio SDK manager and download the corresponding Command-line SDK with version 52

<div align="center">
 <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/f2668f73-902d-458e-8392-3ecc2ff70605" style="width:50%">
</div>

After downloading the corresponding version, navigate to the folder where SDK is installed and change the downloaded version (8.0) to latest

<div align="center">
 <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/3fa35ce5-6ead-4295-869f-945a3c9cb6bf" style="width:50%">
</div>




### Step 5 (Optional): Solving Android Studio not found error

Command used to configure the Android Studio directory in the Flutter environment if it was installed in a different directory.
```
flutter config --android-studio-dir="path\to\Android Studio"
```

### Step 6 (Optional): Resolving Java not found error
```
‘Unable to find bundled Java version with flutter doctor.....’
```
The error "Unable to find bundled Java version" indicates that Flutter was unable to find a Java version included in the bundle. This can occur when Flutter cannot find the Java installation on your system or when the Java installation is not configured correctly.

This error may be caused when the jre folder within the Android Studio directory is empty or has just one file. To solve it, simply copy and paste the jbr folder and rename it to jre

<div align="center">
 <img src="https://github.com/lucasmargui/Flutter_Projeto_Stocks/assets/157809964/a8e5ca2a-dd26-40f2-905d-c38108075edb" style="width:50%">
</div>



</details>








