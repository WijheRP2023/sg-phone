-- client/apps/banking.lua

local playerBalance = 0
local transactionHistory = {}

function openBanking()
    ESX.TriggerServerCallback('sg-phone:server:getBankData', function(balance, transactions)
        playerBalance = balance or 0
        transactionHistory = transactions or {}

        SendNUIMessage({
            action = "openApp",
            app = "banking",
            data = {
                balance = playerBalance,
                transactions = transactionHistory
            }
        })
        SetNuiFocus(true, true)
    end)
end

RegisterNUICallback('transferMoney', function(data, cb)
    if data.target and data.amount then
        TriggerServerEvent('sg-phone:server:transferMoney', data.target, data.amount)
        cb('ok')
    else
        cb('error')
    end
end)

RegisterNUICallback('closeApp', function()
    SetNuiFocus(false, false)
end)

RegisterCommand('openbanking', function()
    openBanking()
end, false)
