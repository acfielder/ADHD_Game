class_name sequence_controller

#signals
signal highlight_pin(pin_key, highlight_type)
signal prompt_for_response()

#var Sequence_Game = preload("res://sequence_game.gd")
var sequence_game = Sequence_Game.new()

#const Sequence = preload("res://Sequence.gd")
#var sequence = Sequence.new()

enum State_Type{MODEL, RESPONSE, HIGHLIGHT}

var game_state = State_Type.MODEL

var view


func _init(view_ref: Sequence):
	#var Sequence_View = preload("res://Sequence.gd")
	#var sequence_view = Sequence_View.new()
	view = view_ref
	
	#sequence_view.connect("begin_trial", self, "_on_begin_trial")
	#sequence_view.connect("pin_press_detected", Callable(self, "pin_press_detected"))

	view.begin_trial.connect(_on_begin_trial)

#var button = Button.new()
	# `button_down` here is a Signal variant type, and we thus call the Signal.connect() method, not Object.connect().
	# See discussion below for a more in-depth overview of the API.
	#button.button_down.connect(_on_button_down)



func highlight_sequence(mem_order):
	for i in range(mem_order.size()):
		#emit_signal("highlight_pin", mem_order[i], 0)
		highlight_pin.emit(mem_order[i], 0)
		

func pin_press_detected(pin_key):
	if game_state == State_Type.RESPONSE:
		if sequence_game.check_update_response(pin_key):
			emit_signal("highlight_pin", pin_key, 1)
		else:
			emit_signal("highlight_pin", pin_key, 2)
			
			
func _on_begin_trial():
	if sequence_game.get_current_trial() < sequence_game.get_total_trials():
		game_state = State_Type.HIGHLIGHT
		highlight_sequence(sequence_game.create_sequence_order())
		game_state = State_Type.RESPONSE
		emit_signal("prompt_for_response") #still needs connected
	else:
		print("what")#end_game() #this could become a func in the model
		
#func (on_all_pins_pressed_signal():
	#game_state = State_Type.MODEL
	#sequence_game.update_overall_performance()
	#sequence_game.update_trial_info()
	#begin_trial()
		
		
		
		
		
		
		
		
		
