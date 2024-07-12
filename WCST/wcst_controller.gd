extends Node
class_name wcstController

var view : wcstView
var user : UserModel
var model : wcstModel

enum State {WATCH,RESPOND}
var state = State.WATCH




func _init(view_in: wcstView, user_in: UserModel):
	view = view_in
	user = user_in
	model = wcstModel.new()
	model.set_user(user)


func begin_session():
	model.setup_session()
	await view.give_instructions() #needs drawn out
	begin_phase_one()
	
func begin_trial():
	#at end when crd is shown start rt and allow response
	#at end state = State.RESPOND
	#model.start_rt = Timer.get_ticks_msec()
	pass
	
func begin_phase_one():
	model.setup_phase() #increase phase on - starts at 0
	await view.setup_phase_one()
	begin_trial()
	
func begin_phase_two():
	model.setup_phase() #increase phase on
	await view.setup_phase_two()
	begin_trial()
	
func card_sort_attempt_detected(card_info: Array):
	if state == State.RESPOND:
		state = State.WATCH
		model.final_rt = Time.get_ticks_msec()
		model.calc_update_current_rt()
		if model.record_check_response(card_info):
			give_feedback(0)
		else:
			give_feedback(1)
		end_trial()

func sort_timer_timeout():
	state = State.WATCH
	give_feedback(2)
	model.timer_ended_trial()
	end_trial()
	
func give_feedback(feedback_type: int):
	await view.display_speech_feedback(feedback_type) #should this be await?
	
func end_trial():
	pass
	
#moves into a trial or ends session once determines where at in process
func check_for_next_trial():
	if model.current_trial_in_rule < model.rule_length:
		begin_trial()
	else:
		if model.current_rule < model.phase_length:
			next_rule()
		else:
			if model.current_phase < 2:
				end_phase_one()
			else:
				end_session()
	update_visuals()
	
	
func next_rule():
	model.rule_change()
	
	
	#the end phases may be the same
func end_phase_one():
	view.end_phase_one()
	model.end_phase()

	
func end_phase_two():
	view.end_phase_two()
	model.end_phase()
	
func update_visuals():
	pass

	
func end_session():
	print("session ended")
	model.end_session()
	view.end_session()


func get_if_pressed():
	return model.get_if_trial_pressed()
