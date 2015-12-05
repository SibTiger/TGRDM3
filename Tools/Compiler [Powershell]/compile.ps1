<#

.SYNOPSIS
    Generates the compiler program for the Morgenstern project.

.DESCRIPTION
    Collects all of the script files used for the project compiler and places them in one giant script file.
    This script requires absolutely no interaction with the end-user.

.INPUTS
    None.

.OUTPUTS
    int value
    0 = Successfully created build; everything's okay.
    1 = Failed to create build

.NOTES
    Created by: Nicholas "Tiger" Gautier
    E-Mail: Nicholas.Gautier.Tiger@GMail.com
    Link: https://github.com/SibTiger/Morgenstern


    License:
    DON'T BE A DICK PUBLIC LICENSE
        http://www.dbad-license.org/
        Version 1, December 2009

#>





# ========================================================================
# ========================================================================
# Main
# ----------------------------
# Parameters:
# ----------------------------
# Brief:
#     The spine of the program
# ========================================================================
function Main()
{
    # Initializations and Declarations
    # =====================================
        # Output compiled filename
            [string] $outputFileName = "compiler.ps1";
        # Scan directory for scripts
            [string] $searchDirPath = ".\Scripts\";
        # Project name
            [string] $projectName = "Morgenstern";
        # Array of files\scripts
            [string[]] $filesArray = @("Help.ps1", "Header.ps1");

            # LOCK THE ARRAY FROM CHANGING DURING EXECUTION
                Set-Variable $filesArray -Option ReadOnly

        # Store the contents of each file into system memory
            [string[]] $cachedData = @();

    # ====
    


    # Clear the buffer
        ClearTerminalBuffer;
    # Move the host WD to the script's root
        HostWorkingDirectory 1;
    # Tell the user that the program is executing
        DisplayCompilingMessage "$projectName";
    # How many indexes are in the files array
        CountArray_OutputMessage $filesArray;
    # What is listed within the array
        DisplayArrayContents $filesArray;
    # Draw the declared files in a table
        DisplayArrayContents_TableFormat $filesArray $searchDirPath;
    # Check for potential errors; check if the files exists in the host filesystem.
        if (CheckTargetStatus_ReportErrorSignal $filesArray $searchDirPath -eq True)
        {
            Write-Error "Error occured:  Missing files";
            return 1;
        }
    # Fetch scripts content
        $cachedData += CacheScriptsHostMemory $filesArray $searchDirPath;
    # Terminate the script
        return 0;
    # ----
}



# ========================================================================
# ========================================================================
# HostWorkingDirectory
# ----------------------------
# Parameters:
#     mode <bool>
# ----------------------------
# Brief:
#     Changes the host's working directory depending on the $mode parameter
#       1 = Update the host's working directory to match with the root
#               of the script file itself.
#       0 = Restore the host's working directory to its pervious state.
# ========================================================================
function HostWorkingDirectory([bool] $mode)
{
    if ($mode -eq 1)
    {
        # Move WD to script root dir
        Push-Location -LiteralPath "$PSScriptRoot";
    }
    else
    {
        # Restore the WD to previous state
        Pop-Location;
    }
}



# ========================================================================
# ========================================================================
# DisplayCompilingMessage
# ----------------------------
# Parameters:
#     Project Name <string>
# ----------------------------
# Brief:
#     Tells the user that the program is executing.
# ========================================================================
function DisplayCompilingMessage([string]$project)
{
    Write-Host "Compiling $project's compiler"
        "Please wait..."
        "";
}



# ========================================================================
# ========================================================================
# ClearTerminalBuffer
# ----------------------------
# Parameters:
# ----------------------------
# Brief:
#     Clears the buffer on the terminal window.
# ========================================================================
function ClearTerminalBuffer()
{
    Clear-Host;
}



# ========================================================================
# ========================================================================
# CountArray
# ----------------------------
# Parameters:
#     Array <string>
# ----------------------------
# Output:
#     Count <int>
# ----------------------------
# Brief:
#     Count how many elements are being used in the array
# ========================================================================
function CountArray([string[]] $array)
{
    return $array.Length;
}



# ========================================================================
# ========================================================================
# CountArray_OutputMessage
# ----------------------------
# Parameters:
#     Array <string>
# ----------------------------
# Brief:
#     Prints how many indexes are in the array
# ========================================================================
function CountArray_OutputMessage([string[]] $array)
{
    Write-Host "Number of files declared: $(CountArray $array)";
}



# ========================================================================
# ========================================================================
# DisplayArrayContents
# ----------------------------
# Parameters:
#     Array <string>
# ----------------------------
# Brief:
#     Prints all the contents within the array
# ========================================================================
function DisplayArrayContents([string[]] $array)
{
    Write-Host "List of files declared:" "$array";
}



