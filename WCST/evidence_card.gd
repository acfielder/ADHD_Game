extends Node2D
class_name evidence_card

signal card_pressed

enum Hats {BEANIE, BUCKET, BOWLER, COWBOY}
enum Glasses {SHADES, CATEYE, BROKENGLASSES, MONOCLE}
enum Clothes {HOODIE, SUIT, TRENCHCOAT, TORNSHIRT}

const HATS_STR = {
	Hats.BEANIE: "beanie",
	Hats.BUCKET: "bucket",
	Hats.BOWLER: "bowler",
	Hats.COWBOY: "cowboy"
}

const GLASSES_STR = {
	Glasses.SHADES: "shades",
	Glasses.CATEYE: "cateye",
	Glasses.BROKENGLASSES: "brokenglasses",
	Glasses.MONOCLE: "monocle"
}

const CLOTHES_STR = {
	Clothes.HOODIE: "hoodie",
	Clothes.SUIT: "suit",
	Clothes.TRENCHCOAT: "trenchcoat",
	Clothes.TORNSHIRT: "tornshirt"
}

var hat: Hats 
var glasses: Glasses 
var clothes: Clothes 

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#visual testing
	#var count = 4
	#while count >2:
	#	give_card_texture("res://Art/WCST/cards/blue_circle_two.png")
	#	await get_tree().create_timer(.5).timeout
	#	give_card_texture("res://Art/WCST/cards/purple_square_three.png")
	#	await get_tree().create_timer(.5).timeout
	#	flip_card_face_down()
	#	await get_tree().create_timer(.5).timeout
	#	count -= 1
	#while count > -5:
	#	choose_set_properties("three")
	#	print(get_card_info_string())
	#	count -= 1
	pass


func give_card_texture(png_path: String):
	var texture = ResourceLoader.load(png_path)
	$Sprite2D.texture = texture
	#save the enum for what the card is	

func flip_card_face_down():
	var texture = ResourceLoader.load("res://Art/WCST/card_back.png")
	$Sprite2D.texture = texture

#update to use parameters
func choose_set_properties(hat_in: String, glasses_in: String, clothes_in: String):
	hat = HATS_STR.find_key(hat_in)
	glasses = GLASSES_STR.find_key(glasses_in)
	clothes = CLOTHES_STR.find_key(clothes_in)
	#var shape_keys = SHAPES_STR.keys()
	#shape = shape_keys.pick_random()
	#var color_keys = COLORS_STR.keys()
	#color = color_keys.pick_random()

#string of 3 info about physical card - color, shape, count
func get_card_info_string() -> Array: 
	var card_details #= [COLORS_STR[color],SHAPES_STR[shape],COUNTS_STR[count]]
	var h = HATS_STR[hat]
	var g = GLASSES_STR[glasses]
	var c = CLOTHES_STR[clothes]
	card_details = [h,g,c]
	return card_details


func _on_button_pressed():
	emit_signal("card_pressed",self)
	
