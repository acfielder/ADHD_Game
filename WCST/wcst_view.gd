extends Node2D
class_name wcstView

var timer

var user : UserModel

var wcst_controller : wcstController

var base_cards : Array

# Called when the node enters the scene tree for the first time.
func _ready():

	#pins[i].pin_pressed.connect(_on_pin_pressed_test)
	
	$base_card_1.connect("card_pressed",_card_press_detected)
	$base_card_2.connect("card_pressed",_card_press_detected)
	$base_card_3.connect("card_pressed",_card_press_detected)
	$base_card_4.connect("card_pressed",_card_press_detected)

	user = User_Data_Manager.load_resource()
	
	user.reset_wcst_data()
	
	wcst_controller = wcstController.new(self,user)
	
	timer = $Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#starting point for when a card press is detected
func _card_press_detected(card):
	print("got that press!" + str(card))
