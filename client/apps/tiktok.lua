local open = false

function openTikTok()
    ESX.TriggerServerCallback('sg-phone:server:getTikTokVideos', function(videos)
        SendNUIMessage({
            action = "openApp",
            app = "tiktok",
            data = { videos = videos }
        })
        SetNuiFocus(true, true)
        open = true
    end)
end

RegisterNUICallback('uploadTikTokVideo', function(data, cb)
    TriggerServerEvent('sg-phone:server:uploadTikTokVideo', data.videoUrl, data.description, data.shareOnDiscord)
    cb('ok')
end)

RegisterNUICallback('likeTikTokVideo', function(data, cb)
    TriggerServerEvent('sg-phone:server:likeTikTokVideo', data.videoId)
    cb('ok')
end)


RegisterNUICallback('closeApp', function()
    SetNuiFocus(false, false)
    open = false
end)

RegisterCommand('opentiktok', function()
    openTikTok()
end, false)
