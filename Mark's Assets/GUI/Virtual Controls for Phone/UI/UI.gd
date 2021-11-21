extends Control


func _on_AnalogLeft_analog_force_change(vector2, analog):
	print(analog.analogName + ": ", vector2)
	pass # Replace with function body.


func _on_AnalogRight_analog_force_change(vector2, analog):
	print(analog.analogName + ": ", vector2)
	pass # Replace with function body.
