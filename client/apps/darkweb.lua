-- client/apps/darkweb.lua

function openDarkweb()
    ESX.TriggerServerCallback('sg-phone:server:getDarkwebListings', function(listings)
        SendNUIMessage({
            action = "openApp",
            app = "darkweb",
            data = { listings = listings }
        })
        SetNuiFocus(true, true)
    end)
end

RegisterNUICallback('placeDarkwebListing', function(data, cb)
    TriggerServerEvent('sg-phone:server:placeDarkwebListing', data.item, data.price, data.amount)
    cb('ok')
end)

RegisterNUICallback('buyDarkwebItem', function(data, cb)
    TriggerServerEvent('sg-phone:server:buyDarkwebItem', data.listingId)
    cb('ok')
end)

RegisterNUICallback('closeApp', function()
    SetNuiFocus(false, false)
end)

RegisterCommand('opendarkweb', function()
    ESX.TriggerServerCallback('sg-phone:server:hasDarkwebAccess', function(hasAccess)
        if hasAccess then
            openDarkweb()
        else
            ESX.ShowNotification("Je hebt geen toegang tot het Darkweb!")
        end
    end)
end, false)
