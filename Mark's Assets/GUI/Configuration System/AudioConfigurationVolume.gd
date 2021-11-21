extends Panel

#export var func_name = "" #erase it on the next commit of github repository (currently on the 7th)
export var volume_type = ""

# Called when the node enters the scene tree for the first time.
func _ready():
    name = volume_type + "Volume"
    $Name.text = volume_type + " Volume"
    #$HSlider.connect("value_changed",get_parent(),"_on_value_changed", [ volume_type ])
    $HSlider.connect("value_changed",get_parent().get_parent(),"_on_value_changed", [ volume_type ])
    $HSlider.connect("value_changed",self,"_on_value_changed", [ volume_type ])
    
    #$Name.get_combined_minimum_size()
    $Name.set_position( Vector2(rect_size.x/2-$Name.get_combined_minimum_size().x/2,$Name.get_transform().get_origin().y) )
    #$Volume.set_position(Vector2(-30  , get_transform().get_origin().y))

func _on_value_changed(value, audio_bus_index):
    #print(volume_type)
    if value == $HSlider.min_value:
        AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus_index),-80)
    else:
        AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus_index),value)
    pass
