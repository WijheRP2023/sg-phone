

local youtubeResults = {}

function openYouTube()
    SendNUIMessage({
        action = "openApp",
        app = "youtube",
        data = {
            results = youtubeResults
        }
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback('searchYouTube', function(data, cb)
    if not data.query or data.query == "" then
        cb({ success = false, error = "Geen zoekterm opgegeven!" })
        return
    end

    ESX.TriggerServerCallback('sg-phone:server:searchYouTube', function(results)
        youtubeResults = results or {}
        cb({ success = true, results = youtubeResults })
    end, data.query)
end)

RegisterNUICallback('watchVideo', function(data, cb)
    if data.videoId then
        SendNUIMessage({
            action = "playYouTubeVideo",
            videoId = data.videoId
        })
        cb({ success = true })
    else
        cb({ success = false, error = "Geen video geselecteerd!" })
    end
end)

RegisterNUICallback('closeApp', function()
    SetNuiFocus(false, false)
end)

RegisterCommand('openyoutube', function()
    openYouTube()
end, false)
