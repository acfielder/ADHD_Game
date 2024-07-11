extends Node
class_name wcstRuleBlock

var block_trials : Array = []

enum Rules {SHAPE,COLOR,COUNT}
var rule : Rules

var adaption_rate : float

var phase : int

var rng = RandomNumberGenerator.new()

func _ready():
	pass

func set_phase(phase_in: int):
	phase = phase_in

func set_rule(prev_rule: Rules):
	rule = prev_rule
	while rule == prev_rule:
		var rule_num = rng.randi_range(0, 2)
		match rule_num:
			0: rule = Rules.SHAPE
			1: rule = Rules.COLOR
			2: rule = Rules.COUNT
	return rule

func setup_add_trial():
	var trial = wcstTrialInfo.new()
	trial.set_card_type(phase)
	block_trials.append(trial)

#adaption rate for this block - this may just be an overall thing
func calc_adaption_rate():
	pass
	
#when a card is attempted to be sorted
#the following two will need to go into the block to get the last trial
func record_check_response():
	pass
	
func timer_ended_trial():
	pass
	
