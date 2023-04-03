fx_version 'cerulean'
game 'gta5'

author 'Nano Development'
description 'Base system by Nano Development.'
version '0.0.2'

shared_script 'config.lua'
server_scripts {
    'server/*.lua',
    'modules/**/server.lua'
}
client_scripts {
    'client/*.lua',
    'modules/**/client.lua'
}

lua54 'yes'