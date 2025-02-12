-- client/apps/video.lua

local callInProgress = false

RegisterNUICallback('startVideoCall', function(data, cb)
    if callInProgress then
        cb({ success = false, error = "Je bent al in een gesprek!" })
        return
    end

    TriggerServerEvent('sg-phone:server:startVideoCall', data.target)
    cb({ success = true })
end)

RegisterNUICallback('acceptVideoCall', function(data, cb)
    callInProgress = true
    SendNUIMessage({ action = "startVideo", peerId = data.peerId })
    cb({ success = true })
end)

RegisterNUICallback('endVideoCall', function(_, cb)
    callInProgress = false
    TriggerServerEvent('sg-phone:server:endVideoCall')
    SendNUIMessage({ action = "endVideo" })
    cb({ success = true })
end)

RegisterNetEvent('sg-phone:client:receiveVideoCall')
AddEventHandler('sg-phone:client:receiveVideoCall', function(peerId)
    SendNUIMessage({ action = "incomingVideoCall", peerId = peerId })
end)

RegisterNetEvent('sg-phone:client:endVideoCall')
AddEventHandler('sg-phone:client:endVideoCall', function()
    callInProgress = false
    SendNUIMessage({ action = "endVideo" })
end)
