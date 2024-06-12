class_name SequenceTrialInfo


var rng = RandomNumberGenerator.new()

var sequence_type : Array #type of sequence for trial
var length : int #length of trial sequence
var score : int #score at end of trial
var mem_order : Array #original memory order
var response : Array #pin selected response based on memory order
var pins_pressed : int #number of pins/responses given
var trial_num : int #ID number of trial within session
var reversed_order : Array #mem_order reversed  #this will be able to be deleted with addition of answer_order
#more may need to be added for updated order
	#var delay: bool #3's have true
var answer_order : Array #mem_order to check response to
var trial_prompt_before_sequence : String = "" #trial specific prompt given in view before sequence is shown
var trial_prompt_after_sequence : String = "" #trial specific prompt given in view after sequence is shown

#i couldnt think of a better way atm
var switched : bool = false
var switched_values : Array

func _init(sequence_type_in: Array, length_in: int, mem_order_in: Array):
	sequence_type = sequence_type_in
	length = length_in
	mem_order = mem_order_in
	pins_pressed = 0
	response = []
	score = 0
	#reversed_order = mem_order_in.duplicate()
	#reversed_order.reverse()

#creates answer order based on sequence type
func create_answer_order() -> Array:
	if sequence_type[0] == 0 || sequence_type[1] == 0:
		answer_order = mem_order
	elif sequence_type[0] == 1 || sequence_type[1] == 1:
		answer_order = mem_order.duplicate()
		answer_order.reverse()
	elif sequence_type[0] == 2 || sequence_type[1] == 2:
		answer_order = []
		var i = rng.randf_range(0,1)
		if i < .5:
			var switch_1 = rng.randf_range(1,mem_order.size()-1)
			var switch_2
			if switch_1 == mem_order.size()-1:
				switch_2 = 0
			else:
				switch_2 = switch_1 + 1
			answer_order = mem_order
			answer_order[switch_1] = mem_order[switch_2]
			answer_order[switch_2] = mem_order[switch_1]
			switched = true
			switched_values = [switch_1,switch_2]
		else:
			for e in range(mem_order.size()-1):
				if int(i) % 2 == 0:
					answer_order.append(mem_order[i])
	return answer_order

#selects prompts for before and after the sequence is shown
func select_prompts() -> Array:
	if sequence_type[0] == 0 || sequence_type[1] == 0:
		trial_prompt_before_sequence = "Repeat this sequence in the same order as presented"
	elif sequence_type[0] == 1 || sequence_type[1] == 1:
		trial_prompt_before_sequence = "Repeat this sequence in reverse order"
	elif sequence_type[0] == 2 || sequence_type[1] == 2:
		if sequence_type[0] == 2:
			trial_prompt_before_sequence = "Repeat this sequence in the updated order described after the sequence is presented"
			if switched: trial_prompt_after_sequence = "The " + str(switched_values[0]) + " and " + str(switched_values[1]) + " events have been switched"
			else: trial_prompt_after_sequence = "Repeat the sequence in forward order, choosing every other event,\nstarting with the first event presented"
		else:
			trial_prompt_after_sequence = "Repeat the sequence in forward order, choosing every other event,\nstarting with the first event presented"
	if sequence_type[0] == 3:
		trial_prompt_before_sequence = trial_prompt_before_sequence + "\n- there will be a delay before you can respond"
	return [trial_prompt_before_sequence,trial_prompt_after_sequence]
	
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
	if single_response == answer_order[pins_pressed-1]:
			response.append(1)
			return true
	elif single_response != answer_order[pins_pressed-1]:
		response.append(0)
		return false
	else:
		print("couldn't properly check response")
		return false


func get_prompt(order: int):
	match order:
		0:
			return trial_prompt_before_sequence
		1:
			return trial_prompt_after_sequence

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
