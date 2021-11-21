extends Control

#var _theme : Theme = preload("res://Text Dialog Assets/addons/My RPG Text Dialogue/default_theme.tres")
export var _export_theme : Theme = preload("res://Mark's Assets/Text Dialog Assets/addons/My RPG Text Dialogue/default_theme.tres")
var _dialog_font  : Font #= _export_theme.default_font

var dialogScript = [] #It's now commonly used as a type of an array variable that collects minimally from its sister back-end variable "DialogSendArray" to send its output to dialogDeliverance with minimum memory consumption during gameplay. It is also used in dialog_append function if the variable's text is too long and will cut its length that fits in the dialog box. It also clears its data quite often as it only relies much of its data from DialogSendArray as it changes.
var dialogDeliverance : String = "" #Deliver one of its dialogScript indexes to the output (it's like a kernel version) as a tunnel or body to text or other back-end variables (Label.text, RichTextLabel.text, variables for updateText(), dialog_append)

var scriptIndex = 0 #it can also be considered as your array index (used for dialogScript array to define its index by input)

#variables for updateText() method
var textCount = 0 #uses to update the incrementation of the next character taken from the dialogDeliverance. It increments until it reaches the length of dialogDeliverance
var subText : String = "" #separated by dialogDeliverance, it has its own purpose: use dialogDeliverance to make new line of the label as its advantage.
var dialogCanvasWidth = 400 #the minimum width before it creates a new line when it reaches the width boundary (related to textCount_nextBoundary, they cooperate by conditional statements)
var dialogCanvasHeight = 500 #the minimum height before it resets its dialog back from the top

#New Variables after the 4th commit (VERSION 2 branch)
var dialogTextCurrent_y = 0
onready var scriptOutputNode = $RichTextLabel
var chars_per_sec = 32 #characters per second
var richTextLabel_fix = 0 #a variable in the updateText(), it is widely used to not include the '[RichTextLabel_Effects]' when writing the text in the dialog window otherwise I get this almost empty dialog in certain line/s. It is used in while loops of updateText().

#New Variables after 6 Commits (VERSION 2 branch)
var DialogSendArray = [] #A back-end variable used for a list of data on the text that collects data by complex management that doesn't consume a lot of memory (which causes lag) when loading a dialog data text in different files (.csv) and will add for its another twin sister back-end variable of dialogScript designed pass through the output that I will see... I guess
#DialogSendArray was previously named as "scriptBoardArray" needs to be renamed = pass this dialog to dialogScript = sendThisDialog_Manager = needs a hire to do the position = dialog sender = DialogSendArray
var DialogSendArray_index = 0

signal textflow_started #must add a function, or you get an error
signal textflow_completed #must add a function, or you get an error
signal dialog_started #must add a function, or you get an error
signal dialog_ended #must add a function, or you get an error

var set_dialog_name = "BubbleDialog"#Used as a back-end for bubble dialog

#Okay that ends for now, my work has been proven fixed so far I can't tell anything what to think next that is possibly wrong. I'm sleepy I can't think anything anymore I stop the record now.

func _init():
	if Engine.is_editor_hint() == false:
		add_font_override("font",_dialog_font )

func _ready():
	
	theme = _export_theme
	_dialog_font = _export_theme.default_font
	$RichTextLabel.theme = _dialog_font
	$Label.theme = _dialog_font
	
	#
	if get_tree().get_root().has_node("Dialog"):#to prevent error when its parent isn't in the officially created of my DialogWindow.tscn node
		print("Dialog node has been queue_free() or removed because it has no DialogWindow parent.")
		queue_free()
	
	if DialogSendArray.empty() && !get_tree().get_root().has_node("BubbleDialog"): #to prevent error if I run it in DialogWindow.tscn directly
		#print("EMPTY!!")
		DialogSendArray.append("Adding a default line when the system has no dialog added. If I don't add a default dialog, it will catch a 'division by zero' error.")
	
	connect("textflow_completed",self,"_textflow_completed") 
	connect("textflow_started",self,"_textflow_started")
	connect("dialog_started",self,"_dialog_started")
	connect("dialog_ended",self,"_dialog_ended")
	
	emit_signal("_dialog_started")
	
	if get_tree().get_current_scene().get_name() != "Dialog":
		if DialogSendArray.empty():
			#if get_tree().get_root().has_node("DialogWindow"):
			#get_parent().queue_free()#This code won't work in its Dialog.tscn because its parent is a root which it doesn't have a node parent, the game will freeze so be careful.
			#queue_free()
			#print("gfree")
			pass
		

