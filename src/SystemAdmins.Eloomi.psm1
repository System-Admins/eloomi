# Variable for script path.
[string]$scriptPath = '';

# Use PSScriptRoot.
$scriptPath = Split-Path -Path $PSCommandPath -Parent;

# Write to log.
Write-Verbose -Message ("PowerShell module is located at '{0}'" -f $scriptPath);

# Set script variable.
$Script:scriptPath = $scriptPath;

# Paths to the private and public folders.
[string]$privatePath = Join-Path -Path $scriptPath -ChildPath 'private';
[string]$publicPath = Join-Path -Path $scriptPath -ChildPath 'public';

# Object array to store all PowerShell files to dot source.
$ps1Files = New-Object -TypeName System.Collections.ArrayList;

# Get all the files in the src (private and public) folder.
$privatePs1Files = Get-ChildItem -Path $privatePath -Recurse -File -Filter *.ps1;
$publicPs1Files = Get-ChildItem -Path $publicPath -Recurse -File -Filter *.ps1;

# Add the private and public files to the object array.
$ps1Files += ($privatePs1Files).FullName;
$ps1Files += ($publicPs1Files).FullName;

# Write to log.
Write-Verbose -Message ("Found {0} PowerShell files to dot source" -f $ps1Files.Count);

# Loop through each PowerShell file.
foreach ($ps1File in $ps1Files)
{
    # If line is empty.
    if ([string]::IsNullOrEmpty($ps1File))
    {
        # Skip to next line.
        continue;
    }

    # Try to dot source the file.
    try
    {
        # Write to log.
        Write-Verbose -Message ("Dot sourcing the PowerShell file '{0}'" -f $ps1File);

        # Dot source the file.
        . $ps1File;
    }
    catch
    {
        # Throw execption.
        throw ("Something went wrong while importing the PowerShell file '{0}', the execption is:`r`n{1}" -f $ps1File, $_);
    }
}

# Get all the functions in the public section.
$publicFunctions = $publicPs1Files.Basename;

# Global variables.
## Module.
[string]$script:ModuleName = 'SystemAdmins.Eloomi';
[string]$script:ModuleEloomiApiKey = '';

## Logging.
[string]$script:ModuleTempFolderPath = ('{0}\{1}' -f ([System.IO.Path]::GetTempPath()), $script:ModuleName);
[string]$script:ModuleLogFolder = ('{0}\Log' -f $script:ModuleTempFolderPath);
[string]$script:ModuleLogFileName = ('{0}_Eloomi.log' -f (Get-Date -Format 'yyyyMMddHHmmss'));
[string]$script:ModuleLogPath = Join-Path -Path $ModuleLogFolder -ChildPath $ModuleLogFileName;

# Foreach function in the public functions.
foreach ($exportFunction in $publicFunctions)
{
    # Write to log.
    Write-Verbose -Message ("Exporting the function '{0}'" -f $exportFunction);
}

# Export functions.
Export-ModuleMember -Function $publicFunctions;