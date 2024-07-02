class_name StopGoModel

var user: UserModel

var session_trials: Array[StopGoTrial] = [] #list of all trials completed in this session

var session_length: int = 15 #number of trials in a session //maybe like 40?
var current_trial : int = 0 #current trial within the session
var current_level : int = 1 #level of the current session

var rng = RandomNumberGenerator.new()

var session_last_ssd: float = 0.1 #tracking of the current ssd
var session_last_ssd_score: bool #0 or 1 for whether or not successful

var min_interval : int = 3 #min time to allow walking before trial
var max_interval : int = 5 #max time to allow walking before trial

#calculations for performance
var session_go_rt_avg: float
var session_prob_signal_response: float
var session_stop_signal_rt: float

var allowed_max_rt: float = 1.5 #maximum time to respond to go cue

#times to subtract from one another to know actual rt
var start_rt_time: float 
var final_rt_time: float

var session_score: int = 0 #calculation of how many trials done correctly through the current session

var session_best_rt: float #the quickest reaction time within the current session


func _init():
	pass
	
func set_user(user_in: UserModel):
	user = user_in	
	
#setup things for this session like what level they're on and later down line, their scores to start their difficulty correctly all around
func setup_session():
	#this could be very related to the ssd and ssRT, as then it will become more difficult with growth(levels wahaha)
	#alter the min and max interval based on user previous session
	pass

#sets up a basic trial by calling models functions that tell trial to set particular parts
func setup_trial():
	var trial = StopGoTrial.new(create_trial_type())
	session_trials.append(trial)
	if !trial.trial_type:
		determine_next_ssd(trial) #updates session_last_ssd
		trial.ssd = session_last_ssd
	trial.start_interval = determine_interval()
	trial.direction = choose_direction(trial)
	current_trial += 1
	trial.trial_num = current_trial
	#maybe determine how long the allowed RT is
	

#chooses between stop and go trials and makes a trial objects
func create_trial_type():
	var trial_type
	var i = rng.randf_range(0,1)
	if i <= 0.7: #should be 0.7
		trial_type = true
	else:
		trial_type = false
	return trial_type
	
#determines the next ssd based on the last ssd and if player was successful - could search through trial list for last ssd rather than saving it?
func determine_next_ssd(trial: StopGoTrial):
	session_last_ssd = trial.determine_ssd(session_last_ssd, session_last_ssd_score)
	return session_last_ssd

#gets the next interval length based on previous trial's interval length and 'successful'
func determine_interval():
	return session_trials[-1].determine_next_interval(min_interval,max_interval)
	
#tells the trial to pick the direction of its go cue
func choose_direction(trial: StopGoTrial):
	return trial.choose_direction()
	
#ends trial when player presses a key within the trial // actually just updates best_rt and session score
func record_check_response():
	var trial = session_trials[-1]
	#trial.pressed = true
	#trial.go_rt = r_t
	#if trial.trial_type && trial.direction == direction:
		#trial.set_successful(true)
	if current_trial == 1 || trial.go_rt < session_best_rt:
		session_best_rt = trial.go_rt
	session_score += 1
		#return true
	#else:
		#trial.set_successful(false)
		#return false
	
#ends trial when player fails to/successfully doesnt respond
func timer_ended_trial():
	var trial = session_trials[-1]
	if trial.trial_type:
		#session_score += 1
		return true
	else:
		trial.go_rt = -1
		session_score += 1
		return false
		
		
	#match trial.trial_type:
	#	0:
	#		trial.set_successful(true)
	#		session_score += 1
	#		return true
	#	1:
	#		trial.set_successful(false)
	#		trial.go_rt = -1
	#		return false
	#	_:
	#		print("unable to end trial on timer timeout")
	
#updates any final information for a now completed trial
func end_trial(): #should this be different depending on which calls it?
	#if ssd was successful, note that as 1 or 0
	#save the rt
	#increase trials completed type of var, this is to know when to stop running more trials
	pass
	
#**session end**#
	
#calls functions to calculate the sessions performance for the three major measurements
func determine_session_results():
	session_go_rt_avg = calc_session_go_rt()
	session_prob_signal_response = calc_session_prob_signal_response() #this needs checked for correctness in task
	session_stop_signal_rt = calc_session_stop_signal_rt(session_go_rt_avg)
	#these things should be saved to the session (then saved to the user)

#calculates the average go trial reaction time for the session
func calc_session_go_rt(): #go trial successful, stop unsuccessful
	var time_sum = 0
	var go_rt_count = 0
	for trial in session_trials:
		if (trial.trial_type && trial.successful) || (!trial.trial_type && !trial.successful):
			go_rt_count += 1
			time_sum += trial.go_rt
	return snappedf(time_sum/go_rt_count,0.001)
	#	elif !trial.trial_type && !trial.successful:
	#		time_sum += trial.go_rt
	
#calculates the probability of signal response across all ssd's
func calc_session_prob_signal_response():
	var correct_stops = 0
	var total_stops = 0
	for trial in session_trials:
		if !trial.trial_type:
			total_stops += 1
			if trial.successful:
				correct_stops += 1
	return float(correct_stops)/float(total_stops)
	
#calculates the stop signal reaction time - needs much more research
func calc_session_stop_signal_rt(go_rt_avg: float):
	var ssd_sum : float = 0
	var ssd_count : float = 0
	for trial in session_trials:
		if !trial.trial_type:
			ssd_count += 1
			ssd_sum += trial.ssd
	var ssd_avg = ssd_sum / ssd_count
	return go_rt_avg - ssd_avg
	
	
#may not need now with the on timer end and the other one
#tells if chosen direction in go trial is corrent or not
#func check_go_response(chosen_dir: int):
#	if session_trials[-1].direction == chosen_dir:
#		return true
#	else:
#		return false

func calc_update_current_rt():
	var rt = final_rt_time - start_rt_time
	session_trials[-1].go_rt = rt
	print(rt)
	return rt

func get_current_trial_type():
	return session_trials[-1].trial_type

func get_if_pressed():
	return session_trials[-1].pressed
	
func set_if_pressed_true():
	session_trials[-1].set_pressed(true)
	return session_trials[-1].pressed
	
func get_current_direction():
	return session_trials[-1].direction

func set_successful(success: bool):
	session_trials[-1].set_successful(success)

func get_interval_time():
	return session_trials[-1].start_interval
	
func get_current_ssd():
	return session_trials[-1].ssd
