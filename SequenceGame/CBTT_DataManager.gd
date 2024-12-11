extends Node
class_name CBTT_DataManager

#FILE NEEDS TO BE LISTENING FOR SIGNALS TO TRIGGER THESE FUNCS

const DataManager = preload("res://DataManager.tscn")

var data_manager: Node = null  # This will hold the single instance of the data manager

var main_controller1 = null #should be of type Sequence_Controller
var model = null

@export var server = "http://127.0.0.1:5000/"

func _ready():
	#update_player_stats({"id": 2343, "name": "jeremiah", "randnum": 234524})
	#fetch_user_data()
	pass

	
func initialize(main_controller): #also needs model_in
	main_controller1 = main_controller
	#model = model_in
	###call_deferred("setup_signal_connections") not needed
	setup_signal_connections()
	
func setup_signal_connections():
	main_controller1.request_user_data.connect(_on_request_user_data)
	main_controller1.update_player_stats.connect(_on_request_update_player_stats)
	#http_request.request_completed.connect(_on_request_completed_get)
	
	#actual signal connections
	#main_controller1.request_session_start_data.connect(get_session_start_info)
	#main_controller1.update_session_progress.connect(post_session_progress_update)
	#main_controller1.update_session_stats.connect(post_session_stats)
	#main_controller1.update_trials_stats.connect(post_trials_stats)
	

# This function ensures the DataManager is only created once
func get_data_manager() -> Node:
	if data_manager == null:
		data_manager = DataManager.instantiate()
		await get_tree().create_timer(0.0).timeout
		#might need the below but its not possible rn?
		#get_tree().root.add_child(data_manager)
		#get_tree().root.call_deferred("add_child", data_manager)
		#get_tree().call_deferred("root.add_child", data_manager)
		#if is_inside_tree():
			#get_tree().root.add_child(data_manager)
		#else:
			#call_deferred("add_child", data_manager)
		#call_deferred("add_child", data_manager)
		add_child(data_manager)
	return data_manager

#example
func fetch_user_data():
	var callback = Callable(self, "_on_user_data_received")
	print(callback)
	var dm = await get_data_manager()
	dm.http_get(server + "get-data", callback, [])

#example - should see about taking the data apart to work with/update model
func _on_user_data_received(data):
	if data:
		print("User data received:", data)
	else:
		print("Failed to retrieve user data")
		
func update_player_stats(data: Dictionary):
	var callback = Callable(self, "_on_player_stats_updated")
	var dm = await get_data_manager()
	dm.http_post(server + "save-player-data", data, callback, [])
	
#these types of callbacks will most likely just be for getting data, the post ones may all go to the same func
func _on_player_stats_updated(response_code):
	if response_code == 201:
		print("stats updated successfully")
	else:
		print("post failed")
		
		
#handle test signal
func _on_request_user_data():
	fetch_user_data()
	
func _on_request_update_player_stats(data):
	update_player_stats(data)


#actual final functions
#calls for getting participant's data from database in order to set up the CBTT session
#doesnt need a view, simply ignore unnecessary data
func get_session_start_info():
	var callback = Callable(self, "_on_session_start_data_retrived")
	var dm = await get_data_manager()
	dm.http_get(server + "get-session-start-data", callback, [])

#callback function to recieve the session start data from the GetPostDataManager
func _on_session_start_data_retrived(data):
	#for i in data:
	#	i[""]
		
		
	pass
	
#calls for saving session progress stat update to database / data - level(if updated that new one), session count, completed of level, default when
func post_session_progress_update(data):
	pass
	
#calls for saving individual session stats to database / data - num, length, score, longest sequence, level completed at(before updated if was), default when
func post_session_stats(data):
	pass
	
#calls for saving each individual trial stats to database / data - num, session #, sequence type name, length, score, default when
func post_trials_stats(data):
	pass
	
#generic callback function for posts - should probably include what the initial call was for testing purposes / or make separate for each post
func _on_post_return(response_code):
	pass
