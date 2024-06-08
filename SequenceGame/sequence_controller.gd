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
func highlight_sequence(mem_order: Array, sequence_type: Array):
	if sequence_type[1] == -1:
		for i in range(mem_order.size()):
			await view.highlight_pin(mem_order[i], 0)
	elif sequence_type[0] == 2:
		#logic for updating for missing one - remove one and display or switch around 2
		pass
	else: #when sequence type is 3
		if sequence_type[1] == 0 || sequence_type[1] == 1:
			for i in range(mem_order.size()):
				await view.highlight_pin(mem_order[i], 0)
		else:
			#logic for updating for missing one 2
			pass
		
		
#on a pin press detected, check response for trial
func pin_press_detected(pin_key: int):
	if game_state == State_Type.RESPONSE:
		if model.check_update_response(pin_key):
			view.highlight_pin(pin_key,1)
		else:
			view.highlight_pin(pin_key,2)
		if model.check_pins_pressed() == model.get_current_mem_order().size():
			all_pins_pressed()
			
#essential order of the game
func begin_trial():
	if user.completed_of_level + model.get_current_trial() > model.level_length:
		model.next_level()
		view.display_current_level()
	if model.get_current_trial() <= model.session_length:
		await view.prompt_for_next_trial()
		game_state = State_Type.HIGHLIGHT
		var sequence_type = model.choose_sequence_type()
		var mem_order
		if sequence_type[0] == -1:
			model.next_level()
			view.display_current_level()
			#display in some way that the level has increased
			sequence_type = model.choose_sequence_type()
			mem_order = model.create_sequence_order(sequence_type)
		#elif sequence_type[0] == 3:
		#	mem_order = model.create_sequence_order(sequence_type) - maybe ignore?
		else:
			mem_order = model.create_sequence_order(sequence_type)
		view.display_sequence_type()
		view.display_current_level()
		await highlight_sequence(mem_order,sequence_type) 
		#here would be where the updating would happen - &await prompt
		if sequence_type[0] == 3:
			if sequence_type[1] == 2:
				#tell them about the updated change
				pass
			await view.display_delay_distraction()
		game_state = State_Type.RESPONSE
		view.prompt_for_response(1)
	else:
		end_session()
		print("trials complete")
		
#finishes trial once all of response is collected - could be updated for breaks/dialogue between trials
func all_pins_pressed():
	view.prompt_for_response(0)
	game_state = State_Type.MODEL
	model.update_session_performance()
	model.update_overall_performance()
	model.reset_trial_info()
	begin_trial()
	
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
		
	
		
