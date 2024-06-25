class_name StopGoModel

var user: UserModel

var session_trials: Array[StopGoTrial] = [] #list of all trials completed in this session

var session_length: int = 20 #number of trials in a session

var rng = RandomNumberGenerator.new()

var session_last_ssd: float = 100 #tracking of the current ssd
var session_last_ssd_score: int #0 or 1 for whether or not successful

var min_interval : int = 2 #min time to allow walking before trial
var max_interval : int = 4 #max time to allow walking before trial

var current_trial : int = 0

func _init():
	pass
	
func set_user(user_in: UserModel):
	user = user_in	
	
#setup things for this session like what level they're on and later down line, their scores to start their difficulty correctly all around
func setup_session():
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

#gets the next interval length based on previous trial's interval length and 'successful'
func determine_interval():
	return session_trials[-1].determine_next_interval(min_interval,max_interval)
	
#tells the trial to pick the direction of its go cue
func choose_direction(trial: StopGoTrial):
	return trial.choose_direction()
	
#updates any final information for a now completed trial
func end_trial():
	#if ssd was successful, note that as 1 or 0
	#save the rt
	#calc stop rt?
	pass
	
#**session end**#
	
#calls functions to calculate the sessions performance for the three major measurements
func determine_session_results():
	calc_session_go_rt()
	calc_session_prob_signal_response()
	calc_session_stop_signal_rt()

#calculates the average go trial reaction time for the session
func calc_session_go_rt(): #go trial successful, stop unsuccessful
	#unsure of this bc idk where ill save unsuccessful stop times, probably right in go
	var time_sum = 0
	for trial in session_trials:
		if trial.trial_type && trial.successful:
			time_sum += trial.go_rt
		elif !trial.trial_type && !trial.successful:
			time_sum += trial.go_rt
	pass
	
#calculates the probability of signal response across all ssd's
func calc_session_prob_signal_response():
	pass
	
#calculates the stop signal reaction time - needs much more research
func calc_session_stop_signal_rt():
	pass

