class_name Sequence_Game

var rng = RandomNumberGenerator.new()

var length = 4
var mem_order = []
var response = []
var current_trial = 1
var total_trials = 3
var overall_performance = [0,0,0,0,0,0,0,0]
var pins_pressed = 0
var pins = 5

signal all_pins_pressed



func check_update_response(pin_key: int):
	pins_pressed += 1
	if pin_key == mem_order[pins_pressed-1]:
		response.append(1)
		return true
	else:
		response.append(0)
		return false
	
	
func create_sequence_order():
	determine_new_length()
	mem_order = []
	response = []
	for i in range(length):
		mem_order.append(int(rng.randf_range(1,pins)))
	return mem_order
	
func determine_new_length():
	if current_trial == 1:
		length = 4
	else:
		var score_sum = 0
		for i in range(response.size()):
			score_sum += response[i]
		if score_sum == mem_order.size() && mem_order.size() <8:
			length = mem_order.size() + 1
		elif score_sum < mem_order.size() && mem_order.size() >3:
			length = mem_order.size() - 1
		else:
			length = mem_order.size()
	
func update_overall_performance():
	for i in range(response.size()):
		overall_performance[i] += response[i]
		
func reset_trial_info():
	pins_pressed = 0
	current_trial += 1
	
		
func get_current_trial():
	return current_trial
	
func get_total_trials():
	return total_trials
	
func check_pins_pressed():
	return pins_pressed
	
func get_mem_order_size():
	return mem_order.size()
	
	
	
	
