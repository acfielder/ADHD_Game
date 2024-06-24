class_name StopGoModel

var user: UserModel

var session_trials: Array[StopGoTrial] = []

var rng = RandomNumberGenerator.new()

var session_last_ssd: float = 100 #tracking of the current ssd

func _init():
	pass
	
func set_user(user_in: UserModel):
	user = user_in	
	
#setup things for this session like what level their on and later down line, their scores to start their difficulty correctly all around
func setup_session():
	pass
	
func setup_trial():
	var trial = StopGoTrial.new(create_trial_type())
	if !trial:
		determine_next_ssd(trial) #updates session_last_ssd
		trial.ssd = session_last_ssd
	trial.start_interval = determine_interval()
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
	
func determine_next_ssd(trial: StopGoTrial):
	session_last_ssd = trial.determine_ssd(session_last_ssd)
	
func determine_interval():
	session_trials[-1].determine_next_interval()
	
#**session end**#
	
#calls functions to calculate the sessions performance for the three major measurements
func determine_session_results():
	calc_session_go_rt()
	calc_session_prob_signal_response()
	calc_session_stop_signal_rt()

#calculates the average go trial reaction time for the session
func calc_session_go_rt():
	pass
	
#calculates the probability of signal response across all ssd's
func calc_session_prob_signal_response():
	pass
	
#calculates the stop signal reaction time - needs much more research
func calc_session_stop_signal_rt():
	pass



