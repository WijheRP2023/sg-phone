ESX.RegisterServerCallback('sg-phone:server:getTikTokVideos', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM tiktok_videos ORDER BY likes DESC', {}, function(videos)
        cb(videos or {})
    end)
end)

RegisterServerEvent('sg-phone:server:uploadTikTokVideo')
AddEventHandler('sg-phone:server:uploadTikTokVideo', function(videoUrl, description, shareOnDiscord)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerName = GetPlayerName(source)

    MySQL.Async.execute('INSERT INTO tiktok_videos (uploader, videoUrl, description, likes) VALUES (@uploader, @videoUrl, @description, 0)', {
        ['@uploader'] = xPlayer.identifier,
        ['@videoUrl'] = videoUrl,
        ['@description'] = description
    })

    TriggerClientEvent('esx:showNotification', source, 'Je video is geüpload naar TikTok!')

    if shareOnDiscord then
        local embedData = {
            {
                ["title"] = "**📱 TikTok Video Geüpload!**",
                ["description"] = "**" .. playerName .. "** heeft een nieuwe TikTok-video geplaatst! 🎥\n\n" .. description,
                ["color"] = 16711680, -- Rood
                ["fields"] = {
                    { ["name"] = "📺 Video Link", ["value"] = videoUrl, ["inline"] = false }
                },
                ["footer"] = { ["text"] = "SG Phone - TikTok", ["icon_url"] = "https://i.imgur.com/XXXXX.png" }
            }
        }

        PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({ username = "SG TikTok", embeds = embedData }), { ['Content-Type'] = 'application/json' })
    end
end)


RegisterServerEvent('sg-phone:server:likeTikTokVideo')
AddEventHandler('sg-phone:server:likeTikTokVideo', function(videoId)
    MySQL.Async.execute('UPDATE tiktok_videos SET likes = likes + 1 WHERE id = @id', {
        ['@id'] = videoId
    })
end)
