extends Button

signal pin_pressed

@export var default_icon : Texture
@export var highlighted_icon: Texture
@export var correct_icon : Texture
@export var incorrect_icon : Texture

func _on_pressed():
	emit_signal("pin_pressed", self)


func change_icon(icon_type: int):
	match icon_type:
		0: self.icon = default_icon
		1: self.icon = highlighted_icon
		2: self.icon = correct_icon
		3: self.icon = incorrect_icon
		_: self.icon = default_icon
