extends Node2D

var transitionincr = 1
var transitionincrBool = false

var what_scene_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    AutoloadControl.back_to_main_menu()
    $MenuMenuMusic.play()

    get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")
    $Panel/Buttons/PlayBtn.grab_focus()

    $CircleTransition.visible = true
    $CircleTransition.get_material().set_shader_param("circle_size", 1) #

    _resize_to_fit()

    if OS.get_name() == "HTML5":
        $Panel/Buttons/ExitBtn.visible = false
        $"Panel/HTML Disclaimer".visible = true

    get_tree().paused = false #This is used to prevent Main Menu from pausing (input not working) after exiting a pause menu in the game.

    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    if transitionincrBool:
        $CircleTransition.mouse_filter = $CircleTransition.MOUSE_FILTER_STOP
        if transitionincr < -.25:
            transitionincrBool = false
            if what_scene_index == 1:
                get_tree().change_scene("res://maps/map_01.tscn")
            elif what_scene_index == 2:
                get_tree().change_scene("res://maps/map_select.tscn")

        $CircleTransition.get_material().set_shader_param("circle_size", transitionincr) #
        transitionincr -= 0.02
        
        #print(transitionincr)
    pass


func _on_viewport_size_changed():
    _resize_to_fit()

func _resize_to_fit():
    #print(get_viewport().size)
    $CircleTransition.rect_size = get_viewport().size
    #$Panel.set_global_position(Vector2(get_viewport().size.x/2-$Panel.rect_size.x/2,get_viewport().size.y/2-$Panel.rect_size.y/2) )
    $Panel.set_global_position(Vector2(get_viewport().size.x/2-$Panel.rect_size.x/2,get_viewport().size.y/2-$Panel.rect_size.y/2) )


func _on_PlayBtn_pressed():
    #get_tree().change_scene("res://maps/map_02.tscn")

    #$CircleTransition.get_material().get_shader_param("circle_size")
    $Panel/Buttons.visible = false
    #$Panel/Title.visible = false
    
    $MenuMenuMusic.stop()
    
    var audio = AudioStreamPlayer.new()
    add_child(audio)
    audio.stream = load("res://music/start.wav")
    audio.play()
    audio.volume_db = -6
    audio.bus = "Music"
    
    audio.connect("finished", self, "is_start_audio_finished")
    pass # Replace with function body.

func is_start_audio_finished():
    transitionincrBool = true
    what_scene_index = 1



func _on_ExitBtn_pressed():
    get_tree().quit()
    print("QUIT!")
    pass # Replace with function body.


func _on_OptionBtn_pressed():
    $Panel/Buttons.visible = false
    $Panel/OptionsPanel.visible = true
    $Panel/OptionsPanel/OptionsBackBtn.grab_focus()
    $Panel/OptionsPanel/CheckFullscreen.pressed = OS.window_fullscreen
    pass # Replace with function body.


func _on_OptionsBackBtn_pressed():
    $Panel/Buttons.visible = true
    $Panel/OptionsPanel.visible = false
    $Panel/Buttons/OptionBtn.grab_focus()
    pass # Replace with function body.


func _on_LevelSelect_pressed():
    $MenuMenuMusic.stop()
    transitionincrBool = true
    what_scene_index = 2


func _on_CreditBtn_pressed():
    $Panel/Buttons.visible = false
    $Panel/Credits.visible = true
    $Panel/Credits/CreditsBackBtn.grab_focus()
    pass # Replace with function body.


func _on_CreditsBackBtn_pressed():
    $Panel/Buttons.visible = true
    $Panel/Credits.visible = false
    $Panel/Buttons/CreditBtn.grab_focus()
    pass # Replace with function body.


func _on_CheckFullscreen_toggled(button_pressed):
    OS.window_fullscreen = button_pressed
    pass # Replace with function body.


