
function Format-Quser {
    param([object[]]$Lines,$Skip = 1)
    $Lines | Select-Object -Skip $skip | ForEach-Object {
        $columns = $_ -split '\\s{2,}' | Where-Object {$_ }
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
    }
}
