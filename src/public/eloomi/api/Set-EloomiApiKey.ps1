function Set-EloomiApiKey
{
    <#
    .SYNOPSIS
        Set Eloomi API key.
    .DESCRIPTION
        Set the Eloomi API globally.
    .EXAMPLE
        Set-EloomiApiKey -ApiKey "<secret>";
    #>
    [cmdletbinding()]
    [OutputType([void])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = (Get-EloomiApiKey)
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Set Eloomi API key';
    }
    PROCESS
    {
        # Set API key.
        $script:ModuleEloomiApiKey = $ApiKey;
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;
    }
}