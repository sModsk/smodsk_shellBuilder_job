fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'smodsk_shellBuilder_job'
author 'sModsk'
version '1.0.0'


shared_scripts {
    '@ox_lib/init.lua',
}


client_scripts {
    "shared/*.lua",
    "client/**/**"
}

server_scripts {
    "shared/*.lua",
    "server/*.lua",
}