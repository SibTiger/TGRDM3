REM =====================================================================
REM Initialization Driver
REM ----------------------------
REM This driver will manage how to either initialize identifiers or if the configuration needs to be saved.
REM =====================================================================


REM # =============================================================================================
REM # Parameters: [{String} Mode] [{String} Options] [{String} TargetPath]
REM # Documentation: This function, depending how it is called - which is set by the first parameter [MODE], will help set up the environment for the program, create or update a user configuration, or update the project resource targets.
REM # =============================================================================================
:Initialization_Driver
REM This driver requires parameters:
REM     [Mode] (OPTIONS) (PATH)
REM When starting the program, this function will be executed.
IF %1 EQU Load (
    REM Parameters: [Mode = Load]
    REM Load the environment field when starting up the program or when this block is executed.
    CALL :Initialization_IdentifiersStatic
    CALL :Initialization_IdentifiersUserSettings 0
    CALL :Initialization_LocalDirectories
    CALL :UserPreset_Driver 0
    CALL :Initialization_UpdateLogging
    GOTO :EOF
)
IF %1 EQU SaveUserConfig (
    REM Parameters: [Mode = SaveUserConfig] [File to Output]
    REM Write the current user configuration that is in current active memory and write it to a file.
    CALL :Initialization_IdentifiersUserSettings 1 "%~2"
    GOTO :EOF
)



REM =====================================================================
REM Module Initialization Functions
REM ----------------------------
REM These functions are designed to help setup the environment
REM =====================================================================


REM # =============================================================================================
REM # Documentation: This function sets the static environment for the module, and other variables that is self managed 1ithin the program.
REM # =============================================================================================
:Initialization_IdentifiersStatic
REM Static Variables
SET ProjectName=Morgenstern
SET ProjectNameShort=Morgenstern
SET ProjectVersion=4
SET ReleaseDate=4.March.2015
SET ProjectNameCompact=Morgenstern
REM Used as the filename and directory when compiling the project.  This is built in the compiling protocol, just let it as 'UNKNOWN' here and change it later.
SET FileName=UNKNOWN
SET FileName_Archive=UNKNOWN
REM Version of the initial project, not the program version.
SET Version=0
REM Error Signal for Operations; if the value is not null, there was a general issue with a function or functions in sequence.
SET ErrorSignal=0
REM Exit Code captures ErrorLevel - but retains the xid.
SET ExitCode=0
REM Fatal Exit retains the exit code from the lower level [spine of the program]; if there is an error from the lower level, then this variable will be updated.
SET FatalExit=0
REM What internal or external CMD was called, this is going to be used primarily for logs and error messages.  Make this easy for the user to understand what program was called, do not make it complicated.
SET TaskCaller_NiceProgramName=NULL
REM Compiled version of 'TaskCaller' into one string.
SET TaskCaller_CallLong=NULL
REM Static SVN revision number holders
SET SVNRevisionOld=-1
SET SVNRevisionNew=-1
SET SVNRevisionRange=0
REM A set hard limit for retrieving the SVN change log history
SET SVNRevisionRangeHardLimit=50
REM Can we update the cached revision that is stored in a small ASCII file?
SET SVNRevisionUpdateCachedRevisionID=False
REM This houses the parameters for 7Zip, this gets filled when we need to invoke it.
SET SevenZipCompactParameters=-
REM Can we find the main project?
SET Detect_ProjectCore=False
REM This variable is used to describe the drivers main purpose and present the value in the log files.
SET DriversNiceTask=UNKNOWN
REM Final destination for the project build; either developmental or release
SET DestinationOutput=UNKNOWN
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This function will set the Local Directory targets.  These local directories are necessary for the program to work correctly.
REM # =============================================================================================
:Initialization_LocalDirectories
REM Note: DirLocal is merely a simple dedicated directory for output data and saved data.
SET "LocalDirectory.MainRoot=%DirProjects%\%ProjectNameCompact%"
REM Temporary data
SET "LocalDirectory.Temp=%LocalDirectory.MainRoot%\Temp"
REM Preset Configurations
SET "LocalDirectory.UserConfig=%LocalDirectory.MainRoot%\Config"
REM Regular data files
SET "LocalDirectory.Builds=%LocalDirectory.MainRoot%\Builds"
    REM  Releases
        SET "LocalDirectory.Releases=%LocalDirectory.Builds%\Release"
    REM Developmental, Beta Builds, Alpha Builds, and the like.
        SET "LocalDirectory.Developmental=%LocalDirectory.Builds%\Development"
