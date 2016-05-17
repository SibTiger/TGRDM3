REM -----------------------------------------------------------------
REM =================================================================
REM -----------------------------------------------------------------
REM                             File Name


REM # =============================================================================================
REM # Parameters: [{int} BuildMode]
REM # Documentation: Determine the file and directory name of the project and the current revision number.
REM # =============================================================================================
:CompileProject_GenerateProjectName
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET "DriversNiceTask=Generating project name"
CALL :CompileProject_Display_IncomingTask "%DriversNiceTask%"
CALL :CompileProject_GenerateProjectName_MakeName %1
CALL :CompileProject_DriverLogFooter "%DriversNiceTask%"
EXIT /B 0



REM # =============================================================================================
REM # Parameters: [{int} BuildMode]
REM # Documentation: Create a generalized name; it is possible for the user to not have a revision ID - which no revision number will be stored.
REM # =============================================================================================
:CompileProject_GenerateProjectName_MakeName
IF %1 EQU 1 (
    CALL :CompileProject_GenerateProjectName_MakeName_NoCommitID
    GOTO :EOF
)
REM Resource build file name
IF %1 EQU 2 (
    CALL :CompileProject_GenerateProjectName_MakeName_AssetName
    GOTO :EOF
)
IF %ProjectCommitID% EQU "UNKNOWN" (
    CALL :CompileProject_GenerateProjectName_MakeName_NoCommitID
    GOTO :EOF
) ELSE (
    CALL :CompileProject_GenerateProjectName_MakeName_WithCommitID
    GOTO :EOF
)



:CompileProject_GenerateProjectName_MakeName_AssetName
REM When the user wants to build an asset archive for specific use of GZDoom Builder or any editor adjacent to, this function will set the correct filename.
SET FileName=%ProjectNameCompact%_assets
CALL :CompileProject_Display_IncomingTaskSubLevelMSG "The file name will be set for standard assets and resources."
GOTO :EOF



:CompileProject_GenerateProjectName_MakeName_NoCommitID
REM If we can not get the newer revision - or we are not wanting the revision ID, then exclude the revision number in the name.
SET FileName=%ProjectNameCompact%_v%Version%
CALL :CompileProject_Display_IncomingTaskSubLevelMSG "The file naming scheme will not include a commit hash-ID."
GOTO :EOF



:CompileProject_GenerateProjectName_MakeName_WithCommitID
REM include the revision in the filename.
SET FileName=%ProjectNameCompact%_v%Version%-%ProjectCommitID%
CALL :CompileProject_Display_IncomingTaskSubLevelMSG "The file naming scheme will include a commit hash-ID."
GOTO :EOF