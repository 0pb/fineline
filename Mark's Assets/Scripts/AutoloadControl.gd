extends Node

var MasterVol = -2
var SoundVol = -2
var MusicVol = -2

var length_of_levels_unlocked = 1

var is_level_changed = false
var gameplay_theme_set_loop = true

var detect_android_on_html = false #This is used in player.gd, VritualController.gd designed to get rid of a bug slow movement.

var is_character_dying = false #This is a bug fix that I discovered when pausing the game when character is dying.

# Called when the node enters the scene tree for the first time.
func _ready():
    #print(name)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func level_changed():
    is_level_changed = false
    
    if !theaven.playing:
        theaven.on_ready()
    if !thell.playing:
        thell.on_ready()


func back_to_main_menu():
    remove_heaven_hell_audio_bus_effect()
    
    theaven.on_stop()
    thell.on_stop()


func remove_heaven_hell_audio_bus_effect():
    #2 - AudioBus index called "heaven"
    for _i in range( AudioServer.get_bus_effect_count(2) ):
        AudioServer.remove_bus_effect(2,0) #when it removes, it sort of pops the index like a stack so I can't use i or I'll miss an index.
    
    #3 - AudioBus index called "hell"
    for _i in range( AudioServer.get_bus_effect_count(3) ):
        AudioServer.remove_bus_effect(3,0) #when it removes, it sort of pops the index like a stack so I can't use i or I'll miss an index.
    

func level_restart():
    AutoloadControl.is_character_dying = false
    get_tree().reload_current_scene()

func player_death():
    is_character_dying = true
    if has_node("/root/Main"):
        get_node("/root/Main")._player_death_1()
        pass
