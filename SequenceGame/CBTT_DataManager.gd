extends Node
class_name CBTT_DataManager

#FILE NEEDS TO BE LISTENING FOR SIGNALS TO TRIGGER THESE FUNCS

const DataManager = preload("res://DataManager.tscn")

var data_manager: Node = null  # This will hold the single instance of the data manager

var main_controller1 = null #should be of type Sequence_Controller

func _ready():
	update_player_stats({"id": 2343, "name": "jeremiah", "randnum": 234524})


	
func initialize(main_controller):
	main_controller1 = main_controller
	#call_deferred("setup_signal_connections")
	setup_signal_connections()
	
func setup_signal_connections():
	main_controller1.request_user_data.connect(_on_request_user_data)
	main_controller1.update_player_stats.connect(_on_request_update_player_stats)
	#http_request.request_completed.connect(_on_request_completed_get)
	

# This function ensures the DataManager is only created once
func get_data_manager() -> Node:
	if data_manager == null:
		data_manager = DataManager.instantiate()
		#might need the below but its not possible rn?
		#get_tree().root.add_child(data_manager)
		#get_tree().root.call_deferred("add_child", data_manager)
		#get_tree().call_deferred("root.add_child", data_manager)
		#if is_inside_tree():
			#get_tree().root.add_child(data_manager)
		#else:
			#call_deferred("add_child", data_manager)
		call_deferred("add_child", data_manager)
	return data_manager

#example
func fetch_user_data():
	var callback = Callable(self, "_on_user_data_received")
	print(callback)
	var dm = await get_data_manager()
	dm.http_get("http://127.0.0.1:5000/get-data", callback, [])

#example - should see about taking the data apart to work with/update model
func _on_user_data_received(data):
	if data:
		print("User data received:", data)
	else:
		print("Failed to retrieve user data")
		
func update_player_stats(data: Dictionary):
	var callback = Callable(self, "_on_player_stats_updated")
	var dm = await get_data_manager()
	dm.http_post("http://127.0.0.1:5000/save-player-data", data, callback, [])
	
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
