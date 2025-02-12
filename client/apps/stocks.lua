-- client/apps/stocks.lua

local stocks = {}
local stockHistory = {}

RegisterNetEvent('sg-phone:client:updateStockPrices')
AddEventHandler('sg-phone:client:updateStockPrices', function(updatedStocks, history)
    stocks = updatedStocks
    stockHistory = history
    SendNUIMessage({
        action = "updateStocks",
        stocks = stocks,
        history = stockHistory
    })
end)

function openStocksApp()
    ESX.TriggerServerCallback('sg-phone:server:getStocks', function(stockData, historyData)
        stocks = stockData or {}
        stockHistory = historyData or {}
        SendNUIMessage({
            action = "openApp",
            app = "stocks",
            data = {
                stocks = stocks,
                history = stockHistory
            }
        })
        SetNuiFocus(true, true)
    end)
end

RegisterNUICallback('buyStock', function(data, cb)
    if data.stock and data.amount then
        TriggerServerEvent('sg-phone:server:buyStock', data.stock, data.amount)
        cb('ok')
    else
        cb('error')
    end
end)

RegisterNUICallback('sellStock', function(data, cb)
    if data.stock and data.amount then
        TriggerServerEvent('sg-phone:server:sellStock', data.stock, data.amount)
        cb('ok')
    else
        cb('error')
    end
end)

RegisterNUICallback('closeApp', function()
    SetNuiFocus(false, false)
end)

RegisterCommand('openstocks', function()
    openStocksApp()
end, false)
