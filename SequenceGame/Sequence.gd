class_name Sequence
extends Node2D


var pins : Array = [] #pointers to pins in scene

enum state {HIGHLIGHT, RESPONSE}
var pins_dict : Dictionary #pins with associated number to recognize correct pin

var sequence_controller : Sequence_Controller
var user : UserModel


func _ready():
	pins = [$TP1, $TP2, $TP3, $TP4, $TP5, $TP6, $TP7, $TP8]
	for i in range(pins.size()):
		pins[i].pin_pressed.connect(_on_pin_pressed_test)
	pins_dict = {1:$TP1, 2:$TP2, 3:$TP3, 4:$TP4, 5:$TP5, 6:$TP6, 7:$TP7, 8:$TP8}

	sequence_controller = Sequence_Controller.new(self,user)
	
	#randomly select from images in a particular location to assign as images - images may become sprites or texture or something idk yet

#begins trials
func _on_start_button_pressed():
	$ColorRect.hide()
	#would probably lead to an instruction section rather than already the starting trial
	sequence_controller.run_trial()
	
#just creates a small timer to create a delay
func create_short_timer(time: float):
	await get_tree().create_timer(time).timeout
	
func prompt_next_trial():
	await get_tree().create_timer(1).timeout
	$ColorRect.show()
	
func update_display(level: int, trial: int, score: int):
	$SessionStats/ColorRect/current_level.text = "Level: " + str(level)
	$SessionStats/ColorRect/current_trial.text = "Trial: " + str(trial)
	$SessionStats/ColorRect/session_score.text = "Score: " + str(score)
	#$SessionStats/ColorRect/trial_type.text = "Trial Type: " + str(type)

#highlights individual pin based on highlight reason
func highlight_pin(pin_key: int, highlight_type: int, highlight_length: float): #deals with pins
	var pin = pins_dict.get(pin_key)
	match highlight_type:
		0: pin.change_icon(0)
		1: pin.change_icon(1)
		2: pin.change_icon(2)
		3: pin.change_icon(3)
		_: pin.change_icon(0)
	await get_tree().create_timer(highlight_length).timeout
	pin.change_icon(0)
	await get_tree().create_timer(0.30).timeout
	
func _on_pin_pressed_test(pin):
	var pin_key = pins_dict.find_key(pin)
	sequence_controller.pin_press_detected(pin_key)
	print("it worked kinda")

#tell player there response is now being collected
func prompt(hide: int, prompt: String = ""):
	if hide == 1:
		$trial_prompt.text = prompt
		$trial_prompt.visible = true
	else:
		$trial_prompt.visible = false


#hides the pins for the duration of the delay period - delay time may eventually become a parameter
func display_delay_distraction():
	$delay_distraction.visible = true
	await get_tree().create_timer(5).timeout 
	$delay_distraction.visible = false
	
func display_session_over():
	$session_over_display.visible = true

