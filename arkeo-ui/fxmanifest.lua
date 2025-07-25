fx_version 'cerulean'
game 'gta5'

author 'ArkeologeN'
description 'Minimal UI w/ React'
version '1.0.3'

-- UI
ui_page 'web/build/index.html'

-- Shared Scripts
shared_scripts {
    'shared/*.lua',
    'shared/*.js'
}

-- Client Scripts
client_scripts {
    'client/*.js',
    'client/*.lua'
}

-- Server Scripts
server_scripts {
    'server/*.js',
    'server/*.lua'
}

-- Additional UI Assets
files {
    'web/build/index.html',
    'web/build/**/*'
} 

exports {
    'Notification',
    'ShowMissionCard',
    'HideMissionCard',
    'ShowProgressBar',
    'CancelProgressBar',
  }