class_name StopGoTrial

var time_to_respond = .8 #or const? unsure if want to change for difficulty purposes later on

var trial_type: bool #true is go, false is stop
var start_interval: float #interval of time between the previous trial and the current trial
var go_rt: float #response time for a go trial or failed stop trial
var stop_rt: float #rt for stop trial - higher level calculations
var successful: bool #whether or not the trial was successfully completed
var ssd: float #stop signal delay time 

var min_trial_interval: int = 2 #sec
var max_trial_interval: int = 4 #sec


func _init(trial_type_in: bool):
	trial_type = trial_type_in
	
#based on successful and trial's ssd, only if this is a stop trial
func determine_ssd(previous_ssd: float):
	pass

func determine_next_interval():
	#determines next based on a random num between min and max
	pass

