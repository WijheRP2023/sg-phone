-- server/apps/darkweb.lua

ESX.RegisterServerCallback('sg-phone:server:hasDarkwebAccess', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob().name

    for _, allowedJob in pairs(Config.DarkwebJobs) do
        if job == allowedJob then
            cb(true)
            return
        end
    end
    cb(false)
end)

ESX.RegisterServerCallback('sg-phone:server:getDarkwebListings', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM darkweb', {}, function(listings)
        cb(listings or {})
    end)
end)

RegisterServerEvent('sg-phone:server:placeDarkwebListing')
AddEventHandler('sg-phone:server:placeDarkwebListing', function(item, price, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasItem = xPlayer.getInventoryItem(item)

    if hasItem and hasItem.count >= amount then
        xPlayer.removeInventoryItem(item, amount)

        MySQL.Async.execute('INSERT INTO darkweb (seller, item, price, amount) VALUES (@seller, @item, @price, @amount)', {
            ['@seller'] = xPlayer.identifier,
            ['@item'] = item,
            ['@price'] = price,
            ['@amount'] = amount
        })
        TriggerClientEvent('esx:showNotification', source, 'Item geplaatst op het Darkweb!')
    else
        TriggerClientEvent('esx:showNotification', source, 'Je hebt niet genoeg items!')
    end
end)

RegisterServerEvent('sg-phone:server:buyDarkwebItem')
AddEventHandler('sg-phone:server:buyDarkwebItem', function(listingId)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM darkweb WHERE id = @id', {
        ['@id'] = listingId
    }, function(result)
        if #result > 0 then
            local listing = result[1]
            local seller = ESX.GetPlayerFromIdentifier(listing.seller)

            if xPlayer.getAccount('black_money').money >= listing.price then
                xPlayer.removeAccountMoney('black_money', listing.price)
                xPlayer.addInventoryItem(listing.item, listing.amount)
                MySQL.Async.execute('DELETE FROM darkweb WHERE id = @id', { ['@id'] = listingId })

                TriggerClientEvent('esx:showNotification', source, 'Item gekocht op het Darkweb!')

                if seller then
                    seller.addAccountMoney('black_money', listing.price)
                    TriggerClientEvent('esx:showNotification', seller.source, 'Je hebt een item verkocht op het Darkweb!')
                end
            else
                TriggerClientEvent('esx:showNotification', source, 'Niet genoeg zwart geld!')
            end
        end
    end)
end)
