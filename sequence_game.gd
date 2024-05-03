class_name Sequence_Game

#old
#var overall_performance = [0,0,0,0,0,0,0,0]
#var new_length = 4
#var memory_order = []
var rng = RandomNumberGenerator.new()
#var trial = 1

var length = 4
var mem_order = []
var response = []
var current_trial = 1
var total_trials = 20
var overall_performance = [0,0,0,0,0,0,0,0]
var pins_pressed = 0
var pins = 5

signal continue_run


#new implementation

func check_update_response(pin_key):
	response.append(pin_key)
	if pin_key == mem_order[response.size()-1]:
		return true
	else:
		return false
	pins_pressed += 1
	
func create_sequence_order():
	determine_new_length()
	mem_order = []
	for i in range(length):
		mem_order.append(int(rng.randf_range(1,pins)))
	return mem_order
	
func determine_new_length():
	if current_trial == 1:
		length = 4
	else:
		var score_sum = 0
		for i in range(response.size()):
			score_sum += mem_order[i]
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
	response = []
	pins_pressed = 0
	current_trial += 1
	
func _process(delta):
	if pins_pressed == mem_order.size():
		emit_signal("continue_run")
		
func get_current_trial():
	return current_trial
	
func get_total_trials():
	return total_trials
	
	
	
	
