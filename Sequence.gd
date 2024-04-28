extends Node2D

signal begin_sequence
var memory_order
var all_pins = []
var original_color
var already_ran = false
var response_index = 0
var response_result = [-1,-1,-1,-1,-1,-1,-1,-1]
var pins = []
var pins_pressed = 0
var rng = RandomNumberGenerator.new()
var pins_dict = {}
@export var total_trials = 10
var current_trial = 1

const Sequence_Info = preload("res://sequence_game.gd")
var sequence_info = SequenceInfo.new()

enum state {HIGHLIGHT, RESPONSE}

#NEXT**************
#change length based on randomized
#change length based on performance


# Called when the node enters the scene tree for the first time.
func _ready():
	#########all but pin connects would be removed here
	pins_dict = {1:[get_node("PushPin1/Button"), $PushPin1], 2:[get_node("PushPin2/Button"), $PushPin2], 3:[get_node("PushPin3/Button"), $PushPin3], 4: [get_node("PushPin4/Button"), $PushPin4], 5: [get_node("PushPin5/Button"), $PushPin5]}
	#all_pins = [[get_node("PushPin1/Button"), $PushPin1], [get_node("PushPin2/Button"), $PushPin2], [get_node("PushPin3/Button"), $PushPin3], [get_node("PushPin4/Button"), $PushPin4], [get_node("PushPin5/Button"), $PushPin5]]
	pins = [$PushPin1, $PushPin2, $PushPin3, $PushPin4, $PushPin5]
	memory_order = [1,1,1,1]
	#.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	
	for i in range(pins.size()):
		pins[i].pin_pressed.connect(_on_pin_pressed)


	# Connect the custom signal to a function in this script
	#button_scene.connect("button_pressed", self, "_on_button_pressed")
	
	
#have both references in one
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_game():
	#start_game in the other file is called twice, making the array too long
	response_index = 0
	pins_pressed = 0
	already_ran = false
	var memory_order_key
	if current_trial > 1:
		memory_order_key = sequence_info.next_trial(response_result)
	else: #current_trial < 1:
		memory_order_key = sequence_info.start_game()
	response_result = [-1,-1,-1,-1,-1,-1,-1,-1]
	#memory_order = call start_game #this creates the starting sequence and saves it here
	#var memory_order_key = sequence_info.start_game()
	memory_order = memory_order_key.duplicate()
	
	for i in range(memory_order_key.size()):
		memory_order[i] = pins_dict.get(memory_order_key[i])
		#print(key)
		#print(pins_dict.get(key))
		
	#this next piece will go away, needs to come back if connection fails
	#memory_order = [1,1,1,1]
	
	#goes through the sequence to light things up
	highlight_sequence()
	
	#these need to come back if the connection fails
	#these two pieces below will also be removed
	#for i in range(memory_order.size()):
		#var index = rng.randf_range(0, all_pins.size()-1)
		#memory_order[i] = all_pins[index]	
	#highlight_sequence()
		
		
	
func highlight_sequence():
	for i in range(memory_order.size()):
		original_color = memory_order[i][0].self_modulate
		memory_order[i][0].self_modulate = Color(0,0,1)
		await get_tree().create_timer(0.75).timeout
		memory_order[i][0].self_modulate = original_color
		await get_tree().create_timer(0.25).timeout
	already_ran = true
	
	
#this is seeing which pin was pressed and comparing to make the array of correct/incorrect responses
#is this good to stay in this script?
func _on_pin_pressed(pin):
	if already_ran == true && (pins_pressed < memory_order.size()):
		if pin == memory_order[response_index][1]:
			print("correct")
			response_result[response_index] = 1
		
		elif pin != memory_order[response_index][1]:
			print("incorrect")
			response_result[response_index] = 0
		response_index += 1
		pins_pressed += 1
	
		if pins_pressed == memory_order.size() && current_trial < total_trials:
			print("completed sequence and response")
			current_trial += 1
			await get_tree().create_timer(0.5).timeout
			start_game()
			
			#call next trial to re-setup sequence for next found
			
			


	# Connect the custom signal to a function in this script
   # button_scene.connect("button_pressed", self, "_on_button_pressed")
	


func _on_start_button_pressed():
	$ColorRect.hide()
	start_game()
