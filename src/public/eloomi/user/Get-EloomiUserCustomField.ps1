function Get-EloomiUserCustomField
{
    <#
    .SYNOPSIS
        Get Eloomi users custom fields.
    .DESCRIPTION
        Get custom fields for Eloomi users.
    .EXAMPLE
        Get-EloomiUserCustomField -ApiKey "<guid>";
    #>
    [cmdletbinding()]
    [OutputType([array])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Get Eloomi users custom fields';

        # Create URI.
        [string]$uri = 'https://api.eloomi.io/public/v1/users/custom-fields';

        # Parameters.
        $paramSplatting = @{
            'ApiKey' = $ApiKey;
            'Uri'    = $uri;
            'Method' = 'GET';
        };
    }
    PROCESS
    {
        # Invoke Eloomi API.
        $users = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Found {0} custom field(s)' -f $users.Count) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $users;
    }
}