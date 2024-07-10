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
