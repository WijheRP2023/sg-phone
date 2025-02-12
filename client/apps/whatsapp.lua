-- client/apps/whatsapp.lua

local chatList = {}

function openWhatsApp()
    ESX.TriggerServerCallback('sg-phone:server:getChats', function(chats)
        chatList = chats or {}

        SendNUIMessage({
            action = "openApp",
            app = "whatsapp",
            data = { chats = chatList }
        })
        SetNuiFocus(true, true)
    end)
end

RegisterNUICallback('sendMessage', function(data, cb)
    if data.target and data.message then
        TriggerServerEvent('sg-phone:server:sendMessage', data.target, data.message)
        cb('ok')
    else
        cb('error')
    end
end)

RegisterNUICallback('sendImage', function(data, cb)
    if data.target and data.image then
        TriggerServerEvent('sg-phone:server:sendImage', data.target, data.image)
        cb('ok')
    else
        cb('error')
    end
end)

RegisterNUICallback('closeApp', function()
    SetNuiFocus(false, false)
end)

RegisterCommand('openwhatsapp', function()
    openWhatsApp()
end, false)
