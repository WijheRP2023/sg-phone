-- server/apps/whatsapp.lua

ESX.RegisterServerCallback('sg-phone:server:getChats', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM whatsapp_messages WHERE sender = @identifier OR receiver = @identifier ORDER BY timestamp DESC', {
            ['@identifier'] = xPlayer.identifier
        }, function(messages)
            cb(messages)
        end)
    else
        cb({})
    end
end)

RegisterServerEvent('sg-phone:server:sendMessage')
AddEventHandler('sg-phone:server:sendMessage', function(targetId, message)
    local sender = ESX.GetPlayerFromId(source)
    local receiver = ESX.GetPlayerFromId(targetId)

    if sender and receiver then
        MySQL.Async.execute('INSERT INTO whatsapp_messages (sender, receiver, message, type, timestamp) VALUES (@sender, @receiver, @message, "text", NOW())', {
            ['@sender'] = sender.identifier,
            ['@receiver'] = receiver.identifier,
            ['@message'] = message
        })

        TriggerClientEvent('sg-phone:client:receiveMessage', receiver.source, sender.identifier, message)
    end
end)

RegisterServerEvent('sg-phone:server:sendImage')
AddEventHandler('sg-phone:server:sendImage', function(targetId, image)
    local sender = ESX.GetPlayerFromId(source)
    local receiver = ESX.GetPlayerFromId(targetId)

    if sender and receiver then
        MySQL.Async.execute('INSERT INTO whatsapp_messages (sender, receiver, message, type, timestamp) VALUES (@sender, @receiver, @message, "image", NOW())', {
            ['@sender'] = sender.identifier,
            ['@receiver'] = receiver.identifier,
            ['@message'] = image
        })

        TriggerClientEvent('sg-phone:client:receiveImage', receiver.source, sender.identifier, image)
    end
end)
