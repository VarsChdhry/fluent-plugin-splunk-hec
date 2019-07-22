
# Grab the DNS suffix, and remove the svc prefix
$CLUSTER_NAME = (get-dnsclient | ? InterfaceAlias -like "*Ethernet*").ConnectionSpecificSuffix -replace "^svc."

# Set cluster name as env var
[Environment]::SetEnvironmentVariable("CLUSTER_NAME", "$CLUSTER_NAME", [System.EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("CLUSTER_NAME", "$CLUSTER_NAME", [System.EnvironmentVariableTarget]::Process)

Get-childitem env:

Write-Host $args
Write-Host "cmd /k fluentd $args"

cmd /k fluentd $args
