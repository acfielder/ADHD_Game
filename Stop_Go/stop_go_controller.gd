class_name StopGoController


#enum for place in trial? or trial type

var user : UserModel

var view : StopGoWorld
var model : StopGoModel


func _init(view_in: StopGoWorld, user_in: UserModel):
	view = view_in
	user = user_in
	model = StopGoModel.new()
	model.set_user(user)
	model.setup_session()
	
#builds trial
func begin_trial():
	model.setup_trial()
	
#starts the trial itself for the player to interact with
func begin_visual_trial():
	pass

#once ssd timer is over, will then switch to the stop visuals
func begin_stop_half():
	pass
	
func trial_key_pressed(direction: int):
	#should say to the model to note taht something was indeed pressed for this trial, whether you were supposed to or not
	#should stop the rt timer
	#should stop any ongoing timer/set a var to true so it doesnt run when it goes off
	#check if response was as it was meant to be - call for it
	pass
	
#func end_timer_ran_out():
	#if stop 
#	pass
	
func check_press_response(direction: int):
	pass
	
func missed_go_cue():
	pass
	
func end_trial(timer_type: int): #could maybe have different types of end_trial that call them a more common end trial?
	#0 is stop timer running out, 1 is go rt timer running out
	#need to pass in if successful?or know which one is calling this func so know if thats a good thing or not
	#tell model to end the trial
	#this is as soon as there is a key press OR a timer runs out
	pass

func get_current_trial_type():
	return model.get_current_trial_type()
	
func get_if_pressed():
	return model.get_if_pressed()
