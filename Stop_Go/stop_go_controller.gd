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
	
	
#begins the session
func begin_session():
	model.setup_session()
	begin_trial()
	
#builds trial
func begin_trial():
	model.setup_trial()
	view.update_visual_info()
	view.run_timer(0,model.get_interval_time())
	
#starts the trial itself for the player to interact with
func begin_visual_trial():
	view.begin_trial_view(model.get_current_direction())
	if model.get_current_trial_type():
		model.start_rt_time = Time.get_ticks_msec()
		view.run_timer(1,model.allowed_max_rt) #fix rt time
	else: 
		model.start_rt_time = Time.get_ticks_msec()
		view.run_timer(2,model.get_current_ssd())
	#model.start_rt_time = Time.get_ticks_msec()

#once ssd timer is over, will then switch to the stop visuals
func begin_stop_half():
	view.begin_stop_visuals()
	view.run_timer(3,1.25)#change second one to be something model holds that determines how long the stop signal is shown for
	#bro dont touch that
	
func trial_key_pressed(direction: int): 
	model.final_rt_time = Time.get_ticks_msec()
	model.set_if_pressed_true()
	print("key pressed - pressed is true - " + str(model.current_trial))
	model.calc_update_current_rt()
	if model.get_current_trial_type():
		if model.get_current_direction() == direction:
			#view.display_feedback("Got it! Good work!")
			model.set_successful(true)
			model.record_check_response()
		else: 
			#view.display_feedback("Missed it! Make sure to look in the right direction")
			model.set_successful(false)
	else:
		#view.display_feedback("Ah! Be careful! Almost blew your cover or got hurt!")
		model.set_successful(false)
	end_trial()
	
#func for when stop or go timer runs out without a button press
func timeout_check_timer():
	if model.get_current_trial_type():
		model.set_successful(false)
		#view.display_feedback("You missed it, but we need to keep moving, we have to be quick")
	else:
		model.set_successful(true)
		#view.display_feedback("Good work! it was unsafe to collect, but we can make note of it")
	model.timer_ended_trial()
	end_trial()
	
#calls for view to display feedback
func give_feedback():
	var feedback = model.select_feedback()
	view.display_feedback(feedback)
	pass
	
func end_trial(): 
	view.update_visual_info()
	view.clear_trial()
	give_feedback()
	model.end_trial()
	#mmmmm reaction time
	check_for_next_trial()
	
#if there is more to go in the session, begin next trial with controller's begin_trial
func check_for_next_trial():
	if model.current_trial < model.session_length:
		begin_trial()
	else:
		print(model.current_trial)
		end_session()

func end_session():
	print("its over")
	model.end_session()
	view.end_session()

func get_current_trial_type():
	return model.get_current_trial_type()
	
func get_if_pressed():
	return model.get_if_pressed()

func get_current_score():
	return model.session_score
	
func get_current_trial_num():
	return model.current_trial
	
func get_current_level():
	return model.current_level
	
func get_best_RT():
	return model.session_best_rt
	
func get_session_length():
	return model.session_length
	
#report
func get_performances():
	return model.get_performances()
	
func get_graph_trial_types():
	return model.get_graph_trial_types()
	
func get_scores():
	return model.get_scores()
