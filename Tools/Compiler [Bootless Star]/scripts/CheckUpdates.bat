REM =====================================================================
REM Check for Updates
REM ----------------------------
REM To make things for the end-user, this allows the user to quickly check for available updates with ease.  Despite there's limitations with Batch, we can not really automatically fetch information and append them.  However, instead, this will open Windows Explorer's functionality to open website pages.  This functionality alone will help the user to determine if there is new updates or if the module that they currently have is still the current latest version.
REM =====================================================================


REM # =============================================================================================
REM # Documentation: This function is a small driver for checking updates.
REM # =============================================================================================
:ModuleUpdates
CALL :DashboardOrClassicalDisplay
CALL :ModuleUpdates_InternalInformation
CALL :ModuleUpdates_OpenWeb
PAUSE
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This will display all of the information necessary to help the user determine if the module is up to date or is outdated.
REM # =============================================================================================
:ModuleUpdates_InternalInformation
ECHO Current Module Information:
ECHO %Separator%
ECHO Project:
ECHO    %ProjectName%
ECHO Version:
ECHO    %ProjectVersion%
ECHO Released:
ECHO    %ReleaseDate%
ECHO.&ECHO.
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This function will call Windows Explorer - regardless of the CallExplorer variable from the core -, and go to an official website or forum that will contain information and resources of newer updates and recent changes.
REM # =============================================================================================
:ModuleUpdates_OpenWeb
CALL :Call_WindowsExplorer "https://github.com/SibTiger/Morgenstern"
GOTO :EOF