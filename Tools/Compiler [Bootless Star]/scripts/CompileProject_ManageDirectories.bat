REM -----------------------------------------------------------------
REM =================================================================
REM -----------------------------------------------------------------
REM                         Directory Manager


REM # =============================================================================================
REM # Parameters: [{int} Type]
REM # Documentation: Directory manager will determine how the directories will be created.
REM # =============================================================================================
:CompileProject_DirectoryManager
IF %1 EQU 0 (
    REM Create the cache directory; this used when generating the project and sorting the contents as needed to fit the ZIP standards.
    GOTO :CompileProject_DirectoryManager_CreateCache
)
IF %1 EQU 1 (
    REM Shift the directory contents to the Build directory
    GOTO :CompileProject_DirectoryManager_ForwardBuild
)
IF %1 EQU 2 (
    REM Thrash the cached build.  The contents has already been compacted
    GOTO :CompileProject_DirectoryManager_ThrashBuild
)
ECHO !ERR: Incorrect call to Directory Manager!  Received [ %1 ] which is not in the scope.
EXIT /B 1



REM # =============================================================================================
REM # Documentation: This section will create a temporary location for building the project.
REM # =============================================================================================
:CompileProject_DirectoryManager_CreateCache
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Creating cache location"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
REM Check to see if the directory already exists before creating it.
CALL :CompileProject_DirectoryManager_CheckExists "%LocalDirectory.Temp%\%FileName%" 0 || (CALL :CaughtErrorSignal& EXIT /B 1)
REM Create the temporary cache directory
CALL :CompileProject_DirectoryManager_CreateDirectory "%LocalDirectory.Temp%\%FileName%" || (CALL :CaughtErrorSignal& EXIT /B 1)
REM Create the temporary cache directory for the build [the project contents is stored here]
CALL :CompileProject_DirectoryManager_CreateDirectory "%LocalDirectory.Temp%\%FileName%\Build" || (CALL :CaughtErrorSignal& EXIT /B 1)
REM Print the footer in the log.
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0



REM # =============================================================================================
REM # Parameters: [{string} Local and Directory Target] [{bool} WarnUser]
REM # Documentation: Check to see if the cache directory already exists; if so - notify the user before thrashing the contents
REM # =============================================================================================
:CompileProject_DirectoryManager_CheckExists
REM The directory does not exist, then leave this function.
IF NOT EXIST "%~1" EXIT /B 0
REM The directory already exists
IF %2 EQU 1 CALL :CompileProject_DirectoryManager_CheckExists_WarnThrash "%~1"
CALL :CompileProject_DirectoryManager_Thrash "%~1" || EXIT /B 1
EXIT /B 0



REM # =============================================================================================
REM # Parameters: [{string} Target]
REM # Documentation: Warn the user that the previous generated file will be thrashed and overwritten
REM # =============================================================================================
:CompileProject_DirectoryManager_CheckExists_WarnThrash
IF %ToggleLog% EQU True (CALL :CompileProject_DirectoryManager_CheckExists_WarnThrash_Log)
ECHO.&ECHO.
ECHO ^<?^>       Directory Already Exists       ^<?^>
ECHO %SeparatorLong%
ECHO.
ECHO Found an existing compiled build which is one step away from being permanently deleted.  Any personalized configurations and customizations that were made within this build will be expunged!  Move any personal files to a safe location before continuing!
ECHO.
ECHO Location:
ECHO   %~1
ECHO.
PAUSE
ECHO.
GOTO :EOF



REM Push the message into a logfile
:CompileProject_DirectoryManager_CheckExists_WarnThrash_Log
(ECHO.&ECHO.) >> %STDOUT%
(ECHO ^<?^>       Directory Already Exists       ^<?^>) >> %STDOUT%
(ECHO %SeparatorLong%) >> %STDOUT%
(ECHO.) >> %STDOUT%
(ECHO Found an existing compiled build which is one step away from being permanently deleted.  Any personalized configurations and customizations that were made within this build will be expunged!  Move any personal files to a safe location before continuing!) >> %STDOUT%
(ECHO.) >> %STDOUT%
(ECHO Location:) >> %STDOUT%
(ECHO   %~1) >> %STDOUT%
(ECHO.) >> %STDOUT%
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Create a directory which will store the output contents.
REM # =============================================================================================
:CompileProject_DirectoryManager_CreateDirectory
REM Create the directory
CALL :CompileProject_Display_IncomingTaskSubLevel "Creating directory [ %~1 ]"
SET TaskCaller_CallLong=MKDIR "%~1"
SET TaskCaller_NiceProgramName=Make Directory
CALL :CompileProject_TaskOperation
EXIT /B %ERRORLEVEL%



REM # =============================================================================================
REM # Documentation: This function will move the contents that was from cache to the regular builds database
REM # =============================================================================================
:CompileProject_DirectoryManager_ForwardBuild
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Transitioning the data from the cached directory to the builds directory"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
REM First check to see if a directory exists
CALL :CompileProject_DirectoryManager_CheckExists "%DestinationOutput%\%FileName%" 1 || (CALL :CaughtErrorSignal& EXIT /B 1)
CALL :CompileProject_DirectoryManager_ForwardBuild_Shift "%LocalDirectory.Temp%\%FileName%" "%DestinationOutput%\"|| (CALL :CaughtErrorSignal& EXIT /B 1)
CALL :CompileProject_DirectoryManager_Thrash "%LocalDirectory.Temp%\%FileName%" || (CALL :CaughtErrorSignal& EXIT /B 1)
REM Print the footer in the log.
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0



REM # =============================================================================================
REM # Parameters: [{string} DirectoryTarget] [{string} DestinationTarget]
REM # Documentation: Move the cached data to the builds; ready to be used state.
REM # =============================================================================================
:CompileProject_DirectoryManager_ForwardBuild_Shift
REM Move the directory
CALL :CompileProject_Display_IncomingTaskSubLevel "Transitioning the %FileName% directory from Cache to Builds"
SET TaskCaller_CallLong=MOVE /Y "%~1" "%~2"
SET TaskCaller_NiceProgramName=Move Directory
CALL :CompileProject_TaskOperation
EXIT /B %ERRORLEVEL%



REM # =============================================================================================
REM # Parameters: [{string} Target]
REM # Documentation: Thrash a directory
REM # =============================================================================================
:CompileProject_DirectoryManager_Thrash
CALL :CompileProject_Display_IncomingTaskSubLevel "Thrashing directory [ %~1 ]"
SET TaskCaller_CallLong=RMDIR /S /Q "%~1"
SET TaskCaller_NiceProgramName=Remove Directory and Files
CALL :CompileProject_TaskOperation
EXIT /B %ERRORLEVEL%



REM # =============================================================================================
REM # Parameters: [{string} Target]
REM # Documentation: Thrash the cached contents, we're finished with them now.
REM # =============================================================================================
:CompileProject_DirectoryManager_ThrashBuild
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Thrashing cache build directory"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
CALL :CompileProject_DirectoryManager_Thrash "%LocalDirectory.Temp%\%FileName%\Build" || (CALL :CaughtErrorSignal& EXIT /B 1)
REM Print the footer in the log.
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0