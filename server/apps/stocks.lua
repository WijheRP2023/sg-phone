local ESX = exports["es_extended"]:getSharedObject()
local stockHistory = {}

-- Genereer willekeurige koersveranderingen
local function updateStockPrices()
    for stock, data in pairs(Config.Stocks) do
        local change = math.random(-5, 5) -- Willekeurige wijziging tussen -5% en +5%
        local newPrice = math.max(1, math.floor(data.price * (1 + (change / 100))))
        Config.Stocks[stock].price = newPrice
        Config.Stocks[stock].change = change

        if not stockHistory[stock] then
            stockHistory[stock] = {}
        end
        table.insert(stockHistory[stock], { timestamp = os.time(), price = newPrice })
    end
    TriggerClientEvent('sg-phone:client:updateStockPrices', -1, Config.Stocks, stockHistory)
    SetTimeout(300000, updateStockPrices) -- Update elke 5 minuten
end
SetTimeout(300000, updateStockPrices)

-- Dividendbetalingen
local function payDividends()
    MySQL.Async.fetchAll('SELECT * FROM sg_phone_stocks', {}, function(results)
        for _, data in pairs(results) do
            local stock = Config.Stocks[data.stock]
            if stock and stock.dividend > 0 then
                local xPlayer = ESX.GetPlayerFromIdentifier(data.identifier)
                if xPlayer then
                    local payout = math.floor(stock.price * (stock.dividend / 100) * data.amount)
                    xPlayer.addAccountMoney('bank', payout)
                    TriggerClientEvent('esx:showNotification', xPlayer.source, "Je hebt €" .. payout .. " dividend ontvangen van " .. stock.name)
                end
            end
        end
    end)
    SetTimeout(1800000, payDividends) -- Betaal dividend elke 30 min
end
SetTimeout(1800000, payDividends)

-- Aandelen verkopen met winst/verliesberekening
RegisterNetEvent('sg-phone:server:sellStock')
AddEventHandler('sg-phone:server:sellStock', function(stockName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local stock = Config.Stocks[stockName]
    if stock and amount > 0 then
        MySQL.Async.fetchScalar('SELECT SUM(amount), AVG(price) FROM sg_phone_stocks WHERE identifier = ? AND stock = ?', {
            xPlayer.identifier, stockName
        }, function(ownedAmount, avgPrice)
            if ownedAmount and ownedAmount >= amount then
                local sellPrice = stock.price * amount
                local profit = sellPrice - (avgPrice * amount)
                xPlayer.addAccountMoney('bank', sellPrice)
                MySQL.Async.execute('DELETE FROM sg_phone_stocks WHERE identifier = ? AND stock = ? LIMIT ?', {
                    xPlayer.identifier, stockName, amount
                })
                TriggerClientEvent('esx:showNotification', source, "Je hebt " .. amount .. " aandelen verkocht in " .. stockName .. " voor €" .. sellPrice .. " (Winst: €" .. profit .. ")")
            else
                TriggerClientEvent('esx:showNotification', source, "Je hebt niet genoeg aandelen!")
            end
        end)
    end
end)
