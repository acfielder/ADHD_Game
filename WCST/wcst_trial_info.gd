extends Node
class_name wcstTrialInfo


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


var trial_num : int

var successful : bool #whether or not the trial was successful
var r_t : float = -1 #reaction time in sorting card
var sort_press : bool = false #whether or not the player sorted the card

var hats : Hats
var glasses : Glasses
var clothes : Clothes

var rng = RandomNumberGenerator.new()

func _ready():
	#set_card_type(1)
	#print(get_card_info_string())
	#set_card_type(2)
	#print(get_card_info_string())
	pass

#select card type based on phase (1 or 2)
func set_card_type(phase: int): 
	var rand_hat
	var rand_glasses
	var rand_clothes
	match phase:
		1:
			rand_hat = rng.randi_range(0, 2)
			rand_glasses = rng.randi_range(0, 2)
			rand_clothes = rng.randi_range(0, 2)	
		2:
			rand_hat = rng.randi_range(0, 3)#become 3
			rand_glasses = rng.randi_range(0, 3)#become 3
			rand_clothes = rng.randi_range(0, 3)
	hats = Hats.values()[rand_hat]
	glasses = Glasses.values()[rand_glasses]
	clothes = Clothes.values()[rand_clothes]

#string of 3 info about physical card - color, shape, count
func get_card_info_string() -> Array: 
	var card_details #= [COLORS_STR[color],SHAPES_STR[shape],COUNTS_STR[count]]
	var h = HATS_STR[hats]
	var g = GLASSES_STR[glasses]
	var c = CLOTHES_STR[clothes]
	card_details = [h,g,c]
	return card_details
	
func set_sort_press_true():
	sort_press = true
	
func set_r_t(r_t_in: float):
	r_t = r_t_in

func get_successful() -> bool:
	return successful
	
func get_r_t() -> float:
	return r_t
