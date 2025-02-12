-- server/apps/video.lua

ESX = exports["es_extended"]:getSharedObject()
local activeCalls = {}

RegisterNetEvent('sg-phone:server:startVideoCall')
AddEventHandler('sg-phone:server:startVideoCall', function(targetId)
    local src = source
    local targetPlayer = ESX.GetPlayerFromId(targetId)

    if targetPlayer then
        TriggerClientEvent('sg-phone:client:receiveVideoCall', targetPlayer.source, src)
        activeCalls[src] = targetId
        activeCalls[targetId] = src
    end
end)

RegisterNetEvent('sg-phone:server:endVideoCall')
AddEventHandler('sg-phone:server:endVideoCall', function()
    local src = source
    if activeCalls[src] then
        local target = activeCalls[src]
        activeCalls[src] = nil
        activeCalls[target] = nil
        TriggerClientEvent('sg-phone:client:endVideoCall', target)
    end
end)
