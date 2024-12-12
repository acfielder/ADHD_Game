class_name Sequence_Controller

#signals emitted for CBTTDataManager
signal request_session_start_data #emitted at end of _init, both along with and partially in place of model.setup_game_for_player
#the three below would be emitted at session end but should be session_stats, trial_stats, then session_progress, and things 
	#inbetween as things like what level they're on may change and completed of level may be reset for session progress.
signal update_session_progress #must send session progress stats all together - dictionary created as emitting
signal update_session_stats #must send new session stats all together - dictionary created as emitting
signal update_trials_stats #must send all trials - may have to break up before being sent to CBTTDataManager 
							#controller but currently setup to send model's trial_history. should also send user's id
							
var datamanager = preload("res://SequenceGame/CBTT_DataManager.tscn")

enum State_Type{MODEL, RESPONSE, HIGHLIGHT}
var game_state = State_Type.MODEL

var user : UserModel

var view : Sequence
var model : Sequence_Game

var trial_response_begun : bool = false




func _init(view_ref: Sequence, user_in: UserModel):
	view = view_ref
	model = Sequence_Game.new()
	user = user_in
	model.set_user(user)
	model.setup_game_for_player()
	#setup_data_manager() #should be uncommented!!! - needs to be initialized though this controller will only ever emit signals for it to listen for

#to initialize CBTT datamanager - though will not directly interact, will emit signals to it
func setup_data_manager():
	var datamanagerscene = datamanager.instantiate()
	datamanagerscene.initialize(self)
	call_deferred("add_child", datamanagerscene)
	await view.create_short_timer(0.0)

#highlights sequence of pins based on the type of sequence and chosen order - incomplete
func highlight_sequence(mem_order: Array): #sequence_type: Array
	for i in range(mem_order.size()):
		await view.highlight_pin(mem_order[i], 1, 0.6)
		
		
#on a pin press detected, check response for trial
func pin_press_detected(pin_key: int):
	if game_state == State_Type.RESPONSE:
		if !trial_response_begun:
			view.begin_string(pin_key)
			trial_response_begun = true
		else:
			view.end_string(pin_key)
			if model.get_if_another_event(): 
				view.begin_string(pin_key)
		
		if model.check_update_response(pin_key):
			view.highlight_pin(pin_key,2,0.3) #correct - feedback
		else:
			view.highlight_pin(pin_key,3,0.3) #incorrect - feedback
		if model.check_pins_pressed() == model.get_answer_order().size(): #this shoudl be answer_order not mem_order
			all_pins_pressed()

#runs through actual trial
func run_trial():
	view.set_pin_images()
	await setup_trial()
	await run_visuals(model.get_current_sequence_type())
			
#sets up current trial
func setup_trial():
	await view.create_short_timer(0.75)
	trial_response_begun = false
	game_state = State_Type.HIGHLIGHT
	var sequence_type = model.choose_sequence_type()
	if sequence_type[0] == -1:
		sequence_type = model.choose_sequence_type()
		#model.next_level() #display in some way that the level has increased
	#view.display_current_level()
	update_display_stats()
	model.create_sequence_order(sequence_type)
	model.update_trial_info()

	
#shows prompts and highlights pins
func run_visuals(sequence_type : Array):
	var trial_prompt = model.get_prompt(0)
	if trial_prompt != null: #test out this if statement below the await highlight
		view.prompt(1, trial_prompt)
	await highlight_sequence(model.get_current_mem_order())
	trial_prompt = model.get_prompt(1)
	if sequence_type[0] == 2 || sequence_type[1] == 2:
		view.prompt(1,trial_prompt)
	if sequence_type[0] == 3: #this would be checking is trial has yes delay on
		await view.display_delay_distraction()
	game_state = State_Type.RESPONSE

		
#updates stats in sequence game view
func update_display_stats():
	view.update_display(model.current_level,model.current_trial,model.current_session_performance, model.session_length)
		
#finishes trial once all of response is collected - could be updated for breaks/dialogue between trials
func all_pins_pressed():
	game_state = State_Type.MODEL
	model.calculate_trial_score()
	model.update_overall_performance()
	model.update_session_performance()
	update_display_stats()
	if model.get_current_trial() < model.session_length:
		
		await view.clear_string() #clearing the connecting string
		model.reset_trial_info()
		await view.prompt_next_trial()
		view.prompt(0)
	else:
		end_session()
	#begin_trial() #if want to continuously go through, uncomment this and comment out above line
	
#finishes the session
func end_session():
	game_state = State_Type.MODEL
	model.end_session()
	view.display_session_over()
	

#below - used by view
func get_current_trial() -> int:
	return model.get_current_trial()
		
func get_current_level() -> int:
	return model.get_current_level()
	
func get_sequence_type() -> Array:
	return model.get_current_sequence_type()
		
func get_performances() -> Dictionary:
	return model.get_performances()
	
func get_scores() -> Array:
	return model.get_scores()
		
