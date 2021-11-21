extends Node2D


var posarray = [Vector2(0,0),Vector2(0,0),Vector2(0,0)]

#signal analog_force_change(vector2, analog)
var moveBool = false
var moveDir = 0


# Called when the node enters the scene tree for the first time.
func _ready():

    get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")
    _resize_to_fit()

    if OS.get_name() == "Android":
        visible = true
        show_virtual_controller_output()
    #else:
    #	visible = false

    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    #get_parent().get_parent().gravity()
    _player_movement()
    pass

func _on_viewport_size_changed():
    _resize_to_fit()

    pass

func _resize_to_fit():
    #print (get_viewport().size)
    
    $InvertBtn.rect_position = Vector2(get_viewport().size.x*.80 - 16,get_viewport().size.y*.85 ) #- $InvertBtn.rect_size.x/2
    $PullBtn.rect_position = Vector2(get_viewport().size.x-$PullBtn.rect_size.x -16,get_viewport().size.y*.70)
    $JumpBtn.rect_position = Vector2(get_viewport().size.x-$JumpBtn.rect_size.x -16,get_viewport().size.y*.85)
    
    $LeftBtn.rect_position = Vector2(get_viewport().size.x*.25/2 -$LeftBtn.rect_size.x,get_viewport().size.y*.725) #-$LeftBtn.rect_size.x
    $RightBtn.rect_position = Vector2(get_viewport().size.x*.25/2 + 0,get_viewport().size.y*.725) #-$RightBtn.rect_size.x
    
    


func _on_PauseBtn_pressed():
    if AutoloadControl.is_character_dying == false:
        get_parent().get_node("Pause")._toggle_pause()
    pass # Replace with function body.



func _input(event):
    
    if event is InputEventScreenTouch:
        _touch_and_drag(event)
        _one_touch(event)
        pass
        

    if event is InputEventScreenDrag:
        
        _touch_and_drag(event)
        _drag_only(event)
        
        pass

    _released(event) #getting the release input from the surface (phone screen)

func _one_touch(event):
    
    if OS.get_name() == "Android" || OS.get_name() == "HTML5":
        show_virtual_controller_output()
    
    AutoloadControl.detect_android_on_html = true #to prevent player's walking to slow down because player.gd is also using _move() as well when it has no speed mixed with the _move() here in this script with a speed, it gets half the speed it need.
    var isReleased = isReleased(event)

    if event.position.x > get_viewport().size.x/2: 
        posarray[1] = event.position
        
        if event.position.x > get_viewport().size.x*.80 and event.position.x < get_viewport().size.x*.90 and event.position.y > get_viewport().size.y*.80:
            $Label6.text = "Invert!"
            if isReleased:
                get_parent().get_parent().get_parent()._change_world()
            pass
        elif event.position.x > get_viewport().size.x*.90 and event.position.x < get_viewport().size.x and event.position.y > get_viewport().size.y*.80:
            $Label6.text = "Jump!"
            get_parent().get_parent()._physics_process_input()
            pass
        else:
            $Label6.text = "Out of Tap"

        
        if isReleased and event.position.x > get_viewport().size.x/2:
            posarray[1] = Vector2(0,0)

    $Label2.text = str( posarray[1] )

    pass

func _touch_and_drag(event):
    
    
    
    if event.position.x < get_viewport().size.x/2: 
        posarray[0] = event.position
        #posarray[1] = Vector2(0,0)
        if event.position.x > 0 and event.position.x < get_viewport().size.x*.25/2 and event.position.y > get_viewport().size.y*.45:
            $Label4.text = "Left Movement"
            moveDir = -1
            moveBool = true
        elif event.position.x > get_viewport().size.x*.25/2 and event.position.x < get_viewport().size.x*.25 and event.position.y > get_viewport().size.y*.45:
            $Label4.text = "Right Movement"
            moveDir = 1
            moveBool = true
        else:
            $Label4.text = "Out of Movement"
            moveBool = false
        
        var isReleased = isReleased(event)
        if isReleased:
            posarray[0] = Vector2(0,0)
        
        if posarray[0] == Vector2(0,0):
            moveBool = false

    posarray[2] = event.position

    if event.position.x > get_viewport().size.x/2: 
        if event.position.x > get_viewport().size.x*.90 and event.position.x < get_viewport().size.x and event.position.y > get_viewport().size.y*.65 and event.position.y < get_viewport().size.y*.80:
            $Label5.text = "Pull Crate!"
            get_parent().get_parent().true_if_pulling = true
        else:
            $Label5.text = "Out of Input."
            get_parent().get_parent().true_if_pulling = false
        
        var isReleased = isReleased(event)
        if isReleased:
            posarray[2] = Vector2(0,0)
            get_parent().get_parent().true_if_pulling = false
        

    $Label.text = str( posarray[0] )
    $Label3.text = str( posarray[2] )

    pass

func _drag_only(event):
    
    if event.position.x > get_viewport().size.x/2 and ( posarray[1] == Vector2(0,0) ): #or posarray[1].x > get_viewport().size.x/2
        #posarray[0] = Vector2(0,0)
        pass
    if event.position.x > get_viewport().size.x/2 and event.position.x < get_viewport().size.x: #and posarray[0] == Vector2(0,0)
        posarray[1] = Vector2(0,0)
        pass
    
    $Label.text = str( posarray[0] )
    $Label2.text = str( posarray[1] )
    pass

func isReleased(event):
    if event is InputEventScreenTouch:
        return !event.pressed
    elif event is InputEventMouseButton:
        return !event.pressed

func _released(event):
    var isReleased = isReleased(event)
    
    if isReleased and event.position.x < get_viewport().size.x/2:
        #posarray[0] = Vector2(0,0)
        #$Label.text = str( posarray[0] )
        pass
    
    if isReleased and event.position.x > get_viewport().size.x/2:
        #posarray[1] = Vector2(0,0)
        #$Label2.text = str( posarray[1] )
        pass
    

func _player_movement():
    if moveBool == false:
        moveDir = 0
    
    if OS.get_name() == "Android" || OS.get_name() == "HTML5":
        if AutoloadControl.detect_android_on_html: #This statement still works on mobile version because I don't have any way to tell if it's in html duh...
            get_parent().get_parent().player_sprite_animate(moveDir)
            get_parent().get_parent()._move(moveDir)

func show_virtual_controller_output():
    $PauseBtn.visible = true
    $InvertBtn.visible = true
    $PullBtn.visible = true
    $JumpBtn.visible = true
    $RightBtn.visible = true
    $LeftBtn.visible = true

func hide_virtual_controller_output():
    $PauseBtn.visible = false
    $InvertBtn.visible = false
    $PullBtn.visible = false
    $JumpBtn.visible = false
    $RightBtn.visible = false
    $LeftBtn.visible = false
