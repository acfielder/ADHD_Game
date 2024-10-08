extends Resource
class_name UserModel

@export var name : String

#~BEGIN WCST VARS
#overall
@export var session_count_wcst : int = 0
@export var prev_overall_adaption_rate : float = .65
@export var prev_rule_block_length : int = 11
#@export var accuracy_rate : float = -1
#@export var avg_r_t : float = -1
#@export var adaption_rate : float = -1

@export var accuracy_rate : Dictionary = {"all rates": 0, "total phases": 0, "overall accuracy rate": 0}
@export var avg_r_t : Dictionary = {"all averages": 0, "total phases": 0, "overall average RT": 0}
@export var adaption_rate : Dictionary = {"all rates": 0, "total phases": 0, "overall adaption rate": 0}
#trials can still save overall pieces, but these are the entire history overalls

#phases
@export var phase_one_data : Array = []
@export var phase_two_data : Array = []

#~END WCST VARS~

#~BEGIN STOP_GO VARS
#overall levels and session
@export var current_SG_level : int = 1
@export var comp_of_level_SG : int = 0
@export var session_count_SG : int = 0

#game specific
#these three are overall for a session
@export var overall_stop_signal_rt : float
@export var overall_go_rt : float
@export var overall_prob_signal_response : float

@export var critical_ssd : float = 0.3 #starts out really low
@export var prev_SG_sess_score : Array = [70,70]

#history
@export var lev_one_SG_sessions : Array = []
@export var lev_two_SG_sessions : Array = []
#more levels
@export var levs_data_SG_sessions : Dictionary = {1:lev_one_SG_sessions}

@export var lev_one_SG_trials : Dictionary = {1: [],0: []}
@export var lev_two_SG_trials : Dictionary = {1: [],0: []}
#more levels
@export var levs_data_SG_trials : Dictionary = {1:lev_one_SG_trials,2:lev_two_SG_trials}

#~END STOP_GO VARS~

#~BEGIN CBTT VARS~
#Corsi Block Tapping Task - Sequence Game
@export var current_level : int = 1 #players current level over sessions
@export var completed_of_level : int = 0 #how many sequences have been completed of the current level
@export var sequence_session_count : int = 0 #number of sessions completed of the sequence game

#2D arrays holding trial data for each level, hased into their particular sequence type
@export var level_one_data : Array = [[],[],[],[],[],[]]
@export var level_two_data : Array = [[],[],[],[],[],[]]
@export var level_three_data : Array = [[],[],[],[],[],[]]
@export var level_four_data : Array = [[],[],[],[],[],[]]
@export var level_five_data : Array = [[],[],[],[],[],[]]
#complete dictionary of all trial info
@export var levels_data : Dictionary = {1:level_one_data, 2:level_two_data, 3:level_three_data, 4:level_four_data, 5:level_five_data}

@export var sequence_session_performance_level : Array = [10,10] #number of trials successful with total in last session
#~END CBTT VARS~

#~BEGIN WCST FUNCS
func create_wcst_trial_save(r_t: float, successful: bool):
	var trial_dict = {"reaction time": r_t, "successful": int(successful)}
	return trial_dict
	
func create_rule_dict(adaption_rate_in: float, trials: Array):
	var rule_dict = {"adaption rate": adaption_rate_in, "trials": trials}
	return rule_dict
	
func create_phase_dict(rule_blocks: Array, accuracy_rate_in: float, avg_r_t_in: float, adaption_rate_in: float):
	var phase_dict = {"rule blocks": rule_blocks, "accuracy rate": accuracy_rate_in, "avg_r_t": avg_r_t_in, "adaption rate": adaption_rate_in}
	return phase_dict
	
func save_phase_data(phase_one: Dictionary, phase_two: Dictionary):
	phase_one_data.append(phase_one)
	phase_two_data.append(phase_two)
	
func update_accuracy_rate(phase_accuracy_rate: float):
	accuracy_rate["all rates"] += phase_accuracy_rate
	accuracy_rate["total phases"] += 1
	accuracy_rate["overall accuracy rate"] = snappedf(float(accuracy_rate.get("all rates"))/float(accuracy_rate.get("total phases")),0.01)
	
func update_avg_rt(phase_avg_rt: float):
	avg_r_t["all averages"] += phase_avg_rt
	avg_r_t["total phases"] += 1
	avg_r_t["overall average RT"] = float(avg_r_t.get("all averages")) / float(avg_r_t.get("total phases"))

func update_adaption_rate(phase_adaption_rate: float):
	adaption_rate["all rates"] += phase_adaption_rate
	adaption_rate["total phases"] += 1
	adaption_rate["overall adaption rate"] = snappedf(float(adaption_rate.get("all rates")) / float(adaption_rate.get("total phases")),0.01)

	
func update_prev_adaption_rate(prev_ar: float):
	prev_overall_adaption_rate = prev_ar


#~END WCST FUNCS~

#~BEGIN STOP-GO FUNCS~
#this should also eventually MAYBE collect rt and such - but thats mostly covered in the session averages
func create_SG_trial_save(score: bool):
	var trial_dict = {"score": score}
	return trial_dict
	
func add_to_SG_trial_level_data(trial_type: bool, score: bool):
	var trial_dict = create_SG_trial_save(score)
	if trial_type:
		levs_data_SG_trials.get(current_SG_level).get(1).append(trial_dict)
	else:
		levs_data_SG_trials.get(current_SG_level).get(0).append(trial_dict)

