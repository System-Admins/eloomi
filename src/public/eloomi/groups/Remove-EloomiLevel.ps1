function Remove-EloomiLevel
{
    <#
    .SYNOPSIS
        Remove a existing Eloomi level.
    .DESCRIPTION
        Remove a level in Eloomi using the API.
    .EXAMPLE
        Remove-EloomiLevel -ApiKey "<secret>" -Id 1;
    #>
    [cmdletbinding()]
    [OutputType([object])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = (Get-EloomiApiKey),

        # Elooomi group ID.
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [int]$Id
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Removing Eloomi level';

        # API URI.
        $uri = 'https://api.eloomi.io/public/v1/user-groups/levels/{0}' -f $Id;

        # Parameters.
        $paramSplatting = @{
            'ApiKey' = $ApiKey;
            'Uri'    = $uri;
            'Method' = 'DELETE';
        };
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Message ('Trying to remove Eloomi level with ID {0}' -f $Id) -Level 'Verbose';

        # Invoke Eloomi API.
        $response = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Successfully removed Eloomi level with ID {0}' -f $Id) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $response;
    }
}