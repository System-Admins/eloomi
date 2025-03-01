function New-EloomiGroup
{
    <#
    .SYNOPSIS
        Create a new Eloomi group.
    .DESCRIPTION
        Create a group in Eloomi using the API.
    .EXAMPLE
        New-EloomiGroup -ApiKey '<secret>' -Name "MyGroupName" -ShortName "GRP" -Description "My group description" -Color "#FFFFFF" -ParentId 123 -LevelId 123 -Type "Standard";
    #>
    [cmdletbinding()]
    [OutputType([object])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = (Get-EloomiApiKey),

        # Name.
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
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
        [int]$ParentId,

        # Level ID.
        [Parameter(Mandatory = $false, Position = 6, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [int]$LevelId,

        # Type.
        [Parameter(Mandatory = $false, Position = 7, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('standard', 'hierarchy')]
        [string]$Type = 'standard'
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Creating Eloomi group';

        # API URI.
        $uri = 'https://api.eloomi.io/public/v1/user-groups';

        # Parameters.
        $paramSplatting = @{
            'ApiKey' = $ApiKey;
            'Uri'    = $uri;
            'Method' = 'POST';
        };

        # Create body.
        $body = @{
            'name' = $Name;
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

        # Add type to body.
        $body.Add('type', $Type.ToLower());

        # Add body to parameters.
        $paramSplatting.Add('Body', $body);
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Message ('Trying to create Eloomi group with name {0}' -f $Name) -Level 'Verbose';

        # Invoke Eloomi API.
        $response = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Successfully created Eloomi group with name {0}' -f $Name) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $response;
    }
}