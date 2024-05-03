class_name Sequence
extends Node2D


var pins = []
enum state {HIGHLIGHT, RESPONSE}
var pins_highlight
var pins_detect
var sequence_controller


func _ready():
	pins_highlight = {1:get_node("PushPin1/Button"), 2:get_node("PushPin2/Button"), 3: get_node("PushPin3/Button"), 4: get_node("PushPin4/Button"), 5: get_node("PushPin5/Button")}
	pins_detect = {1:$PushPin1, 2:$PushPin2, 3:$PushPin3, 4:$PushPin4, 5:$PushPin5}
	
	pins = [$PushPin1, $PushPin2, $PushPin3, $PushPin4, $PushPin5]

	for i in range(pins.size()):
		pins[i].pin_pressed.connect(_on_pin_pressed)

	sequence_controller = Sequence_Controller.new(self)


func _on_start_button_pressed():
	$ColorRect.hide()
	sequence_controller.begin_trial()


func highlight_pin(pin_key: int, highlight_type: int):
	var color
	match highlight_type:
		0: color = Color(0,0,0.545098)
		1: color = Color(0.564706,0.933333,0.564706)
		2: color = Color(1,0,0)
	var pin = pins_highlight.get(pin_key)
	var original_color = pin.self_modulate
	pin.self_modulate = color
	await get_tree().create_timer(0.5).timeout
	pin.self_modulate = original_color
	await get_tree().create_timer(0.25).timeout
	
func _on_pin_pressed(pin): #how can i put a type here for PushPin
	var pin_key = pins_detect.find_key(pin)
	sequence_controller.pin_press_detected(pin_key)
	
func prompt_for_response(hide: int):
	if hide == 1:
		$ResponsePrompt.visible = true
	else:
		$ResponsePrompt.visible = false
	
	
func prompt_for_next_trial():
	await get_tree().create_timer(1).timeout
	$current_trial.text = str("Trial", sequence_controller.get_current_trial())
	print("begining next trial")
	


