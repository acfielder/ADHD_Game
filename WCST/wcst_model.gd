extends Node
class_name wcstModel


var user : UserModel

var session_rule_blocks : Array[wcstRuleBlock] = [] # each holds all trials within that block of rules
var current_trial : int = 0
var current_phase : int = 0
var phase_length : int = 5 #unsure how long each should be (theres two, not doing a full session length as both of these together tell you that)

var rng = RandomNumberGenerator.new()

var accuracy_rate : float
var avg_r_t : float
var overall_adaption_rate : float

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
	current_phase += 1
	
#setup new rule block/end the old one
func rule_change():
	var rule_block = wcstRuleBlock.new()
	rule_block.set_phase(current_phase)
	rule_block.set_rule(session_rule_blocks[-1].get_rule())
	session_rule_blocks.append(rule_block)
	
func setup_trial():
	#will get the current block and call into that to create it
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
	
	pass
	
	
func end_session():
	determine_session_results()
	#save all graph data to user first
	#User_Data_Manager.save(user)
	
func determine_session_results():
	calc_accuracy_rate()
	calc_avg_r_t()
	calc_overall_adaption_rate()


func calc_accuracy_rate():
	var tot_correct = 0
	var total = 0
	for rule_block in session_rule_blocks:
		tot_correct += rule_block.get_accuracy()
		total += rule_block.size() #or get_length works too
	accuracy_rate = float(tot_correct)/float(total)
	return accuracy_rate
	
func calc_avg_r_t():
	var tot_time = 0
	var num_trials = 0
	for rule_block in session_rule_blocks:
		tot_time += rule_block.get_rts_total()
		num_trials += rule_block.size()  #or get_length works too
	avg_r_t = float(tot_time)/float(num_trials)
	return avg_r_t
	
func calc_overall_adaption_rate():
	var a_rate_tot = 0
	for rule_block in session_rule_blocks:
		a_rate_tot += rule_block.adaption_rate
	overall_adaption_rate = float(a_rate_tot)/float(session_rule_blocks.size())
	return overall_adaption_rate

#getters
func get_if_trial_pressed():
	return session_rule_blocks[-1].get_if_pressed()
