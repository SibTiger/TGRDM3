REM =====================================================================
REM Error Manager
REM ----------------------------
REM When error occurs, the methods below will output and deal with the next step without causing much hassle.
REM =====================================================================


REM # =============================================================================================
REM # Documentation: When a resource was found missing, this function will be called.  This function will call the sub-function which outputs the error and records the error on the log.
REM # =============================================================================================
:ResourceErrorSignal
IF %ToggleLog% EQU True CALL :ResourceErrorSignal_LogError "%~1"
CALL :ResourceErrorSignal_DisplayError "%~1"
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Display the error message on the user's screen from the terminal buffer.
REM # =============================================================================================
:ResourceErrorSignal_DisplayError
IF %UseBell% GEQ 1 (ECHO %SND_BELL% %SND_BELL% %SND_BELL% %SND_BELL%)
ECHO %SeparatorLong%
ECHO.&ECHO.
ECHO ^<!^>       Critical Error Has Occurred!       ^<!^>
ECHO %SeparatorLong%
ECHO.
ECHO Could not find a required file or directory, details below:
ECHO %Separator%
ECHO File or Directory that was not found:
ECHO   %~1
ECHO.
PAUSE
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Log the error message to the ASCII file located within the filesystem.
REM # =============================================================================================
:ResourceErrorSignal_LogError
(ECHO %SeparatorLong%)>> "%STDOUT%"
(ECHO.&ECHO.)>> "%STDOUT%"
(ECHO ^<!^>       Critical Error Has Occurred!       ^<!^>)>> "%STDOUT%"
(ECHO %SeparatorLong%)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
(ECHO Could not find a required file or directory, details below:)>> "%STDOUT%"
(ECHO %Separator%)>> "%STDOUT%"
(ECHO File or Directory that was not found:)>> "%STDOUT%"
(ECHO   %~1)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
GOTO :EOF



REM # =============================================================================================
REM # Documentation: When the program reaches an error during compiling process, this function will be called.  This function will accordingly output the error message on the log [depending on the ToggleLog var] and display the message on the terminal.
REM # =============================================================================================
:CaughtErrorSignal
IF %ToggleLog% EQU True CALL :CaughtErrorSignal_LogError
CALL :CaughtErrorSignal_DisplayError
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Display the error message on the user's screen from the terminal buffer.
REM # =============================================================================================
:CaughtErrorSignal_DisplayError
IF %UseBell% GEQ 1 (ECHO %SND_BELL% %SND_BELL% %SND_BELL% %SND_BELL%)
ECHO %SeparatorLong%
ECHO.&ECHO.
ECHO ^<!^>       Critical Error Has Occurred!       ^<!^>
ECHO %SeparatorLong%
ECHO.
ECHO Caught an Error Signal, details below:
ECHO %Separator%
ECHO Exit Code: %ExitCode%
ECHO Program Called: %TaskCaller_NiceProgramName%
ECHO Command Invoked: %TaskCaller_CallLong%
ECHO.
PAUSE
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Log the error message to the ASCII file located within the filesystem.
REM # =============================================================================================
:CaughtErrorSignal_LogError
(ECHO %SeparatorLong%)>> "%STDOUT%"
(ECHO.&ECHO.)>> "%STDOUT%"
(ECHO ^<!^>       Critical Error Has Occurred!       ^<!^>)>> "%STDOUT%"
(ECHO %SeparatorLong%)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
(ECHO Caught an Error Signal, details below:)>> "%STDOUT%"
(ECHO %Separator%)>> "%STDOUT%"
(ECHO Exit Code: %ExitCode%)>> "%STDOUT%"
(ECHO Program Called: %TaskCaller_NiceProgramName%)>> "%STDOUT%"
(ECHO Command Invoked: %TaskCaller_CallLong%)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
GOTO :EOF