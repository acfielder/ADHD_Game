class_name StopGoModel


var session_trials: Array[StopGoTrial]


var min_trial_interval: int = 2 #sec
var max_trial_interval: int = 4 #sec

func _init():
	pass
	
#chooses between stop and go trials and makes a trial objects
func create_trial_type():
	#if >70 = go
	#else = stop
	#create trial obj
	pass
	

	
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



