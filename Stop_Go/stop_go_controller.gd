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
	model.setup_session()
	
func begin_trial():
	model.setup_trial()
	
func trial_key_pressed():
	pass
	
func end_trial():
	#tell model to end the trial
	pass


