class_name Sequence
extends Node2D


var pins : Array = [] #pointers to pins in scene
enum state {HIGHLIGHT, RESPONSE}
#these two may be able to change or not be needed
var pins_highlight : Dictionary #pins with associated number to highlight correct pin
var pins_detect : Dictionary #pins with associated number to recognize correct pin

var sequence_controller : Sequence_Controller
var user : UserModel


func _ready():
	pins_highlight = {1:get_node("PushPin1/Button"), 2:get_node("PushPin2/Button"), 3: get_node("PushPin3/Button"), 4: get_node("PushPin4/Button"), 5: get_node("PushPin5/Button"), 6: get_node("PushPin6/Button"), 7: get_node("PushPin7/Button"), 8: get_node("PushPin8/Button")}
	pins_detect = {1:$PushPin1, 2:$PushPin2, 3:$PushPin3, 4:$PushPin4, 5:$PushPin5, 6:$PushPin6, 7:$PushPin7, 8:$PushPin8}
	
	pins = [$PushPin1, $PushPin2, $PushPin3, $PushPin4, $PushPin5, $PushPin6, $PushPin7, $PushPin8]

	for i in range(pins.size()):
		pins[i].pin_pressed.connect(_on_pin_pressed)

	sequence_controller = Sequence_Controller.new(self,user)
	
	#randomly select from images in a particular location to assign as images - images may become sprites or texture or something idk yet

#begins trials
func _on_start_button_pressed():
	$ColorRect.hide()
	deactivate_pins()
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
func highlight_pin(pin_key: int, highlight_type: int):
	var color
	match highlight_type:
		0: color = Color(0,0,0.545098)
		1: color = Color(0.564706,0.933333,0.564706)
		2: color = Color(1,0,0)
	var pin = pins_highlight.get(pin_key)
	var original_color = pin.self_modulate
	pin.self_modulate = color
	await get_tree().create_timer(0.6).timeout
	pin.self_modulate = original_color
	await get_tree().create_timer(0.30).timeout
	
#tells controller a pin was pressed
func _on_pin_pressed(pin): 
	var pin_key = pins_detect.find_key(pin)
	sequence_controller.pin_press_detected(pin_key)

#tell player there response is now being collected
func prompt(hide: int, prompt: String = ""):
	if hide == 1:
		$trial_prompt.text = prompt
		$trial_prompt.visible = true
	else:
		$trial_prompt.visible = false

func activate_pins():
	#for pin in pins:
		#pin.set_disabled(false)
	pass

func deactivate_pins():
	#for pin in pins:
	#	if pin is Button:
	#		pin.set_disabled(true)
	pass


#hides the pins for the duration of the delay period - delay time may eventually become a parameter
func display_delay_distraction():
	$delay_distraction.visible = true
	await get_tree().create_timer(5).timeout 
	$delay_distraction.visible = false
	
func display_session_over():
	$session_over_display.visible = true

