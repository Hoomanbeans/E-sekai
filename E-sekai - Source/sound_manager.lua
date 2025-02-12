
local sounds = {

    jump = love.audio.newSource("Assets/Sounds/Player/8_bit_jump.flac", "static"),
    run_grass = love.audio.newSource("Assets/Sounds/Player/running-in-grass0_2.wav", "static") ,
    run_stone = love.audio.newSource("Assets/Sounds/Player/steps-narrow-street.wav","static"), 
    player_death = love.audio.newSource("Assets/Sounds/Player/playerdeath.wav","static"),
    slime_run = love.audio.newSource("Assets/Sounds/Slime/slime_run.wav","static"),
    slime_death = love.audio.newSource("Assets/Sounds/Slime/slime_death.wav","static"),
    player_damage = love.audio.newSource("Assets/Sounds/Player/player_damage.wav","static"),
    shield_death = love.audio.newSource("Assets/Sounds/shield/shield_death.wav","static"),
    hit_spike = love.audio.newSource("Assets/Sounds/Player/hit_spike.wav","static"),

    BGM_forest = love.audio.newSource("Assets/Sounds/Background_music/forest_background.flac","stream"),
    BGM_cave = love.audio.newSource("Assets/Sounds/Background_music/cave_background.wav","stream"),
    BGM_boss = love.audio.newSource("Assets/Sounds/Background_music/CleytonRX - Battle RPG Theme.mp3" , "stream")
} 

function Play_audio(Sounds,TS,volume,pitch,loop)

        Sounds[TS]:setVolume(volume/100)
            Sounds[TS]:setPitch(pitch/100)

            if loop == true then
                Sounds[TS]:setLooping(true)
                Sounds[TS]:play()
            else
            Sounds[TS]:play()
            end
end

function Stop_audio(Sounds,TS)
    Sounds[TS]:pause()
end

function Get_sound()
    return sounds
end