extends Node
class_name User_Data_Manager

static var user: Resource = null

#load in usermodel resource
static func load_resource(path: String = "user://User_Model.tres") -> UserModel:
	user = ResourceLoader.load(path) as UserModel
	if user == null:
		user = UserModel.new()
		print("Created new user data")
	else:
		print("User data loaded, " + str(user.completed_of_level))
	return user

#save current user to usermodel resource
static func save(user_data: UserModel, path: String = "user://User_Model.tres") -> void:
	var save_result = ResourceSaver.save(user_data, path)
	if save_result == OK:
		print("User data saved")
	else:
		print("Failed to save user data", save_result)
