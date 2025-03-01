function Remove-EloomiUser
{
    <#
    .SYNOPSIS
        Remove a existing Eloomi user.
    .DESCRIPTION
        Remove a user in Eloomi using the API.
    .EXAMPLE
        Remove-EloomiUser -ApiKey "<secret>" -UserId 1;
    #>
    [cmdletbinding()]
    [OutputType([object])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = (Get-EloomiApiKey),

        # Elooomi user ID.
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [int]$Id
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Removing Eloomi user';

        # API URI.
        $uri = 'https://api.eloomi.io/public/v1/users/{0}' -f $Id;

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
        Write-CustomLog -Message ('Trying to remove Eloomi user with ID {0}' -f $Id) -Level 'Verbose';

        # Invoke Eloomi API.
        $response = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Successfully removed Eloomi user with ID {0}' -f $Id) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $response;
    }
}