func dialog_ready():#This function was created for DialogWindow parent node in DialogWindow.tscn so the array append might work.
	if Engine.is_editor_hint() == false:
		#Custom Throw Exception (it isn't the professional way, I don't know what is GDScript's throw exception really is...)
		if scriptOutputNode.get_class() != "Label" && scriptOutputNode.get_class() != "RichTextLabel":
			print("Exiting Godot, please use Label or RichTextLabel for your scriptOutputNode as your Node.'")
			get_tree().quit()
			pass
		
		dialogCanvasWidth = rect_size.x
		dialogCanvasHeight = rect_size.y
		
		if get_tree().get_root().has_node("DialogWindow"):
			#print("DialogWindow has_node is true, no codes written for now... output comes from Dialog.gd or Dialog Node.")
			#dialogCanvasWidth = get_parent().rect_size.x
			#dialogCanvasHeight = get_parent().rect_size.y
			pass
		else:
			#print("DialogWindow parent NOT found.")
			pass
		
		$ColorRect.margin_right = dialogCanvasWidth
		$ColorRect.margin_bottom = dialogCanvasHeight
		$ColorRect.visible = false
		
		scriptOutputNode.margin_right = dialogCanvasWidth
		scriptOutputNode.margin_bottom = dialogCanvasHeight
		
		if DialogSendArray.empty():
			#print("DialogSendArray is empty, free the node")
			#get_parent().queue_free() #This code won't work in its Dialog.tscn because its parent is a root which it doesn't have a node parent, the game will freeze so be careful.
			pass
		else:
			dialog_append(DialogSendArray[DialogSendArray_index])
			#I like to add a feature that I can add more scripts without resetting the dialog. It can be used if the other scripts weren't used and others were such as decision making.
			dialogDeliverance = dialogScript[scriptIndex]

			scriptOutputNode.get_node("AnimationPlayer").playback_speed = float(chars_per_sec)/dialogDeliverance.length()

			#I had to use these varaibles because I'm using updateText() its values are on edge and needs to be restarted to nothing
			textCount = 0 #without this, the text will be empty
			scriptOutputNode.text = "" # without this, it will print the whole string at start crossing dialog height if i used $Label
			if scriptOutputNode is RichTextLabel: scriptOutputNode.bbcode_text = "" #this code saved me
			for i in dialogDeliverance.length():
				updateText()
				pass
			pass
		
		#Bubble Dialog resize fixing for first text appearing.
		_bubble_dialog_conditional()
	pass

