function Remove-EloomiGroupMember
{
    <#
    .SYNOPSIS
        Remove a existing Eloomi group member.
    .DESCRIPTION
        Remove a group member in Eloomi using the API.
    .EXAMPLE
        Remove-EloomiGroup -ApiKey "<secret>" -Id 1;
    #>
    [cmdletbinding()]
    [OutputType([object])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = (Get-EloomiApiKey),

        # Elooomi group member ID.
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [int]$Id
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Removing Eloomi group member';

        # API URI.
        $uri = 'https://api.eloomi.io/public/v1/user-groups/members/{0}' -f $Id;

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
        Write-CustomLog -Message ('Trying to remove Eloomi user ID {0} from group with ID {1}' -f $UserId, $GroupId) -Level 'Verbose';

        # Invoke Eloomi API.
        $response = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Successfully removed Eloomi user ID {0} from group with ID {1}' -f $UserId, $GroupId) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $response;
    }
}