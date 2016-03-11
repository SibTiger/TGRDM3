REM =====================================================================
REM Settings Menu
REM ----------------------------
REM This allows the user to manipulate some settings that is available in this module script.
REM =====================================================================


REM # =============================================================================================
REM # Documentation: Main Control Panel
REM # =============================================================================================
:Settings
CALL :DashboardOrClassicalDisplay
ECHO Control Panel
ECHO %Separator%
ECHO.
ECHO [1] Git Version Control Settings
ECHO [2] Directory Management
ECHO [U] Update Saved Profile named: %UserConfigurationLoaded%
ECHO [X] Exit
CALL :UserInput
GOTO :Settings_UserInput



REM # =============================================================================================
REM # Documentation: Inspect the users input.
REM # =============================================================================================
:Settings_UserInput
IF "%STDIN%" EQU "1" GOTO :SettingsChoice_Git
IF "%STDIN%" EQU "2" GOTO :SettingsChoice_DirectoryManagement
IF /I "%STDIN%" EQU "U" GOTO :SettingsChoice_UpdateProfile
IF /I "%STDIN%" EQU "X" GOTO :EOF
IF /I "%STDIN%" EQU "Exit" GOTO :EOF
CALL :BadInput& GOTO :Settings



REM # =============================================================================================
REM # Documentation: Git Version Control Settings
REM # =============================================================================================
:SettingsChoice_Git
CALL :ClearBuffer
CALL :SettingsGit_Menu
CALL :ClearBuffer
GOTO :Settings



REM # =============================================================================================
REM # Documentation: Directory Settings
REM # =============================================================================================
:SettingsChoice_DirectoryManagement
CALL :ClearBuffer
CALL :SettingsDirectoryManagement_Menu
CALL :ClearBuffer
GOTO :Settings



REM # =============================================================================================
REM # Documentation: User Configuration Settings
REM # =============================================================================================
:SettingsChoice_UpdateProfile
CALL :ClearBuffer
CALL :UserPreset_Driver 1
CALL :ClearBuffer
GOTO :Settings



REM ============================================================



REM # =============================================================================================
REM # Documentation: Git Commandline Settings Menu
REM # =============================================================================================
:SettingsGit_Menu
CALL :DashboardOrClassicalDisplay
ECHO Git Control Panel
ECHO %Separator%
ECHO.
ECHO [1] Git Master Control
ECHO     When set to 'True', this will allow the program to utilize Git features and functionality.
ECHO     - Current Value: [%UserConfig.GitMasterControl%]
ECHO     - Detected: [%Detect_Git%]
ECHO.
ECHO [2] Allow Local Working Copy to be Updated
ECHO     Allow the local working copy to be updated to that latest revision.
ECHO     - Current Value: [%UserConfig.GitAllowWorkingCopyUpdate%]
ECHO.
ECHO [3] Allow fetching changelog history
ECHO     Allow the program to fetch a changelog history of the %ProjectName% project.
ECHO     - Current Value: [%UserConfig.GitAllowFetchChangeLog%]
ECHO.
ECHO [X] Exit
CALL :UserInput
GOTO :SettingsGit_UserInput



REM # =============================================================================================
REM # Documentation: Inspect the users input.
REM # =============================================================================================
:SettingsGit_UserInput
IF "%STDIN%" EQU "1" GOTO :SettingsGit_ToggleMaster
IF "%STDIN%" EQU "2" GOTO :SettingsGit_ToggleWorkingCopyUpdate
IF "%STDIN%" EQU "3" GOTO :SettingsGit_ToggleFetchChangelog
IF /I "%STDIN%" EQU "X" GOTO :EOF
IF /I "%STDIN%" EQU "Exit" GOTO :EOF
CALL :BadInput& GOTO :SettingsGit_Menu



REM # =============================================================================================
REM # Documentation: Allow the program to use Git?  If this is set to false, the program is _NOT_ allowed to use Git commandline utilities.
REM # =============================================================================================
:SettingsGit_ToggleMaster
IF %UserConfig.GitMasterControl% EQU True (
    SET UserConfig.GitMasterControl=False
) ELSE (
    SET UserConfig.GitMasterControl=True
)
CALL :ClearBuffer
GOTO :SettingsGit_Menu



REM # =============================================================================================
REM # Documentation: This allows the program to update the local working copy contents.
REM # =============================================================================================
:SettingsGit_ToggleWorkingCopyUpdate
IF %UserConfig.GitAllowWorkingCopyUpdate% EQU True (
    SET UserConfig.GitAllowWorkingCopyUpdate=False
) ELSE (
    SET UserConfig.GitAllowWorkingCopyUpdate=True
)
CALL :ClearBuffer
GOTO :SettingsGit_Menu



REM # =============================================================================================
REM # Documentation: This will allow the program to fetch the project's commit changelog history.
REM # =============================================================================================
:SettingsGit_ToggleFetchChangelog
IF %UserConfig.GitAllowFetchChangeLog% EQU True (
    SET UserConfig.GitAllowFetchChangeLog=False
) ELSE (
    SET UserConfig.GitAllowFetchChangeLog=True
)
CALL :ClearBuffer
GOTO :SettingsGit_Menu



REM ============================================================



