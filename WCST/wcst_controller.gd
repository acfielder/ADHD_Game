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
	#begin_phase_one()
	view.prompt_phase_one()

	
func begin_trial():
	var trial_card_info = model.setup_trial()
	view.set_trial_card_texture(trial_card_info)
	view.update_visual_info()
	state = State.RESPOND
	if model.current_phase == 1:
		view.create_run_timer(8)
	elif model.current_phase == 2:
		view.create_run_timer(6)
	model.start_rt = Time.get_ticks_msec()
	#at end when crd is shown start rt and allow response
	#at end state = State.RESPOND
	#model.start_rt = Timer.get_ticks_msec()
	
func begin_phase_one():
	model.setup_phase() #increase phase on - starts at 0
	await view.setup_phase_one()
	model.rule_change()
	view.update_rule()
	begin_trial()
	
func begin_phase_two():
	model.setup_phase() #increase phase on
	await view.setup_phase_two()
	model.rule_change()
	view.update_rule()
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
	view.update_visual_info()
	check_for_next_trial()
	
#moves into a trial or ends session once determines where at in process
func check_for_next_trial():
	if model.current_trial_in_rule < model.rule_length:
		begin_trial()
	else:
		if model.current_rule < model.phase_length:
			next_rule()
			view.update_rule()
			begin_trial()
		else:
			if model.current_phase < 2:
				end_phase_one()
			else:
				end_phase_two()
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
	end_session()
	
func update_visuals():
	pass

	
func end_session():
	print("session ended")
	model.end_session()
	view.end_session()


func get_current_rule_string():
	var rule = model.get_current_rule_string()
	return rule

func get_if_pressed():
	return model.get_if_trial_pressed()
	
func get_score():
	return model.score
	
func get_phase():
	return model.current_phase
	
func get_trial():
	return model.current_trial
	
func get_best_rt():
	return model.best_rt

func get_performances():
	return model.get_performances()
	
func get_scores():
	return model.get_scores()
	
func get_rt_info():
	return model.get_rt_info()
