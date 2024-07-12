extends Node2D
class_name EvidenceTrialCard

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func give_card_texture(png_path: String):
	var texture = ResourceLoader.load(png_path) #may not need to load if already used in another scene, check again
	$Sprite2D.texture = texture
	#this may need to be more complex so that the base are dynamic but always fit certain requirements

func flip_card_face_down():
	var texture = ResourceLoader.load("res://Art/WCST/card_back.png")
	$Sprite2D.texture = texture
