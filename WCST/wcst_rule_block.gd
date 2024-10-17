extends Node
class_name wcstRuleBlock

var block_trials : Array = []

enum Rules {HAT, GLASSES, CLOTHES}
var rule : Rules

const RULES_STR : Dictionary = {Rules.HAT: "Hat", Rules.GLASSES: "Glasses", Rules.CLOTHES: "Clothes"}

var adaption_rate : float

var phase : int

var rng = RandomNumberGenerator.new()

func _ready():
	#var trial = wcstTrialInfo.new()
	#trial.successful = true
	#var trial2 = wcstTrialInfo.new()
	#trial2.successful = true
	#var trial3 = wcstTrialInfo.new()
	#trial3.successful = true
	#var trial4 = wcstTrialInfo.new()
	#trial4.successful = false
	#block_trials.append(trial)
	#block_trials.append(trial2)
	#block_trials.append(trial3)
	#block_trials.append(trial4)
	#print("adaption rate: " + str(calc_adaption_rate()))
	
	#var trial = wcstTrialInfo.new()
	#trial.shape = wcstTrialInfo.Shapes.CIRCLE
	#trial.color = wcstTrialInfo.Colors.BLUE
	#trial.count = wcstTrialInfo.Counts.TWO
	#block_trials.append(trial)
	#rule = Rules.COLOR
	#record_check_response(["blue","triangle","one"])
	#print(trial.successful)
	#rule = Rules.SHAPE
	#record_check_response(["blue","triangle","one"])
	#print(trial.successful)
	pass


func set_phase(phase_in: int):
	phase = phase_in

func set_rule(prev_rule : Rules = Rules.HAT):
	rule = prev_rule
	while rule == prev_rule:
		var rule_num = rng.randi_range(0, 2)
		match rule_num:
			0: rule = Rules.HAT
			1: rule = Rules.GLASSES
			2: rule = Rules.CLOTHES
	return rule

func setup_add_trial():
	var trial = wcstTrialInfo.new()
	trial.set_card_type(phase)
	block_trials.append(trial)
	return trial.get_card_info_string()

#adaption rate for this block - adaption period of 5 trials
func calc_adaption_rate():
	var sorted = 0
	for i in range(5):
		if block_trials[i].successful: 
			sorted += 1
	adaption_rate = float(float(sorted)/float(5))#correct/adaption period length
	return adaption_rate
	
#when a card is attempted to be sorted
#the following two will need to go into the block to get the last trial
func record_check_response(info: Array): #color,shape,count - CHECK
	block_trials[-1].set_sort_press_true()
	var trial_info = block_trials[-1].get_card_info_string()
	match rule:
		Rules.HAT:
			if trial_info[0] == info[0]:
				block_trials[-1].successful = true
			else:
				block_trials[-1].successful = false
		Rules.GLASSES:
			if trial_info[1] == info[1]:
				block_trials[-1].successful = true
			else:
				block_trials[-1].successful = false
		Rules.CLOTHES:
			if trial_info[2] == info[2]:
				block_trials[-1].successful = true
			else:
				block_trials[-1].successful = false
	return block_trials[-1].successful
	
func timer_ended_trial():
	block_trials[-1].successful = false
	
func update_trial_rt(rt: float):
	block_trials[-1].r_t = rt
	
func get_accuracy():
	var accurate = 0
	for trial in block_trials:
		if trial.get_successful():
			accurate += 1
	return accurate
	
func get_rts_total():
	var tot_rt = 0
	for trial in block_trials:
		if trial.get_r_t() != -1: #get rt
			tot_rt += trial.get_r_t()
	return tot_rt
	
func get_length():
	return block_trials.size()
	
func get_rule() -> Rules:
	return rule
	
func get_rule_string():
	return RULES_STR[rule]
	
func get_if_pressed():
	return block_trials[-1].sort_press
