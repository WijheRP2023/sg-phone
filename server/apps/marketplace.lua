-- server/apps/marketplace.lua

ESX.RegisterServerCallback('sg-phone:server:getMarketplace', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM marketplace', {}, function(listings)
        cb(listings or {})
    end)
end)

RegisterServerEvent('sg-phone:server:placeListing')
AddEventHandler('sg-phone:server:placeListing', function(plate, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.execute('INSERT INTO marketplace (owner, plate, price) VALUES (@owner, @plate, @price)', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = plate,
            ['@price'] = price
        })
        TriggerClientEvent('esx:showNotification', source, 'Voertuig te koop gezet!')
    end
end)

RegisterServerEvent('sg-phone:server:buyVehicle')
AddEventHandler('sg-phone:server:buyVehicle', function(listingId, garage)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM marketplace WHERE id = @id', {
            ['@id'] = listingId
        }, function(result)
            if #result > 0 then
                local listing = result[1]
                local owner = ESX.GetPlayerFromIdentifier(listing.owner)

                if xPlayer.getAccount('bank').money >= listing.price then
                    xPlayer.removeAccountMoney('bank', listing.price)
                    MySQL.Async.execute('DELETE FROM marketplace WHERE id = @id', { ['@id'] = listingId })

                    MySQL.Async.execute('UPDATE owned_vehicles SET owner = @newOwner, garage = @garage WHERE plate = @plate', {
                        ['@newOwner'] = xPlayer.identifier,
                        ['@plate'] = listing.plate,
                        ['@garage'] = garage
                    })

                    TriggerClientEvent('esx:showNotification', source, 'Auto gekocht! Opgeslagen in ' .. garage)

                    if owner then
                        owner.addAccountMoney('bank', listing.price)
                        TriggerClientEvent('esx:showNotification', owner.source, 'Je hebt een auto verkocht!')
                    end
                else
                    TriggerClientEvent('esx:showNotification', source, 'Niet genoeg geld!')
                end
            end
        end)
    end
end)
