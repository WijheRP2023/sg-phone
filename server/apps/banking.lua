-- server/apps/banking.lua

ESX.RegisterServerCallback('sg-phone:server:getBankData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local balance = xPlayer.getAccount('bank').money
        MySQL.Async.fetchAll('SELECT * FROM banking_transactions WHERE identifier = @identifier ORDER BY date DESC LIMIT 10', {
            ['@identifier'] = xPlayer.identifier
        }, function(transactions)
            cb(balance, transactions)
        end)
    else
        cb(0, {})
    end
end)

RegisterServerEvent('sg-phone:server:transferMoney')
AddEventHandler('sg-phone:server:transferMoney', function(targetId, amount)
    local sender = ESX.GetPlayerFromId(source)
    local receiver = ESX.GetPlayerFromId(targetId)

    amount = tonumber(amount)
    if not sender or not receiver or not amount or amount <= 0 then return end

    if sender.getAccount('bank').money >= amount then
        sender.removeAccountMoney('bank', amount)
        receiver.addAccountMoney('bank', amount)

        MySQL.Async.execute('INSERT INTO banking_transactions (identifier, type, amount, target, date) VALUES (@identifier, "transfer", @amount, @target, NOW())', {
            ['@identifier'] = sender.identifier,
            ['@amount'] = -amount,
            ['@target'] = receiver.identifier
        })

        MySQL.Async.execute('INSERT INTO banking_transactions (identifier, type, amount, target, date) VALUES (@identifier, "receive", @amount, @target, NOW())', {
            ['@identifier'] = receiver.identifier,
            ['@amount'] = amount,
            ['@target'] = sender.identifier
        })

        TriggerClientEvent('esx:showNotification', sender.source, "Je hebt ~g~€" .. amount .. "~s~ overgemaakt naar ~b~" .. receiver.getName())
        TriggerClientEvent('esx:showNotification', receiver.source, "Je hebt ~g~€" .. amount .. "~s~ ontvangen van ~b~" .. sender.getName())
    else
        TriggerClientEvent('esx:showNotification', sender.source, "Je hebt niet genoeg geld op je bankrekening!")
    end
end)
