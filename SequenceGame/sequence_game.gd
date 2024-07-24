class_name Sequence_Game

var rng = RandomNumberGenerator.new()

#game based 
var pins : int = 8 #num pins in view, will need changed with UI
var level_length : int = 7 #should be roughly 50 - check notes - maybe less when im only taking the correct ones
var increased_level : bool = false

#session based
var trial_history : Array = [] #holds SequenceTrialInfo objects for history of session's trials
#var overall_performance : Array = [0,0,0,0,0,0,0,0] 
var stm_performance : Array = [0,0,0,0,0,0]
var update_performance : Array = [0,0,0,0,0,0]
var delay_performance : Array = [0,0,0,0,0,0]
var session_length : int = 10 #should be 20
var current_session_performance : int = 0

#trial based
var current_trial : int = 1 #current trial within session
var pins_pressed : int = 0 #pins pressed count for current trial response

#user based
var current_level : int = 1
var user : UserModel

#enum Sequence_Type{FORWARD, REVERSE, UPDATE, DELAY}
#var sequence_type_state = Sequence_Type.FORWARD

signal all_pins_pressed

#initialize user in model scope
func set_user(user_in: UserModel) -> void:
	user = user_in
	
#setup any session dependent factors
func setup_game_for_player() -> void:
	update_session_length(user.sequence_session_count, user.sequence_session_performance_level)
	current_level = user.current_level
	#could add any other setup functions here, keeps it open so dont have to change controller
	#if unnecessary could call update_session_length directly from controller

#check individual response to sequence order
func check_update_response(pin_key: int) -> bool:
	pins_pressed += 1
	return trial_history[trial_history.size()-1].check_update_response(pin_key)
	
	
	
#create memory sequence order based on the sequence type
func create_sequence_order(sequence_type: Array) -> Array:
	#would be rather different for new sequence types - ignore this?
	var length = determine_new_length(sequence_type)
	var mem_order = []
	for i in range(length):
		mem_order.append(int(rng.randf_range(1,pins)))
	var next_trial = SequenceTrialInfo.new(sequence_type, length, mem_order)
	trial_history.append(next_trial)
	return mem_order
	
#updates trial object based on sequence type for later use
func update_trial_info():
	trial_history[-1].create_answer_order()
	trial_history[-1].select_prompts()

	
#choose trial's sequence type based on player's progress	
func choose_sequence_type() -> Array:
	print(user.completed_of_level)
	#switch-case depending on level, different types allowed for different levels, chosen based on difficulty ratios
	#print(user.completed_of_level)
	#if current_trial == 1 && current_level == 1:
	#	return [0,-1]
	if current_level == 100: #obviously this is wrong and needs removed #user.completed_of_level >= level_length && increased_level == false: # && current_trial == 1 && increased_level == false:
		#increased_level = true
		return [-1]
	elif current_trial == 1 && current_level == 1:
		return [0,-1]
	else:
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
			_:
				print("couldn't produce sequence_type")
				return [0,-1]

#would need to be completely rewritten along with tests
func choose_sequence_type_static_test():
	var sequence_type
	match current_trial:
		1:
			sequence_type = [0,-1]
		2:
			sequence_type = [1,-1]
		3:
			sequence_type = [2,-1]
		4: 
			sequence_type = [3,0]
		5:
			sequence_type = [3,1]
		6:
			sequence_type = [3,2]
	return sequence_type
	
#determines length of current trial's sequence based on previous trial of same sequence type
func determine_new_length(sequence_type: Array) -> int:
	if current_trial == 1:
		return 4
	else:
		for i in range(trial_history.size() - 1, -1, -1):
			if trial_history[i].get_sequence_type() == sequence_type:
				return trial_history[i].determine_next_trial_length()
		return 4

#calls for the trial's score to be calculated
func calculate_trial_score():
	return trial_history[-1].calculate_score()

#increases self & user's session performance counts if trial was successful
func update_session_performance():
	if trial_history[-1].score == trial_history[-1].answer_order.size():
		current_session_performance += 1
		user.sequence_session_performance_level[0] = current_session_performance
		user.completed_of_level += 1
	if user.completed_of_level >= level_length && increased_level == false && current_level < 5: # this needs moved elsewhere to where it belongs, maybe not idk?
		increased_level = true
		

	
	
	
