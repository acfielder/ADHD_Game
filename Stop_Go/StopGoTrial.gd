class_name StopGoTrial

var rng = RandomNumberGenerator.new()

var time_to_respond = .8 #or const? unsure if want to change for difficulty purposes later on

var trial_type: bool #true is go, false is stop
var trial_num: int #trial num in session
var start_interval: float #interval of time between the previous trial and the current trial
var go_rt: float #response time for a go trial or failed stop trial
var stop_rt: float #rt for stop trial - higher level calculations
var successful: bool #whether or not the trial was successfully completed
var ssd: float #stop signal delay time 
var direction: int #left is 1, right is 2 (center is 0 but doesnt need to be set)
var pressed: bool #to know whether or not the player responded in a trial (should or shouldnt have)




func _init(trial_type_in: bool):
	trial_type = trial_type_in
	
#based on successful and trial's ssd, only if this is a stop trial
func determine_ssd(previous_ssd: float, success: int): #need to know if it was successful or not
	
	pass

#determines next based on a random num between min and max
func determine_next_interval(min_interval: float, max_interval: float):
	var i = rng.randf_range(min_interval, max_interval)
	return i
	
#chooses the direction of the go cue
func choose_direction():
	var i = rng.randf_range(0,1)
	if i < 0.5:
		direction = 1
	else:
		direction = 2
	return direction

#saves the go cue RT after response - either successful go or unsuccessful stop
func set_go_rt(rt: float):
	go_rt = rt
	
#calculates the stop reaction time for the trial?
func calc_stop_rt():
	pass
	
#sets whether or not the trial was considered successful
func set_successful():
	pass
