function ConvertTo-EnglishString
{
    <#
    .SYNOPSIS
        Convert string into normalized letters.
    .DESCRIPTION
        Use text normalization to convert string into safe English characters.
    .EXAMPLE
        ConvertTo-EnglishString;
    #>
    [cmdletbinding()]
    [OutputType([string])]
    param
    (
        # String to convert.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InputString
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Converting string to English characters';

        # Initialize variable.
        [string]$normalized = '';
    }
    PROCESS
    {
        # Convert to normalized.
        $normalized = $InputString.Normalize([Text.NormalizationForm]::FormD);

        # Remove unsafe characters.
        $normalized = ($normalized -replace '\p{M}', '');

        # Just to be safe.
        $normalized = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding('Cyrillic').GetBytes($normalized));
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $normalized;
    }
}