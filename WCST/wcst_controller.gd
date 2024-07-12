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
	begin_phase_one()
	
func begin_trial():
	#at end when crd is shown start rt and allow response
	#at end state = State.RESPOND
	#model.start_rt = Timer.get_ticks_msec()
	pass
	
func begin_phase_one():
	view.give_phase_instruction(1)
	pass
	
func begin_phase_two():
	view.give_phase_instruction(2)
	pass
	
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
	
#returns whether or not there is a next trial in this phase
func check_for_next_trial() -> bool:
	if model.current_trial >= model.phase_length:
		return false
	else: return true
	
#moves onto next pahse if there is one or ends session
func check_for_next_phase():
	if model.current_phase < 2:
		begin_phase_two()
	else:
		end_session()
	
	#the end phases may be the same
func end_phase_one():
	view.end_phase_one()
	pass
	
func end_phase_two():
	pass
	
func end_session():
	print("session ended")
	model.end_session()
	view.end_session()


func get_if_pressed():
	return model.get_if_trial_pressed()
