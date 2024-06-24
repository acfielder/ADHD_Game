class_name StopGoTrial


var trial_type: bool #true is go, false is stop
var go_rt: float #response time for a go trial or failed stop trial
var stop_rt: float #rt for stop trial - higher level calculations
var successful: bool #whether or not the trial was successfully completed
var ssd: float #stop signal delay time 


func _init(trial_type_in: bool):
	trial_type = trial_type_in
	
#based on successful and trial's ssd, only if this is a stop trial
func determine_next_ssd():
	pass