REM Log Files
SET "LocalDirectory.Logs=%LocalDirectory.MainRoot%\Logs"
GOTO :EOF



REM # =============================================================================================
REM # Parameters: [{Int} Mode] [{String} UserConfigOutput]
REM # Documentation: This function houses the users settings and customizations; this manages both loading and writing to a file, depending on the argument when this function is called.
REM #  First Parameter:
REM #   0 = Read\Load
REM #   1 = Write to specific file
REM #  Second Parameter:
REM #   Output File
REM # =============================================================================================
:Initialization_IdentifiersUserSettings
REM --------------------------------
REM ================================
REM Subversion Settings
REM -------------------------------------
IF %1 EQU 1 (ECHO REM Subversion Settings)>> "%~2"
IF %1 EQU 1 (ECHO REM --------------------)>> "%~2"
REM ----
REM Allow the program to use Subversion commandline?
IF %1 EQU 0 (SET UserConfig.SVNMasterControl=False)
IF %1 EQU 1 (ECHO REM Allow the program to use Subversion CUI)>> "%~2"
IF %1 EQU 1 (ECHO SET UserConfig.SVNMasterControl=%UserConfig.SVNMasterControl%)>> "%~2"
REM ----
REM Allow the working copy to be updated?
IF %1 EQU 0 (SET UserConfig.SVNAllowWorkingCopyUpdate=False)
IF %1 EQU 1 (ECHO REM Allow the program to update the Working Copy.)>> "%~2"
IF %1 EQU 1 (ECHO SET UserConfig.SVNAllowWorkingCopyUpdate=%UserConfig.SVNAllowWorkingCopyUpdate%)>> "%~2"
REM ----
REM Allow the program to fetch for the SVN revision log history?
IF %1 EQU 0 (SET UserConfig.SVNAllowFetchRevisionLog=False)
IF %1 EQU 1 (ECHO REM This allows the program to fetch the SVN revision log.)>> "%~2"
IF %1 EQU 1 (ECHO SET UserConfig.SVNAllowFetchRevisionLog=%UserConfig.SVNAllowFetchRevisionLog%)>> "%~2"
REM ----
REM Allow the program to fetch for the SVN revision log history in XML format?
IF %1 EQU 0 (SET UserConfig.SVNAllowFetchRevisionLogXML=False)
IF %1 EQU 1 (ECHO REM This allows the program to fetch the SVN revision log in XML formatting.)>> "%~2"
IF %1 EQU 1 (ECHO SET UserConfig.SVNAllowFetchRevisionLogXML=%UserConfig.SVNAllowFetchRevisionLogXML%)>> "%~2"


IF %1 EQU 1 (ECHO.)>> "%~2"
REM Directory Management Settings
REM -------------------------------------
IF %1 EQU 1 (ECHO REM Directory Management Settings)>> "%~2"
IF %1 EQU 1 (ECHO REM --------------------)>> "%~2"
REM ----
REM Direct location of the project location [must be in the same path as the solution file]
IF %1 EQU 0 (SET "UserConfig.DirProjectWorkingCopy=%UserProfile%\Morgenstern\")
IF %1 EQU 1 (ECHO REM Path to the project.  This is crucially important for the program to have the correct path, otherwise this program will not properly work.)>> "%~2"
IF %1 EQU 1 (ECHO SET "UserConfig.DirProjectWorkingCopy=%UserConfig.DirProjectWorkingCopy%")>> "%~2"



REM # =============================================================================================
REM # Documentation: Update the log file name, if logging is enabled.
REM # =============================================================================================
:Initialization_UpdateLogging
IF "%ToggleLog%" NEQ "False" SET "STDOUT=%LocalDirectory.Logs%\%ProjectNameCompact%_%core.Date%.txt"
GOTO :EOF