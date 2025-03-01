function Set-EloomiGroupMember
{
    <#
    .SYNOPSIS
        Set Eloomi group(s) member.
    .DESCRIPTION
        Set aEloomi group member.
    .EXAMPLE
        Set-EloomiGroupMember -ApiKey "<secret>" -GroupId 1 -UserId 1;
    #>
    [cmdletbinding()]
    [OutputType([array])]
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

        # Elooomi user ID.
        [Parameter(Mandatory = $true, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [int]$UserId
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Adding Eloomi group member';

        # API URI.
        [string]$uri = 'https://api.eloomi.io/public/v1/user-groups/members';

        # Parameters.
        $paramSplatting = @{
            'ApiKey' = $ApiKey;
            'Uri'    = $uri;
            'Method' = 'POST';
        };

        # Create body.
        $body = @{
            'user_group_id' = $GroupId;
            'user_id'      = $UserId;
        };

        # Add body to parameters.
        $paramSplatting.Add('Body', $body);
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Message ('Trying to add Eloomi user ID {0} to group with ID {1}' -f $UserId, $GroupId) -Level 'Verbose';

        # Invoke Eloomi API.
        $response = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Successfully added Eloomi user ID {0} to group with ID {1}' -f $UserId, $GroupId) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $response;
    }
}