extends Node
class_name wcstController

var view : wcstView
var user : UserModel
var model : wcstModel



func _init(view_in: wcstView, user_in: UserModel):
	view = view_in
	user = user_in
	model = wcstModel.new()
	model.set_user(user)


func begin_session():
	pass
	
func begin_trial():
	pass
	
func begin_phase_one():
	pass
	
func begin_phase_two():
	pass
	
func card_sort_attempt_detected():
	pass

func sort_timer_timeout():
	pass
	
func give_feedback():
	pass
	
func end_trial():
	pass
	
func check_for_next_trial():
	pass
	
	#the end phases may be the same
func end_phase_one():
	pass
	
func end_phase_two():
	pass
	
func end_session():
	pass


func get_if_pressed():
	pass
