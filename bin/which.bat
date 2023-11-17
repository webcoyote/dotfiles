@ECHO OFF
:: Check Windows version
IF "%OS%"=="Windows_NT" (SETLOCAL) ELSE (GOTO Syntax)

:: Check command line argument
IF     "%~1"=="" GOTO Syntax
IF NOT "%~2"=="" GOTO Syntax
ECHO.%1 | FIND /V ":" | FIND /V "\" | FIND /V "*" | FIND /V "?" | FIND /V "," | FIND /V ";" | FIND /V "/"  | FIND "%~1" >NUL
IF ERRORLEVEL 1 GOTO Syntax

:: First of all, check if the command specified is a DOSKEY macro
FOR /F "tokens=1* delims==" %%A IN ('DOSKEY /MACROS') DO (
	IF /I "%~1"=="%%~A" (
		ECHO -DOSKEY Macro-
		GOTO:EOF
	)
)

:: Next, check if the command specified is an internal command;
:: check for the commands NOT listed in CMD's help screen
IF /I "%~1"=="COPY" (
	ECHO -CMD Internal Command-
	GOTO:EOF
)
IF /I "%~1"=="DIR" (
	ECHO -CMD Internal Command-
	GOTO:EOF
)
:: check for the commands listed in CMD's help screen
FOR /F %%A IN ('CMD /? ^| FINDSTR /R /B /C:"    [A-Z][A-Z]*$"') DO (
	IF /I "%~1"=="%%~A" (
		ECHO -CMD Internal Command-
		GOTO:EOF
	)
)
FOR /F "tokens=1,3" %%A IN ('CMD /? ^| FINDSTR /R /B /C:"    [A-Z][A-Z]* or [A-Z][A-Z]*$"') DO (
	IF /I "%~1"=="%%~A" (
		ECHO -CMD Internal Command-
		GOTO:EOF
	)
	IF /I "%~1"=="%%~B" (
		ECHO -CMD Internal Command-
		GOTO:EOF
	)
)

:: Search current directory first, then PATH, for the "pure"
:: file name itself or one of the extensions defined in PATHEXT.
:: Add quotes to match directory names with spaces as well.
SET Path="%CD%";"%Path:;=";"%"
SET Found=-None-
:: This command line was rewritten by Yakov Azulay.
::FOR %%A IN (%Path%) DO FOR %%B IN (.;%PathExt%) DO IF EXIST "%%~A.\%~1%%~B" CALL :Found "%%~A.\%~1%%~B"
:: This command line was rewritten by Patrick Wyatt.
FOR %%A IN (%Path%) DO FOR %%B IN (%PathExt%;.) DO IF EXIST "%%~A.\%~1%%~B" CALL :Found "%%~A.\%~1%%~B"

:: Display the result
ECHO.%Found%

:: Done
GOTO End


:Found
:: Stop after finding the first match
IF NOT "%Found%"=="-None-" GOTO:EOF
:: Store the first match found
SET Found=%~f1
GOTO:EOF


:Syntax
ECHO.
ECHO WHICH, Version 4.02+ (edited by Patrick Wyatt)
ECHO UNIX-like WHICH utility for Windows 2000 / XP / Vista
ECHO.
ECHO Usage:  WHICH  program_name
ECHO.
ECHO Notes:  You may specify the program_name with or without extension, but
ECHO         wildcards, drive, or path are NOT allowed.
ECHO         This batch file first searches the list of DOSKEY macros, then
ECHO         the list of CMD's internal commands, then the current directory,
ECHO         and finally the PATH for the command specified.
ECHO.
ECHO Written by Yakov Azulay
ECHO and Rob van der Woude
ECHO http://www.robvanderwoude.com

:End
IF "%OS%"=="Windows_NT" ENDLOCAL
