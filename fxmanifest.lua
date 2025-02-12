// sg-phone fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'JouwNaam'
description 'sg-phone - Basisversie'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
    'locales.lua'
}

client_scripts {
    'client/main.lua',
    'client/ui.lua',
    'client/apps/whatsapp.lua',
    'client/apps/marketplace.lua',
    'client/apps/darkweb.lua',
    'client/apps/banking.lua',
    'client/apps/youtube.lua',
    'client/apps/tiktok.lua',
    'client/apps/videocall.lua'
	'client/apps/stocks.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/apps/whatsapp.lua',
    'server/apps/marketplace.lua',
    'server/apps/darkweb.lua',
    'server/apps/banking.lua',
    'server/apps/youtube.lua',
    'server/apps/tiktok.lua',
    'server/apps/videocall.lua'
	'server/apps/stocks.lua'
}

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/apps/whatsapp.html',
    'html/apps/marketplace.html',
    'html/apps/darkweb.html',
    'html/apps/banking.html',
    'html/apps/youtube.html',
    'html/apps/tiktok.html',
    'html/apps/videocall.html'
	'html/apps/stocks.lua'
}

ui_page 'html/index.html'
