#               MORGENSTERN COMPILER
# A continuation of the TGRDM3 (codename: Morgenstern) project
# ----------------
# Created by: Nicholas "Tiger" Gautier
# Contact: Nicholas.Gautier.Tiger@GMail.com
# Website: https://github.com/SibTiger/
# Details: This software is designed to compile the assets within Morgenstern project into ZDoom's archive standards, which from there is usable in ZDoom based engines and editors like GZDoom Builder.
# prerequisites:
#      Powershell Version 4.0; at-least that is the version I am using to code in, but past versions may work?
#         For Microsoft Windows 7 users ONLY: http://www.microsoft.com/en-us/download/details.aspx?id=40855
#         Microsoft Windows 8 and later, already comes with Powershell 4.0.
#      7Zip version 9.20
#         Download: http://www.7-zip.org/
# License: Don't Be a Dick (version 1, 2009 December) [ http://www.dbad-license.org/ ]
# ====================================================================
# ====================================================================




# Goals for the Compiler:
# ----
# This shell script is designed to compile the Morgenstern project.  The project's assets is organized in the standard SVN\Version Control environment hierarchy, but in order for it to be used in
#    (G)ZDoom engine and GZDoom Builder, it /MUST/ be generated in the ZDoom archive data file hierarchy standard as defined here [ http://zdoom.org/wiki/Using_ZIPs_as_WAD_replacement ].
# Adjacent to the TGRDM3's compiler, this program can generate the following:
#     1) Standard Build
#     2) Essential Assets [used with GZDoom Builder or some other (G)ZDoom level editor]
# ----------------


# Powershell V. Batch
# ----
# For those that might know (or not), I have been programming in Windows Command Shell for several years now.  With Microsoft's new shell, Powershell, I'd figured I would go ahead and
#   migrate over to the newer environment that might make my life easier and possibly use newer functionality that is not possible to do in Windows Command shell [citation needed].
# ----------------


# HELP ME!
# ----
#   If the script does not execute and receive the following message:  Compiler.ps1 cannot be loaded because the execution of scripts is disabled on this system.  Please see "get-help about_signing" for more details.
#      Please see this article: https://technet.microsoft.com/en-us/library/ee176961.aspx
#                           OR: https://www.cogmotive.com/blog/powershell/allowing-powershell-scripts-to-execute
# ----------------


# ====================================================================
# ====================================================================
# ====================================================================