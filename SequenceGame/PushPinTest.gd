extends Button

signal pin_pressed


func _on_button_pressed():
	emit_signal("pin_pressed", self)
