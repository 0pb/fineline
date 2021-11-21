extends Node2D

var velocity = Vector2()

var projectile = preload("res://body/projectile.tscn")

export var xMove = 0
export var yMove = 2
export var shoot_time : float = 1
export var bullet_destroy_time = 3

export var in_hell = false
export var in_heaven = false

var world_shifted = false

func _ready():
	get_node("Timer").set_wait_time(shoot_time)
	get_node("Timer").start()
	
	if in_hell:
		add_to_group("hell")
	if in_heaven:
		add_to_group("heaven")

func timer_timout():
	print("timer timout")

func _on_Timer_timeout():
	
	if world_shifted == false:
		var _projectile = projectile.instance()
		#_projectile.set_name("_projectile")
		#print(name + " creates " + str(_projectile.name) + ", its script is in Enemy.gd")
		if has_node("root/Main"):
			get_node("/root/Main").add_child(_projectile)
		else:
			add_child(_projectile)
		_projectile.name = "EnemyProjectile"
		_projectile.global_transform.origin = global_transform.origin
		_projectile.xMove = xMove
		_projectile.yMove = yMove
		_projectile.get_node("Timer").wait_time = bullet_destroy_time
		_projectile.get_node("Timer").start()
		
		if in_hell:
			_projectile.add_to_group("hell")
		
		if in_heaven:
			_projectile.add_to_group("heaven")
	
	
	pass # Replace with function body.


func disable_on_world_change(bool_):
	if bool_:
		world_shifted = false
	else:
		world_shifted = true