REM # =============================================================================================
REM # Documentation: Directory Management Settings Menu
REM # =============================================================================================
:SettingsDirectoryManagement_Menu
CALL :DashboardOrClassicalDisplay
ECHO Directory Control Panel
ECHO %Separator%
ECHO.
ECHO [1] Locate %ProjectName% Directory
ECHO     This defines where the program can locate the %ProjectName% directory.
ECHO     This is an important setting that must be properly defined, otherwise this program will not work correctly.
REM pass through the detection
CALL :DetectionProject "%UserConfig.DirProjectWorkingCopy%"
REM ----
REM Capture the string for the detection
CALL :ExitCodeIntToStringCommon %ERRORLEVEL%
ECHO     - Detected: [%ProcessVarA%]
REM ----
ECHO     - Current Value: [%UserConfig.DirProjectWorkingCopy%]
ECHO.
ECHO [X] Exit
CALL :UserInput
GOTO :SettingsDirectoryManagement_UserInput



REM # =============================================================================================
REM # Documentation: Inspect the users input.
REM # =============================================================================================
:SettingsDirectoryManagement_UserInput
IF "%STDIN%" EQU "1" GOTO :SettingsDirectoryManagement_TargetProjectDirectory
IF /I "%STDIN%" EQU "X" GOTO :EOF
IF /I "%STDIN%" EQU "Exit" GOTO :EOF
CALL :BadInput& GOTO :SettingsDirectoryManagement_Menu



REM # =============================================================================================
REM # Documentation: This function helps the user to safely set the target path of the project.
REM #   Keep in mind, that the target path must point to the directory that contains 'Compiler_Map.bat' file, otherwise, nothing can be set properly.
REM # =============================================================================================
:SettingsDirectoryManagement_TargetProjectDirectory
CALL :ClearBuffer
CALL :DashboardOrClassicalDisplay
ECHO Target Path: %ProjectName%
ECHO %Separator%
ECHO.
ECHO This setting is very important - as this will help the program to successfully detect where the %ProjectName% project can be located.
ECHO.
ECHO Current Target:
ECHO %UserConfig.DirProjectWorkingCopy%
CALL :DetectionProject "%UserConfig.DirProjectWorkingCopy%"
REM Capture the string for the detection
CALL :ExitCodeIntToStringCommon %ERRORLEVEL%
ECHO Detected: [%ProcessVarA%]
ECHO.
ECHO.
ECHO Enter a new target:
ECHO.
ECHO Other options:
ECHO [X] Exit
CALL :UserInput
REM If the user opts out, leave this function now.
IF /I "%STDIN%" EQU "X" CALL :ClearBuffer& GOTO :SettingsDirectoryManagement_Menu
CALL :SettingsDirectoryManagement_TargetProjectDirectoryManageUpdate-Filter
CALL :DetectionProject "%STDIN%"
CALL :SettingsDirectoryManagement_TargetProjectDirectoryManageUpdate %ERRORLEVEL%
REM -----
REM If the new target exists, then we're done.
IF %ERRORLEVEL% EQU 0 CALL :ClearBuffer& GOTO :SettingsDirectoryManagement_Menu
REM This function is already big enough
CALL :SettingsDirectoryManagement_TargetProjectDirectoryBadLocation
CALL :ClearBuffer&
GOTO :SettingsDirectoryManagement_TargetProjectDirectory



REM # =============================================================================================
REM # Documentation: If the specified path does not exist when the user is attempting to update the project's location within the working copy, this error message will be displayed on the screen.
REM # =============================================================================================
:SettingsDirectoryManagement_TargetProjectDirectoryBadLocation
ECHO.&ECHO.
ECHO ^<!^>       Bad Target       ^<!^>
ECHO %SeparatorLong%
ECHO.
ECHO !ERR: The location specified does not exist or the 'Compiler_Map.bat' file was not found.
ECHO.
ECHO Directory contains:
ECHO %STDIN%
ECHO %SeparatorLong%
DIR /B "%STDIN%"
ECHO %SeparatorLong%
ECHO.
PAUSE
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Update the project's Working Copy target.
REM # =============================================================================================
:SettingsDirectoryManagement_TargetProjectDirectoryManageUpdate
IF %1 EQU 1 (
    SET "UserConfig.DirProjectWorkingCopy=%STDIN%"
    SET Detect_ProjectCore=True
    EXIT /B 0
) ELSE (
    REM The target location does not exist or is not what we are wanting
    EXIT /B 1
)



REM # =============================================================================================
REM # Documentation: Filter any trailing back-slashes.  If incase the user adds '\' at the ending of the string, remove it as this can cause issues with some of the programs like Subversion, for example.
REM # =============================================================================================
:SettingsDirectoryManagement_TargetProjectDirectoryManageUpdate-Filter
REM Using the variable value, read the last character from the value.  -1 == One character from the right side
IF "%STDIN:~-1%" EQU "\" (
    REM Select the range, the -1 means we are limiting the right side; we're effectively dropping 'one' character.
    SET "STDIN=%STDIN:~0,-1%"
) ELSE (
    GOTO :EOF
)
REM If incase the user adds more of the back slashes for whatever reason, call the function again until it is fixed.
GOTO :SettingsDirectoryManagement_TargetProjectDirectoryManageUpdate-Filter