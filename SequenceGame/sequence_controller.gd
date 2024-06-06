class_name Sequence_Controller


enum State_Type{MODEL, RESPONSE, HIGHLIGHT}

var game_state = State_Type.MODEL

var view
var model


func _init(view_ref: Sequence):
	view = view_ref
	model = Sequence_Game.new()


func highlight_sequence(mem_order: Array):
	for i in range(mem_order.size()):
		await view.highlight_pin(mem_order[i], 0)
		

func pin_press_detected(pin_key: int):
	if game_state == State_Type.RESPONSE:
		if model.check_update_response(pin_key):
			view.highlight_pin(pin_key,1)
		else:
			view.highlight_pin(pin_key,2)
		if model.check_pins_pressed() == model.get_current_mem_order().size():
			all_pins_pressed()
			
			
func begin_trial():
	if model.get_current_trial() <= model.get_total_trials():
		await view.prompt_for_next_trial()
		game_state = State_Type.HIGHLIGHT
		highlight_sequence(model.create_sequence_order(model.choose_sequence_type()))
		#the above line would have to be broken up to ensure not accidentally sending the complete mem_order for upper levels
		#here would be where the updating would happen
		game_state = State_Type.RESPONSE
		view.prompt_for_response(1)
	else:
		print("trials complete")#end_session() #this could become a func in the model
		
func all_pins_pressed():
	view.prompt_for_response(0)
	game_state = State_Type.MODEL
	model.update_overall_performance()
	model.reset_trial_info()
	begin_trial()
	
func get_current_trial():
	return model.get_current_trial()
		
		
		
		
		
		
		
		
