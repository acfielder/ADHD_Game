extends Node
class_name wcstRuleBlock

var block_trials : Array = []

enum Rules {SHAPE,COLOR,COUNT}
var rule : Rules

var adaption_rate : float


func set_rule(prev_rule: Rules):
	pass

func setup_add_trial():
	pass

#adaption rate for this block - this may just be an overall thing
func calc_adaption_rate():
	pass
	
#when a card is attempted to be sorted
#the following two will need to go into the block to get the last trial
func record_check_response():
	pass
	
func timer_ended_trial():
	pass
	
