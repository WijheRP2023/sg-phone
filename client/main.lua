-- client/main.lua

local phoneOpen = false
local playerPhoneNumber = nil
local callHistory = {}
local voicemails = {}
local blockedNumbers = {}

-- Open en sluit de telefoon
RegisterNUICallback('openPhone', function(_, cb)
    SetNuiFocus(true, true)
    phoneOpen = true
    cb('ok')
end)

RegisterNUICallback('closePhone', function(_, cb)
    SetNuiFocus(false, false)
    phoneOpen = false
    cb('ok')
end)

RegisterNUICallback('triggerApp', function(data, cb)
    if data.app then
        TriggerEvent('sg-phone:client:openApp', data.app)
    end
    cb('ok')
end)

RegisterCommand('phone', function()
    if phoneOpen then
        SetNuiFocus(false, false)
        phoneOpen = false
    else
        SendNUIMessage({ action = "openPhone" })
        SetNuiFocus(true, true)
        phoneOpen = true
    end
end, false)

RegisterKeyMapping('phone', 'Open telefoon', 'keyboard', 'M')

-- Telefoonnummer ophalen
RegisterNetEvent('sg-phone:client:setPhoneNumber')
AddEventHandler('sg-phone:client:setPhoneNumber', function(number)
    playerPhoneNumber = number
    SendNUIMessage({ action = "updatePhoneNumber", number = number })
end)

-- Bellen starten
RegisterNUICallback('startCall', function(data, cb)
    TriggerServerEvent('sg-phone:server:startCall', data.targetNumber)
    cb('ok')
end)

RegisterNetEvent('sg-phone:client:receiveCall')
AddEventHandler('sg-phone:client:receiveCall', function(callerNumber)
    SendNUIMessage({ action = "incomingCall", caller = callerNumber })
end)

RegisterNUICallback('acceptCall', function(_, cb)
    TriggerServerEvent('sg-phone:server:acceptCall')
    cb('ok')
end)

RegisterNUICallback('endCall', function(_, cb)
    TriggerServerEvent('sg-phone:server:endCall')
    cb('ok')
end)

-- Oproepgeschiedenis ophalen
RegisterNUICallback('getCallHistory', function(_, cb)
    ESX.TriggerServerCallback('sg-phone:server:getCallHistory', function(history)
        callHistory = history
        cb(history)
    end)
end)

-- Voicemails ophalen
RegisterNUICallback('getVoicemails', function(_, cb)
    ESX.TriggerServerCallback('sg-phone:server:getVoicemails', function(messages)
        voicemails = messages
        cb(messages)
    end)
end)

-- Voicemail achterlaten
RegisterNUICallback('leaveVoicemail', function(data, cb)
    TriggerServerEvent('sg-phone:server:leaveVoicemail', data.targetNumber, data.message)
    cb('ok')
end)

-- Nummer blokkeren
RegisterNUICallback('blockNumber', function(data, cb)
    blockedNumbers[data.number] = true
    TriggerServerEvent('sg-phone:server:blockNumber', data.number)
    cb('ok')
end)

-- Telefoonnummer delen via target-systeem met animatie
RegisterNUICallback('sharePhoneNumber', function(data, cb)
    local targetPlayer = data.target
    if targetPlayer then
        TriggerServerEvent('sg-phone:server:sharePhoneNumber', targetPlayer, playerPhoneNumber)
        TriggerEvent('sg-phone:client:startShareAnimation', PlayerPedId())
        TriggerServerEvent('sg-phone:server:triggerTargetAnimation', targetPlayer)
    end
    cb('ok')
end)

RegisterNetEvent('sg-phone:client:receivePhoneNumber')
AddEventHandler('sg-phone:client:receivePhoneNumber', function(number, sender)
    SendNUIMessage({ action = "receivedPhoneNumber", number = number, sender = sender })
    TriggerEvent('sg-phone:client:startShareAnimation', PlayerPedId())
end)

-- Animatie voor telefoonnummer delen
RegisterNetEvent('sg-phone:client:startShareAnimation')
AddEventHandler('sg-phone:client:startShareAnimation', function(playerPed)
    if not IsEntityPlayingAnim(playerPed, "mp_common", "givetake1_a", 3) then
        RequestAnimDict("mp_common")
        while not HasAnimDictLoaded("mp_common") do
            Wait(100)
        end
        TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, -8.0, 3000, 49, 0, false, false, false)
    end
end)

RegisterNetEvent('sg-phone:client:triggerTargetAnimation')
AddEventHandler('sg-phone:client:triggerTargetAnimation', function()
    TriggerEvent('sg-phone:client:startShareAnimation', PlayerPedId())
end)
