function Get-EloomiGroupMember
{
    <#
    .SYNOPSIS
        Get Eloomi group(s) member.
    .DESCRIPTION
        Get all Eloomi group(s) members.
    .EXAMPLE
        Get-EloomiGroupMember -ApiKey "<secret>";
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
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Get Eloomi group members';

        # API URI.
        [string]$uri = 'https://api.eloomi.io/public/v1/user-groups/members';

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
        $groupMembers = Invoke-EloomiApi @paramSplatting;
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $groupMembers;
    }
}