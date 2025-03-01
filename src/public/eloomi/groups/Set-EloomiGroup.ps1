function Set-EloomiGroup
{
    <#
    .SYNOPSIS
        Update a existing Eloomi group.
    .DESCRIPTION
        Update a group in Eloomi using the API.
    .EXAMPLE
        Set-Eloomigroup -ApiKey "<secret>" -Id 1 -Email "abc@contoso.com" -FirstName "John" -LastName "Doe";
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
        [int]$Id,

        # Name.
        [Parameter(Mandatory = $false, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 64)]
        [string]$Name,

        # Short name.
        [Parameter(Mandatory = $false, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 3)]
        [string]$ShortName,

        # Description.
        [Parameter(Mandatory = $false, Position = 3, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 512)]
        [string]$Description,

        # Color.
        [Parameter(Mandatory = $false, Position = 4, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$')]
        [string]$Color,

        # Parent ID.
        [Parameter(Mandatory = $false, Position = 5, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [Nullable[System.Int32]]$ParentId,

        # Level ID.
        [Parameter(Mandatory = $false, Position = 6, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [int]$LevelId,

        # Type.
        [Parameter(Mandatory = $false, Position = 7, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('standard', 'hierarchy')]
        [string]$Type
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Updating Eloomi group';

        # One or more parameters are required.
        if (-not $PSBoundParameters.ContainsKey('Name') -and -not $PSBoundParameters.ContainsKey('ShortName') -and -not $PSBoundParameters.ContainsKey('Description') -and -not $PSBoundParameters.ContainsKey('Color') -and -not $PSBoundParameters.ContainsKey('ParentId') -and -not $PSBoundParameters.ContainsKey('LevelId') -and -not $PSBoundParameters.ContainsKey('Type'))
        {
            # Throw error.
            throw 'One or more parameters are required';
        }

        # API URI.
        $uri = 'https://api.eloomi.io/public/v1/user-groups/{0}' -f $Id;

        # Parameters.
        $paramSplatting = @{
            'ApiKey' = $ApiKey;
            'Uri'    = $uri;
            'Method' = 'PATCH';
        };

        # Create body.
        $body = @{
        };

        # If name is set.
        if (-not [string]::IsNullOrEmpty($Name))
        {
            # Add property to body.
            $body.Add('name', $Name);
        }

        # If short name is set.
        if (-not [string]::IsNullOrEmpty($ShortName))
        {
            # Add property to body.
            $body.Add('short_name', $ShortName);
        }

        # If description is set.
        if (-not [string]::IsNullOrEmpty($Description))
        {
            # Add property to body.
            $body.Add('description', $Description);
        }

        # If color is set.
        if (-not [string]::IsNullOrEmpty($Color))
        {
            # Add property to body.
            $body.Add('color', $Color);
        }

        # If parent ID is set.
        if ($ParentId -ne 0)
        {
            # Add property to body.
            $body.Add('parent_id', $ParentId);
        }

        # If level ID is set.
        if ($LevelId -ne 0)
        {
            # Add property to body.
            $body.Add('level_id', $LevelId);
        }

        # If color is set.
        if (-not [string]::IsNullOrEmpty($Type))
        {
            # Add type to body.
            $body.Add('type', $Type.ToLower());
        }

        # Add body to parameters.
        $paramSplatting.Add('Body', $body);
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Message ('Trying to update Eloomi group with ID {0}' -f $Id) -Level 'Verbose';

        # Invoke Eloomi API.
        $response = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Successfully updated Eloomi group with ID {0}' -f $Id) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $response;
    }
}