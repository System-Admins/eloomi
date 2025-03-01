function Set-EloomiCustomField
{
    <#
    .SYNOPSIS
        Update a existing Eloomi custom field.
    .DESCRIPTION
        Update a custom field in Eloomi using the API.
    .EXAMPLE
        Set-EloomiCustomField -ApiKey "<secret>" -Id 1 -Name "Testing" -Description "My field description";
    #>
    [cmdletbinding()]
    [OutputType([object])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = (Get-EloomiApiKey),

        # Elooomi custom field ID.
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [int]$Id,

        # Name for the custom field.
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 50)]
        [string]$Name,

        # Description for the custom field.
        [Parameter(Mandatory = $false, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 255)]
        [string]$Description
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Updating Eloomi custom field';

        # One or more parameters are required.
        if (-not $PSBoundParameters.ContainsKey('Name') -and -not $PSBoundParameters.ContainsKey('Description'))
        {
            # Throw error.
            throw 'One or more parameters are required';
        }

        # API URI.
        $uri = 'https://api.eloomi.io/public/v1/users/custom-fields/{0}' -f $Id;

        # Parameters.
        $paramSplatting = @{
            'ApiKey' = $ApiKey;
            'Uri'    = $uri;
            'Method' = 'PATCH';
        };

        # Create body.
        $body = @{};

        # If name is set.
        if (-not [string]::IsNullOrEmpty($Name))
        {
            # Add property to body.
            $body.Add('name', $Name);
        }

        # If description is set.
        if (-not [string]::IsNullOrEmpty($Description))
        {
            # Add property to body.
            $body.Add('description', $Description);
        }

        # Add body to parameters.
        $paramSplatting.Add('Body', $body);
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Message ('Trying to update Eloomi custom field with ID {0}' -f $Id) -Level 'Verbose';

        # Invoke Eloomi API.
        $response = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Successfully updated Eloomi custom field with id {0}' -f $Id) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $response;
    }
}