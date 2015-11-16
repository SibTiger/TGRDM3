REM =====================================================================
REM User Configuration [Key Chain]
REM ----------------------------
REM This allows the user to effectively to update, create, and load their own configuration presets.
REM
REM This is compatible with Bootless Star's 1.2 Key Chain Model
REM =====================================================================


REM # =============================================================================================
REM # Parameters: [{int} Mode]
REM # Documentation: This driver function assures that the users configuration file is either loaded or saved properly.
REM # =============================================================================================
:UserPreset_Driver
REM First, check to make sure that we're not using the coreDefault configuration.  If the user is using the default, then opt out of this driver -- we can not use this feature.
IF %UserConfigurationKeyChainToken% EQU 0 EXIT /B 1

REM Cache the filename to a variable - for simplicity.
CALL :UserPreset_CacheFileName

REM Check the parameters and determine how to execute.
IF %1 EQU 0 CALL :UserPreset_Load "%ProcessVarA%"
IF %1 EQU 1 CALL :UserPreset_Update "%ProcessVarA%"
IF %1 EQU 2 CALL :UserPreset_Create "%ProcessVarA%"
REM Successful operation
EXIT /B 0



REM # =============================================================================================
REM # Documentation: Cache the filename to a variable - for simplicity.
REM # =============================================================================================
:UserPreset_CacheFileName
SET "ProcessVarA=%LocalDirectory.UserConfig%\%UserConfigurationKeyChainToken%.bat"
GOTO :EOF



REM # =============================================================================================
REM # Parameters: [{String} File]
REM # Documentation: Load the preset configuration file.
REM # =============================================================================================
:UserPreset_Load
IF EXIST "%~1" CALL "%~1"
GOTO :EOF



REM # =============================================================================================
REM # Parameters: [{String} File]
REM # Documentation: Update the configuration file with newer settings.
REM # =============================================================================================
:UserPreset_Update
CALL :UserPreset_Create "%~1"
GOTO :EOF



REM # =============================================================================================
REM # Parameters: [{String} File]
REM # Documentation: Create a new configuration file for this module.  This function is designed to create a new preset script file.  If in case a preset exists, this will automatically thrash it and write a new file within the filesystem.
REM # =============================================================================================
:UserPreset_Create
CALL :UserPreset_MakeFile_Header "%~1"
CALL :Initialization_Driver SaveUserConfig "%~1"
CALL :UserPreset_MakeFile_Footer "%~1"
GOTO :EOF



REM # =============================================================================================
REM # Parameters: [{String} File]
REM # Documentation: This function will create a header for the configuration file; this supplies identity of the file.
REM # =============================================================================================
:UserPreset_MakeFile_Header
(ECHO REM Preset Configuration File)> "%~1"
(ECHO REM %ProjectName% version %ProjectVersion%)>> "%~1"
(ECHO REM Created on: %DATE% - %TIME%)>> "%~1"
(ECHO REM Filename: %UserConfigurationLoaded% - Key Chain: %UserConfigurationKeyChainToken%)>> "%~1"
(ECHO REM %SeparatorLong%)>> "%~1"
(ECHO.)>> "%~1"
GOTO :EOF



REM # =============================================================================================
REM # Parameters: [{String} File]
REM # Documentation: This function will create a footer for the configuration file.
REM # =============================================================================================
:UserPreset_MakeFile_Footer
(ECHO GOTO :EOF)>> "%~1"
GOTO :EOF