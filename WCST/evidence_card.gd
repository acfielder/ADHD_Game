extends Node2D
class_name evidence_card

signal card_pressed

enum Colors {GREEN, BLUE, PURPLE, ORANGE}
enum Shapes {CIRCLE, SQUARE, TRIANGLE, STAR}
enum Counts {ONE, TWO, THREE, FOUR}

const COLORS_STR = {
	Colors.GREEN: "green",
	Colors.BLUE: "blue",
	Colors.PURPLE: "purple",
	Colors.ORANGE: "orange"
}

const SHAPES_STR = {
	Shapes.CIRCLE : "circle",
	Shapes.SQUARE : "square",
	Shapes.TRIANGLE : "triangle",
	Shapes.STAR : "star"
}

const COUNTS_STR = {
	Counts.ONE: "one",
	Counts.TWO: "two",
	Counts.THREE: "three",
	Counts.FOUR: "four"
}

var shape: Shapes
var color: Colors
var count: Counts

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
func choose_set_properties(count_in: String, shape_in: String, color_in: String):
	count = COUNTS_STR.find_key(count_in)
	shape = SHAPES_STR.find_key(shape_in)
	color = COLORS_STR.find_key(color_in)
	#var shape_keys = SHAPES_STR.keys()
	#shape = shape_keys.pick_random()
	#var color_keys = COLORS_STR.keys()
	#color = color_keys.pick_random()

#string of 3 info about physical card - color, shape, count
func get_card_info_string() -> Array: 
	var card_details #= [COLORS_STR[color],SHAPES_STR[shape],COUNTS_STR[count]]
	var s = SHAPES_STR[shape]
	var cou = COUNTS_STR[count]
	var col = COLORS_STR[color]
	card_details = [col,s,cou]
	return card_details


func _on_button_pressed():
	emit_signal("card_pressed",self)
	
