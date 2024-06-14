class_name Sequence_Controller


enum State_Type{MODEL, RESPONSE, HIGHLIGHT}
var game_state = State_Type.MODEL

var user : UserModel

var view : Sequence
var model : Sequence_Game


func _init(view_ref: Sequence, user_in: UserModel):
	view = view_ref
	model = Sequence_Game.new()
	user = user_in
	model.set_user(user)
	model.setup_game_for_player()

#highlights sequence of pins based on the type of sequence and chosen order - incomplete
func highlight_sequence(mem_order: Array): #sequence_type: Array
	for i in range(mem_order.size()):
		await view.highlight_pin(mem_order[i], 1, 0.6)
		
		
#on a pin press detected, check response for trial
func pin_press_detected(pin_key: int):
	if game_state == State_Type.RESPONSE:
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
	game_state = State_Type.HIGHLIGHT
	var sequence_type = model.choose_sequence_type()
	if sequence_type[0] == -1:
		model.next_level() #display in some way that the level has increased
		sequence_type = model.choose_sequence_type()
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
	if sequence_type[0] == 3:
		await view.display_delay_distraction()
	game_state = State_Type.RESPONSE

		
#updates stats in sequence game view
func update_display_stats():
	view.update_display(model.current_level,model.current_trial,model.current_session_performance, model.session_length)
		
#finishes trial once all of response is collected - could be updated for breaks/dialogue between trials
func all_pins_pressed():
	if model.get_current_trial() < model.session_length:
		game_state = State_Type.MODEL
		model.calculate_trial_score()
		model.update_overall_performance()
		model.update_session_performance()
		update_display_stats()
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
		
	
		
