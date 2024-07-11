extends Node
class_name wcstModel


var user : UserModel

var session_rule_blocks : Array[wcstRuleBlock] = [] # each holds all trials within that block of rules
var current_trial : int = 0
var current_phase : int = 1
var phase_length : int = 5 #unsure how long each should be (theres two, not doing a full session length as both of these together tell you that)

var rng = RandomNumberGenerator.new()

var accuracy_rate : float
var avg_r_t : float
var overall_adaption_rate : float

func set_user(user_in: UserModel):
	user = user_in

func setup_session():
	pass
	
#will do thigns based on what the current phase is so that needs to make sure to increase when it needs to
func setup_phase():
	pass
	
func setup_trial():
	#will get the current block and call into that to create it
	pass

#when a card is attempted to be sorted
#the following two will need to go into the block to get the last trial
func record_check_response():
	pass
	
func timer_ended_trial():
	pass
	

func calc_current_rt():
	pass

func select_feedback():
	pass
	

func end_trial():
	#also go into block to set things in the last trial
	pass
	
	
func end_phase():
	pass
	
	
func end_session():
	pass


func calc_accuracy_rate():
	pass
	
func calc_avg_r_t():
	pass
	
func calc_overall_adaption_rate():
	pass


#getters
