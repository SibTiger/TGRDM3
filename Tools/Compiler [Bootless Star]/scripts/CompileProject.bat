REM =====================================================================
REM Main Compiling Driver
REM ----------------------------
REM This entire functionality compiles the project into a compatible archive file that works with ZDoom and GZDoom.
REM This entire section is not _independent_ and requires 'Compiler_Map.bat' script file which specifically states what and how the project's contents are to be compiled, while this section just aids the compiling process from the general scope.  With this in mind, this section should require little maintenance and upkeep.
REM =====================================================================



REM # =============================================================================================
REM # Parameters: [{int} BuildMode]
REM # Documentation: This driver will guide the entire compiling procedure.
REM #   Parameters: BuildMode: 0=Developmental Build, 1=Release Build, 2=Resource Build [GZDB]
REM # =============================================================================================
:CompileManager_Driver
CALL :DashboardOrClassicalDisplay

REM Display the header message
CALL :CompileProject_DisplayHeaderMessage


REM Check to make sure that all prerequisites and dependencies are available and ready to be used.  This detection is important, otherwise - everything will be a waste of time if some minor issue occurs.
CALL :CompileProject_CheckResources || GOTO :CompileProject_TerminateWithError


REM ----
REM Prepare and preform Initializations if needed for the compiling process
CALL :CompileProject_Prepare %1 || GOTO :CompileProject_TerminateWithError


REM ----
REM Update the local working copy to the latest commit
CALL :CompileProject_GitUpdateProject || GOTO :CompileProject_TerminateWithError


REM ----
REM Find the latest commit hash ID
CALL :CompileProject_FetchGitCommitID || GOTO :CompileProject_TerminateWithError


REM ----
REM Update the Version ID for the projects output
CALL "%UserConfig.DirProjectWorkingCopy%\Compiler_Map.bat" Version


REM ----
REM Update the file name for the projects output
CALL :CompileProject_GenerateProjectName %1 || GOTO :CompileProject_TerminateWithError


REM ----
REM Create the cached directory, which will be used for putting the files into the proper ZIP formatting as specified in ZDoom's Wiki Database.
CALL :CompileProject_DirectoryManager 0 || GOTO :CompileProject_TerminateWithError


REM ----
REM Create the project; the developers will specify how the project is created.
CALL "%UserConfig.DirProjectWorkingCopy%\Compiler_Map.bat" Make "%LocalDirectory.Temp%\%FileName%\Build\" "%LocalDirectory.Temp%\%FileName%\" %1 || GOTO :CompileProject_TerminateWithError


REM ----
REM Fetch the revision log history
CALL :CompileProject_FetchGitCommitLogHistory || GOTO :CompileProject_TerminateWithError



REM ----
REM Place the compiled data in an archive data file
CALL :CompileProject_7ZipCompactData || GOTO :CompileProject_TerminateWithError


REM ----
REM Verify that contents within the archive
CALL :CompileProject_7ZipVerifyData || GOTO :CompileProject_TerminateWithError


REM ----
REM Thrash the build directory that is stored in the cache directory.  The files has already been compacted with 7zip.
CALL :CompileProject_DirectoryManager 2 || GOTO :CompileProject_TerminateWithError


REM ----
REM Move the cached data - to the builds directory.  From there, the data should be ready for use
CALL :CompileProject_DirectoryManager 1 || GOTO :CompileProject_TerminateWithError


REM ----
REM Pop-up windows of the new builds
CALL :CompileProject_PopupWindowsExplorer || GOTO :CompileProject_TerminateWithError


REM ----
GOTO :CompileProject_TerminateSuccessfully