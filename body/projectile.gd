extends Area2D

#var velocity = Vector2()
var xMove = 0
var yMove = 0

var world_shifted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#velocity.x += xMove
	#velocity.y += yMove
	#velocity = move_and_slide(velocity)
	transform.origin.x += xMove
	transform.origin.y += yMove
	
#	pass


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.


func _process(delta):
	pass



func _on_Projectile_body_shape_entered(body_id, body, body_shape, area_shape):
	
	if get_overlapping_bodies().size() > 0:
		var getOverlappingBodies = get_overlapping_bodies()
		for i in getOverlappingBodies.size():
			if getOverlappingBodies[i].name == "player":
				
				
				
				if get_node("/root/Main").has_node("player"): #Prevent errors if player node didn't exist.
					
					if world_shifted == false:
						AutoloadControl.player_death()
					
					pass
					
				
				
				pass
			pass
		pass
	pass
	
	queue_free()
	
	pass # Replace with function body.

func disable_on_world_change(bool_):
	if bool_:
		world_shifted = false
	else:
		world_shifted = true
