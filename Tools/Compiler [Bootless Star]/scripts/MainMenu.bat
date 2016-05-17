REM =====================================================================
REM Main Menu Interaction Field
REM ----------------------------
REM The main menu for the module program.
REM =====================================================================


REM # =============================================================================================
REM # Documentation: Main menu of the program.
REM # =============================================================================================
:MainMenu
CALL :DashboardOrClassicalDisplay
ECHO Project Menu
ECHO %Separator%
ECHO.
ECHO Compile Operations
ECHO %SeparatorSmall%
ECHO [1] Compile Developmental Build
ECHO [2] Compile Release Build
ECHO [3] Compile Resource Build
ECHO.
ECHO Other Options
ECHO %SeparatorSmall%
ECHO [S] Settings
ECHO [V] View Directories
ECHO [C] Cleanup
ECHO [U] Check for Updates
ECHO [X] Exit
CALL :UserInput
GOTO :Menu_UserInput



REM # =============================================================================================
REM # Documentation: Inspect the users input.
REM # =============================================================================================
:Menu_UserInput
IF "%STDIN%" EQU "1" GOTO :Main_Choice_DevelopmentBuild
IF "%STDIN%" EQU "2" GOTO :Main_Choice_ReleaseBuild
IF "%STDIN%" EQU "3" GOTO :Main_Choice_ResourceBuild
IF /I "%STDIN%" EQU "S" GOTO :Main_Choice_Settings
IF /I "%STDIN%" EQU "V" GOTO :Main_Choice_ViewDirectories
IF /I "%STDIN%" EQU "C" GOTO :Main_Choice_Cleanup
IF /I "%STDIN%" EQU "U" GOTO :Main_Choice_Updates
IF /I "%STDIN%" EQU "X" GOTO :EOF
CALL :BadInput& GOTO :MainMenu



REM # =============================================================================================
REM # Documentation: Compile a development build of the project.
REM # =============================================================================================
:Main_Choice_DevelopmentBuild
CALL :ClearBuffer
CALL :CompileManager_Driver 0
CALL :ClearBuffer
GOTO :MainMenu



REM # =============================================================================================
REM # Documentation: Compile a release build of the project.
REM # =============================================================================================
:Main_Choice_ReleaseBuild
CALL :ClearBuffer
CALL :CompileManager_Driver 1
CALL :ClearBuffer
GOTO :MainMenu



REM # =============================================================================================
REM # Documentation: Compile a resource build of the project.
REM # =============================================================================================
:Main_Choice_ResourceBuild
CALL :ClearBuffer
CALL :CompileManager_Driver 2
CALL :ClearBuffer
GOTO :MainMenu



REM # =============================================================================================
REM # Documentation: Access the control panel.
REM # =============================================================================================
:Main_Choice_Settings
CALL :ClearBuffer
CALL :Settings
CALL :ClearBuffer
GOTO :MainMenu



REM # =============================================================================================
REM # Documentation: Check for available module updates.
REM # =============================================================================================
:Main_Choice_Updates
CALL :ClearBuffer
CALL :ModuleUpdates
CALL :ClearBuffer
GOTO :MainMenu



REM # =============================================================================================
REM # Documentation: Cleanup the local directory and sub-directories.
REM # =============================================================================================
:Main_Choice_Cleanup
CALL :ClearBuffer
CALL :Cleanup_Menu
CALL :ClearBuffer
GOTO :MainMenu



REM # =============================================================================================
REM # Documentation: Allow the user to simply open directories in the GUI shell.
REM # =============================================================================================
:Main_Choice_ViewDirectories
CALL :ClearBuffer
CALL :ViewDirectories
CALL :ClearBuffer
GOTO :MainMenu