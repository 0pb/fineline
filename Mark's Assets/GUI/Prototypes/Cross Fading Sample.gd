extends Node2D


onready var tween_out = get_node("Tween")

onready var tween_out2 = get_node("Tween2")

export var transition_duration = 0.50
export var transition_type = 1 # TRANS_SINE

func fade_out():
    
    tween_out2.interpolate_property($ColorRect, "self_modulate", Color(1, 1, 1, $ColorRect.self_modulate.a), Color(1, 1, 1, 0), .5, transition_type, Tween.EASE_IN, 0)
    tween_out2.start()
   


func _on_FadeInBtn_pressed():
    
    tween_out2.interpolate_property($ColorRect, "self_modulate", Color(1, 1, 1, $ColorRect.self_modulate.a), Color(1, 1, 1, 1), .5, transition_type, Tween.EASE_IN, 0)
    tween_out2.start()
    
    pass # Replace with function body.


func _on_FadeOutBtn_pressed():
    
    pass # Replace with function body.


func _on_Tween_tween_all_completed():
    # stop the music -- otherwise it continues to run at silent volume
    #object.stop()
    pass # Replace with function body.


func _on_ToggleFadeInAndOutBtn_pressed():
    toggle_fade()
    pass # Replace with function body.

func toggle_fade():
    if $ColorRect2.self_modulate.a == 0:
        # tween music volume down to 0
        tween_out.interpolate_property($Heaven, "volume_db", $Heaven.volume_db, 0, transition_duration-.25, transition_type, Tween.EASE_IN, 0)
        tween_out.start()
        $Tween4.interpolate_property($Hell, "volume_db", $Hell.volume_db, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
        $Tween4.start()
         # when the tween ends, the music will be stopped
        
        $Tween3.interpolate_property($ColorRect2, "self_modulate", Color(1, 1, 1, $ColorRect2.self_modulate.a), Color(1, 1, 1, 1), transition_duration, transition_type, Tween.EASE_IN, 0)
        $Tween3.start()
        $Tween5.interpolate_property($ColorRect3, "self_modulate", Color(1, 1, 1, $ColorRect3.self_modulate.a), Color(1, 1, 1, 0), transition_duration, transition_type, Tween.EASE_IN, 0)
        $Tween5.start()
    elif $ColorRect2.self_modulate.a == 1:
        
        # tween music volume down to 0
        tween_out.interpolate_property($Heaven, "volume_db", $Heaven.volume_db, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
        tween_out.start()
        $Tween4.interpolate_property($Hell, "volume_db", $Hell.volume_db, 0, transition_duration-.25, transition_type, Tween.EASE_IN, 0)
        $Tween4.start()
        # when the tween ends, the music will be stopped
        
        $Tween3.interpolate_property($ColorRect2, "self_modulate", Color(1, 1, 1, $ColorRect2.self_modulate.a), Color(1, 1, 1, 0), transition_duration, transition_type, Tween.EASE_IN, 0)
        $Tween3.start()
        $Tween5.interpolate_property($ColorRect3, "self_modulate", Color(1, 1, 1, $ColorRect3.self_modulate.a), Color(1, 1, 1, 1), transition_duration, transition_type, Tween.EASE_IN, 0)
        $Tween5.start()
        


