function New-Password
{
    <#
    .SYNOPSIS
        Generate a new password.
    .DESCRIPTION
        Generate a new password from a set of characters.
    .PARAMETER PasswordLength
        Length of the password.
    .EXAMPLE
        New-Password -Length 20;
    #>
    [cmdletbinding()]
    [OutputType([string])]
    param
    (
        # Length of the password.
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$PasswordLength = 20
    )

    BEGIN
    {
        # Write to log.
        $customProgress = Write-CustomProgress -Activity $MyInvocation.MyCommand.Name -CurrentOperation 'Generating new password';
    }
    PROCESS
    {
        # Password to return.
        [string]$password = ('ABCDEFGHIJKLMNPQRSTUVWXYZabcdefghjkmopqstuvwxyz123456789!@'.ToCharArray() | Get-Random -Count $PasswordLength) -join '';
    }
    END
    {
        # Write to log.
        Write-CustomProgress @customProgress;

        # Return result.
        return $password;
    }
}