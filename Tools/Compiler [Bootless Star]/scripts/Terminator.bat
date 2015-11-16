REM =====================================================================
REM Terminating Protocol
REM ----------------------------
REM These functions will determine how the program is going to be terminated.
REM =====================================================================



REM # =============================================================================================
REM # Documentation: When the user is ready to close the program, this function will make sure that the program reports the proper Exit Code along with any necessary statements - if needed.
REM # =============================================================================================
:Terminate_MainExit
IF %FatalExit% EQU 0 (
    SET scriptExitCode=0
    GOTO :Terminate
) ELSE (
    SET scriptExitCode=1
    GOTO :Terminate
)



REM =====================================================================
REM Termination
REM ----------------------------
REM Terminate this script
REM =====================================================================


:Terminate
ECHO.&ECHO.
ECHO Closing module...
GOTO :EOF