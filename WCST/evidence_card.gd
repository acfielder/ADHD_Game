extends Node2D
class_name evidence_card

signal card_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#visual testing
	var count = 10
	while count >2:
		give_card_texture("res://Art/WCST/cards/card_blue_circle_two.png")
		await get_tree().create_timer(.5).timeout
		give_card_texture("res://Art/WCST/cards/card_purple_square_three.png")
		await get_tree().create_timer(.5).timeout
		flip_card_face_down()
		await get_tree().create_timer(.5).timeout
		count -= 1
	


func give_card_texture(png_path: String):
	var texture = ResourceLoader.load(png_path) #may not need to load if already used in another scene, check again
	$Sprite2D.texture = texture

func flip_card_face_down():
	var texture = ResourceLoader.load("res://Art/WCST/cards/card_back.png")
	$Sprite2D.texture = texture


func _on_button_pressed():
	emit_signal("card_pressed",self)
