extends Node2D
class_name wcstView

var timer

var user : UserModel

var wcst_controller : wcstController

var base_cards : Array

var card_art : Array


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
	
	card_art = load_cards("res://Art/WCST/cards")
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#starting point for when a card press is detected
func _card_press_detected(card):
	print("got that press!" + str(card))
	#tell controller a card was chosen and which it was
		
	
#choose the card arts to be passed to the base cards to set their textures
func set_base_cards():
	pass
	
#set the texture of the trial card, should select it at random here (so long as it fits with a base card with the current rule
func set_trial_card_texture():
	pass
	
	
#
func setup_phase_one():
	#should not at this point set a trial card
	#set the base cards
	#call for displaying of initial instruction
	#make sure base card 4 is hidden/not functional
	pass
	
func end_phase_one():
	#flip cards away
	#any instructions for end of it
	pass
	
	#ideally cards would flip away at end of phase 1
func setup_phase_two():
	#set base cards including showing the 4th one
	#initial instruction
	#flip the cards back over ^
	pass

#ends the second phase 
func end_phase_two():
	pass
	
#may not be much here as end phase two covers a lot
func end_session():
	pass

	
#shows speech bubble and gives feedback in it
func display_speech_feedback():
	pass
	
	
func create_run_timer(duration: float):
	if timer.time_left > 0:
		timer.stop()
	var to_call: Callable = response_timer_timeout
	timer.set_wait_time(duration)
	timer.timeout.connect(to_call)
	timer.start()


#change to load the actual card files if needbe, change func name, call from ready
func load_cards(folder_path):
	var image_files = []
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if file_name.ends_with(".png"):
				image_files.append(folder_path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	return image_files
	
	
func response_timer_timeout():
	if !wcst_controller.get_if_pressed():
		wcst_controller.sort_timer_timeout()


func _on_begin_pressed():
	wcst_controller.begin_session()
	$SessionBegin.hide()
	

func _on_begin_phase_pressed():
	wcst_controller.begin_phase_two()
