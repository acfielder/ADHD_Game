class_name Sequence_Game

var rng = RandomNumberGenerator.new()


var current_trial = 1
var total_trials = 20
var overall_performance = [0,0,0,0,0,0,0,0]
var pins_pressed = 0
var pins = 5
var trial_history = []


#enum Sequence_Type{FORWARD, REVERSE, TEST}
#var sequence_type_state = Sequence_Type.FORWARD

signal all_pins_pressed



func check_update_response(pin_key: int):
	pins_pressed += 1
	return trial_history[trial_history.size()-1].check_update_response(pin_key)
	
	
	
func create_sequence_order(sequence_type: int):
	#would be rather different for new sequence types
	print(sequence_type)
	var length = determine_new_length(sequence_type)
	var mem_order = []
	for i in range(length):
		mem_order.append(int(rng.randf_range(1,pins)))
	var next_trial = SequenceTrialInfo.new(sequence_type, length, mem_order)
	trial_history.append(next_trial)
	return mem_order
	
	
func choose_sequence_type():
	#would change, put choose sequence type in individual levels
	#check to ensure not at end of level, return -1 if a level ended, controller should prompt again with the next level
	#call individual trial with current level
	if current_trial == 1:
		return 0
	else:
		var i = rng.randf_range(0,1)
		if i < .31:
			return 1
		else:
			return 0
	
	
func choose_sequence_type_static_test():
	var sequence_type
	match current_trial:
		1:
			sequence_type = 0
		2:
			sequence_type = 0
		3:
			sequence_type = 1
		4: 
			sequence_type = 0
		5:
			sequence_type = 1
		6:
			sequence_type = 1
	return sequence_type
	
	
func determine_new_length(sequence_type: int):
	if current_trial == 1:
		return 3
	else:
		#var previous_trial_match
		for i in range(trial_history.size() - 1, -1, -1):
			if trial_history[i].get_sequence_type() == sequence_type:
				return trial_history[i].determine_next_trial_length()
		return 3
	
	
func update_overall_performance():
	var last_performance = trial_history[trial_history.size()-1].get_response()
	trial_history[trial_history.size()-1].calculate_score()
	for i in range(last_performance.size()):
		overall_performance[i] += last_performance[i]
	return overall_performance
		
		
func reset_trial_info():
	pins_pressed = 0
	current_trial += 1
	
	
func get_current_trial():
	return current_trial
	
func get_total_trials():
	return total_trials
	
func check_pins_pressed():
	return pins_pressed
	
func get_current_mem_order():
	return trial_history[-1].mem_order
	

	
	
	
	