func update_overall_performance(): #this may not need to exist or can be moved or combined with session performance, depends on how reports are created
	#var last_performance = trial_history[-1].get_response()
	#for i in range(last_performance.size()):
	#	overall_performance[i] += last_performance[i]
	#	print(overall_performance)
	#return overall_performance
	if trial_history[-1].score == trial_history[-1].answer_order.size():
		var sequence_type = trial_history[-1].sequence_type
		if sequence_type[0] == 0:
			stm_performance[trial_history[-1].mem_order.size()-3] += 1
		elif sequence_type[0] == 1 || sequence_type[0] == 2:
			update_performance[trial_history[-1].mem_order.size()-3] += 1
		elif sequence_type[0] == 3:
			delay_performance[trial_history[-1].mem_order.size()-3] += 1

		
#resets trial specific information for beginning next trial
func reset_trial_info():
	pins_pressed = 0
	current_trial += 1
	
#increases level of self & user
func next_level() -> bool:
#	if current_level <5:
#		current_level += 1	
	user.increase_sequence_level()
	return true
#	else:
#		return false

#change session length based on previous session performance
func update_session_length(session_count: int, performance: Array):
	if session_count > 0: #session_count > 0
		session_length = performance[1]
		var performance_last_session = float(performance[0]) / float(performance[1])
		if performance_last_session < 0.5 && performance[1] > 3: #5should be 15
			session_length -= 2#5
		elif performance_last_session > 0.5 && performance_last_session <= 0.7:
			session_length = performance[1]
		elif performance_last_session > 0.7 && performance[1] < 9: #15should be 25
			session_length += 2#5
	else:
		session_length = 5 #20 - was changed for testing purposes #ten for testing
	user.sequence_session_performance_level[0] = 0
	user.sequence_session_performance_level[1] = session_length
	return session_length
	
	
	#if user.sequence_session_count > 0:
	#	session_length = user.sequence_session_performance_level[1]
	#	var performance_last_session = float(user.sequence_session_performance_level[0]) / float(user.sequence_session_performance_level[1])
	#	if performance_last_session < 0.5 && user.sequence_session_performance_level[1] > 5: #should be 15
	#		session_length -= 5
	#	elif performance_last_session > 0.5 && performance_last_session <= 0.7:
	#		session_length = user.sequence_session_performance_level[1]
	#	elif performance_last_session > 0.7 && user.sequence_session_performance_level[1] < 15: #should be 25
	#		session_length += 5
	#else:
	#	session_length = 10 #20 - was changed for testing purposes
	#user.sequence_session_performance_level[1] = session_length

#save user's session's data to user
func end_session():
	print(current_level)
	#user.completed_of_level += user.sequence_session_performance_level[0] #alternative is in update_session_performance
	user.sequence_session_count += 1
	#if current_level > user.current_level:
	#	print("end of session level increase")
	#	next_level()
	
	for trial in range(trial_history.size()):
		user.add_to_sequence_level_data(trial_history[trial].sequence_type, trial_history[trial].length, trial_history[trial].score)
	if increased_level:
		next_level()
		print(user.current_level)
	User_Data_Manager.save(user)
	
#gets prompt to be displayed from trial object
func get_prompt(order: int):
	return trial_history[-1].get_prompt(order)
		
func get_current_level() -> int:
	return current_level
	
func get_current_trial() -> int:
	return current_trial
	
func check_pins_pressed() -> int:
	return pins_pressed
	
func get_current_mem_order() -> Array:
	return trial_history[-1].mem_order
	
func get_current_sequence_type() -> Array:
	return trial_history[-1].sequence_type
	
func get_answer_order() -> Array:
	return trial_history[-1].answer_order
	
func get_if_another_event():
	if pins_pressed + 1 < trial_history[-1].answer_order.size():
		return true
	else:
		return false
	
func get_performances():
	return {"Short term memory/ working memory": stm_performance,"update/manipulation": update_performance,"delayed response": delay_performance}
	
func get_scores() -> Array:
	var sequences_completed = str(session_length)
	var total_correct = str(user.sequence_session_performance_level[0]) + "/" + str(session_length)
	var crimes_solved = str(int(user.sequence_session_performance_level[0]/2)) + "/" + str(session_length/2)#12??			#for every two correct, a crime is solved, should be like in a row or something
	var op_1 = float(float(user.sequence_session_performance_level[0])/float(user.sequence_session_performance_level[1]))
	var op_2 = float(int(user.sequence_session_performance_level[0]/2)/float(user.sequence_session_performance_level[0]))
	var op_3 = op_1 + op_2
	var op_4 = float(op_3 /2)
	var op_5 = op_4 * 100
	var overall_performance = str(int(op_5)) + "/100"
	return [sequences_completed, total_correct, crimes_solved, overall_performance]

#should reset all seeing as this will always be loaded when in showcase, should also be done in other games
func reset_session():
	pass
