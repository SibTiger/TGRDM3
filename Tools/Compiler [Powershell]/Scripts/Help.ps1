<#

.SYNOPSIS
    Compiles the Morgenstern project.

.DESCRIPTION
    Builds the Morgenstern project by taking the assets from the Local Working Copy and manipulates the contents within a temporary directory.  Within the temporary directory, will be adjusted to comply with ZDoom's Archive Standards [ http://zdoom.org/wiki/Using_ZIPs_as_WAD_replacement ].
    This software will allow the user to generate the following builds: Standard build, Editing Build (for use with GZDoom Builder)

    Using Editing Build:
        Most assets will be included - EXCEPT for the textures.  In GZDoom Builder, include the texture directory in the load sequence.
    
    Using Standard Build:
        Out-of-the-Box experience; just run it with GZDoom with the correct IWAD.

    
    This program will require 7Zip [ http://www.7-zip.org/ ]


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