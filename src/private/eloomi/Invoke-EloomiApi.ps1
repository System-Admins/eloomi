function Invoke-EloomiApi
{
    <#
    .SYNOPSIS
        Invokes Eloomi API.
    .DESCRIPTION
        Wrapper function to invoke Eloomi API.
    .PARAMETER ApiKey
        API Key.
    .PARAMETER Uri
        URI.
    .PARAMETER Query
        Query.
    .PARAMETER PageSize
        Page size (only for GET method).
    .PARAMETER MaxRetries
        Throttle retries.
    .PARAMETER Body
        Body.
    .PARAMETER Method
        Method.
    .EXAMPLE
        Invoke-EloomiApi -ApiKey "secret" -Uri "https://api.eloomi.io/public/v1/users" -Method 'GET';
    #>
    [cmdletbinding()]
    [OutputType([array])]
    param
    (
        # API Key.
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey,

        # URI.
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Uri,

        # Query.
        [Parameter(Mandatory = $false, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Query,

        # Page size (only for GET method).
        [Parameter(Mandatory = $false, Position = 3, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 1000)]
        [int]$PageSize = 25,

        # Throttle retries.
        [Parameter(Mandatory = $false, Position = 4, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 1000)]
        [int]$MaxRetries = 5,

        # Body.
        [Parameter(Mandatory = $false, Position = 5, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$Body,

        # Method.
        [Parameter(Mandatory = $true, Position = 6, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('GET', 'POST', 'PATCH', 'DELETE')]
        [string]$Method
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Invoking Eloomi API';

        # Create header.
        $header = @{
            'Content-Type' = 'application/json';
            'apiKey'       = $ApiKey;
        };

        # Array list to store result.
        $results = @();
    }
    PROCESS
    {
        # If method is GET.
        if ($Method -eq 'GET')
        {
            # Write to log.
            Write-CustomLog -Message ("Invoking Eloomi API (GET) for URI '{0}'" -f $Uri) -Level 'Verbose';

            # Current page.
            [int]$currentPage = 1;

            # Current try.
            [int]$currentTry = 1;

            # Last page.
            [int]$lastPage = 1;

            # Do while we have not reached the last page.
            do
            {
                # If last page is set.
                if (-not [string]::IsNullOrEmpty($content.last_page))
                {
                    # Write to log.
                    Write-CustomLog -Message ('Current page {0} out of {1}' -f $currentPage, $content.last_page) -Level 'Verbose';
                }

                # Construct URI.
                $invokeUri = ('{0}?page={1}&pageSize={2}' -f $Uri, $currentPage, $PageSize);

                # If query is set.
                if (-not [string]::IsNullOrEmpty($Query))
                {
                    # Add query to URI.
                    $invokeUri = ('{0}&{1}' -f $invokeUri, $Query);
                }

                # Try to invoke Eloomi API.
                try
                {
                    # Invoke Eloomi API.
                    $response = Invoke-WebRequest -Uri $invokeUri -Headers $header -Method Get -ContentType 'application/json' -ErrorAction Stop;
                }
                # Something went wrong.
                catch
                {
                    # Get exception message.
                    $exceptionMessage = $_.Exception.Message;

                    # Get error details.
                    $errorDetailMessage = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue;

                    # Throw exception.
                    throw ("Failed to invoke Eloomi API, execption is`r`n{0}`r`n{1}" -f $exceptionMessage, $errorDetailMessage);
                }

                # Test if we are being throttled.
                $isThrottled = Test-EloomiRateLimit -InputObject $response.StatusCode;

                # If we are being throttled.
                if ($isThrottled -and $currentTry -lt $MaxRetries)
                {
                    # Increment current try.
                    $currentTry++;

                    # Continue to next iteration (retry).
                    continue;
                }
                # Else if we are being throttled and we have reached the maximum retries.
                elseif ($isThrottled -and $currentTry -ge $MaxRetries)
                {
                    # Throw exception.
                    throw ('Failed to invoke Eloomi API, maximum retries reached');
                }

                # Write to log.
                Write-CustomLog -Message ("Status code from Eloomi was '{0}'" -f $response.StatusCode) -Level 'Verbose';

                # If status code is 200-299.
                if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
                {
                    # Parse content.
                    $content = $response.Content | ConvertFrom-Json;

                    # If last page is not set.
                    if (-not [string]::IsNullOrEmpty($content.last_page))
                    {
                        # Try to convert last page to integer.
                        try
                        {
                            # Set last page.
                            [int]$lastPage = $content.last_page;
                        }
                        # Manually set last page.
                        catch
                        {
                            # Set last page.
                            [int]$lastPage = 1;
                        }
                    }

                    # If content is not empty.
                    if (-not [string]::IsNullOrEmpty($content))
                    {
                        # Get content property.
                        $contentProperty = $content | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name;

                        # If data is not empty.
                        if ('data' -in $contentProperty)
                        {
                            # Add content to array.
                            $results += $content.data;
                        }
                        # Else use content.
                        else
                        {
                            # Add content to array.
                            $results += $content;
                        }
                    }

                    # Increment current page.
                    $currentPage++;

                    # Write to log.
                    Write-CustomLog -Message ('Successfully invoked Eloomi API') -Level 'Verbose';
                }
            }
            while ($currentPage -le $lastPage);
        }
        # Else if method is POST.
        elseif ($Method -eq 'POST')
        {
            # Write to log.
            Write-CustomLog -Message ("Invoking Eloomi API (POST) for URI '{0}'" -f $Uri) -Level 'Verbose';

            # Current try.
            [int]$currentTry = 1;

            # Do while we are being throttled.
            do
            {
                # Write to log.
                Write-CustomLog -Message ('Body:') -Level 'Verbose';
                Write-CustomLog -Message ($Body | ConvertTo-Json) -Level 'Verbose';

                # Try
                try
                {
                    # Invoke Eloomi API.
                    $response = Invoke-WebRequest -Uri $Uri -Headers $header -Method Post -ContentType 'application/json' -Body ($Body | ConvertTo-Json) -ErrorAction Stop;
                }
                catch
                {
                    # If HTTP status code is not 429.
                    if ($_.Exception.Response.StatusCode -ne 429)
                    {
                        # Get exception message.
                        $exceptionMessage = $_.Exception.Message;

                        # Get error details.
                        $errorDetailMessage = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue;

                        # Throw exception.
                        throw ('{0} -> {1}' -f $exceptionMessage, $errorDetailMessage.detail);
                    }
                }

                # Test if we are being throttled.
                $isThrottled = Test-EloomiRateLimit -InputObject $response.StatusCode;

                # If we are being throttled.
                if ($true -eq $isThrottled)
                {
                    # Increment current try.
                    $currentTry++;
                }
            }
            # While we are being throttled and we have not reached the maximum retries.
            while ($true -eq $isThrottled -and $currentTry -lt $MaxRetries);

            # Write to log.
            Write-CustomLog -Message ("Status code from Eloomi was '{0}'" -f $response.StatusCode) -Level 'Verbose';

            # Parse content.
            $content = $response.Content | ConvertFrom-Json;

            # If status code is 200-299.
            if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
            {
                # Add content to array.
                $results += $content;

                # Write to log.
                Write-CustomLog -Message ('Successfully invoked Eloomi API') -Level 'Verbose';
            }
        }
        # Else if method is PATCH.
        elseif ($Method -eq 'PATCH')
        {
            # Write to log.
            Write-CustomLog -Message ("Invoking Eloomi API (PATCH) for URI '{0}'" -f $Uri) -Level 'Verbose';

            # Current try.
            [int]$currentTry = 1;

            # Do while we are being throttled.
            do
            {
                # Write to log.
                Write-CustomLog -Message ('Body:') -Level 'Verbose';
                Write-CustomLog -Message ($Body | ConvertTo-Json) -Level 'Verbose';

                # Try
                try
                {
                    # Invoke Eloomi API.
                    $response = Invoke-WebRequest -Uri $Uri -Headers $header -Method Patch -ContentType 'application/json' -Body ($Body | ConvertTo-Json) -ErrorAction Stop;
                }
                catch
                {
                    # If HTTP status code is not 429.
                    if ($_.Exception.Response.StatusCode -ne 429)
                    {
                        # Get exception message.
                        $exceptionMessage = $_.Exception.Message;

                        # Get error details.
                        $errorDetailMessage = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue;

                        # Throw exception.
                        throw ("{0}`r`n{1}" -f $exceptionMessage, $errorDetailMessage.detail);
                    }
                }

                # Test if we are being throttled.
                $isThrottled = Test-EloomiRateLimit -InputObject $response.StatusCode;

                # If we are being throttled.
                if ($true -eq $isThrottled)
                {
                    # Increment current try.
                    $currentTry++;
                }
            }
            # While we are being throttled and we have not reached the maximum retries.
            while ($true -eq $isThrottled -and $currentTry -lt $MaxRetries);

            # Write to log.
            Write-CustomLog -Message ("Status code from Eloomi was '{0}'" -f $response.StatusCode) -Level 'Verbose';

            # Parse content.
            $content = $response.Content | ConvertFrom-Json;

            # If status code is 200-299.
            if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
            {
                # Add content to array.
                $results += $content;

                # Write to log.
                Write-CustomLog -Message ('Successfully invoked Eloomi API') -Level 'Verbose';
            }
        }
        # Else if method is DELETE.
        elseif ($Method -eq 'DELETE')
        {
            # Write to log.
            Write-CustomLog -Message ("Invoking Eloomi API (DELETE) for URI '{0}'" -f $Uri) -Level 'Verbose';

            # Current try.
            [int]$currentTry = 1;

            # Do while we are being throttled.
            do
            {
                # Try
                try
                {
                    # Invoke Eloomi API.
                    $response = Invoke-WebRequest -Uri $Uri -Headers $header -Method Delete -ContentType 'application/json' -ErrorAction Stop;
                }
                catch
                {
                    # If HTTP status code is not 429.
                    if ($_.Exception.Response.StatusCode -ne 429)
                    {
                        # Get exception message.
                        $exceptionMessage = $_.Exception.Message;

                        # Get error details.
                        $errorDetailMessage = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue;

                        # Throw exception.
                        throw ("{0}`r`n{1}" -f $exceptionMessage, $errorDetailMessage.detail);
                    }
                }

                # Test if we are being throttled.
                $isThrottled = Test-EloomiRateLimit -InputObject $response.StatusCode;

                # If we are being throttled.
                if ($true -eq $isThrottled)
                {
                    # Increment current try.
                    $currentTry++;
                }
            }
            # While we are being throttled and we have not reached the maximum retries.
            while ($true -eq $isThrottled -and $currentTry -lt $MaxRetries);

            # Write to log.
            Write-CustomLog -Message ("Status code from Eloomi was '{0}'" -f $response.StatusCode) -Level 'Verbose';

            # Parse content.
            $content = $response.Content | ConvertFrom-Json;

            # If status code is 200-299.
            if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
            {
                # Add content to array.
                $results += $content;

                # Write to log.
                Write-CustomLog -Message ('Successfully invoked Eloomi API') -Level 'Verbose';
            }
        }
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $results;
    }
}