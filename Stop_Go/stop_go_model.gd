class_name StopGoModel

var user: UserModel

var session_trials: Array[StopGoTrial] = [] #list of all trials completed in this session

var session_length: int = 20 #number of trials in a session //maybe like 40?

var rng = RandomNumberGenerator.new()

var session_last_ssd: float = 100 #tracking of the current ssd
var session_last_ssd_score: int #0 or 1 for whether or not successful

var min_interval : int = 2 #min time to allow walking before trial
var max_interval : int = 4 #max time to allow walking before trial

var current_trial : int = 0

var session_go_rt_avg: float
var session_prob_signal_response: float
var session_stop_signal_rt: float

var allowed_max_rt: float = 0.8


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
	if !trial:
		determine_next_ssd(trial) #updates session_last_ssd
		trial.ssd = session_last_ssd
	trial.start_interval = determine_interval()
	trial.direction = choose_direction(trial)
	current_trial += 1
	trial.trial_num = current_trial
	#maybe determine how long the allowed RT is
	session_trials.append(trial)

#chooses between stop and go trials and makes a trial objects
func create_trial_type():
	var trial_type
	var i = rng.randf_range(0,1)
	if i <= 0.7:
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
	
#updates any final information for a now completed trial
func end_trial(): #should this be different depending on which calls it?
	#if ssd was successful, note that as 1 or 0
	#save the rt
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
	for trial in session_trials:
		if (trial.trial_type && trial.successful) || (!trial.trial_type && !trial.successful):
			time_sum += trial.go_rt
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
	return correct_stops/total_stops
	
#calculates the stop signal reaction time - needs much more research
func calc_session_stop_signal_rt(go_rt_avg: float):
	var ssd_sum
	var ssd_count
	for trial in session_trials:
		if !trial.trial_type:
			ssd_count += 1
			ssd_sum += trial.ssd
	var ssd_avg = ssd_sum / ssd_count
	return go_rt_avg - ssd_avg
	
#tells if chosen direction in go trial is corrent or not
func check_go_response(chosen_dir: int):
	if session_trials[-1].direction == chosen_dir:
		return true
	else:
		return false

func get_current_trial_type():
	return session_trials[-1].trial_type

func get_if_pressed():
	return session_trials[-1].pressed

func set_successful(success: bool):
	session_trials[-1].set_successful(success)
