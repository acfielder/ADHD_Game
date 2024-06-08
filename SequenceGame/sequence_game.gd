class_name Sequence_Game

var rng = RandomNumberGenerator.new()


var current_trial = 1
var total_trials = 20
var overall_performance = [0,0,0,0,0,0,0,0]
var pins_pressed = 0
var pins = 5
var trial_history = []
#would maybe need to have level lengths here as well as where they currently are in it - that should be saved to user, can this class get info from user?
var current_level = 1
var level_length = 10
var trials_completed_for_level = 0
var session_length = 20
var current_session_performance = 0

var user : UserModel

#enum Sequence_Type{FORWARD, REVERSE, UPDATE, DELAY}
#var sequence_type_state = Sequence_Type.FORWARD

signal all_pins_pressed

func set_user(user_in: UserModel):
	user = user_in
	
func setup_game_for_player():
	update_session_length()
	#update session length, any other data bits that need setup first
	#this method could maybe move to the game, it would just have to be in the constructor to call methods

func check_update_response(pin_key: int):
	pins_pressed += 1
	return trial_history[trial_history.size()-1].check_update_response(pin_key)
	
	
	
func create_sequence_order(sequence_type: Array):
	#would be rather different for new sequence types
	print(sequence_type)
	var length = determine_new_length(sequence_type)
	var mem_order = []
	for i in range(length):
		mem_order.append(int(rng.randf_range(1,pins)))
	var next_trial = SequenceTrialInfo.new(sequence_type, length, mem_order)
	trial_history.append(next_trial)
	return mem_order
	
	
func choose_sequence_type():
	#check to ensure not at end of level, return -1 if a level ended, controller should prompt again with the next level
	#switch-case depending on level, different types allowed for different levels
	if current_trial == 1 && current_level == 1:
		return [0,-1]
	elif current_trial > level_length:
		#current_trial = 1
		return [-1]
		#above this would need changed bc we want trials for a session, not for a level
	#elif user.sequences_completed == level_length:
		#user.sequence_completed = 0
		#return [-1]
	else:
		#var i = rng.randf_range(0,1)
		#if i < .31:
		#	return 1
		#else:
		#	return 0
		var i = rng.randf_range(0,1)
		match current_level:
			1:
				if i <= .20:
					return [1,-1]
				else:
					return [0,-1]
			2:
				if i <= .20:
					return [1,-1]
				elif i <= .40:
					return [0,-1]
				else:
					return [2,-1]
			3:
				if i <= .30:
					return [0,-1]
				elif i <= .60:
					return [1,-1]
				else:
					return [2,-1]
			4:
				if i <= .10:
					return [0,-1]
				elif i <= .30:
					return [1,-1]
				else:
					var e = rng.randf_range(0,1)
					if e <= .60:
						return [3,0]
					else:
						return [3,1]
			5:
				if i <= .05:
					return [0,-1]
				elif i <= .15:
					return [1,-1]
				else:
					var e = rng.randf_range(0,1)
					if e <= .30:
						return [3,0]
					elif e <= .50:
						return [3,1]
					else:
						return [3,2]

	
func choose_sequence_type_static_test():
	var sequence_type
	match current_trial:
		1:
			sequence_type = 0
		2:
			sequence_type = 0
		3:
			sequence_type = 1
		4: 
			sequence_type = 0
		5:
			sequence_type = 1
		6:
			sequence_type = 1
	return sequence_type
	
	
func determine_new_length(sequence_type: Array):
	if current_trial == 1:
		return 3
	else:
		for i in range(trial_history.size() - 1, -1, -1):
			if trial_history[i].get_sequence_type() == sequence_type:
				return trial_history[i].determine_next_trial_length()
		return 3
	
func update_session_performance():
	if trial_history[-1].score == trial_history[-1].length:
		current_session_performance += 1
	
	
func update_overall_performance():
	var last_performance = trial_history[trial_history.size()-1].get_response()
	trial_history[trial_history.size()-1].calculate_score()
	for i in range(last_performance.size()):
		overall_performance[i] += last_performance[i]
	return overall_performance
		
		
func reset_trial_info():
	pins_pressed = 0
	current_trial += 1
	
func next_level():
	if current_level <5:
		current_level += 1	
		return true
	else:
		return false
	
func update_session_length():
	#based on how many the user has gotten correct previously can change the session length***
	if user.session_count != 0:
		var performance_last_session = user.sequence_session_performence_level[0] / user.sequence_session_performance_level[1]
		if performance_last_session < 0.5 && user.sequence_session_performance_level[0] > 5: #should be 15
			session_length -= 5
		elif performance_last_session > 0.5 && performance_last_session < 0.7:
			session_length = user.sequence_session_performance_level[0]
		elif user.sequence_session_performance_level[0] < 15: #should be 25
			session_length += 5
	else:
		session_length = 10 #20 - was changed for testing purposes

func end_session():
	#save users session data, and more things certainly
	#save trials data and 
	user.sequence_session_performance_level = [session_length,current_session_performance]
	user.completed_of_level += session_length
	user.session_count += 1
	for trial in range(trial_history.size()):
		user.add_to_sequence_level_data(trial_history[trial].sequence_type, trial_history[trial].length, trial_history[trial].score)
	User_Data_Manager.save(user)
		
func get_current_level():
	return current_level
	
func get_current_trial():
	return current_trial
	
func get_total_trials():
	return total_trials
	
func check_pins_pressed():
	return pins_pressed
	
func get_current_mem_order():
	return trial_history[-1].mem_order
	
func get_current_sequence_type():
	return trial_history[-1].sequence_type
	
	
	
	
