fx_version 'cerulean'
game 'gta5'

author 'dossantosrp'
description 'DS Arsenal'
version '1.0.0'

ui_page 'web/index.html'

shared_scripts {
    '@vrp/lib/utils.lua',
	'config.lua'
}

client_scripts {
    'client.lua',
}

server_scripts {
	'server.lua',
	'functions.lua'
}


files {
	"web/**/*",
	"web/index.html",
	"web/script.js",
	"web/style.css"
}