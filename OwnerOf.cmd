<!-- :  CMD-Script : Show Ownership of a FileObject
:: Demo-Script: Show Owner
::컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�{ CodePage: 850 }컴
:: on other codePage you don't see a line:                  頰�german Verison頰�
::
:: Don't use DIR /Q since the ownership info may be clipped
:: and also localisation and custom-format makes hard to got back right token.
::
:: This is the german Version � Script by M꼡 2022
::
:: Wieder einmal ist es nicht m봥lich, einen Standart-CMD-Befehl im Script zu
:: benutzen, das kennen wir bereits von TIME und DATE wo wir besser auf WMIC
:: zur갷kgreifen. Auch bei der Option /Q vom DIR-Befehl werden wir dazu ge-
:: zwungen ein wenig mehr Aufwand betreiben zu m걌sen.
::
::컴컴컴컴컴컴컴컴�{ set Debug to see whats happens }컴컴컴컴컴컴컴컴컴컴컴컴컴�
@echo off %debug%
::컴컴컴컴컴컴컴컴�{ set Error, cause SETLOCAL did not, but reset }컴컴컴컴컴컴�
 verify Error 2>nul
 setLocal enableExtensions enableDelayedExpansion
 if errorLevel 1 goTo NoExt
::컴컴컴컴컴컴컴컴컴컴컴컴컴{ Parameter to the Script should be a FileObject }컴
 set "P="
 set "P=%~f1"
 if not defined P goTo:ShowUsage
 if not exist "%P%" goTo:ShowUsage
 call:StartCheck %P%
 
 echo;
 timeout -1
 exit /b 0

::컴컴컴컴컴�{ Purose of the Script and Usage of }컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 :ShowUsage
 mode 73
 for /L %%a in (1,1,15) do echo;
 echo; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
 echo;    Don't use DIR /Q since the ownership info may be clipped. 
 echo;
 echo; Usage: %~n0 ^<FileObject^>
 echo;                                                    � german Version:
 echo; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
 echo;  Der Befehl DIR /Q generiert eine voll lokalisierte Ausgabe,
 echo;  welche nur durch die System-Einstellung eingestellt werden kann.
 echo;  Sich aber vorallem nicht einfach von der Kommandozeile bestimmt
 echo;  werden kann, um eine brauchbar formatierte Ausgabe f걊 ein Skript
 echo;  zu erhalten.
 echo;
 echo;  Batch-Skript Programmier kenne es bereits von DATE und TIME
 echo;  wo ebenfalls WMIC bem갿t werden muss, um eine stehts brauchbare
 echo;  Zeitmarke f걊 Logbuch-Dateien generieren zu k봭nen, welche un-
 echo;  abh꼗gig von der Lokaliserung auf jedem Windows-System laufen
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
::컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
:: Spezial-Zeichen generien:
::   BS = Backspace      = L봲che Zeichen links
::   CR = Carrier Return = Wagenr갷klauf (ohne Zeilensprung)
 prompt $H$S
 call set T="Tokens=1,3"
 for /F %T% %%a in ('for /F %%b in ^('copy /z "%~f0" nul'^) do %%b 2^>nul') do (
  set "BS=%%a"
  set "CR=%%b"
 )
 prompt
::컴컴컴컴컴컴{ You may enter a File Object now }컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
 :FragObjekt
 set "P="
 set /P "P=.%BS%  Datei-Object: "
 if not defined P goTo:EoF
 if not exist "%P%" (
   echo;
   echo;  Ist das Laufwerk vielleicht nicht bereit?
   echo;  Zum abbrechen bitte nichts eingeben,
   echo;  also nur die Eingabe-Taste dr갷ken!
   echo;
   goTo:FragObjekt
 )
 call:StartCheck %P%
 echo;
 timeout -1
 exit /b 0

::컴컴컴컴컴컴컴컴컴{ Main-Programm }컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
 :StartCheck
 set "FSO="
 call set "FSO=%~f1"
 call set "FOA=%~a1"
 echo; %FOA% | find /i "-" >NUL && set "Obj= Datei"
 echo; %FOA% | find /i "D" >NUL && set "Obj=Ordner"
 Title %Obj%-Besitzer von "%~nx1" ist ...
 echo;
 echo; %Obj%: %~nx1

::컴�{ This is only needful to come in a shorter line for FOR /F & WMIC }컴컴컴�
 set "wmicPath=Win32_LogicalFileSecuritySetting"
 set "a_RR=/resultRole:Owner"
 set "a_AC=/assocClass:Win32_logicalFileOwner"
 set "a_RC=/resultClass:Win32_SID"
 set "Assoc=assoc !a_RR! !a_AC! !a_RC!"
 set "WMI=wmic path %wmicPath% where Path^="%FSO:\=\\%" %Assoc%"
 set FP="skip=2 tokens=*"
 for /F %FP% %%a in ('%WMI%') do call:Splice "%%a"
 goTo:EoF
::컴컴컴컴컴컴컴컴컴{ Splice WMIC Output }컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 :Splice
 call set "Shredd=%~1"
 call set Shredded="%Shredd:  =�%" 
 for /F "delims=� tokens=12,10,13" %%a in (%Shredded%) do (
  echo;  Owner: %%b\%%a
  echo;    SID: %%c
 ) 
 goTo:EoF
 
::컴컴컴컴{ No CMD-Ext.Error Message in a PopUpWindow }컴컴컴컴컴컴컴컴컴컴컴컴�
 :NoExt
 echo: 
 set "cmd=mode 52,8&color 4e&echo:"
 set "cmd=%cmd%&echo:  Sorry this Script don't support your System,"
 set "cmd=%cmd%&echo:  cause your System don't support Cmd-Extensions!"
 set "cmd=%cmd%&echo:"
 set "cmd=%cmd%&echo:  Fehler: System-Befehlserweiterung nicht m봥lich."
 set "cmd=%cmd%&echo:"
 set "cmd=%cmd%&Pause >nul"
 start "Can't run", "cmd /C %cmd%"
 pause
exit /b 1