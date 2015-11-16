REM -----------------------------------------------------------------
REM =================================================================
REM -----------------------------------------------------------------
REM                       General Program Use


REM # =============================================================================================
REM # Documentation: This function will help keep the activity messages in a cleaner standard.
REM # Parameters:
REM #   [string] TaskName
REM # =============================================================================================
:CompileProject_Display_IncomingTask
IF %ToggleLog% EQU True CALL :CompileProject_Display_IncomingTaskLog "%~1"
ECHO %~1. . .
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This function will help keep the activity messages in a cleaner standard.
REM # Parameters:
REM #   [string] TaskName
REM # =============================================================================================
:CompileProject_Display_IncomingTaskSubLevel
IF %ToggleLog% EQU True CALL :CompileProject_Display_IncomingTaskLog "%~1"
ECHO    %~1. . .
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This function will help keep the activity messages in a cleaner standard.  Messages passed through this function are only treated as standard messages and not fully procedures.
REM # Parameters:
REM #   [string] TaskName
REM # =============================================================================================
:CompileProject_Display_IncomingTaskSubLevelMSG
(ECHO %~1) >> %STDOUT%
ECHO    %~1
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This function will help keep the log activity messages in a cleaner standard.
REM # Parameters:
REM #   [string] TaskName
REM # =============================================================================================
:CompileProject_Display_IncomingTaskLog
(ECHO Performing Task:) >> %STDOUT%
(ECHO   %~1) >> %STDOUT%
(ECHO.) >> %STDOUT%
(ECHO.) >> %STDOUT%
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Run the operation by invoking the defined variable 'TaskCaller_CallLong'.
REM # =============================================================================================
:CompileProject_TaskOperation
REM Run the operation that is packaged.
%TaskCaller_CallLong%>> "%STDOUT%" 2>&1
SET ExitCode=%ERRORLEVEL%
REM If we're logging, call the log-footer
IF %ToggleLog% EQU True CALL :CompileProject_LogFooter
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Always print this to log files after executing a task or a program.
REM # =============================================================================================
:CompileProject_LogFooter
(ECHO.)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
(ECHO Program Called:)>> "%STDOUT%"
(ECHO   %TaskCaller_NiceProgramName%)>> "%STDOUT%"
(ECHO Task Performed:)>> "%STDOUT%"
(ECHO   %TaskCaller_CallLong%)>> "%STDOUT%"
(ECHO Exit Code: %ExitCode%)>> "%STDOUT%"
(ECHO %Separator%)>> "%STDOUT%"
(ECHO Time: %Time%   -   Date: %Date%)>> "%STDOUT%"
(ECHO Project Name: %ProjectName%   -   Module Version: %ProjectVersion%)>> "%STDOUT%"
(ECHO %SeparatorLong%)>> "%STDOUT%"
(ECHO %SeparatorLong%)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Always print this to logfiles after a driver finished executing.
REM # Parameters: [{String} DriverMainProcess]
REM # =============================================================================================
:CompileProject_DriverLogFooter
REM ----
REM If incase the drivers call this function, opt out when the program is not logging.
IF %ToggleLog% EQU False (GOTO :EOF)
REM ----
(ECHO.)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
(ECHO %SeparatorSmall%)>> "%STDOUT%"
(ECHO %Separator%)>> "%STDOUT%"
(ECHO Finished Executing Task:)>> "%STDOUT%"
(ECHO   %~1)>> %STDOUT%
(ECHO Time: %Time%   -   Date: %Date%)>> "%STDOUT%"
(ECHO Project Name: %ProjectName%   -   Module Version: %ProjectVersion%)>> "%STDOUT%"
(ECHO %SeparatorLong%)>> "%STDOUT%"
(ECHO %SeparatorLong%)>> "%STDOUT%"
(ECHO %Separator%)>> "%STDOUT%"
(ECHO %Separator%)>> "%STDOUT%"
(ECHO %SeparatorLong%)>> "%STDOUT%"
(ECHO %SeparatorLong%)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
(ECHO.)>> "%STDOUT%"
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Cautionary note; the user should never close this program prematurely.
REM # =============================================================================================
:CompileProject_DisplayHeaderMessage
REM Just display text on the terminal
ECHO ^<i^>       Important       ^<i^>
ECHO Terminating this program prematurely can cause either hanging or zombie processes, in case can either hog the system's resources for an extended amount of time or will never terminate.
ECHO.
ECHO Compiling this project might take several minutes, please be patient!
ECHO.&ECHO.
GOTO :EOF




REM --------------------
REM ====================




REM # =============================================================================================
REM # Documentation: An error occurred while compiling the project.
REM # =============================================================================================
:CompileProject_TerminateWithError
IF %UseBell% GEQ 1 ECHO %SND_BELL%& ECHO %SND_BELL%
ECHO ^<!!!^>       FATAL ERROR       ^<!!!^>
ECHO %SeparatorLong%
ECHO.
ECHO An error occurred while compiling the %ProjectName% project!
REM If the user is logging, tell them where they can find the logs
IF %ToggleLog% EQU True (
    ECHO Check the log for more information about the error.
    ECHO Log Directory:
    ECHO   %LocalDirectory.Logs%
    ECHO Log Name:
    ECHO   %STDOUT%
)
PAUSE
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Everything was compiled successfully.
REM # =============================================================================================
:CompileProject_TerminateSuccessfully
IF %UseBell% EQU 1 ECHO %SND_BELL%
ECHO ^<-^>       Operation Successful       ^<-^>
ECHO %SeparatorLong%
ECHO.
ECHO The %ProjectName% project has been compiled successfully!
PAUSE
GOTO :EOF