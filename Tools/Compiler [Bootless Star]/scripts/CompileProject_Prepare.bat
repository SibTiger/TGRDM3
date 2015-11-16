REM =====================================================================
REM Compile: Preparations
REM ----------------------------
REM In this section, the program will merely setup any last minute updates\configurations and anything else that is required for the compiling process.
REM =====================================================================


REM # =============================================================================================
REM # Parameters: [{int} BuildMode]
REM # Documentation: Within this section, we're preparing the entire compiling process.
REM # =============================================================================================
:CompileProject_Prepare
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Preparing compiling process"
REM Print on the screen that the program is preparing
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
REM ----
REM Initialize some runtime variables
CALL :CompileProject_Prepare_Initializations %1
REM ----
REM Print the footer in the log.
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0



REM # =============================================================================================
REM # Parameters: [{int} BuildMode]
REM # Documentation: This function will update any mutable variables that is needed within the entire backup process.
REM # =============================================================================================
:CompileProject_Prepare_Initializations
CALL :CompileProject_Display_IncomingTaskSubLevel "Initializing RunTime mutable variables"
REM Determine the DestinationOutput
IF %1 EQU 0 (
    REM Developmental
    SET "DestinationOutput=%LocalDirectory.Developmental%"
) ELSE (
    REM Release
    SET "DestinationOutput=%LocalDirectory.Releases%"
)
GOTO :EOF