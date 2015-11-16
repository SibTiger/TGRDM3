REM # =============================================================================================
REM # Documentation: The spine of the program; the main is the general flow of the program but not the center of the program.  When this module starts, main will always be the function to execute.  Not only is this easier on the eyes, but this will help the programmer or user to not 'get lost' when reading the code.
REM # =============================================================================================
:Main
REM Clear the terminal buffer
CALL :ClearBuffer

REM Setup the identifiers as needed for this program
CALL :Initialization_Driver Load

REM Check and manage any protocols necessary within the prerequisite manager.
CALL :Prerequisite_Driver || SET FatalExit=1

REM Open the main menu and drive the program from there.
IF %FatalExit% EQU 0 CALL :MainMenu

REM Set the termination process.
CALL :Terminate_MainExit

REM terminate the script with the exitcode obtained from the Termination process.
EXIT /B %scriptExitCode%