tool
extends Control

#Note: The bubble resize effect is not written in this code it's in Dialog.gd. Its location is you search and find the word 'BubbleDialog' since it's used as its conditional

var _name
var _subject
var _dialog
var _profile

var _theme : Theme = preload("res://Mark's Assets/Text Dialog Assets/addons/My RPG Text Dialogue/default_theme.tres")
var _dialog_font  : Font = _theme.default_font

func _draw():
	var center = Vector2(200, 200)
	var radius = 80
	var angle_from = 75
	var angle_to = 195
	var color = Color(1.0, 0.0, 0.0)
	#draw_circle_arc(center, radius, angle_from, angle_to, color)
	pass

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func _ready():
	
	if Engine.is_editor_hint() == false:
		_theme = $Dialog._export_theme
		_dialog_font = _theme.default_font

		$Dialog.rect_position = Vector2(8,5)
		set_size(Vector2($Dialog._dialog_font.get_string_size($Dialog/RichTextLabel.text).x,$Dialog._dialog_font.get_string_size($Dialog/RichTextLabel.text).y))
		$Dialog.dialog_ready()
		
		if $Dialog.DialogSendArray.empty():
			print("Bubble Dialog been queue freed because there is no appended text added otherwise I'd get an error.")
			queue_free()
		
	pass
