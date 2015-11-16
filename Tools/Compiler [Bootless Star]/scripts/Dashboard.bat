REM =====================================================================
REM Dashboard
REM ----------------------------
REM The dashboard here is to only highlight important and display what the user needs to know for the program to work correctly.
REM The idea of this dashboard, is to NOT be so verbose or full of details, but only display quick and brief details.
REM This feature can be rather intensive as this does detections, which requires reads and writes within the memory field.  Disabling this feature can slightly improve the performance.
REM =====================================================================


REM # =============================================================================================
REM # Documentation: The main header for the Dashboard Viewer tool.
REM # =============================================================================================
:Dashboard
CALL :Dashboard_HeaderBorder
ECHO                  Dashboard Viewer
ECHO Ver: %ProjectVersion%                           %ReleaseDate%
CALL :Dashboard_ProjectDetection
ECHO %ProjectName% Directory - Status: %ProcessVarA%
ECHO Preset: %UserConfigurationLoaded%
CALL :Dashboard_CallDetection
CALL :Dashboard_FooterBorder
CALL :Dashboard_ExtraLineBreaks
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This function tries to find errors that could prevent the program from working efficiently.  If errors were found, this will add warning notifications within the dashboard.
REM # =============================================================================================
:Dashboard_CallDetection
CALL :DashboardDetection
IF %ERRORLEVEL% EQU 1 (
    REM Some resources didn't pass through the detection
    ECHO.
    ECHO Warning^(s^): %ProcessVarB%
    ECHO %SeparatorSmall%
    ECHO %ProcessVarA%
)
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This function will display wither or not the main project can be located; if the detection fails, this will warn the user.
REM # =============================================================================================
:Dashboard_ProjectDetection
CALL :DetectionProject "%UserConfig.DirProjectWorkingCopy%"
IF %ERRORLEVEL% EQU 1 (
    SET ProcessVarA=Found
) ELSE (
    SET ProcessVarA=Not Found
)
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This adds additional lines to help prevent the Dashboard Viewer tool from being crowded with the main content of the program.
REM # =============================================================================================
:Dashboard_ExtraLineBreaks
ECHO.&ECHO.&ECHO.
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This function adds the header to the main Dashboard Viewer tool.
REM # =============================================================================================
:Dashboard_HeaderBorder
ECHO %SeparatorLong%
GOTO :EOF



REM # =============================================================================================
REM # Documentation: This function adds the footer to the main Dashboard Viewer tool.
REM # =============================================================================================
:Dashboard_FooterBorder
ECHO %SeparatorLong%
ECHO %SeparatorLong%
GOTO :EOF