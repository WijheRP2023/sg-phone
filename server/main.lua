-- server/main.lua

ESX = exports["es_extended"]:getSharedObject()
local activeCalls = {}
local phoneNumbers = {}
local callHistory = {}
local blockedNumbers = {}
local voicemails = {}

-- Geef spelers een uniek telefoonnummer bij het joinen
RegisterServerEvent('sg-phone:server:getPhoneNumber')
AddEventHandler('sg-phone:server:getPhoneNumber', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not phoneNumbers[xPlayer.identifier] then
        phoneNumbers[xPlayer.identifier] = math.random(100000, 999999)
    end
    TriggerClientEvent('sg-phone:client:setPhoneNumber', src, phoneNumbers[xPlayer.identifier])
end)

-- Start een oproep
RegisterNetEvent('sg-phone:server:startCall')
AddEventHandler('sg-phone:server:startCall', function(targetNumber)
    local src = source
    local caller = ESX.GetPlayerFromId(src)
    
    for id, number in pairs(phoneNumbers) do
        if number == targetNumber then
            local target = ESX.GetPlayerFromIdentifier(id)
            if target then
                if blockedNumbers[target.source] and blockedNumbers[target.source][src] then
                    TriggerClientEvent('sg-phone:client:callBlocked', src)
                    return
                end
                
                activeCalls[src] = target.source
                activeCalls[target.source] = src
                
                callHistory[src] = callHistory[src] or {}
                table.insert(callHistory[src], { number = targetNumber, type = "outgoing" })
                
                callHistory[target.source] = callHistory[target.source] or {}
                table.insert(callHistory[target.source], { number = phoneNumbers[caller.identifier], type = "incoming" })
                
                TriggerClientEvent('sg-phone:client:receiveCall', target.source, phoneNumbers[caller.identifier])
            end
        end
    end
end)

-- Accepteer een oproep
RegisterNetEvent('sg-phone:server:acceptCall')
AddEventHandler('sg-phone:server:acceptCall', function()
    local src = source
    if activeCalls[src] then
        TriggerClientEvent('sg-phone:client:startCall', activeCalls[src])
        TriggerClientEvent('sg-phone:client:startCall', src)
    end
end)

-- Beëindig een oproep
RegisterNetEvent('sg-phone:server:endCall')
AddEventHandler('sg-phone:server:endCall', function()
    local src = source
    if activeCalls[src] then
        local target = activeCalls[src]
        activeCalls[src] = nil
        activeCalls[target] = nil
        TriggerClientEvent('sg-phone:client:endCall', target)
        TriggerClientEvent('sg-phone:client:endCall', src)
    end
end)

-- Telefoonnummer delen via target
RegisterNetEvent('sg-phone:server:sharePhoneNumber')
AddEventHandler('sg-phone:server:sharePhoneNumber', function(targetPlayer, phoneNumber)
    TriggerClientEvent('sg-phone:client:receivePhoneNumber', targetPlayer, phoneNumber, source)
end)

-- Trigger animatie bij target
RegisterNetEvent('sg-phone:server:triggerTargetAnimation')
AddEventHandler('sg-phone:server:triggerTargetAnimation', function(targetPlayer)
    TriggerClientEvent('sg-phone:client:triggerTargetAnimation', targetPlayer)
end)

-- Voicemail opslaan
RegisterNetEvent('sg-phone:server:leaveVoicemail')
AddEventHandler('sg-phone:server:leaveVoicemail', function(targetNumber, message)
    for id, number in pairs(phoneNumbers) do
        if number == targetNumber then
            voicemails[id] = voicemails[id] or {}
            table.insert(voicemails[id], { sender = source, message = message })
        end
    end
end)

-- Voicemails ophalen
ESX.RegisterServerCallback('sg-phone:server:getVoicemails', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = voicemails[xPlayer.identifier] or {}
    cb(result)
end)

-- Oproepgeschiedenis ophalen
ESX.RegisterServerCallback('sg-phone:server:getCallHistory', function(source, cb)
    cb(callHistory[source] or {})
end)

-- Nummer blokkeren
RegisterNetEvent('sg-phone:server:blockNumber')
AddEventHandler('sg-phone:server:blockNumber', function(targetNumber)
    local src = source
    blockedNumbers[src] = blockedNumbers[src] or {}
    blockedNumbers[src][targetNumber] = true
end)