# ========================================================================
# ========================================================================
# DisplayArrayContents_TableFormat
# ----------------------------
# Parameters:
#     Array <string>
#     Search Path <string>
# ----------------------------
# Brief:
#     Draws a table that displays the file names of the scripts with the
#      respected index address.
# ========================================================================
function DisplayArrayContents_TableFormat([string[]] $array, [string] $searchPath)
{
    # Create a new temporary table
        [string] $drawTable_ParentName = "Array Declared Contents";
        [Data.DataTable] $drawTable = New-Object system.Data.DataTable "$drawTable_ParentName";
    
    # Create the necessary columns
        [Data.DataColumn] $column_1 = New-Object system.Data.DataColumn Index, ([int]);
        [Data.DataColumn] $column_2 = New-Object system.Data.DataColumn FileName, ([string]);
        [Data.DataColumn] $column_3 = New-Object System.Data.DataColumn Status, ([string]);
        $drawTable.Columns.add($column_1); # Add the column to the table object
        $drawTable.Columns.add($column_2); # Add the column to the table object
        $drawTable.Columns.add($column_3); # Add the column to the table object

    # Create the rows as needed
        for ([int] $i = 0; $i -lt $array.Length; $i++)
        {
            # Create a new instance of this scopped variable
                $rowScopped = $drawTable.NewRow();

            # Index
                $rowScopped.Index = $i;

            # File Name
                $rowScopped.FileName = $array[$i];

            # Check file status
                $rowScopped.Status = CheckTargetStatus $searchPath $array[$i];

            # Push to the table
                $drawTable.Rows.Add($rowScopped);

            # Flush the variable
                Clear-Variable -Name rowScopped;
        }

    # Draw the table onto the terminal host
        $drawTable | Format-Table -AutoSize;
}



# ========================================================================
# ========================================================================
# CheckTargetStatus_ReportErrorSignal
# ----------------------------
# Parameters:
#     array <string>
#     searchPath <string>
# ----------------------------
# Output:
#     Status <bool>
# ----------------------------
# Brief:
#     Checks if the target exists within the filesystem, but will return a
#      a value depending if all of the files were found.
#        True = Error was detected; a file didn't exist within the filesystem
#        False = No error was detected.
# ========================================================================
function CheckTargetStatus_ReportErrorSignal([string[]] $array, [string] $searchPath)
{
    for ([int] $i = 0; $i -lt $array.Length; $i++)
    {
        # Does the file exist within the given path?
        if (!(CheckTargetStatus $searchPath $array[$i]))
        {
            # Doesn't exist
            return $True;
        }
    }

    # No errors
    return $False;
}



# ========================================================================
# ========================================================================
# CheckTargetStatus
# ----------------------------
# Parameters:
#     target Directory <string>
#     target File <string>
# ----------------------------
# Output:
#     Status <bool>
# ----------------------------
# Brief:
#     Checks if the target exists within the filesystem.
# ========================================================================
function CheckTargetStatus([string] $targetDir, [string] $targetFile)
{
    return Test-Path "$targetDir$targetFile";
}



# ========================================================================
# ========================================================================
# CacheScriptsHostMemory
# ----------------------------
# Parameters:
#     Files Array <string>
#     Search Directory <string>
# ----------------------------
# Brief:
#     Fetches all of the scripts and caches them in the system memory
# ========================================================================
function CacheScriptsHostMemory([string[]] $files, [string] $source)
{
    # This will store the data from the ascii files.
    [string[]] $cachedData = @();


    # Fill the array
    for([int] $i = 0; $i -le $files.Length; $i++)
    {
        #$cachedData += Get-Content "$source$files[$i]";
        Write-Output "$source$files[$i]";
        Write-Output "$source";
        Write-Output "$files[$i]";
    }


    # Return the array to the caller
    return $cachedData;
}



# ========================================================================
# ========================================================================
# GenerateScript
# ----------------------------
# Parameters:
#     Array <string>
#     Output <string>
# ----------------------------
# Brief:
#     Output the cached data into one script file.
# ========================================================================
function GenerateScript([string[]] $array, [string] $output)
{
    for ([int] $i = 0; $i -le $array.Length; $i++)
    {
        Add-Content "$output" "$array[$i]";
    }

    return 0;
}



# -------------------------------------------------------------------------
# Once all the functions within this script have been defined; execute Main
Main;
# Retrive the exit\return code from Main
[int] $exitCode = $LASTEXITCODE;
# Restore the host's previous WD
HostWorkingDirectory 0;
# Stop the process
Exit $exitCode;