extends Node
class_name CBTT_DataManager

#FILE NEEDS TO BE LISTENING FOR SIGNALS TO TRIGGER THESE FUNCS

const DataManager = preload("res://DataManager.tscn")

var data_manager: Node = null  # This will hold the single instance of the data manager

var main_controller1 = null #should be of type Sequence_Controller
var model = null

@export var server = "http://127.0.0.1:5000/" #should eventually become a live, nonlocal server

func _ready():
	#update_player_stats({"id": 2343, "name": "jeremiah", "randnum": 234524})
	#fetch_user_data()
	pass

#should be initialized
func initialize(main_controller, model_in): 
	main_controller1 = main_controller
	model = model_in
	###call_deferred("setup_signal_connections") not needed
	setup_signal_connections()
	
func setup_signal_connections():
	#main_controller1.request_user_data.connect(_on_request_user_data)
	#main_controller1.update_player_stats.connect(_on_request_update_player_stats)
	
	#actual signal connections
	main_controller1.request_session_start_data.connect(get_session_start_info)
	main_controller1.update_session_progress.connect(post_session_progress_update)
	main_controller1.update_session_stats.connect(post_session_stats)
	main_controller1.update_trials_stats.connect(post_trials_stats)
	

# This function ensures the DataManager is only created once
func get_data_manager() -> Node:
	if data_manager == null:
		data_manager = DataManager.instantiate()
		await get_tree().create_timer(0.0).timeout
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
func get_session_start_info(par_id): #participant's id to ensure collecting correct data
	var callback = Callable(self, "_on_session_start_data_retrived")
	var dm = await get_data_manager()
	#needs to also send the parid to get correct one
	var url = server + "get-cbtt-session-start-data" + "?id=" + str(par_id) #sending parid parameter through url
	dm.http_get(url, callback, [])

#callback function to recieve the session start data from the GetPostDataManager
func _on_session_start_data_retrived(data):
	for row in data:
		row["sessionscompleted"] #-> save directly into model var # equivalent to sessioncount in calling model's update_session_length
		row["currentlevel"] #-> save directly into model var # equivalent to model's currentlevel
		row["completedoflevel"] #-> save directly into model var #equivalent to usermodel's completed_of_level (CBTT) 
		row["lastsessionscore"] #-> save directly into model var # equivalent to performance[0] in calling model's update_session_length
		row["sessionlength"] #-> save directly into model var #equivalent to performance[1] in calling model's update_session_length
	pass
	
#calls for saving session progress stat update to database / data (dictionary) - parid, level(if updated, that new one), session count/ session num just completed, completed of level(if new level, should be 0), (default when- done in flask)
func post_session_progress_update(data: Dictionary):
	#example = {"parid": par_id, "level": currentlevel, "sessioncount": sessionnum, "completedoflevel": completedoflevel]}
	var callback = Callable(self, "_on_post_return")
	var dm = await get_data_manager()
	dm.http_post(server + "post-cbtt-session-progress-update", data, callback, [])
	
#calls for saving individual session stats to database / data (dictionary)- parid, num, length, score, longest sequence(not currently saved but should be), level completed at(before updated if was),(default when- done in flask)
func post_session_stats(data: Dictionary):
	#example = {"parid": par_id, "sessionnum": sessionnum, "length": session_length, "score": current_session_performance, "longestsequence": longest_sequence, "level": currentlevel]}
	var callback = Callable(self, "_on_post_return")
	var dm = await get_data_manager()
	dm.http_post(server + "post-cbtt-session-stats", data, callback, [])
	
#calls for saving each individual trial stats to database / data - parid (from model-doesnt exist), num, session #(from model-doesnt exist), sequence type name(wrong format for current trialinfo), length, score, (default when- done in flask)
func post_trials_stats(trials: Array):
	var data = []
	for trial in trials:
		var dict_to_add = {"parid": model.parid, "trialnum": trial.trial_num, "sessionnum": model.session_num, "sequencetype": trial.sequence_type, "length": trial.length, "score": trial.score}
		data.append(dict_to_add)
	var callback = Callable(self, "_on_post_return")
	var dm = await get_data_manager()
	dm.http_post(server + "post-cbtt-trials-stats", data, callback, [])
	
#generic callback function for posts - should probably include what the initial call was for testing purposes / or make separate for each post
func _on_post_return(response_code):
	if response_code == 201:
		print("Player stats added to database successfully")
	else:
		print("POST failed")
