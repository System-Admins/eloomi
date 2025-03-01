function Set-EloomiUser
{
    <#
    .SYNOPSIS
        Update a existing Eloomi user.
    .DESCRIPTION
        Update a user in Eloomi using the API.
    .EXAMPLE
        Set-EloomiUser -ApiKey "<secret>" -Id 1 -Email "abc@contoso.com" -FirstName "John" -LastName "Doe";
    #>
    [cmdletbinding()]
    [OutputType([object])]
    param
    (
        # API Key for Eloomi.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = (Get-EloomiApiKey),

        # Elooomi user ID.
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [int]$Id,

        # Email address.
        [Parameter(Mandatory = $false, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-EmailAddress -InputObject $_ })]
        [ValidateLength(3, 250)]
        [string]$Email,

        # Account ID.
        [Parameter(Mandatory = $false, Position = 3, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(3, 250)]
        [string]$AccountId,

        # First name.
        [Parameter(Mandatory = $false, Position = 4, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 250)]
        [string]$FirstName,

        # Last name.
        [Parameter(Mandatory = $false, Position = 5, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 250)]
        [string]$LastName,

        # Job title.
        [Parameter(Mandatory = $false, Position = 6, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$JobTitle,

        # User role.
        [Parameter(Mandatory = $false, Position = 7, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('User', 'Admin')]
        [string]$UserRole,

        # Active.
        [Parameter(Mandatory = $false, Position = 8, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [bool]$Active,

        # Send email invite.
        [Parameter(Mandatory = $false, Position = 9, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [bool]$SendEmailInvite = $false,

        # Temporary password.
        [Parameter(Mandatory = $false, Position = 10, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [securestring]$TemporaryPassword,

        # Custom fields.
        [Parameter(Mandatory = $false, Position = 11, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$CustomFields,

        # Language.
        [Parameter(Mandatory = $false, Position = 12, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('da-DK', 'de-DE', 'en-GB', 'en-US', 'es-ES', 'fi-FI', 'fr-FR', 'is-IS', 'nl-NL', 'no-NO', 'pt-PT', 'ru-RU', 'sv-SE', 'zh-CN')]
        [string]$Language,

        # Manager ID.
        [Parameter(Mandatory = $false, Position = 13, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 2147483647)]
        [int]$ManagerId
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Updating Eloomi user';

        # One or more parameters are required.
        if (-not $PSBoundParameters.ContainsKey('FirstName') -and -not $PSBoundParameters.ContainsKey('LastName') -and -not $PSBoundParameters.ContainsKey('Email') -and -not $PSBoundParameters.ContainsKey('Active') -and -not $PSBoundParameters.ContainsKey('UserRole') -and -not $PSBoundParameters.ContainsKey('SendEmailInvite') -and -not $PSBoundParameters.ContainsKey('AccountId') -and -not $PSBoundParameters.ContainsKey('JobTitle') -and -not $PSBoundParameters.ContainsKey('TemporaryPassword') -and -not $PSBoundParameters.ContainsKey('CustomFields') -and -not $PSBoundParameters.ContainsKey('Language') -and -not $PSBoundParameters.ContainsKey('ManagerId'))
        {
            # Throw error.
            throw 'One or more parameters are required';
        }

        # API URI.
        $uri = 'https://api.eloomi.io/public/v1/users/{0}' -f $Id;

        # Parameters.
        $paramSplatting = @{
            'ApiKey' = $ApiKey;
            'Uri'    = $uri;
            'Method' = 'PATCH';
        };

        # Create body.
        $body = @{
        };

        # If first name is set.
        if (-not [string]::IsNullOrEmpty($FirstName))
        {
            # Add property to body.
            $body.Add('first_name', $FirstName);
        }

        # If last name is set.
        if (-not [string]::IsNullOrEmpty($LastName))
        {
            # Add property to body.
            $body.Add('last_name', $LastName);
        }

        # If email is set.
        if (-not [string]::IsNullOrEmpty($Email))
        {
            # Add property to body.
            $body.Add('email', $Email);
        }

        # If active is set.
        if ($PSBoundParameters.ContainsKey('Active'))
        {
            # Add property to body.
            $body.Add('active', $Active);
        }

        # If user role is set.
        if (-not [string]::IsNullOrEmpty($UserRole))
        {
            # Add property to body.
            $body.Add('user_role', $UserRole);
        }

        # If send email invite is set.
        if ($true -eq $SendEmailInvite)
        {
            # Add property to body.
            $body.Add('send_email_invite', $SendEmailInvite);
        }

        # If account ID is set.
        if (-not [string]::IsNullOrEmpty($AccountId))
        {
            # Add property to body.
            $body.Add('account_id', $AccountId);
        }

        # If job title is set.
        if (-not [string]::IsNullOrEmpty($JobTitle))
        {
            # Add property to body.
            $body.Add('job_title', $JobTitle);
        }

        # If temporary password is set.
        if (-not [string]::IsNullOrEmpty($TemporaryPassword))
        {
            # Convert secure string to plain text.
            $TemporaryPassword = ConvertFrom-SecureString -SecureString $TemporaryPassword -AsPlainText;

            # Add property to body.
            $body.Add('temporary_password', $TemporaryPassword);
        }

        # If custom fields is set.
        if ($null -ne $CustomFields)
        {
            # Add property to body.
            $body.Add('custom_fields', $CustomFields);
        }

        # If language is set.
        if (-not [string]::IsNullOrEmpty($Language))
        {
            # Add property to body.
            $body.Add('language', $Language);
        }

        # If manager ID is set.
        if (0 -ne $ManagerId)
        {
            # Add property to body.
            $body.Add('manager_id', $ManagerId);
        }

        # Add body to parameters.
        $paramSplatting.Add('Body', $body);
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Message ('Trying to update Eloomi user with ID {0}' -f $Id) -Level 'Verbose';

        # Invoke Eloomi API.
        $response = Invoke-EloomiApi @paramSplatting;

        # Write to log.
        Write-CustomLog -Message ('Successfully updated Eloomi user with ID {0}' -f $Id) -Level 'Verbose';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $response;
    }
}