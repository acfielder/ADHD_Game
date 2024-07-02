extends Resource
class_name UserModel

@export var name : String

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

@export var critical_ssd : float
@export var prev_SG_sess_score : Array = [70,70]

#history
@export var lev_one_SG_sessions : Array = []
#more levels
@export var levs_data_SG_sessions : Dictionary = {1:lev_one_SG_sessions}

@export var lev_one_SG_trials : Dictionary = {"stop": [], "go": []}
#more levels
@export var levs_data_SG_trials : Dictionary = {1:lev_one_SG_trials}


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


#~BEGIN STOP-GO FUNCS~
func create_SG_trial_save(trial_type: bool, score: bool):
	var trial_dict = {"trial_type": trial_type, "score": score}
	return trial_dict
	
func add_to_SG_trial_level_data(trial_type: bool, score: bool):
	var trial_dict = create_SG_trial_save(trial_type, score)
	if trial_type:
		levs_data_SG_trials.get(current_level).get("go").append(trial_dict)
	else:
		levs_data_SG_trials.get(current_level).get("stop").append(trial_dict)

func create_SG_session_save(go_rt: float, prob_signal_response: float, stop_signal_rt: float):
	var session_dict = {"go_rt_avg": go_rt, "prob_signal_response": prob_signal_response, "stop_signal_rt": stop_signal_rt}
	return session_dict

func add_to_SG_session_level_data(go_rt: float, prob_signal_response: float, stop_signal_rt: float):
	var session_dict = create_SG_session_save(go_rt, prob_signal_response, stop_signal_rt)
	levs_data_SG_sessions.get(current_SG_level).append(session_dict)
	
#should take in the overall using the players saved results -- not using right now but graph for levels may
func update_SG_overalls(stop_signal_rt: float, go_rt: float, prob_signal_response: float):
	overall_go_rt = go_rt
	overall_prob_signal_response = prob_signal_response
	overall_stop_signal_rt = stop_signal_rt
	
func increase_SG_level():
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
	
	pass
	
	
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

#~END RESETING FUNCS~	
