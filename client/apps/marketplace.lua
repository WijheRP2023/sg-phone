
function openMarketplace()
    ESX.TriggerServerCallback('sg-phone:server:getMarketplace', function(listings)
        SendNUIMessage({
            action = "openApp",
            app = "marketplace",
            data = { listings = listings }
        })
        SetNuiFocus(true, true)
    end)
end

RegisterNUICallback('placeListing', function(data, cb)
    TriggerServerEvent('sg-phone:server:placeListing', data.plate, data.price)
    cb('ok')
end)

RegisterNUICallback('buyVehicle', function(data, cb)
    TriggerServerEvent('sg-phone:server:buyVehicle', data.listingId, data.garage)
    cb('ok')
end)

RegisterNUICallback('closeApp', function()
    SetNuiFocus(false, false)
end)

RegisterCommand('openmarketplace', function()
    openMarketplace()
end, false)

RegisterNUICallback('fetchMarketplace', function(_, cb)
    ESX.TriggerServerCallback('sg-phone:server:getMarketplaceListings', function(listings)
        marketplaceListings = listings or {}
        cb(marketplaceListings)
    end)
end)

RegisterNUICallback('closeApp', function()
    SetNuiFocus(false, false)
end)

RegisterCommand('openmarketplace', function()
    openMarketplaceApp()
end, false)
