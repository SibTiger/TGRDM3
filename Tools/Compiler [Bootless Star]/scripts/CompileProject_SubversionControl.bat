REM -----------------------------------------------------------------
REM =================================================================
REM -----------------------------------------------------------------
REM                            Subversion


REM -------------------------------
REM -------------------------------
REM Update the local working copy


REM # =============================================================================================
REM # Documentation: This function will update the local Working Directory to the latest revision.
REM # =============================================================================================
:CompileProject_SVNUpdateProject
REM ----
REM Run this function?
IF %Detect_SVN% EQU False EXIT /B 0
IF %UserConfig.SVNMasterControl% EQU False EXIT /B 0
REM The user does NOT want to update the local working copy?
IF %UserConfig.SVNAllowWorkingCopyUpdate% EQU False EXIT /B 0
REM ----
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Updating local working copy contents"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
CALL :CompileProject_SVNUpdateProject_TaskUpdate || (CALL :CaughtErrorSignal& EXIT /B 1)
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
REM ----
EXIT /B 0



:CompileProject_SVNUpdateProject_TaskUpdate
CALL :CompileProject_Display_IncomingTaskSubLevel "Updating the SVN Local Working Copy"
REM Prepare the variables needed for the operation function.
SET TaskCaller_CallLong=SVN update "%UserConfig.DirProjectWorkingCopy%"
SET TaskCaller_NiceProgramName=Subversion Commandline
CALL :CompileProject_TaskOperation
REM Error Check
CALL :CompileProject_SVNErrorCheck %ExitCode%
EXIT /B %ERRORLEVEL%



REM -------------------------------
REM -------------------------------
REM Fetch the latest revision ID


REM # =============================================================================================
REM # Documentation: This function will try to retrieve the SVN revision that the working copy is based off from.  {NOT MERGED; this is not possible}
REM # =============================================================================================
:CompileProject_FetchSVNRevisionID
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Fetching SVN revision number"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
REM Perform the tasks in multiple functions, to keep things a little sane in the code.
CALL :CompileProject_FetchSVNRevisionID_OldRevision
CALL :CompileProject_FetchSVNRevisionID_TaskNewRevision || (CALL :CaughtErrorSignal& EXIT /B 1)
CALL :CompileProject_FetchSVNRevisionID_CleanupResult
CALL :CompileProject_FetchSVNRevisionID_Calculate
CALL :CompileProject_FetchSVNRevisionID_CalculateRange
CALL :CompileProject_FetchSVNRevisionID_CheckUpdateCachedRevision
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0



REM # =============================================================================================
REM # Documentation: Setup the field and find the current revision number.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionID_TaskNewRevision
REM Prepare the variables needed for the error function; this is NOT tied into the operation function.
SET TaskCaller_CallLong=SVNVERSION "%UserConfig.DirProjectWorkingCopy%"
SET TaskCaller_NiceProgramName=Subversion Commandline
CALL :CompileProject_FetchSVNRevisionID_NewRevision
REM Error Check
CALL :CompileProject_SVNErrorCheck %ERRORLEVEL%
EXIT /B %ERRORLEVEL%



REM # =============================================================================================
REM # Documentation: Fetch the working copy revision number and store it in primary memory.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionID_NewRevision
CALL :CompileProject_Display_IncomingTaskSubLevel "Capturing the local Working Copy's current revision"
FOR /F %%a IN ('SVNVERSION "%UserConfig.DirProjectWorkingCopy%"') DO SET SVNRevisionNew=%%a
EXIT /B %ERRORLEVEL%



REM -------------------------------
REM -------------------------------
REM Fetch the latest revision history log


REM # =============================================================================================
REM # Documentation: Fetch the SVN revision log history.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionLogHistory
REM ----
REM Run this function?
IF %Detect_SVN% EQU False EXIT /B 0
IF %UserConfig.SVNMasterControl% EQU False EXIT /B 0
REM Did the user wanted a log history?
IF %UserConfig.SVNAllowFetchRevisionLog% EQU False (
    IF %UserConfig.SVNAllowFetchRevisionLogXML% EQU False EXIT /B 0
)
REM ----
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Fetching SVN revision history log"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
CALL :CompileProject_FetchSVNRevisionHistory || (CALL :CaughtErrorSignal& EXIT /B 1)
CALL :CompileProject_FetchSVNRevisionHistoryXML || (CALL :CaughtErrorSignal& EXIT /B 1)
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0



REM # =============================================================================================
REM # Documentation: Generate a changelog history in a regular text file.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionHistory
REM Did the user wanted this log type?
IF %UserConfig.SVNAllowFetchRevisionLog% EQU False EXIT /B 0
CALL :CompileProject_Display_IncomingTaskSubLevel "Fetching a standard revision change log [txt formatting]"
REM Fetch the log
SET TaskCaller_CallLong=SVN log -l %SVNRevisionRange% -r HEAD:1 "%UserConfig.DirProjectWorkingCopy%" 1> "%LocalDirectory.Temp%\%FileName%\Changelog.txt"
SET TaskCaller_NiceProgramName=Subversion
SVN log -l %SVNRevisionRange% -r HEAD:1 "%UserConfig.DirProjectWorkingCopy%" 1> "%LocalDirectory.Temp%\%FileName%\Changelog.txt"
REM Error Check
CALL :CompileProject_SVNErrorCheck %ERRORLEVEL%
EXIT /B %ERRORLEVEL%



REM -------------------------------
REM -------------------------------
REM Error Checking


REM # =============================================================================================
REM # Parameters: [{int} ExitCode]
REM # Documentation: Error check function.  This function examines the exitcodes and determines if the software closed with an error or if was successful.
REM # =============================================================================================
:CompileProject_SVNErrorCheck
REM Did Subversion return an error?
IF %1 EQU 0 (
    EXIT /B 0
) ELSE (
    EXIT /B 1
)