func _input(event):
	if Engine.is_editor_hint() == false && event is InputEventKey:
		var forward_backward_input : bool = false
		var input = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
		if forward_backward_input == false: input = Input.get_action_strength("ui_accept")
		
		var assignedButtons : bool = (Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_left")) #(event.scancode == KEY_RIGHT || event.scancode == KEY_LEFT)
		if forward_backward_input == false: assignedButtons = (Input.is_action_just_pressed("ui_accept")) #(event.scancode == KEY_ENTER || event.scancode == KEY_KP_ENTER)
		
		if assignedButtons && input != 0:
			if scriptOutputNode.get_node("AnimationPlayer").get_current_animation_position() >= scriptOutputNode.get_node("AnimationPlayer").get_current_animation_length():
				scriptIndex += sign(input)
				
				
				if scriptIndex >= 0:
					textCount = 0
					scriptOutputNode.text = ""
					if scriptOutputNode.get_class() == "RichTextLabel": scriptOutputNode.bbcode_text = ""
					
				if scriptIndex > dialogScript.size()-1:
					if (DialogSendArray_index < DialogSendArray.size()-1):
						DialogSendArray_index += 1
						dialog_append(DialogSendArray[DialogSendArray_index])
						#print("dialogScript.size(): " + str(dialogScript.size()))
					else: 
						emit_signal("_dialog_ended")
						get_parent().queue_free() #This code won't work in its Dialog.tscn because its parent is a root which it doesn't have a node parent, the game will freeze so be careful.
				
				if scriptIndex < 0:
					scriptIndex = 0
				else:
					#SystemControl._play_sound("res://Multimedia/Sound Assets/DialogBox_Next.wav")
					scriptOutputNode.get_node("AnimationPlayer").stop(true)
					scriptOutputNode.get_node("AnimationPlayer").play()
					scriptOutputNode.visible = false
					if DialogSendArray_index < DialogSendArray.size()-1 || scriptIndex < dialogScript.size(): 
						dialogDeliverance = dialogScript[scriptIndex]
					scriptOutputNode.get_node("AnimationPlayer").playback_speed = float(chars_per_sec)/dialogDeliverance.length()
					if DialogSendArray_index < DialogSendArray.size():
						for textCount in dialogDeliverance.length():
							updateText()
							pass
					
					_bubble_dialog_conditional()
			else: 
				scriptOutputNode.get_node("AnimationPlayer").seek(1,true)
				#print("SKIP")
				emit_signal("textflow_completed")
				pass
			
			if (input != 0): scriptOutputNode.visible = true #I get troubles when I press the button for the next dialogue and it shows its whole dialogue in a micro second before it goes empty and start its text flow which made me uncomfortable. This code is one of the biggest contributions ever so far...

func _bubble_dialog_conditional():
	if get_parent().name == set_dialog_name:#used for Bubble Dialog scene
		#textCount_nextBoundary += dialogCanvasWidth - ((textCount_nextBoundary+dialogCanvasWidth) - _dialog_font.get_string_size(subText).x)
		#If I ever get confused why I made this function for another function? It's because this conditional statement
		#is been used on 2 functions (_input and dialog_ready) and I want to make the code a bit shorter so I make a 
		#function like this. I can copy paste this code below and put it on where the function is placed and it will 
		#work the same way as this one.
		if _dialog_font.get_string_size($RichTextLabel.text).x < dialogCanvasWidth: 
			print("bubble dialog resize, text is shorter than the width")
			get_parent().get_node("Panel").set_size(Vector2(_dialog_font.get_string_size($RichTextLabel.text).x+(rect_position.x*2),_dialog_font.get_string_size($RichTextLabel.text).y+(rect_position.y*2)))
			#print(_dialog_font.get_string_size($RichTextLabel.text).x)
		else: 
			get_parent().get_node("Panel").set_size(Vector2(dialogCanvasWidth+(rect_position.x*2),_dialog_font.get_string_size($RichTextLabel.text).y*2+(rect_position.y*2)))
			print("Width is Larger, set its bubble dialog to its largest size.")
			#print(textCount_nextBoundary)
		
		#dialogTextCurrent_y
		#print(_dialog_font.get_string_size($Dialog/RichTextLabel.text))
		pass

func _textflow_started():
	
	pass
func _textflow_completed():
	
	pass

func _dialog_ended():
	
	pass
func _dialog_started():
	
	pass

func _dialog_ended_emit_signal():#I added this function because of electrical pad for plot linear 6-7 not working as I expect.
	emit_signal("dialog_ended") 


func _process(delta):
	if Engine.is_editor_hint() == true:
		$ColorRect.margin_right = rect_size.x
		$ColorRect.margin_bottom = rect_size.y
		pass

func updateText():
	scriptOutputNode.text += dialogDeliverance.substr(textCount,1)
	if scriptOutputNode.get_class() == "RichTextLabel": scriptOutputNode.bbcode_text += dialogDeliverance.substr(textCount,1)
	subText = dialogDeliverance.substr(0,textCount+1)
	
	if textCount < dialogDeliverance.length():#(back-end) this conditional statement is for 1 word detection (back-end)
		textCount += 1
	else:
		pass

#This is the function to add your script dialog
func dialog_append(string : String, idx : int = dialogScript.size()):
	dialogDeliverance = str(string)
	var lastTextCount = 0
	
	while true:
		dialogTextCurrent_y = 0 
		for textCount in dialogDeliverance.length():
			updateText()
			
			if dialogTextCurrent_y >= dialogCanvasHeight - _dialog_font .get_string_size("").y: #Defining Dialog Height on the value it should stop
				break
			pass
		
		dialogScript.append( dialogDeliverance.substr(lastTextCount,textCount-lastTextCount) )
		if scriptOutputNode is RichTextLabel: scriptOutputNode.bbcode_text = ""
		
		lastTextCount = textCount
		if textCount >= dialogDeliverance.length():
			break
	
	textCount = 0 
	scriptOutputNode.text = "" 
	
	pass

func _on_AnimationPlayer_animation_started_RichTextLabel(anim_name):
	emit_signal("textflow_started")
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished_RichTextLabel(anim_name):
	emit_signal("textflow_completed")
	pass # Replace with function body.
