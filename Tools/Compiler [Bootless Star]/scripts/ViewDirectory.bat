REM =====================================================================
REM View Directories
REM ----------------------------
REM Within this section, this will allow the user to simply open directories right from the GUI shell -- nothing fancy other than EXPLORER calls.
REM =====================================================================


REM # =============================================================================================
REM # Documentation: What directory does the user wish to view?
REM # =============================================================================================
:ViewDirectories
CALL :DashboardOrClassicalDisplay
ECHO Open a Directory Menu
ECHO %Separator%
ECHO.
ECHO [1] Build directory
ECHO [2] Log directory
ECHO [X] Exit
CALL :UserInput
GOTO :ViewDirectories_UserInput



REM # =============================================================================================
REM # Documentation: Inspect the user's input
REM # =============================================================================================
:ViewDirectories_UserInput
IF "%STDIN%" EQU "1" (
    CALL :ViewDirectories_InputDriver Builds
    GOTO :ViewDirectories
)
IF "%STDIN%" EQU "2" (
    CALL :ViewDirectories_InputDriver Logs
    GOTO :ViewDirectories
)
IF /I "%STDIN%" EQU "X" GOTO :EOF
CALL :BadInput& GOTO :ViewDirectories



REM # =============================================================================================
REM # Documentation: Manage the users request in a simple package and slightly easier to manage.
REM # =============================================================================================
:ViewDirectories_InputDriver
IF %1 EQU Builds CALL :ViewDirectories_BuildsDir
IF %1 EQU Logs CALL :ViewDirectories_LogsDir
CALL :ClearBuffer
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Open the Builds Directory within the graphical user interface.
REM # =============================================================================================
:ViewDirectories_BuildsDir
CALL :Call_WindowsExplorer "%LocalDirectory.Builds%"
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Open the Log Directory within the graphical user interface.
REM # =============================================================================================
:ViewDirectories_LogsDir
CALL :Call_WindowsExplorer "%LocalDirectory.Logs%"
GOTO :EOF