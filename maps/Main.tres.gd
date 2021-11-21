
extends Node2D


onready var node_heaven = get_node("heaven")
onready var node_hell = get_node("hell")
onready var node_theme_heaven = theaven
onready var node_theme_hell = thell
export var string_next_level = "res://maps/map_01.tscn"


var true_if_heaven = true

#Mark's code (below)
export var level_name = ""

export var transition_duration = 0.2
export var transition_type = 1 # TRANS_SINE
var player_death = false
#Mark's code (above)

export var time_to_gold : float = 10.0
export var time_to_silver : float = 20.0


func _ready():
    #instantiate tween
    var inst_map_tweens = preload("res://maps/map_tweens.tscn").instance()
    add_child(inst_map_tweens)
    
    if !has_node("timer"): #I want to add the timer instance in a script instead in the map_0x scenes. It hurts my head thinking about them when forgetting it.
        var timer_inst = preload("res://maps/timer.tscn").instance()
        timer_inst.time_to_gold = time_to_gold
        timer_inst.time_to_silver = time_to_silver
        add_child(timer_inst)
        
    
    Engine.time_scale = 1.0 # reset in case of bug by death
    
    # setup the music
    AutoloadControl.level_changed()
    change_to_heaven()
    node_theme_heaven.stream_paused = false
    node_theme_hell.stream_paused = false

#	if not node_theme_heaven.playing:
#		node_theme_heaven.playing = true
#
#	if not node_theme_hell.playing:
#		node_theme_hell.playing = true

    # set the fadeinout
#    fadeinout.update_signal(self)
    $player/death_player.connect("timeout", self, "_on_end_death")

    # setup pressure plate and traps signals
    var pressures_plates = get_tree().get_nodes_in_group("pressure")
    for plate in pressures_plates:
        plate.update_signals(self)

    var traps = get_tree().get_nodes_in_group("traps")
    for trap in traps:
        trap.update_signals(self)

    _display_death()

onready var scene_death = preload("res://body/death_sprite.tscn")
func _display_death():
    for death in death_position.positions:
        var sprite_ = scene_death.instance()
        sprite_.global_position = death
        add_child(sprite_)


func _on_exit():
    $timer.on_exit()
    death_position.positions = []
    node_theme_heaven.stream_paused = true
    node_theme_hell.stream_paused = true
    
func _on_end_retry():
    get_tree().change_scene(get_tree().current_scene.filename)
func _on_end_next():
    get_tree().change_scene(string_next_level)


func _on_plate_entered(area, _current_plate):
    _current_plate.current_bodies += [area]
    if _current_plate.node_wanted:
        _current_plate.node_wanted.activate()
    else:
        get_node("exit").activate()
func _on_plate_exited(area, _current_plate):
    # in case the player leave the plate after pushing a box on it
    _current_plate.current_bodies.erase(area)
    if _current_plate.current_bodies:
        return
    elif _current_plate.node_wanted:
        _current_plate.node_wanted.deactivate()
    else:
        get_node("exit").deactivate()


func _player_death(area):
    AutoloadControl.is_character_dying = true #I found a bug fix by pausing when player is dying
    Engine.time_scale = 0.5
    # $player.play_death_particle()
    death_position.positions += [Vector2(area.global_position)]
    $player.false_if_dead = false
    $player/death_player.start(1.0)
    $player/death_particle.emitting = true

func _on_end_death():
    get_tree().reload_current_scene()
   
func _player_death_1():
    if player_death == false:
        player_death = true
        Engine.time_scale = 0.5
        # $player.play_death_particle()
        if has_node("player"):
            death_position.positions += [Vector2($player.global_position)]
            $player.false_if_dead = false
            $player/death_player.start(.5)
            $player/death_particle.emitting = true

func _on_laser_entered(area):
    if area.is_in_group("player"):
        #_player_death(area)
        pass

func _on_fire_entered(area):
    if area.is_in_group("player"):
        _player_death(area)
    if area.is_in_group("box"):
        area.queue_free()

func _on_spike_entered(area):
    if area.is_in_group("player"):
        _player_death(area)


func _update_list_node(bool_):
    var nodes_hell = get_tree().get_nodes_in_group("hell")
    for node in nodes_hell:
        if "visible" in node:
            #node.visible = bool_
            if bool_ == false:
                $map_tweens/TweenHell.interpolate_property(node, "modulate", Color(1, 1, 1, node.modulate.a), Color(1, 1, 1, 0), transition_duration, transition_type, Tween.EASE_IN, 0)
                $map_tweens/TweenHell.start()
                #print("hell")
            else:
                $map_tweens/TweenHell.interpolate_property(node, "modulate", Color(1, 1, 1, node.modulate.a), Color(1, 1, 1, 1), transition_duration, transition_type, Tween.EASE_IN, 0)
                $map_tweens/TweenHell.start()
        
        if node.has_method("disable_on_world_change"):
            node.disable_on_world_change(bool_)
    
    var nodes_heaven = get_tree().get_nodes_in_group("heaven")
    for node in nodes_heaven:
        if "visible" in node:
            #node.visible = !bool_
            if bool_ == false:
                $map_tweens/TweenHell.interpolate_property(node, "modulate", Color(1, 1, 1, node.modulate.a), Color(1, 1, 1, 1), transition_duration, transition_type, Tween.EASE_IN, 0)
                $map_tweens/TweenHell.start()
            else:
                $map_tweens/TweenHell.interpolate_property(node, "modulate", Color(1, 1, 1, node.modulate.a), Color(1, 1, 1, 0), transition_duration, transition_type, Tween.EASE_IN, 0)
                $map_tweens/TweenHell.start()
        if node.has_method("disable_on_world_change"):
            node.disable_on_world_change(!bool_)


func _update_tilemaps_collision(bool_):
    node_heaven.set_collision_layer_bit(0, bool_)
    node_heaven.set_collision_mask_bit(0, bool_)
    node_hell.set_collision_layer_bit(0, !bool_)
    node_hell.set_collision_mask_bit(0, !bool_)


func change_to_heaven():
    _update_tilemaps_collision(true)
    _update_list_node(false)
    
#    node_theme_heaven.volume_db = -6
#    node_theme_hell.volume_db = -80
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("heaven"), AutoloadControl.MusicVol)
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("hell"), -80)


func change_to_hell():
    _update_tilemaps_collision(false)
    _update_list_node(true)

#    node_theme_heaven.volume_db = -80
#    node_theme_hell.volume_db = -6
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("heaven"), -80)
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("hell"), AutoloadControl.MusicVol)


func _unhandled_input(event):
    if event.is_action_pressed("change_world"):
        _change_world()

func _change_world():
    true_if_heaven = !true_if_heaven
    if true_if_heaven:
        change_to_heaven()
    else:
        change_to_hell()

#func _change_world():
#	true_if_heaven = !true_if_heaven
#	fadeinout.fadein()
#	fadeinout.fadein_sound()
#
#
#func _on_endfadein():
#	if true_if_heaven:
#		change_to_heaven()
#	else:
#		change_to_hell()
#
        
