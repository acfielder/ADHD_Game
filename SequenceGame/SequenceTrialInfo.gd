class_name SequenceTrialInfo


var rng = RandomNumberGenerator.new()

var sequence_type
var length
var score
var mem_order
var response
var pins_pressed
var trial_num
var reversed_order


func _init(sequence_type_in: Array, length_in: int, mem_order_in: Array):
	sequence_type = sequence_type_in #changed this to an array, will need updated down below
	length = length_in
	mem_order = mem_order_in
	pins_pressed = 0
	response = []
	score = 0
	reversed_order = mem_order_in.duplicate()
	reversed_order.reverse()
	
	
func calculate_score():
	for i in range(response.size()):
		score += response[i]
	return score	
	
func determine_next_trial_length():
	if score == length && length < 8:
		return (length + 1)
	elif score < length && length > 3:
		return (length - 1)
	else: return length

func check_update_response(single_response: int):
	pins_pressed += 1
	if sequence_type[0] == 0 || sequence_type[1] == 0:
		if single_response == mem_order[pins_pressed-1]:
			response.append(1)
			return true
		else:
			response.append(0)
			return false
	elif sequence_type[0] == 1 || sequence_type[1] == 1:
		if single_response == reversed_order[pins_pressed-1]:
			response.append(1)
			return true
		else:
			response.append(0)
			return false


func get_sequence_type():
	return sequence_type
	
func get_trial_num():
	return trial_num
	
func get_length():
	return length
	
func get_score():
	return score
	
func get_mem_order():
	return mem_order
	
func get_reversed_order():
	return reversed_order
	
func get_response():
	return response

func get_pins_pressed():
	return pins_pressed
