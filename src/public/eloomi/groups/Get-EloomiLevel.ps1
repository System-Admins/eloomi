function Get-EloomiLevel
{
    <#
    .SYNOPSIS
        Get Eloomi level(s).
    .DESCRIPTION
        Get all Eloomi level(s) or single using name.
    .EXAMPLE
        Get-EloomiLevel -ApiKey "<secret>" -Name "MyGroupName";
    .EXAMPLE
        Get-EloomiLevel -ApiKey "<secret>";
    #>
    [cmdletbinding()]
    [OutputType([array])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = (Get-EloomiApiKey),

        # Group name.
        [Parameter(Mandatory = $false, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Get Eloomi levels';

        # API URI.
        [string]$uri = 'https://api.eloomi.io/public/v1/user-groups/levels';

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
        # If name is set.
        if (-not [string]::IsNullOrEmpty($Name))
        {
            # Write to log.
            Write-CustomLog -Message ("Filter is set to get user level with name '{0}'" -f $Name) -Level 'Verbose';

            # Add query.
            $query += ('filters=name=={0}' -f $Name);
        }

        # If query is set.
        if (-not [string]::IsNullOrEmpty($query))
        {
            # Add query.
            $paramSplatting.Add('Query', $query);
        }

        # Invoke Eloomi API.
        $levels = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Found {0} group(s)' -f $groups.Count) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $levels;
    }
}