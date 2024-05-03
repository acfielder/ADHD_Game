class_name Sequence
extends Node2D


var pins = []


#const Sequence_Game = preload("res://sequence_game.gd")
#var sequence_game = Sequence_Game.new()

enum state {HIGHLIGHT, RESPONSE}

#new

var pins_highlight
var pins_detect
signal pin_press_detected
signal begin_trial
var controller_instance
#const Sequence_Controller = preload("res://sequence_controller.gd")
#var sequence_controller = Sequence_Controller.new()

#NEXT**************
#change length based on randomized
#change length based on performance


# Called when the node enters the scene tree for the first time.
func _ready():
	pins_highlight = {1:get_node("PushPin1/Button"), 2:get_node("PushPin2/Button"), 3: get_node("PushPin3/Button"), 4: get_node("PushPin4/Button"), 5: get_node("PushPin5/Button")}
	pins_detect = {1:$PushPin1, 2:$PushPin2, 3:$PushPin3, 4:$PushPin4, 5:$PushPin5}
	
	pins = [$PushPin1, $PushPin2, $PushPin3, $PushPin4, $PushPin5]
	#.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	
	
	for i in range(pins.size()):
		pins[i].pin_pressed.connect(_on_pin_pressed)
		
	var Sequence_Controller = preload("res://sequence_controller.gd")
	var sequence_controller = Sequence_Controller.new(self)
	
	controller_instance = preload("res://sequence_controller.gd").new(self)
	#switch between controller_instance and sequence_controller
	controller_instance.connect("highlight_pin", Callable(self, "_on_highlight_pin"))
	controller_instance.connect("prompt_for_response", Callable(self, "_on_prompt_for_response"))

	
	#controller_instance.connect("highlight_pin", self, "_on_highlight_pin")
	#controller_instance.connect("prompt_for_response", self, "_on_prompt_for_response")
	# Connect the signal from this script to a method in the receiving script (if needed)
	# script_instance.connect("some_signal", self, "handle_some_signal")

	# Connect the custom signal to a function in this script
	#button_scene.connect("button_pressed", self, "_on_button_pressed")
	

#new


func _on_start_button_pressed():
	$ColorRect.hide()
	#start_game()
	self.emit_signal("begin_trial")


func _on_highlight_pin(pin_key, highlight_type):
	var color
	match highlight_type:
		0: color = Color(0,0,0.545098)
		1: color = Color(0.564706,0.933333,0.564706)
		2: color = Color(1,0,0)
	var pin = pins_highlight.get(pin_key)
	var original_color = pin.self_modulate
	pin.self_modulate = color
	await get_tree().create_timer(0.75).timeout
	pin.self_modulate = original_color
	await get_tree().create_timer(0.25).timeout
	
func _on_pin_pressed(pin):
	var pin_key = pins_detect.find_key(pin)
	self.emit_signal("pin_press_detected", pin_key)
	
func _on_prompt_for_response():
	pass
	
