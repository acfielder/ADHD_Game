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
	view.run_timer(3,2)#change second one to be something model holds that determines how long the stop signal is shown for
	#bro dont touch that
	
func trial_key_pressed(direction: int): 
	model.final_rt_time = Time.get_ticks_msec()
	model.set_if_pressed_true()
	print("key pressed - pressed is true - " + str(model.current_trial))
	model.calc_update_current_rt()
	if model.get_current_trial_type():
		if model.get_current_direction() == direction:
			model.set_successful(true)
	else:
		model.set_successful(false)
	end_trial()
	
#func for when stop or go timer runs out without a button press
func timeout_check_timer():
	if model.get_current_trial_type():
		model.set_successful(false)
	else:
		model.set_successful(true)
	end_trial()
	
func end_trial(): 
	view.clear_trial()
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
	view.end_session()

func get_current_trial_type():
	return model.get_current_trial_type()
	
func get_if_pressed():
	return model.get_if_pressed()
