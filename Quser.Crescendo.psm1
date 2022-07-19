# Module created by Microsoft.PowerShell.Crescendo
class PowerShellCustomFunctionAttribute : System.Attribute { 
    [bool]$RequiresElevation
    [string]$Source
    PowerShellCustomFunctionAttribute() { $this.RequiresElevation = $false; $this.Source = "Microsoft.PowerShell.Crescendo" }
    PowerShellCustomFunctionAttribute([bool]$rElevation) {
        $this.RequiresElevation = $rElevation
        $this.Source = "Microsoft.PowerShell.Crescendo"
    }
}



function Get-LoggedOnuser
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding(DefaultParameterSetName='Default')]

param(
[Parameter(Position=1,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='Default')]
[string]$ComputerName,
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true,ParameterSetName='Default')]
[string]$Identity
    )

BEGIN {
    $__PARAMETERMAP = @{
         ComputerName = @{
               OriginalName = '/SERVER:'
               OriginalPosition = '0'
               Position = '1'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $True
               }
         Identity = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $False; Handler = { param([object[]]$Lines,$Skip = 1)
                    $Lines | Select-Object -Skip $skip | ForEach-Object {
                        $columns = $_ -split '\s{2,}' | Where-Object {$_ }
                        if($columns.count -eq 5)
                        {
                            [pscustomobject]@{
                                UserName    = [String]($columns[0] -replace '>').trim()
                                SessionName = $null
                                ID          = [String]$columns[1]
                                State       = [String]$columns[2]
                                IdleTime    = [String]$columns[3]
                                LogonTime   = Get-Date $columns[4]
                            }
                        }else{
                            [pscustomobject]@{
                                UserName    = [String]($columns[0] -replace '>').Trim()
                                SessionName = [String]$columns[1]
                                ID          = [String]$columns[2]
                                State       = [String]$columns[3]
                                IdleTime    = [String]$columns[4]
                                LogonTime   = Get-Date $columns[5]
                            }
                        }
                        } } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                $pFmt = "{0}{1}"
                if($value -match "\s") { $pFmt = "{0}""{1}""" }
                $__commandArgs += $pFmt -f $param.OriginalName, $value
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                $__commandArgs += $value | Foreach-Object {$_}
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message $env:windir/System32/quser.exe
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("$env:windir/System32/quser.exe $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "$env:windir/System32/quser.exe")) {
          throw "Cannot find executable '$env:windir/System32/quser.exe'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            & "$env:windir/System32/quser.exe" $__commandArgs| & $__handler
        }
        else {
            $result = & "$env:windir/System32/quser.exe" $__commandArgs
            & $__handler $result
        }
    }
  } # end PROCESS

<#
.SYNOPSIS
Display information about users logged on to the system.

.DESCRIPTION 
Display information about users logged on to the system

.PARAMETER ComputerName
Name of local or remote computer

.PARAMETER Identity
This value can be username, sessionname or sessionID.

.EXAMPLE
Get-LoggedOnUser
Display session information for users logged onto local machine

.EXAMPLE
Get-LoggedOnUser -Identity 'USER'
Display session information on a specific user
.EXAMPLE
Get-LoggedOnUser -ComputerName 'REMOTEPC'
Display session information for users logged onto specified machine. 

.EXAMPLE
Get-LoggedOnUser -Identity 'USER' -ComputerName 'REMOTEPC'
Display session information for specific user on specific machine


#>
}


