function Remove-EloomiGroupManager
{
    <#
    .SYNOPSIS
        Remove a existing Eloomi group manager.
    .DESCRIPTION
        Remove a group maanger in Eloomi using the API.
    .EXAMPLE
        Remove-EloomiGroup -ApiKey "<secret>" -GroupId 1 -ManagerId 1;
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
        [int]$GroupId,

        # Elooomi manager ID.
        [Parameter(Mandatory = $true, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [int]$ManagerId
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Removing Eloomi group manager';

        # API URI.
        $uri = 'https://api.eloomi.io/public/v1/user-groups/managers/{0}' -f $ManagerId;

        # Parameters.
        $paramSplatting = @{
            'ApiKey' = $ApiKey;
            'Uri'    = $uri;
            'Method' = 'DELETE';
        };

        # Create body.
        $body = @{
            'id' = $GroupId;
        };

        # Add body to parameters.
        $paramSplatting.Add('Body', $body);
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Message ('Trying to remove Eloomi manager ID {0} from group with ID {1} as manager' -f $ManagerId, $GroupId) -Level 'Verbose';

        # Invoke Eloomi API.
        $response = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Successfully removed Eloomi manager ID {0} from group with ID {1} as manager' -f $ManagerId, $GroupId) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $response;
    }
}