class_name SequenceTrialInfo


var rng = RandomNumberGenerator.new()

var sequence_type : Array #type of sequence for trial
var length : int #length of trial sequence
var score : int #score at end of trial
var mem_order : Array #original memory order
var response : Array #pin selected response based on memory order
var pins_pressed : int #number of pins/responses given
var trial_num : int #ID number of trial within session
var reversed_order : Array #mem_order reversed 
#more may need to be added for updated order

func _init(sequence_type_in: Array, length_in: int, mem_order_in: Array):
	sequence_type = sequence_type_in
	length = length_in
	mem_order = mem_order_in
	pins_pressed = 0
	response = []
	score = 0
	reversed_order = mem_order_in.duplicate()
	reversed_order.reverse()
	
#calculate score of trial
func calculate_score() -> int:
	for i in range(response.size()):
		score += response[i]
	return score	

#determine length of next trial of the same type based on performance
func determine_next_trial_length() -> int:
	if score == length && length < 8:
		return (length + 1)
	elif score < length && length > 3:
		return (length - 1)
	else: return length

#checks and records individual responses
func check_update_response(single_response: int) -> bool:
	pins_pressed += 1
	if sequence_type[0] == 0 || sequence_type[1] == 0: #[0,-1] , [3,0]
		if single_response == mem_order[pins_pressed-1]:
			response.append(1)
			return true
		else:
			response.append(0)
			return false
	elif sequence_type[0] == 1 || sequence_type[1] == 1: #[1,-1] , [3,1]
		if single_response == reversed_order[pins_pressed-1]:
			response.append(1)
			return true
		else:
			response.append(0)
			return false
	#anything with 2 in it may become elif or be covered by the above
	else:
		print("couldn't properly check response")
		return false


func get_sequence_type() -> Array:
	return sequence_type
	
func get_trial_num() -> int:
	return trial_num
	
func get_length() -> int:
	return length
	
func get_score() -> int:
	return score
	
func get_mem_order() -> Array:
	return mem_order
	
func get_reversed_order() -> Array:
	return reversed_order
	
func get_response() -> Array:
	return response

func get_pins_pressed() -> int:
	return pins_pressed
