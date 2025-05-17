fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.0.0'
author 'Lips | Nebula Scripts'
description 'Bindiving script made by Lips'

client_scripts {
    'client/client.lua',

}

server_scripts {
    'server.lua'
}


shared_scripts { 
    'config.lua',
    '@ox_lib/init.lua',
    '@oxmysql/lib/MySQL.lua'
}

escrow_ignore {
    'config.lua',
}
