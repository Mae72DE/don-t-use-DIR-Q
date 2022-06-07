<!-- :  CMD-Script : Show Ownership of a FileObject
:: Demo-Script: Show Owner
::ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ{ CodePage: 850 }ÄÄ
:: on other codePage you don't see a line:                  úúúgerman Verisonúúú
::
:: Don't use DIR /Q since the ownership info may be clipped
:: and also localisation and custom-format makes hard to got back right token.
::
:: This is the german Version ú Script by M„x 2022
::
:: Wieder einmal ist es nicht m”glich, einen Standart-CMD-Befehl im Script zu
:: benutzen, das kennen wir bereits von TIME und DATE wo wir besser auf WMIC
:: zurckgreifen. Auch bei der Option /Q vom DIR-Befehl werden wir dazu ge-
:: zwungen ein wenig mehr Aufwand betreiben zu mssen.
::
::ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ{ set Debug to see whats happens }ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
@echo off %debug%
::ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ{ set Error, cause SETLOCAL did not, but reset }ÄÄÄÄÄÄÄÄÄÄÄÄÄ
 verify Error 2>nul
 setLocal enableExtensions enableDelayedExpansion
 if errorLevel 1 goTo NoExt
::ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ{ Parameter to the Script should be a FileObject }ÄÄ
 set "P="
 set "P=%~f1"
 if not defined P goTo:ShowUsage
 if not exist "%P%" goTo:ShowUsage
 call:StartCheck %P%
 
 echo;
 timeout -1
 exit /b 0

::ÄÄÄÄÄÄÄÄÄÄÄ{ Purose of the Script and Usage of }ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 :ShowUsage
 mode 73
 for /L %%a in (1,1,15) do echo;
 echo; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 echo;    Don't use DIR /Q since the ownership info may be clipped. 
 echo;
 echo; Usage: %~n0 ^<FileObject^>
 echo;                                                    ú german Version:
 echo; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 echo;  Der Befehl DIR /Q generiert eine voll lokalisierte Ausgabe,
 echo;  welche nur durch die System-Einstellung eingestellt werden kann.
 echo;  Sich aber vorallem nicht einfach von der Kommandozeile bestimmt
 echo;  werden kann, um eine brauchbar formatierte Ausgabe fr ein Skript
 echo;  zu erhalten.
 echo;
 echo;  Batch-Skript Programmier kenne es bereits von DATE und TIME
 echo;  wo ebenfalls WMIC bemht werden muss, um eine stehts brauchbare
 echo;  Zeitmarke fr Logbuch-Dateien generieren zu k”nnen, welche un-
 echo;  abh„ngig von der Lokaliserung auf jedem Windows-System laufen
 echo;  soll.
 echo;
 echo;  Dieses Demo-Skript zeigt wie WMIC genutzt werden kann,
 echo;  um nun auch den DIR /Q Befehl zu ersetzen.
 echo;
 echo;  Das Skript erwartet als Start-Parameter ein Ordner oder Datei.
 echo;  Benutze Drag ^& Drop wenn Du das Skript nicht aus der CMD-Ein-
 echo;  gabeaufforderung aufrufst.
 echo;
 echo;
::ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
:: Spezial-Zeichen generien:
::   BS = Backspace      = L”sche Zeichen links
::   CR = Carrier Return = Wagenrcklauf (ohne Zeilensprung)
 prompt $H$S
 call set T="Tokens=1,3"
 for /F %T% %%a in ('for /F %%b in ^('copy /z "%~f0" nul'^) do %%b 2^>nul') do (
  set "BS=%%a"
  set "CR=%%b"
 )
 prompt
::ÄÄÄÄÄÄÄÄÄÄÄÄ{ You may enter a File Object now }ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 :FragObjekt
 set "P="
 set /P "P=.%BS%  Datei-Object: "
 if not defined P goTo:EoF
 if not exist "%P%" (
   echo;
   echo;  Ist das Laufwerk vielleicht nicht bereit?
   echo;  Zum abbrechen bitte nichts eingeben,
   echo;  also nur die Eingabe-Taste drcken!
   echo;
   goTo:FragObjekt
 )
 call:StartCheck %P%
 echo;
 timeout -1
 exit /b 0

::ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ{ Main-Programm }ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 :StartCheck
 set "FSO="
 call set "FSO=%~f1"
 call set "FOA=%~a1"
 echo; %FOA% | find /i "-" >NUL && set "Obj= Datei"
 echo; %FOA% | find /i "D" >NUL && set "Obj=Ordner"
 Title %Obj%-Besitzer von "%~nx1" ist ...
 echo;
 echo; %Obj%: %~nx1

::ÄÄÄ{ This is only needful to come in a shorter line for FOR /F & WMIC }ÄÄÄÄÄÄÄ
 set "wmicPath=Win32_LogicalFileSecuritySetting"
 set "a_RR=/resultRole:Owner"
 set "a_AC=/assocClass:Win32_logicalFileOwner"
 set "a_RC=/resultClass:Win32_SID"
 set "Assoc=assoc !a_RR! !a_AC! !a_RC!"
 set "WMI=wmic path %wmicPath% where Path^="%FSO:\=\\%" %Assoc%"
 set FP="skip=2 tokens=*"
 for /F %FP% %%a in ('%WMI%') do call:Splice "%%a"
 goTo:EoF
::ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ{ Splice WMIC Output }ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 :Splice
 call set "Shredd=%~1"
 call set Shredded="%Shredd:  =ú%" 
 for /F "delims=ú tokens=12,10,13" %%a in (%Shredded%) do (
  echo;  Owner: %%b\%%a
  echo;    SID: %%c
 ) 
 goTo:EoF
 
::ÄÄÄÄÄÄÄÄ{ No CMD-Ext.Error Message in a PopUpWindow }ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 :NoExt
 echo: 
 set "cmd=mode 52,8&color 4e&echo:"
 set "cmd=%cmd%&echo:  Sorry this Script don't support your System,"
 set "cmd=%cmd%&echo:  cause your System don't support Cmd-Extensions!"
 set "cmd=%cmd%&echo:"
 set "cmd=%cmd%&echo:  Fehler: System-Befehlserweiterung nicht m”glich."
 set "cmd=%cmd%&echo:"
 set "cmd=%cmd%&Pause >nul"
 start "Can't run", "cmd /C %cmd%"
 pause
exit /b 1