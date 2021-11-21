extends Control

var defaultValue = -5

# Called when the node enters the scene tree for the first time.
func _ready():
    
    $Panel/MasterVolume/HSlider.value = AutoloadControl.MasterVol
    $Panel/SoundVolume/HSlider.value = AutoloadControl.SoundVol
    $Panel/MusicVolume/HSlider.value = AutoloadControl.MusicVol#defaultValue
    
    update_volume("MasterVolume")
    update_volume("SoundVolume")
    update_volume("MusicVolume")
    
#	if has_node("Panel/" + "MusicVolume/Volume"):
#
#		get_node("Panel/" + "MusicVolume/Volume").text = str($Panel/MusicVolume/HSlider.value) + " decibel/s"
#
#		get_node("Panel/" + "MusicVolume/Volume").set_position(Vector2(get_node("Panel/" + "MusicVolume").rect_size.x/2 - get_node("Panel/" + "MusicVolume/Volume").get_combined_minimum_size().x/2  ,31.139))
        
    pass # Replace with function body.

func update_volume(index):
    if has_node("Panel/" + index + "/Volume"): 
        get_node("Panel/" + index + "/Volume").text = str(get_node("Panel/" + index + "/HSlider").value) + " decibel/s"
        get_node("Panel/" + index + "/Volume").set_position(Vector2(get_node("Panel/" + index).rect_size.x/2 - get_node("Panel/" + index + "/Volume").get_combined_minimum_size().x/2  ,31.139))
    else:
        print(str(index) + "/Volume" + " node path doesn't exist... fix it please.'")

func _on_value_changed(value, audio_bus_index):
    #get_node(volume_type+str("Volume/Volume")).text = str(value) + "%"
    #print(str(volume_type))
    #var test = "Master"
    
    
    if audio_bus_index == "Master":
        AutoloadControl.MasterVol = value
    elif audio_bus_index == "Sound":
        AutoloadControl.SoundVol = value
    
    update_volume(str(audio_bus_index) + "Volume")
#	if has_node("Panel/" + str(audio_bus_index) + "Volume/Volume"):
#
#		get_node("Panel/" + str(audio_bus_index) + "Volume/Volume").text = str(value) + " decibel/s"
#
#		get_node("Panel/" + str(audio_bus_index) + "Volume/Volume").set_position(Vector2(get_node("Panel/" + str(audio_bus_index) + "Volume").rect_size.x/2 - get_node("Panel/" + str(audio_bus_index) + "Volume/Volume").get_combined_minimum_size().x/2  ,31.139))
#
#		#$Panel/Title.text
#	else:
#		print(str(audio_bus_index) + "Volume/Volume" + " node path doesn't exist... fix it please.'")
    

func _on_HSlider_value_changed(value):
    AutoloadControl.MusicVol = value
