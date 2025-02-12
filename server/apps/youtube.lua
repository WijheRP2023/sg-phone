
ESX.RegisterServerCallback('sg-phone:server:searchYouTube', function(source, cb, query)
    local apiKey = Config.YoutubeAPIKey
    if not apiKey or apiKey == "" then
        print("[SG-PHONE] ⚠️ Geen YouTube API-key ingesteld in config.lua!")
        cb({})
        return
    end

    local url = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=10&q=" .. query .. "&key=" .. apiKey

    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            local results = {}

            for _, item in ipairs(data.items) do
                table.insert(results, {
                    videoId = item.id.videoId,
                    title = item.snippet.title,
                    thumbnail = item.snippet.thumbnails.default.url
                })
            end

            cb(results)
        else
            print("[SG-PHONE] ❌ Fout bij YouTube API-oproep: " .. statusCode)
            cb({})
        end
    end, "GET", "", { ["Content-Type"] = "application/json" })
end)
