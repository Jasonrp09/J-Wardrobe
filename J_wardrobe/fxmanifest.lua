fx_version 'cerulean'
game 'gta5'

author 'jason.09'
description 'j_development Wardrobe'
version '1.0.0'

shared_script '@es_extended/imports.lua'
client_scripts {
    'config.lua',
    'client.lua'
}
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}
