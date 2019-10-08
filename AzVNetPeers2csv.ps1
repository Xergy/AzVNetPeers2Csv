
$Peers_All = Get-AzSubscription | Set-AzContext | ForEach-Object { Get-AzVirtualNetwork } | Select-Object -property @{N='VirtualNetworkName';E={$_.Name}},ResourceGroupName | Get-AzVirtualNetworkPeering

$Peers_Filtered = $Peers_All | 
    Select-Object -Property Name, ResourceGroupName, VirtualNetworkName, PeeringState, AllowVirtualNetworkAccess, AllowForwardedTraffic, AllowGatewayTransit, UseRemoteGateways,     
        @{N='RemoteVNet';E={$_.RemoteVirtualNetwork.id.tostring().split('/')[8]}},
        @{N='Subscription';E={
            Get-AzSubscription -SubscriptionId ($_.RemoteVirtualNetwork.id.tostring().split('/')[2]) | foreach-object {$_.Name}
            }
        } |
        Select-Object -Property Subscription, ResourceGroupName, VirtualNetworkName, RemoteVNet, Name, PeeringState, AllowVirtualNetworkAccess, AllowForwardedTraffic, AllowGatewayTransit, UseRemoteGateways


$Peers_Filtered | Export-Csv -Path Peers_all.csv -NoTypeInformation

ii Peers_all.csv
        