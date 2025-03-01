function Remove-EloomiApiKey
{
    <#
    .SYNOPSIS
        Remove Eloomi API key from memory.
    .DESCRIPTION
        Remove the Eloomi API.
    .EXAMPLE
        Remove-EloomiApiKey;
    #>
    [cmdletbinding()]
    [OutputType([void])]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Remove Eloomi API key';
    }
    PROCESS
    {
        # Set API key.
        $script:ModuleEloomiApiKey = "";
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;
    }
}