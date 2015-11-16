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
REM # Documentation: If incase the cached revision ID that is stored on the filesystem matches with the new value, then do NOT write a new [but duplicated] file.  This will prevent wear-and-tear the platter [for SSD killed cell blocks] and repetitive tasks.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionID_CheckUpdateCachedRevision
IF %SVNRevisionOld% EQU %SVNRevisionNew% (
    CALL :CompileProject_Display_IncomingTaskSubLevelMSG "The revision difference between the newly stored revision matches with the previously stored revision, there is no new %ProjectName% updates."
    SET SVNRevisionUpdateCachedRevisionID=False
) ELSE (
    CALL :CompileProject_Display_IncomingTaskSubLevelMSG "The revision difference indicates that there is %ProjectName% updates."
    SET SVNRevisionUpdateCachedRevisionID=True
)
GOTO :EOF



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
REM # Documentation: Load the previous saved revision ID to a variable.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionID_OldRevision
IF EXIST "%LocalDirectory.MainRoot%\SVNVersion.txt" (
    CALL :CompileProject_Display_IncomingTaskSubLevelMSG "Caching previously saved revision number"
    SET /P SVNRevisionOld=< "%LocalDirectory.MainRoot%\SVNVersion.txt"
) ELSE (
    CALL :CompileProject_Display_IncomingTaskSubLevelMSG "Could not find previously saved revision number, using 'Zero' instead"
    SET SVNRevisionOld=0
)
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Fetch the working copy revision number and store it in primary memory.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionID_NewRevision
CALL :CompileProject_Display_IncomingTaskSubLevel "Capturing the local Working Copy's current revision"
FOR /F %%a IN ('SVNVERSION "%UserConfig.DirProjectWorkingCopy%"') DO SET SVNRevisionNew=%%a
EXIT /B %ERRORLEVEL%



REM # =============================================================================================
REM # Documentation: It is possible that if the working copy is modified, the SVN Revision ID may contain non-integers.  For example: 1715M. This is a very special variable manipulator.  The idea is to remove any non-integer from the last line of the SVN Version number.
REM #  NOTE: Mixed Revisions is NOT supported within this check, that'll require a much more complicated procedure.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionID_CleanupResult
CALL :CompileProject_Display_IncomingTaskSubLevel "Thrashing non-integer characters from the newly stored revision number"
REM If the working copy is Modified, the SVN version fetched will be reported as 1715M.  Remove the Modified signature character from the variable.
SET SVNRevisionNew=%SVNRevisionNew:M=%
REM ----
REM If the working copy is Switched, the SVN version fetched will be reported as 1715S.  Remove the Switch signature character from the variable.
SET SVNRevisionNew=%SVNRevisionNew:S=%
REM ----
REM If the working copy is Partial, the SVN version fetched will be reported as 1715P.  Remove the Partial signature character from the variable.
SET SVNRevisionNew=%SVNRevisionNew:P=%
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Calculate the difference between the new revision ID against the previously saved revision ID, and store the value in memory for further computation.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionID_Calculate
CALL :CompileProject_Display_IncomingTaskSubLevel "Calculating the difference from the current revision number and the previous revision"
SET /A SVNRevisionRange=%SVNRevisionNew%-%SVNRevisionOld%
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Calculate the range and determine if it exceeds the HardLimit set.  If the calculated value is over the HardLimit range, then merely force the hard-limit to be the changelog limit.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionID_CalculateRange
CALL :CompileProject_Display_IncomingTaskSubLevel "Calculating the difference range"
REM We need to make sure that the value we have from 'CompileProject_FetchSVNRevisionID_Calculate' does not exceed the hard limit variable 'SVNRevisionRangeHardLimit'
IF %SVNRevisionRange% GTR %SVNRevisionRangeHardLimit% (
    SET SVNRevisionRange=%SVNRevisionRangeHardLimit%
) ELSE (
    IF %SVNRevisionRange% LEQ 0 SET SVNRevisionRange=%SVNRevisionRangeHardLimit%
)
GOTO :EOF



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



REM # =============================================================================================
REM # Documentation: Generate a changelog history in an XML file.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionHistoryXML
IF %UserConfig.SVNAllowFetchRevisionLogXML% EQU False EXIT /B 0
CALL :CompileProject_Display_IncomingTaskSubLevel "Fetching an advanced revision change log [xml formatting]"
REM Fetch the log
SET TaskCaller_CallLong=SVN log --xml -v -l %SVNRevisionRange%  -r HEAD:1 "%UserConfig.DirProjectWorkingCopy%" 1> "%LocalDirectory.Temp%\%FileName%\Changelog.xml"
SET TaskCaller_NiceProgramName=Subversion
SVN log --xml -v -l %SVNRevisionRange%  -r HEAD:1 "%UserConfig.DirProjectWorkingCopy%" 1> "%LocalDirectory.Temp%\%FileName%\Changelog.xml"
REM Error Check
CALL :CompileProject_SVNErrorCheck %ERRORLEVEL%
EXIT /B %ERRORLEVEL%



REM -------------------------------
REM -------------------------------
REM Update the cached revision number in the secondary storage


REM # =============================================================================================
REM # Documentation: Store the newly SVN revision ID in the secondary storage.  This will be used next time when compiling the project.
REM # =============================================================================================
:CompileProject_SVNUpdateCachedRevision
REM ----
REM Run this function?
IF %Detect_SVN% EQU False EXIT /B 0
IF %UserConfig.SVNMasterControl% EQU False EXIT /B 0
REM ----
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Updating cached revision ID"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
CALL :CompileProject_FetchSVNRevisionID_UpdateCachedValue
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0



REM # =============================================================================================
REM # Documentation: Save the information to the specified file for future use.
REM # =============================================================================================
:CompileProject_FetchSVNRevisionID_UpdateCachedValue
CALL :CompileProject_Display_IncomingTaskSubLevel "Saving the revision [%SVNRevisionNew%] ID for future use"
ECHO %SVNRevisionNew% 1> "%LocalDirectory.MainRoot%\SVNVersion.txt"
GOTO :EOF



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