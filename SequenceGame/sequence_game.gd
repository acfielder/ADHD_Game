class_name Sequence_Game

var rng = RandomNumberGenerator.new()

var length = 4
var mem_order = []
var response = []
var current_trial = 1
var total_trials = 5
var overall_performance = [0,0,0,0,0,0,0,0]
var pins_pressed = 0
var pins = 5
#testing in adding reverse things
var last_for_length = 3
var last_rev_length = 2
var last_for_score = 3
var last_rev_score = 2
var reversed_order = []

enum Sequence_Type{FORWARD, REVERSE, TEST}
var sequence_type_state = Sequence_Type.FORWARD

signal all_pins_pressed



func check_update_response(pin_key: int):
	pins_pressed += 1
	if sequence_type_state == Sequence_Type.FORWARD:
		if pin_key == mem_order[pins_pressed-1]:
			response.append(1)
			return true
		else:
			response.append(0)
			return false
	elif sequence_type_state == Sequence_Type.REVERSE:
		if pin_key == reversed_order[pins_pressed-1]:
			response.append(1)
			return true
		else:
			response.append(0)
			return false
	
	
func create_sequence_order(sequence_type: int):
	if sequence_type == 0:
		sequence_type_state = Sequence_Type.FORWARD
	elif sequence_type == 1:
		sequence_type_state = Sequence_Type.REVERSE
	length = determine_new_length(sequence_type_state)
	mem_order = []
	reversed_order = []
	response = []
	for i in range(length):
		mem_order.append(int(rng.randf_range(1,pins)))
	if sequence_type_state == Sequence_Type.REVERSE:
		reversed_order = mem_order.duplicate()
		reversed_order.reverse()
	return mem_order
	
	
func choose_sequence_type():
	var sequence_type 
	if current_trial == 1:
		sequence_type = 0
	else:
		var i = rng.randf_range(0,1)
		if i < .31:
			sequence_type = 1
		else:
			sequence_type = 0
	print(sequence_type)
	return sequence_type
	
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
	
	
	#if current_trial == 1:
		#sequence_type_state = Sequence_Type.FORWARD
	#else:
		#var i = rng.randf_range(0,1)
		#if i < .31:
			#sequence_type_state = Sequence_Type.REVERSE
		#else:
			#sequence_type_state = Sequence_Type.FORWARD
	#print(sequence_type_state)
	
	
func determine_new_length(sequence_type: int):
	if current_trial == 1:
		return 3
	else:
		#var score_sum = 0
		#for i in range(response.size()):
			#score_sum += response[i]
		if sequence_type == 1:#Sequence_Type.REVERSE:
			if last_rev_score == last_rev_length && last_rev_length < 8:
				return last_rev_length + 1
			elif last_rev_score < last_rev_length && last_rev_length > 3:
				return last_rev_length - 1
		elif sequence_type == 0:#Sequence_Type.FORWARD:
			if last_for_score == last_for_length && last_for_length < 8:
				return last_for_length + 1
			elif last_for_score < last_for_length && last_for_length > 3:
				return last_for_length - 1
		#if reverse
			#sum = mem size && last reverse


		#if score_sum == mem_order.size() && mem_order.size() <8:
		#	length = mem_order.size() + 1
		#elif score_sum < mem_order.size() && mem_order.size() >3:
		#	length = mem_order.size() - 1
		#else:
			#length = mem_order.size()
	
	
func update_overall_performance():
	for i in range(response.size()):
		overall_performance[i] += response[i]
		
		
func reset_trial_info():
	var score_sum = 0
	for i in range(response.size()):
			score_sum += response[i]
	if sequence_type_state == Sequence_Type.FORWARD:
		last_for_length = length
		last_for_score = score_sum
	elif sequence_type_state == Sequence_Type.REVERSE:
		last_rev_length = length
		last_rev_score = score_sum
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
	
	
	
	
