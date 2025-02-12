Config = {}

Config.YoutubeAPIKey = "JOUW_API_SLEUTEL_HIER" -- Vul hier je API key in

Config.DarkwebJobs = {
    "gang",    -- Bijvoorbeeld voor gangleden
    "mafia"    -- Bijvoorbeeld voor de maffia
}

-- Maximale video-grootte in MB
Config.MaxVideoSize = 10 

-- Toegestane bestandstypen
Config.AllowedFileTypes = { "mp4", "webm" }

-- URL voor externe videohosting (indien nodig)
Config.VideoHostingURL = "https://jouwserver.com/uploads/"

Config.DiscordWebhook = "https://discord.com/api/webhooks/XXXX/XXXX" -- Vervang met je eigen webhook URL

-- API voor realistische koersen (optioneel, anders simulatie)
Config.StockAPI = "https://api.example.com/stocks"

-- Discord-webhook voor investeringen
Config.InvestmentWebhook = "https://discord.com/api/webhooks/XXXXXXXXXX/XXXXXXXXXX"

-- 20 grootste Nederlandse beursbedrijven
Config.Stocks = {
    ["ASML"] = { name = "ASML Holding", price = 700, dividend = 2.5 },
    ["RDSA"] = { name = "Shell", price = 27, dividend = 3.2 },
    ["UNILEVER"] = { name = "Unilever", price = 50, dividend = 2.1 },
    ["PHILIPS"] = { name = "Philips", price = 17, dividend = 1.8 },
    ["ING"] = { name = "ING Groep", price = 12, dividend = 3.5 },
    ["ABN"] = { name = "ABN AMRO", price = 14, dividend = 2.8 },
    ["AALB"] = { name = "Aalberts", price = 45, dividend = 1.5 },
    ["DSM"] = { name = "DSM-Firmenich", price = 144, dividend = 1.9 },
    ["KPN"] = { name = "KPN", price = 3, dividend = 4.0 },
    ["TKH"] = { name = "TKH Group", price = 40, dividend = 2.3 },
    ["AKZO"] = { name = "AkzoNobel", price = 80, dividend = 2.4 },
    ["NN"] = { name = "NN Group", price = 35, dividend = 2.9 },
    ["POSTNL"] = { name = "PostNL", price = 2, dividend = 4.5 },
    ["BESI"] = { name = "BE Semiconductor", price = 80, dividend = 2.7 },
    ["RAND"] = { name = "Randstad", price = 60, dividend = 3.0 },
    ["JUSTEAT"] = { name = "Just Eat Takeaway", price = 18, dividend = 0.0 },
    ["SIGNIFY"] = { name = "Signify", price = 33, dividend = 2.2 },
    ["BAM"] = { name = "BAM Groep", price = 4, dividend = 3.3 },
    ["HEINEKEN"] = { name = "Heineken", price = 90, dividend = 2.6 },
    ["VOPAK"] = { name = "Vopak", price = 26, dividend = 3.1 }
}
