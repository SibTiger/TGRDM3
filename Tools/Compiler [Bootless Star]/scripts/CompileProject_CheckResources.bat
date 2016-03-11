REM -----------------------------------------------------------------
REM =================================================================
REM -----------------------------------------------------------------
REM                          Check Resources


REM # =============================================================================================
REM # Documentation: This function will make sure that the all of the resources that are necessary for this program are available and ready.  If there is _one_ issue, terminate the program - unless it is possible to _assume_ settings automatically.
REM # =============================================================================================
:CompileProject_CheckResources
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Running Self-Check"
REM Print on the screen that the program is trying to self-check
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
REM ----
REM Check if the project can be detected
CALL :CompileProject_CheckResources_ProjectTarget || EXIT /B 1
REM ----
REM Check if the 7Zip software can be detected
CALL :CompileProject_CheckResources_7Zip || EXIT /B 1
REM ----
REM Check if the Git CUI tools can be detected
CALL :CompileProject_CheckResources_Git || EXIT /B 1
REM ----
REM Print the footer in the log.
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0



REM # =============================================================================================
REM # Documentation: Check to make sure that the program can detect the project.
REM # =============================================================================================
:CompileProject_CheckResources_ProjectTarget
REM Were we able to find the projects directory?
CALL :CompileProject_Display_IncomingTaskSubLevel "Checking if %ProjectName%'s directory exists"
IF %Detect_ProjectCore% EQU False (
    REM We can't find the project
    CALL :CompileProject_CheckResources_ProjectTarget_ERR
    EXIT /B 1
)
REM We can find the project
EXIT /B 0



:CompileProject_CheckResources_ProjectTarget_ERR
IF %ToggleLog% EQU True CALL :CompileProject_CheckResources_ProjectTarget_ERRLog
ECHO !ERR_CRIT!: Could not locate the %ProjectName% project!
ECHO This program can not continue until this issue has been resolved!
ECHO.
PAUSE
GOTO :EOF



:CompileProject_CheckResources_ProjectTarget_ERRLog
(ECHO !ERR_CRIT!: Could not locate the %ProjectName% project!) >> %STDOUT%
(ECHO This program can not continue until this issue has been resolved!) >> %STDOUT%
(ECHO.) >> %STDOUT%
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Check to make sure that the 7Zip software was detected from the core.
REM # =============================================================================================
:CompileProject_CheckResources_7Zip
REM Were we able to detect [from the core] that the 7zip program exists?
CALL :CompileProject_Display_IncomingTaskSubLevel "Checking if 7Zip was detected"
REM Detected 7Zip
IF %Detect_7Zip% EQU True EXIT /B 0
REM Couldn't find 7Zip
CALL :CompileProject_CheckResources_7Zip_ERR
EXIT /B 1



:CompileProject_CheckResources_7Zip_ERR
IF %ToggleLog% EQU True CALL :CompileProject_CheckResources_7Zip_ERRLog
ECHO !ERR_CRIT!: Could not find 7Zip software!
ECHO This program can not continue until this issue has been resolved!
ECHO.
PAUSE
GOTO :EOF



:CompileProject_CheckResources_7Zip_ERRLog
(ECHO !ERR_CRIT!: Could not find 7Zip software!) >> %STDOUT%
(ECHO This program can not continue until this issue has been resolved!) >> %STDOUT%
(ECHO.) >> %STDOUT%
GOTO :EOF



REM # =============================================================================================
REM # Documentation: Check to make sure that the Git toolset software was detected from the core.
REM # =============================================================================================
:CompileProject_CheckResources_Git
REM Were we able to detect [from the core] that the Git CUI tools exists?
CALL :CompileProject_Display_IncomingTaskSubLevel "Checking if Git CLI Toolset was detected"
REM Detected Git
IF %Detect_Git% EQU True EXIT /B 0
REM User wanted to allow the use of Git?
IF %UserConfig.GitMasterControl% EQU False EXIT /B 0
REM Couldn't find Git
CALL :CompileProject_CheckResources_Git_ERR
EXIT /B 1



:CompileProject_CheckResources_Git_ERR
IF %ToggleLog% EQU True CALL :CompileProject_CheckResources_Git_ERRLog
ECHO !ERR_CRIT!: Could not find Git CLI Toolset!
ECHO This program can not continue until this issue has been resolved!
ECHO.
PAUSE
GOTO :EOF



:CompileProject_CheckResources_Git_ERRLog
(ECHO !ERR_CRIT!: Could not find Git CLI Toolset!) >> %STDOUT%
(ECHO This program can not continue until this issue has been resolved!) >> %STDOUT%
(ECHO.) >> %STDOUT%
GOTO :EOF