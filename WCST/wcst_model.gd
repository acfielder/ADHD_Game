extends Node
class_name wcstModel


var user : UserModel

var session_rule_blocks : Array[wcstRuleBlock] = [] # each holds all trials within that block of rules
var current_trial : int = 0
var current_rule : int = 0
var current_phase : int = 0
var phase_length : int = 6 #unsure how long each should be (theres two, not doing a full session length as both of these together tell you that)
var rule_length : int = 10
var current_trial_in_rule : int = 0

var rng = RandomNumberGenerator.new()

var accuracy_rate_phase_one : float
var avg_r_t_phase_one : float
var overall_adaption_rate_phase_one : float
var accuracy_rate_phase_two : float
var avg_r_t_phase_two : float
var overall_adaption_rate_phase_two : float

var score : int = 0

var start_rt
var final_rt

func set_user(user_in: UserModel):
	user = user_in

func setup_session():
	#any updating of the game itself based on past results
	pass
	
#will do thigns based on what the current phase is so that needs to make sure to increase when it needs to
func setup_phase():
	current_trial = 1
	current_phase += 1
	match current_phase:
		1:
			rule_length = 10
		2:
			rule_length = 7
	
#setup new rule block/end the old one
func rule_change():
	current_rule += 1
	var rule_block = wcstRuleBlock.new()
	rule_block.set_phase(current_phase)
	rule_block.set_rule(session_rule_blocks[-1].get_rule())
	session_rule_blocks.append(rule_block)
	current_trial_in_rule += 1
	
func setup_trial():
	#will get the current block and call into that to create it
	current_trial_in_rule += 1
	var trial_info = session_rule_blocks[-1].setup_add_trial() #string of 3 properties


#when a card is attempted to be sorted
#the following two will need to go into the block to get the last trial
func record_check_response(info: Array):
	if session_rule_blocks[-1].record_check_response(info):
		score += 1
		return true
	else: return false
	
func timer_ended_trial():
	session_rule_blocks[-1].timer_ended_trial()
	
func calc_update_current_rt():
	var rt = final_rt - start_rt
	session_rule_blocks[-1].update_trial_rt(rt)
	

func end_trial():
	pass


func end_phase():
	match current_phase:
		1:
			accuracy_rate_phase_one = calc_accuracy_rate()
			avg_r_t_phase_one = calc_avg_r_t()
			overall_adaption_rate_phase_one = calc_overall_adaption_rate()
		2:
			accuracy_rate_phase_two = calc_accuracy_rate()
			avg_r_t_phase_two = calc_avg_r_t()
			overall_adaption_rate_phase_two = calc_overall_adaption_rate()
	
func end_session():
	
	#save session data to user
	var phase_one_rules = []
	var phase_two_rules = []
	for rule_block in session_rule_blocks:
		var trials = []
		for trial in rule_block.block_trials:
			trials.append(user.create_wcst_trial_save(trial.r_t, trial.successful))
		match rule_block.phase:
			1:
				phase_one_rules.append(user.create_rule_dict(rule_block.adaption_rate,trials))
			2:
				phase_two_rules.append(user.create_rule_dict(rule_block.adaption_rate,trials))
	var p_one_dict = user.create_phase_dict(phase_one_rules,accuracy_rate_phase_one,avg_r_t_phase_one,overall_adaption_rate_phase_one)
	var p_two_dict = user.create_phase_dict(phase_two_rules,accuracy_rate_phase_two,avg_r_t_phase_two,overall_adaption_rate_phase_two)
	user.save_phase_data(p_one_dict,p_two_dict)
	
	user.update_accuracy_rate(accuracy_rate_phase_one)
	user.update_accuracy_rate(accuracy_rate_phase_two)
	user.update_adaption_rate(overall_adaption_rate_phase_one)
	user.update_adaption_rate(overall_adaption_rate_phase_two)
	user.update_avg_rt(avg_r_t_phase_one)
	user.update_avg_rt(avg_r_t_phase_two)
	
	
	User_Data_Manager.save(user)
	

func calc_accuracy_rate():
	var tot_correct = 0
	var total = 0
	for rule_block in session_rule_blocks:
		tot_correct += rule_block.get_accuracy()
		total += rule_block.size() #or get_length works too
	var accuracy_rate = float(tot_correct)/float(total)
	return accuracy_rate
	
func calc_avg_r_t():
	var tot_time = 0
	var num_trials = 0
	for rule_block in session_rule_blocks:
		tot_time += rule_block.get_rts_total()
		num_trials += rule_block.size()  #or get_length works too
	var avg_r_t = float(tot_time)/float(num_trials)
	return avg_r_t
	
func calc_overall_adaption_rate():
	var a_rate_tot = 0
	for rule_block in session_rule_blocks:
		a_rate_tot += rule_block.adaption_rate
	var overall_adaption_rate = float(a_rate_tot)/float(session_rule_blocks.size())
	return overall_adaption_rate

#getters
func get_if_trial_pressed():
	return session_rule_blocks[-1].get_if_pressed()
