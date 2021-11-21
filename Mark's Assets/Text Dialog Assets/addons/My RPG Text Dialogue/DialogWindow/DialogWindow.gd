extends Panel

var _name
var _subject
var _dialog
var _profile

signal dialogWindow_created
signal dialogWindow_removed

var is_dialog_scene_active_activation : bool = false

func _ready():
	$Panel.visible = false
	
	
	#$Dialog.DialogSendArray.append("Hello, this is a dialog.")
	#$Dialog.DialogSendArray.append("I hope we can make an amazing experience for everyone!")
	
	connect("dialogWindow_created",self,"_dialogWindow_created") 
	connect("dialogWindow_removed",self,"_dialogWindow_removed")
	
	$Dialog.dialog_ready()
	pass

func _dialogWindow_created():
	
	pass
func _dialogWindow_removed():
	
	pass

func _on_Timer_timeout():
	#print("timeout!")
	if $Dialog.scriptOutputNode.get_node("AnimationPlayer").get_current_animation_position() >= $Dialog.scriptOutputNode.get_node("AnimationPlayer").get_current_animation_length():
		$Panel.visible = not $Panel.visible
		#$Timer.start(0)
	else:
		$Panel.visible = false
	pass # Replace with function body.


func _on_Dialog_textflow_completed():
	$Timer.start(0)
	$Panel.visible = true
	pass # Replace with function body.

func _on_Dialog_textflow_started():
	$Panel.visible = false
	pass # Replace with function body.

func _on_Dialog_dialog_started():
	#print("Dialog started")
	emit_signal("dialogWindow_created")
	pass # Replace with function body.

func _on_Dialog_dialog_ended():
	#print("Dialog ended")
	print(is_dialog_scene_active_activation)
	if is_dialog_scene_active_activation == true:
		#SystemControl.is_dialog_scene_active = false
		#print("DID IT WORK?")
		pass
	emit_signal("dialogWindow_removed")
	pass # Replace with function body.
