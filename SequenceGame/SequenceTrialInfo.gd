class_name SequenceTrialInfo

var sequence_type
var length
var score
var mem_order
var response


func _init(sequence_type_in: int, length_in: int, mem_order_in: Array):
	sequence_type = sequence_type_in
	length = length_in
	mem_order = mem_order_in
	
func determine_next_trial_length():
	pass
	
func check_update_response(response_in: int):
	pass
	
