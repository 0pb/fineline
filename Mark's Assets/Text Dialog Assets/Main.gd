extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DialogWindowBtn_pressed():
	
	var instance_name = "DialogWindow"
	
	if !has_node(instance_name):
		print("Create a Dialog on this!")
		var scene = preload("res://Mark's Assets/Text Dialog Assets/addons/My RPG Text Dialogue/DialogWindow/DialogWindow.tscn")
		var scene_instance = scene.instance()
		
		scene_instance.get_node("Dialog").DialogSendArray.append("This is a dialogue test.")
		scene_instance.get_node("Dialog").DialogSendArray.append("It's amazing that this is working very well.")
		scene_instance.get_node("Dialog").DialogSendArray.append("Oh and by the way, you're awesome.")
		
		scene_instance.set_name(instance_name)
		add_child(scene_instance)
		
		scene_instance.rect_position = Vector2(0,0)
	
	pass # Replace with function body.


func _on_BubbleDialogBtn_pressed():
	
	var instance_name = "BubbleWindow"
	
	if !has_node(instance_name):
		print("Create a Dialog on this!")
		var scene = preload("res://Mark's Assets/Text Dialog Assets/addons/My RPG Text Dialogue/BubbleDialog/BubbleDialog.tscn")
		var scene_instance = scene.instance()
		
		scene_instance.get_node("Dialog").DialogSendArray.append("This is a dialogue test.")
		scene_instance.get_node("Dialog").DialogSendArray.append("It's amazing that this is working very well.")
		scene_instance.get_node("Dialog").DialogSendArray.append("Oh and by the way, you're awesome.")
		scene_instance.get_node("Dialog").DialogSendArray.append("Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test TestTest Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test.")
		
		scene_instance.set_name(instance_name)
		add_child(scene_instance)
		
		scene_instance.rect_position = Vector2(500,400)
		
		
	pass # Replace with function body.
