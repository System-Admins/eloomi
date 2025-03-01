function New-EloomiUserCustomField
{
    <#
    .SYNOPSIS
        Create a new Eloomi users custom field.
    .DESCRIPTION
        Create custom field for Eloomi users.
    .EXAMPLE
        New-EloomiUserCustomField -ApiKey "<guid>" -Name "CustomField1" -Description "Custom field 1";
    #>
    [cmdletbinding()]
    [OutputType([array])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey,

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
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Creating new Eloomi users custom field';

        # Create URI.
        [string]$uri = 'https://api.eloomi.io/public/v1/users/custom-fields';

        # Parameters.
        $paramSplatting = @{
            'ApiKey' = $ApiKey;
            'Uri'    = $uri;
            'Method' = 'POST';
        };

        # Create body.
        $body = @{
            'name'        = $Name;
            'description' = $Description;
        };

        # Add body to parameters.
        $paramSplatting.Add('Body', $body);

    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Message ('Trying to create Eloomi user custom field {0}' -f $Name) -Level 'Verbose';

        # Invoke Eloomi API.
        $customfield = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Successfully created Eloomi user custom field {0}' -f $Name) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $customfield;
    }
}