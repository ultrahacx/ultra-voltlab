fx_version 'cerulean'
game {'gta5'}

author 'ultrahacx'
version '1.0.0'

files {
    'html/*.js',
    'html/screen.html',
    'html/*.gif',
    'html/*.png',
    'dlc_hei4/dlc_hei4_v_mg.awc',
    'dlc_hei4/dlc_hei4_fh_mg.awc',
    'audiodata/dlchei4_game.dat151',
    'audiodata/dlchei4_game.dat151.nametable',
    'audiodata/dlchei4_game.dat151.rel',
    'audiodata/dlchei4_sounds.dat54',
    'audiodata/dlchei4_sounds.dat54.nametable',
    'audiodata/dlchei4_sounds.dat54.rel',
}

data_file 'AUDIO_GAMEDATA' 'audiodata/dlchei4_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audiodata/dlchei4_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'dlc_hei4'

ui_page 'html/screen.html'

client_script 'client.lua'

server_script 'server.lua'

client_script 'config.lua'
