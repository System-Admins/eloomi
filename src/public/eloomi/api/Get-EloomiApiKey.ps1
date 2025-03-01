function Get-EloomiApiKey
{
    <#
    .SYNOPSIS
        Get Eloomi API key.
    .DESCRIPTION
        Get the Eloomi API from variable.
    .EXAMPLE
        Get-EloomiApiKey;
    #>
    [cmdletbinding()]
    [OutputType([string])]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Get Eloomi API key';

        # API key variable.
        [string]$ApiKey = "";
    }
    PROCESS
    {
        # If API key is not set.
        if ([string]::IsNullOrEmpty($script:ModuleEloomiApiKey))
        {
            # Write to log.
            Write-CustomLog -Message "Use the cmdlet 'Set-EloomiApiKey -ApiKey <secret>'" -Level 'Warning';

            # Throw error.
            throw 'API key is not set.';
        }
        # Else.
        else
        {
            # Get API key.
            $ApiKey = $script:ModuleEloomiApiKey;
        }
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $ApiKey;
    }
}