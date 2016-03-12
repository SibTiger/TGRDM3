REM -----------------------------------------------------------------
REM =================================================================
REM -----------------------------------------------------------------
REM                            Git Version Control


REM -------------------------------
REM -------------------------------
REM Update the local working copy


REM # =============================================================================================
REM # Documentation: This function will update the local Working Directory to the latest commit.
REM # =============================================================================================
:CompileProject_GitUpdateProject
REM ----
REM Run this function?
IF %Detect_Git% EQU False EXIT /B 0
IF %UserConfig.GitMasterControl% EQU False EXIT /B 0
REM The user does NOT want to update the local working copy?
IF %UserConfig.GitAllowWorkingCopyUpdate% EQU False EXIT /B 0
REM ----
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Updating local working copy contents"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
CALL :CompileProject_GitUpdateProject_TaskUpdate || (CALL :CaughtErrorSignal& EXIT /B 1)
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
REM ----
EXIT /B 0



:CompileProject_GitUpdateProject_TaskUpdate
CALL :CompileProject_Display_IncomingTaskSubLevel "Updating the Git Local Working Copy"
REM Prepare the variables needed for the operation function.
SET TaskCaller_CallLong=GIT --git-dir="%UserConfig.DirProjectWorkingCopy%\.git" pull origin master
SET TaskCaller_NiceProgramName=Git Commandline
CALL :CompileProject_TaskOperation
EXIT /B %ERRORLEVEL%



REM -------------------------------
REM -------------------------------
REM Fetch the latest commit ID


REM # =============================================================================================
REM # Documentation: This function will try to retrieve the Git commit ID that the working copy is based off from.
REM # =============================================================================================
:CompileProject_FetchGitCommitID
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Fetching the project's commit ID"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
CALL :CompileProject_FetchGitCommitID_TaskFetchID || (CALL :CaughtErrorSignal& EXIT /B 1)
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
REM ----
EXIT /B 0



:CompileProject_FetchGitCommitID_TaskFetchID
CALL :CompileProject_Display_IncomingTaskSubLevel "Retriving commit ID"
FOR /F %%a IN ('GIT --git-dir="%UserConfig.DirProjectWorkingCopy%\.git" rev-parse --short HEAD') DO SET ProjectCommitID=%%a
EXIT /B %ERRORLEVEL%



REM -------------------------------
REM -------------------------------
REM Fetch the latest commit changelog history


REM # =============================================================================================
REM # Documentation: Fetch the git commit changelog history.
REM # =============================================================================================
:CompileProject_FetchGitCommitLogHistory
REM ----
REM Run this function?
IF %Detect_Git% EQU False EXIT /B 0
IF %UserConfig.GitMasterControl% EQU False EXIT /B 0
REM Did the user wanted a log history?
IF %UserConfig.GitAllowFetchChangeLog% EQU False EXIT /B 0
REM ----
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Fetching project's changelog history"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
CALL :CompileProject_FetchGitCommitLogHistory_Task || (CALL :CaughtErrorSignal& EXIT /B 1)
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0



REM # =============================================================================================
REM # Documentation: Generate a changelog history in a regular text file.
REM # =============================================================================================
:CompileProject_FetchGitCommitLogHistory_Task
REM Did the user wanted this log type?
IF %UserConfig.GitAllowFetchChangeLog% EQU False EXIT /B 0
CALL :CompileProject_Display_IncomingTaskSubLevel "Fetching a standard changelog [txt formatting]"
REM Fetch the log
GIT --git-dir="%UserConfig.DirProjectWorkingCopy%\.git" log -%DevelopmentChangeLog_HardLimit% 1> "%LocalDirectory.Temp%\%FileName%\Changelog.txt"
EXIT /B %ERRORLEVEL%