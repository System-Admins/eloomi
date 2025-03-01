function Get-EloomiCustomField
{
    <#
    .SYNOPSIS
        Get Eloomi custom fields.
    .DESCRIPTION
        Get custom fields for Eloomi users.
    .EXAMPLE
        Get-EloomiCustomField -ApiKey "<secret>";
    #>
    [cmdletbinding()]
    [OutputType([array])]
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
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Get Eloomi custom fields';

        # API URI.
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
        $customFields = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Found {0} custom field(s)' -f $customFields.Count) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $customFields;
    }
}