extends Node
class_name wcstTrialInfo

enum Colors {GREEN, BLUE, PURPLE}
enum Shapes {CIRCLE, SQUARE, TRIANGLE}
enum Counts {ONE, TWO, THREE, FOUR}

var COLORS_STR = {
	Colors.GREEN: "green",
	Colors.BLUE: "blue",
	Colors.PURPLE: "purple",
}

var SHAPES_STR = {
	Shapes.CIRCLE : "circle",
	Shapes.SQUARE : "square",
	Shapes.TRIANGLE : "triangle"
}

var COUNTS_STR = {
	Counts.ONE: "one",
	Counts.TWO: "two",
	Counts.THREE: "three",
	Counts.FOUR: "four"
}


var trial_num : int

var successful : bool #whether or not the trial was successful
var r_t : float #reaction time in sorting card
var sort_press : bool = false #whether or not the player sorted the card

var shape : Shapes
var color : Colors
var count : Counts

var rng = RandomNumberGenerator.new()

func _ready():
	set_card_type(1)
	print(get_card_info_string())
	set_card_type(2)
	print(get_card_info_string())

#select card type based on phase (1 or 2)
func set_card_type(phase: int): 
	var rand_shape
	var rand_color
	var rand_count
	match phase:
		1:
			rand_shape = rng.randi_range(0, 2)
			rand_color = rng.randi_range(0, 2)
			rand_count = rng.randi_range(0, 2)	
		2:
			rand_shape = rng.randi_range(0, 2)
			rand_color = rng.randi_range(0, 2)
			rand_count = rng.randi_range(0, 3)
	shape = Shapes.values()[rand_shape]
	print(shape)
	color = Colors.values()[rand_color]
	count = Counts.values()[rand_count]

#string of 3 info about physical card - color, shape, count
func get_card_info_string() -> Array: 
	var card_details #= [COLORS_STR[color],SHAPES_STR[shape],COUNTS_STR[count]]
	var s = SHAPES_STR[shape]
	var cou = COUNTS_STR[count]
	var col = COLORS_STR[color]
	card_details = [col,s,cou]
	return card_details
	
func set_sort_press_true():
	sort_press = true
	
func set_r_t(r_t_in: float):
	r_t = r_t_in
