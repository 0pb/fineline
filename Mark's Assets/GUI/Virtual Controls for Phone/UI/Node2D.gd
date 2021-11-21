extends Node2D

const MAX_POINTS = 10

var points = []

var last_dist = 0
var current_dist = 0
var zoom_rate = 0.1
var zoom_started = false

var last_angle = 0
var current_angle = 0
var rotate_rate = 5
var rotate_started = false

signal on_zoom(val)
signal on_rotate(val)

func _ready():
	for i in range(MAX_POINTS):
		points.append({pos=Vector2(),start_pos=Vector2(),state=false})

	set_process(true)
	set_process_input(true)
	
	connect("on_zoom", self, "scale_sprite")
	connect("on_rotate", self, "rot_sprite")

func _input(event):
	if event.type == InputEvent.SCREEN_DRAG:
		points[event.index].pos = event.pos
	if event.type == InputEvent.SCREEN_TOUCH:
		points[event.index].state = event.pressed
		points[event.index].pos = event.pos
		if event.pressed:
			points[event.index].start_pos = event.pos

	var count = 0
	for point in points:
		if point.state:
			count += 1

	if event.type == InputEvent.SCREEN_TOUCH:
		if !event.pressed and count < 2:
			current_dist = 0
			last_dist = 0
			current_angle = 0
			last_angle = 0
			zoom_started = false
			rotate_started = false
		if event.pressed and count == 2:
			zoom_started = true
			rotate_started = true

	if count == 2:
		handle_zoom(event)
		handle_rotate(event)

func handle_zoom(event):
	if event.type == InputEvent.SCREEN_DRAG:
		var dist = points[0].pos.distance_to(points[1].pos)
		if zoom_started:
			zoom_started = false
			last_dist = dist
			current_dist = dist
		else:
			current_dist = last_dist - dist
			last_dist = dist
		emit_signal("on_zoom", current_dist)

func handle_rotate(event):
	if event.type == InputEvent.SCREEN_DRAG:
		var angle = points[0].pos.angle_to_point(points[1].pos)
		if rotate_started:
			rotate_started = false
			last_angle = angle
			current_angle = angle
		else:
			current_angle = last_angle - angle
			last_angle = angle
		emit_signal("on_rotate", current_angle)

func scale_sprite(val):
	if abs(current_dist) > 0.1 and abs(current_dist) < 20:
		var s = get_node("Sprite").get_scale()
		var zoom = current_dist * zoom_rate
		s.x = clamp(s.x + zoom, 1, 10)
		s.y = clamp(s.y + zoom, 1, 10)
		get_node("Sprite").set_scale(s)

func rot_sprite(val):
	if abs(current_angle) > 0.001 and abs(current_angle) < 0.5:
		var r = get_node("Sprite").get_rot()
		var a = current_angle * rotate_rate
		get_node("Sprite").set_rot(r-a)

func _process(delta):
	update()

func _draw():
	for i in range(points.size()):
		var c = Color(1,0,0)
		if !points[i].state:
			c = Color(0,0,1)
		draw_circle(points[i].pos, 32, c)
		draw_circle(points[i].start_pos, 32, Color(0,1,0))
		draw_line(points[i].pos, points[i].start_pos, Color(1,1,0), 4)
