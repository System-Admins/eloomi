function Test-EloomiRateLimit
{
    <#
    .SYNOPSIS
        Test if Eloomi API is being throttled.
    .DESCRIPTION
        Test if Eloomi API is being throttled by checking the HTTP status code.
        If the status code is 429, the function will wait 60 seconds before continuing.
    .EXAMPLE
        Test-EloomiRateLimit -InputObject $response;
    #>
    [cmdletbinding()]
    [OutputType([bool])]
    param
    (
        # Input object.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Testing Eloomi rate limiting';

        # Is throttled.
        [bool]$isThrottled = $false;
    }
    PROCESS
    {
        # If we are being throttled.
        if ($InputObject -eq 429)
        {
            # Write to log.
            Write-CustomLog -Message ('API is being throttling, waiting 60 seconds for a reset') -Level 'Verbose';

            # Wait 60 seconds.
            Start-Sleep -Seconds 61;

            # Set throttled to true.
            $isThrottled = $true;
        }
        # Else if we are not being throttled.
        else
        {
            # Write to log.
            Write-CustomLog -Message ('API is not being throttled') -Level 'Verbose';
        }
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $isThrottled;
    }
}