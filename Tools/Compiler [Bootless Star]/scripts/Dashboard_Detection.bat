REM =====================================================================
REM Dashboard - Detection
REM ----------------------------
REM This is merely an extended version of the dashboard feature, though this includes further checks.
REM =====================================================================


REM # =============================================================================================
REM # Documentation: This function executes the entire detection procedure for the Dashboard Viewer Tool.
REM # =============================================================================================
:DashboardDetection
CALL :DashboardDetection_CheckResources
IF %ProcessVarB% NEQ 0 EXIT /B 1
EXIT /B 0



REM # =============================================================================================
REM # Documentation: This function scans for warnings that could cause problems when attempting to compile the project.
REM # =============================================================================================
:DashboardDetection_CheckResources
REM Clear the variables
SET ProcessVarA=
SET ProcessVarB=0

CALL :DashboardDetection_WorkingCopy
IF %ERRORLEVEL% EQU 1 (
    SET "ProcessVarA=%ProcessVarA%Morgenstern Dir - Not Found!&ECHO."
    SET /A ProcessVarB=%ProcessVarB%+1
)
CALL :DashboardDetection_SVN
IF %ERRORLEVEL% EQU 1 (
    SET "ProcessVarA=%ProcessVarA%Subversion - Not Found!&ECHO."
    SET /A ProcessVarB=%ProcessVarB%+1
)
CALL :DashboardDetection_7Zip
IF %ERRORLEVEL% EQU 1 (
    SET "ProcessVarA=%ProcessVarA%7Zip - Not Found!&ECHO."
    SET /A ProcessVarB=%ProcessVarB%+1
)
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Were we able to detect the project's Working Copy files?
REM # =============================================================================================
:DashboardDetection_WorkingCopy
REM Morgenstern Local Working Copy
CALL :DetectionProject "%UserConfig.DirProjectWorkingCopy%"
IF %ERRORLEVEL% EQU 0 EXIT /B 1
EXIT /B 0



REM # =============================================================================================
REM # Documentation: Was the Subversion Commandline tools detected from the core?
REM # =============================================================================================
:DashboardDetection_SVN
IF %UserConfig.SVNMasterControl% EQU True (
    IF %Detect_SVN% EQU False EXIT /B 1
)
EXIT /B 0



REM # =============================================================================================
REM # Documentation: Was the 7Zip software detected from the core?
REM # =============================================================================================
:DashboardDetection_7Zip
IF %Detect_7Zip% EQU False EXIT /B 1
EXIT /B 0