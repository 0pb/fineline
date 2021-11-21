extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    if not get_tree().paused:
        visible = get_tree().paused

    get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")
    _resize_to_fit()
    
    pass # Replace with function body.

#func _unhandled_input(event):
func _input(event):
    if event is InputEventKey:
        if AutoloadControl.is_character_dying == false:
            if OS.get_name() == "HTML5":
                if event.pressed and event.echo == false and event.scancode == KEY_P:
                    _toggle_pause()
                    pass 
            else:
                if event.pressed and event.echo == false and event.scancode == KEY_ESCAPE:
                    _toggle_pause()
                    pass 


var time_started := 0.0
var time_elapsed := 0.0
func _toggle_pause():
    var new_pause_state = not get_tree().paused
    $PauseFront/OptionsPanel.visible = false
    $PauseFront/Credits.visible = false
    $PauseFront/PauseMain/ContinueBtn.grab_focus()
    $PauseFront/PauseMain.visible = true

    get_tree().paused = new_pause_state
    visible = new_pause_state

    # used for the timer
    var node_timer = get_parent().get_parent().get_parent().get_node('timer')
    if new_pause_state:
        time_started = OS.get_ticks_msec()
    else:
        time_elapsed = OS.get_ticks_msec() - time_started
        prints(node_timer.time_start, time_elapsed)
        node_timer.time_start = node_timer.time_start + time_elapsed


    if get_tree().root.has_node("Main"):
        if new_pause_state == false:
            AutoloadControl.remove_heaven_hell_audio_bus_effect()

        if get_tree().root.get_node("Main").true_if_heaven == true:
            if new_pause_state == true:
                AudioServer.add_bus_effect(2,AudioEffectReverb.new())
                #AudioServer.add_bus_effect(2,AudioEffectLowPassFilter.new())
                #AudioServer.add_bus_effect(2,AudioEffectFilter.new())
                
                AudioServer.get_bus_effect(2,0).dry = 0.16
                AudioServer.get_bus_effect(2,0).wet = 0.16
                
                thell.remove_audio_bus_effect()

        else:
            if new_pause_state == true:
                AudioServer.add_bus_effect(3,AudioEffectReverb.new())
                #AudioServer.add_bus_effect(3,AudioEffectLowPassFilter.new())
                #AudioServer.add_bus_effect(3,AudioEffectFilter.new())
                
                AudioServer.get_bus_effect(3,0).dry = 0.16
                AudioServer.get_bus_effect(3,0).wet = 0.16
                
                theaven.remove_audio_bus_effect()

            


func _on_Button2_pressed(): #Exit Button
    theaven.stop()
    thell.stop()
    
    get_tree().change_scene("res://Mark's Assets/GUI/Runtime Menu/MainMenu.tscn")
    pass # Replace with function body.


func _on_viewport_size_changed():
    # Do whatever you need to do when the window changes!
    
    #print ("Viewport size changed")
    _resize_to_fit()
    
func _resize_to_fit():
    #print (get_viewport().size)
    #$CircleTransition.rect_size = get_viewport().size
    
    $ColorRect.rect_size = get_viewport().size
    $ShaderBackgroundEffect.rect_size = get_viewport().size
    $PauseFront.set_global_position(Vector2(get_viewport().size.x/2-$PauseFront.rect_size.x/2,get_viewport().size.y/2-$PauseFront.rect_size.y/2) )

func _on_Button3_pressed(): #Options
    
    $PauseFront/OptionsPanel/CheckFullscreen.pressed = OS.window_fullscreen
    $PauseFront/OptionsPanel.visible = true
    $PauseFront/OptionsPanel/OptionsBackBtn.grab_focus()
    $PauseFront/PauseMain.visible = false
    
    pass # Replace with function body.


func _on_OptionsBackBtn_pressed(): #Options back to Pause Menu
    $PauseFront/OptionsPanel.visible = false
    $PauseFront/PauseMain/Button3.grab_focus()
    $PauseFront/PauseMain.visible = true
    pass # Replace with function body.


func _on_CreditsBackBtn_pressed():
    $PauseFront/Credits.visible = false
    $PauseFront/PauseMain/CreditsBtn.grab_focus()
    $PauseFront/PauseMain.visible = true
    pass # Replace with function body.


func _on_CreditsBtn_pressed():
    $PauseFront/Credits/CreditsBackBtn.grab_focus()
    $PauseFront/Credits.visible = true
    $PauseFront/PauseMain.visible = false
    pass # Replace with function body.

func _on_ContinueBtn_pressed():
    _toggle_pause()
#	var new_pause_state = not get_tree().paused
#	get_tree().paused = new_pause_state
#	visible = new_pause_state
    pass # Replace with function body.


func _on_CheckFullscreen_toggled(button_pressed):
    #print(button_pressed)
    OS.window_fullscreen = button_pressed
    pass # Replace with function body.


func _on_Reset_pressed():
    _toggle_pause()
    AutoloadControl.level_restart()
    pass # Replace with function body.
