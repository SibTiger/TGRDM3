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
            [string[]] $filesArray = @("Help", "Header");

            # LOCK THE ARRAY FROM CHANGING DURING EXECUTION
                Set-Variable $filesArray -Option ReadOnly

        # Store the contents of each file into system memory
            [string[]] $cachedData = @();

    # ====
    


    # Clear the buffer
        ClearTerminalBuffer;
    # ----
    # Tell the user that the program is executing
        DisplayCompilingMessage "$projectName";
    # How many indexes are in the files array
        CountArray_OutputMessage $filesArray;
    # What is listed within the array
        DisplayArrayContents $filesArray;
    # Draw the declared files in a table
        DisplayArrayContents_TableFormat $filesArray;
    # Fetch scripts content
        $cachedData += CacheScriptsHostMemory $filesArray $searchDirPath;
    # ----
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
# ----------------------------
# Brief:
#     Draws a table that displays the file names of the scripts with the
#      respected index address.
# ========================================================================
function DisplayArrayContents_TableFormat([string[]] $array)
{
    # Create a new temporary table
        [string] $drawTable_ParentName = "Array Declared Contents";
        [Data.DataTable] $drawTable = New-Object system.Data.DataTable "$drawTable_ParentName";
    
    # Create the necessary columns
        [Data.DataColumn] $column_1 = New-Object system.Data.DataColumn Index, ([int]);
        [Data.DataColumn] $column_2 = New-Object system.Data.DataColumn FileName, ([string]);
        $drawTable.Columns.add($column_1); # Add the column to the table object
        $drawTable.Columns.add($column_2); # Add the column to the table object

    # Create the rows as needed
        for ([int] $i = 0; $i -lt $array.Length; $i++)
        {
            # Create a new instance of this scopped variable
                $rowScopped = $drawTable.NewRow();

            # Index
                $rowScopped.Index = $i;

            # File Name
                $rowScopped.FileName = $array[$i];

            # Push to the table
                $drawTable.Rows.Add($rowScopped);
        }

    # Draw the table onto the terminal host
        $drawTable | Format-Table -AutoSize;
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
Main