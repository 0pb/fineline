extends Node2D


var transitionincrBool = false
var transitionincr = 1
var what_scene_index = 1


# Called when the node enters the scene tree for the first time.
func _ready():
    
    _resize_to_fit()
    get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")
    
    pass # Replace with function body.

func _on_viewport_size_changed():
    _resize_to_fit()

func _resize_to_fit():
    #print(get_viewport().size)
    $CircleTransition.rect_size = get_viewport().size
    $ColorRect.rect_size = get_viewport().size
    $ColorRect2.rect_size = get_viewport().size
    #$Panel.set_global_position(Vector2(get_viewport().size.x/2-$Panel.rect_size.x/2,get_viewport().size.y/2-$Panel.rect_size.y/2) )
    $Button.set_global_position(Vector2(get_viewport().size.x/2-$Button.rect_size.x/2,get_viewport().size.y*.80) )
    $Credits.set_global_position(Vector2(get_viewport().size.x/2-$Credits.rect_size.x/2,0) )



func _on_Button_pressed():
    $EndingAudioPlayer.stop()
    transitionincrBool = true
    $CircleTransition.mouse_filter = $CircleTransition.MOUSE_FILTER_STOP
    pass # Replace with function body.


func _physics_process(_delta):
    if transitionincrBool:
        if transitionincr < -.25:
            transitionincrBool = false
            if what_scene_index == 1:
                get_tree().change_scene("res://Mark's Assets/GUI/Runtime Menu/MainMenu.tscn")

        $CircleTransition.get_material().set_shader_param("circle_size", transitionincr) #
        transitionincr -= 0.02
