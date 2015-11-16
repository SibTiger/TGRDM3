REM -----------------------------------------------------------------
REM =================================================================
REM -----------------------------------------------------------------
REM                         Windows Explorer


REM # =============================================================================================
REM # Parameters: [{int} BuildMode]
REM # Documentation: Open new windows within the desktop environment that helps the user quickly identify the new contents that has been either compiled or generated.
REM # =============================================================================================
:CompileProject_PopupWindowsExplorer
REM ----
REM Run this function?
IF %CallExplorerCommands% EQU False (
    CALL :CompileProject_TerminateSuccessfully_ExtendedNoExplorer
    EXIT /B 0
)
REM ----
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Calling Windows Explorer"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
CALL :CompileProject_PopupWindowsExplorer_StandardBuild
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0



REM # =============================================================================================
REM # Documentation: Open a new windows and select the recently compiled engine.
REM # =============================================================================================
:CompileProject_PopupWindowsExplorer_FileNotFound
ECHO !ERR: Could not locate file { %~1 } on the filesystem!  As such, the Windows Explorer will not be called to locate this file.
IF %ToggleLog% EQU True (ECHO !ERR: Could not locate file { %~1 } on the filesystem!  As such, the Windows Explorer will not be called to locate this file.)>> "%STDOUT%"
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Open a new windows and select the recently compiled engine.
REM # =============================================================================================
:CompileProject_PopupWindowsExplorer_StandardBuild
IF NOT EXIST "%DestinationOutput%\%FileName%" (
    CALL :CompileProject_PopupWindowsExplorer_FileNotFound "%DestinationOutput%\%FileName%"
    EXIT /B 0
)
REM ----
SET TaskCaller_NiceProgramName=Windows Explorer
SET TaskCaller_CallLong=EXPLORER /SELECT,"%DestinationOutput%\%FileName%"
CALL :CompileProject_TaskOperation
EXIT /B %ERRORLEVEL%



REM # =============================================================================================
REM # Documentation: If the user disallows any module to use Windows Explorer, then alternatively, tell the user where the files are located within the file.
REM # =============================================================================================
:CompileProject_TerminateSuccessfully_ExtendedNoExplorer
ECHO.&ECHO.
    ECHO Compiled Builds Directory:
    ECHO   %LocalDirectory.Builds%
    ECHO Filename:
    ECHO   %FileName%
    ECHO.
GOTO :EOF