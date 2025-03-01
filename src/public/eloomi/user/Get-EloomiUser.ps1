function Get-EloomiUser
{
    <#
    .SYNOPSIS
        Get Eloomi user(s).
    .DESCRIPTION
        Get all Eloomi user(s) or single using email.
    .EXAMPLE
        Get-EloomiUser -ApiKey "<secret>" -Email "abc@contoso.com";
    .EXAMPLE
        Get-EloomiUser -ApiKey "<secret>";
    #>
    [cmdletbinding()]
    [OutputType([array])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = (Get-EloomiApiKey),

        # Email address.
        [Parameter(Mandatory = $false, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-EmailAddress -InputObject $_ })]
        [string]$Email
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Get Eloomi users';

        # API URI.
        [string]$uri = 'https://api.eloomi.io/public/v1/users';

        # Parameters.
        $paramSplatting = @{
            'ApiKey' = $ApiKey;
            'Uri'    = $uri;
            'Method' = 'GET';
        };

        # Query.
        [string]$query = '';
    }
    PROCESS
    {
        # If email is set.
        if (-not [string]::IsNullOrEmpty($Email))
        {
            # Write to log.
            Write-CustomLog -Message ("Filter is set to get user with email '{0}'" -f $Email) -Level 'Verbose';

            # Add query.
            $query += ('filters=email=={0}' -f $Email);
        }

        # If query is set.
        if (-not [string]::IsNullOrEmpty($query))
        {
            # Add query.
            $paramSplatting.Add('Query', $query);
        }

        # Invoke Eloomi API.
        $users = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Found {0} user(s)' -f $users.Count) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $users;
    }
}