func create_SG_session_save(go_rt: float, prob_signal_response: float, stop_signal_rt: float):
	var session_dict = {"go_rt_avg": go_rt, "prob_signal_response": prob_signal_response, "stop_signal_rt": stop_signal_rt}
	return session_dict

func add_to_SG_session_level_data(go_rt: float, prob_signal_response: float, stop_signal_rt: float):
	var session_dict = create_SG_session_save(go_rt, prob_signal_response, stop_signal_rt)
	levs_data_SG_sessions.get(current_SG_level).append(session_dict)
	print(levs_data_SG_sessions)
	
#should take in the overall using the players saved results -- not using right now but graph for levels may
func update_SG_overalls(stop_signal_rt: float, go_rt: float, prob_signal_response: float):
	overall_go_rt = go_rt
	overall_prob_signal_response = prob_signal_response
	overall_stop_signal_rt = stop_signal_rt
	
func increase_SG_level():
	#the if statement will become the highest level possible as they're implemented
	if current_SG_level < 2:
		current_SG_level += 1
		comp_of_level_SG = 0

#~END STOP GO FUNCS~


#~BEGIN CBTT FUNCS~

#takes trial information to condense into a dictionary
func create_sequence_trial_save(sequence_type: Array, length: int, score: int):
	var trial_dict = {"sequence_type": sequence_type, "sequence_length": length, "score":score}
	return trial_dict

#adds previously played trial's info to user's save - info saved may change
func add_to_sequence_level_data(sequence_type: Array, length: int, score: int):
	var trial_dict = create_sequence_trial_save(sequence_type, length, score)
	var index = sequence_type[0] + sequence_type[1] + 1
	levels_data.get(current_level)[index].append(trial_dict)

#increases saved sequece level once user completes level within completed session
func increase_sequence_level():
	#print(str("current level before change: ") + str(current_level))
	current_level += 1
	print(str("current level after change: ") + str(current_level))
	completed_of_level = 0
	#print("users internal level has been increased")
	
	#~END CBTT FUNCS~
	
	
	
#funcs to return specific pieces like the actual level dicts for level report purposes
#session reports will happen fully in the game model
	
	
	
#~RESETING FUNCS~	
	
	
#resets all user data as though starting a new save
func reset_user_data():
	name = "" #this will need asked for at start of game
	
	#stop go data
	current_SG_level = 1
	comp_of_level_SG = 0
	session_count_SG = 0
	critical_ssd = 0.1
	prev_SG_sess_score = [70,70]
	lev_one_SG_sessions = []
	lev_two_SG_sessions = []
	levs_data_SG_sessions = {1:lev_one_SG_sessions,2:lev_two_SG_sessions}
	lev_one_SG_trials = {1: [], 0: []}
	lev_two_SG_trials = {1: [], 0: []}
	levs_data_SG_trials = {1:lev_one_SG_trials,2:lev_two_SG_trials}
	
	
	#cbtt data
	current_level = 1
	completed_of_level = 0
	sequence_session_count = 0
	sequence_session_performance_level = [10,10]
	level_one_data = [[],[],[],[],[],[]]
	level_two_data = [[],[],[],[],[],[]]
	level_three_data = [[],[],[],[],[],[]]
	level_four_data = [[],[],[],[],[],[]]
	level_five_data = [[],[],[],[],[],[]]
	levels_data = {1:level_one_data, 2:level_two_data, 3:level_three_data, 4:level_four_data, 5:level_five_data}
	
	
func reset_stop_go_data():
	current_SG_level = 1
	comp_of_level_SG = 0
	session_count_SG = 0
	critical_ssd = 0.1
	prev_SG_sess_score = [70,70]
	lev_one_SG_sessions = []
	lev_two_SG_sessions = []
	levs_data_SG_sessions = {1:lev_one_SG_sessions,2:lev_two_SG_sessions}
	lev_one_SG_trials = {1: [], 0: []}
	lev_two_SG_trials = {1: [], 0: []}
	levs_data_SG_trials = {1:lev_one_SG_trials,2:lev_two_SG_trials}
	
	
func reset_cbtt_data():
	name = "" #this will need asked for at start of game
	current_level = 1
	completed_of_level = 0
	sequence_session_count = 0
	sequence_session_performance_level = [10,10]
	level_one_data = [[],[],[],[],[],[]]
	level_two_data = [[],[],[],[],[],[]]
	level_three_data = [[],[],[],[],[],[]]
	level_four_data = [[],[],[],[],[],[]]
	level_five_data = [[],[],[],[],[],[]]
	levels_data = {1:level_one_data, 2:level_two_data, 3:level_three_data, 4:level_four_data, 5:level_five_data}

func reset_wcst_data():
	session_count_wcst = 0
	accuracy_rate = {"all rates": 0, "total phases": 0, "overall accuracy rate": 0}
	avg_r_t = {"all averages": 0, "total phases": 0, "overall average RT": 0}
	adaption_rate = {"all rates": 0, "total phases": 0, "overall adaption rate": 0}
	phase_one_data = []
	phase_two_data = []
	
	session_count_wcst = 0
	prev_overall_adaption_rate = .65
	prev_rule_block_length = 11

#~END RESETING FUNCS~	
