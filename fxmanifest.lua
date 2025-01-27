fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Piqooe'
description 'Job Nambang'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'es_extended',
    'ox_inventory',
    'ox_lib',
    'ox_target'
}
