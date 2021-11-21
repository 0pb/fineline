extends AudioStreamPlayer


onready var tween_in = get_node("Tween_begin")
onready var tween_out = get_node("Tween_end")


export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE


var list_song_heaven = ["res://music/CalmHeaven.ogg", "res://music/heaven.ogg"]
var list_song_hell = ["res://music/Calmhell.ogg", "res://music/Hell.ogg"]
var volume_db_wanted = -6
var length_song = 0.0
var random_song_index = 0  # 0 or 1
var res_song


func _ready():
    #volume_db = -80
    randomize()
#    on_ready()


func on_ready():
    #print("on ready")
    # pick an index between 0 and 1, then load the song corresponding to the index
    # only happen to the theme_heaven node, the theme_hell chose what the heaven node picked
    if 'heaven' in name:
        var array = [0, 1]
        random_song_index = array[randi() % array.size()]
    if 'hell' in name:
        random_song_index = theaven.random_song_index
        res_song = load(list_song_hell[random_song_index])
    if 'heaven' in name:
        res_song = load(list_song_heaven[random_song_index])
    stream = res_song

    # fade in
    play()
    _on_starting_song()
    
    $Timer.connect("timeout", self, "_on_ending_song")
    $Timer2.connect("timeout", self, "_on_start_another_song")

    # 5s before the end the fade out start
    length_song = stream.get_length()
    $Timer.wait_time = length_song - transition_duration
    $Timer.start()

func on_stop():
    playing = false
    $Timer.stop()
    $Timer2.stop()


func _on_starting_song():
    print("starting song")
    tween_in.interpolate_property(self, "volume_db", -80, volume_db_wanted, transition_duration, transition_type, Tween.EASE_IN, 0)
    tween_in.start()

func _on_ending_song():
    print("ending song")
    tween_out.interpolate_property(self, "volume_db", volume_db_wanted, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
    tween_out.start()
    $Timer2.start()


func _on_start_another_song():
    on_ready()


func _on_TweenOut_tween_completed(object, key):
    # stop the music -- otherwise it continues to run at silent volume
    object.stop()


func remove_audio_bus_effect():
    #2 - AudioBus index called "heaven"
    for _i in range( AudioServer.get_bus_effect_count(2) ):
        AudioServer.remove_bus_effect(2,0) #when it removes, it sort of pops the index like a stack so I can't use i or I'll miss an index.
