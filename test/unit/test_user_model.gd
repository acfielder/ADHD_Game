extends GutTest

#~CBTT TESTS~
func test_create_sequence_trial_save():
	var user = UserModel.new()
	assert_eq(user.create_sequence_trial_save([1,-1],5,4),{"sequence_type": [1,-1], "sequence_length": 5, "score": 4})
	assert_eq(user.create_sequence_trial_save([3,2],7,0),{"sequence_type": [3,2], "sequence_length": 7, "score": 0})

func test_add_to_sequence_level_data():
	var user = UserModel.new()
	assert_eq(user.levels_data, {1:[[],[],[],[],[],[]], 2:[[],[],[],[],[],[]], 3:[[],[],[],[],[],[]], 4:[[],[],[],[],[],[]], 5:[[],[],[],[],[],[]]})
	user.add_to_sequence_level_data([2,-1],4,3)
	assert_eq(user.level_one_data, [[],[],[{"sequence_type": [2,-1], "sequence_length": 4, "score": 3}],[],[],[]])
	
	user.add_to_sequence_level_data([2,-1],6,6)
	assert_eq(user.level_one_data, [[],[],[{"sequence_type": [2,-1], "sequence_length": 4, "score": 3}, {"sequence_type": [2,-1], "sequence_length": 6, "score": 6}],[],[],[]])
	
	user.current_level = 3
	user.add_to_sequence_level_data([1,-1],4,3)
	user.add_to_sequence_level_data([3,0],3,2)
	assert_eq(user.level_three_data, [[],[{"sequence_type": [1,-1], "sequence_length": 4, "score": 3}],[],[],[{"sequence_type": [3,0], "sequence_length": 3, "score": 2}],[]])
	
	assert_eq(user.levels_data, {1:[[],[],[{"sequence_type": [2,-1], "sequence_length": 4, "score": 3}, {"sequence_type": [2,-1], "sequence_length": 6, "score": 6}],[],[],[]], 2:[[],[],[],[],[],[]], 3:[[],[{"sequence_type": [1,-1], "sequence_length": 4, "score": 3}],[],[],[{"sequence_type": [3,0], "sequence_length": 3, "score": 2}],[]], 4:[[],[],[],[],[],[]], 5:[[],[],[],[],[],[]]})

func test_increase_sequence_level():
	var user = UserModel.new()
	assert_eq(user.current_level,1)
	user.increase_sequence_level()
	assert_eq(user.current_level,2)
	
#~END CBTT TESTS~

#~STOP GO TESTS~
func test_create_SG_trial_save():
	var user = User_Data_Manager.load_resource()
	user.reset_stop_go_data()
	assert_eq(user.create_SG_trial_save(true),{"score": true})

func test_add_to_SG_trial_level_data():
	var user = User_Data_Manager.load_resource()
	user.reset_stop_go_data()
	user.add_to_SG_trial_level_data(true,true)
	assert_eq(user.levs_data_SG_trials,{1:{1:[{"score": true}],0:[]},2:{1:[],0:[]}})
	user.add_to_SG_trial_level_data(false,true)
	assert_eq(user.levs_data_SG_trials,{1:{1:[{"score": true}],0:[{"score":true}]},2:{1:[],0:[]}})
	user.current_SG_level = 2
	user.levs_data_SG_trials = {1:user.lev_one_SG_trials,2:user.lev_two_SG_trials}
	user.add_to_SG_trial_level_data(false,false)
	assert_eq(user.levs_data_SG_trials,{1:{1:[{"score": true}],0:[{"score":true}]},2:{1:[],0:[{"score":false}]}})
	
	
func test_create_SG_session_save():
	var user = User_Data_Manager.load_resource()
	user.reset_stop_go_data()
	assert_eq(user.create_SG_session_save(456.0,0.67,0.87),{"go_rt_avg": 456.0, "prob_signal_response": 0.67, "stop_signal_rt": 0.87})

	
func test_add_to_SG_session_level_data():
	var user = User_Data_Manager.load_resource()
	user.reset_stop_go_data()
	user.add_to_SG_session_level_data(536.7,0.67,0.45)
	assert_eq(user.levs_data_SG_sessions,{1:[{"go_rt_avg": 536.7, "prob_signal_response": 0.67, "stop_signal_rt": 0.45}],2:[]})
	user.add_to_SG_session_level_data(453.7,0.42,0.34)
	assert_eq(user.levs_data_SG_sessions,{1:[{"go_rt_avg": 536.7, "prob_signal_response": 0.67, "stop_signal_rt": 0.45},{"go_rt_avg": 453.7, "prob_signal_response": 0.42, "stop_signal_rt": 0.34}],2:[]})
	user.increase_SG_level()
	user.add_to_SG_session_level_data(345.5,0.90,0.45)
	assert_eq(user.levs_data_SG_sessions,{1:[{"go_rt_avg": 536.7, "prob_signal_response": 0.67, "stop_signal_rt": 0.45},{"go_rt_avg": 453.7, "prob_signal_response": 0.42, "stop_signal_rt": 0.34}],2:[{"go_rt_avg": 345.5, "prob_signal_response": 0.90, "stop_signal_rt": 0.45}]})

	
	#@export var lev_two_SG_sessions : Array = []
#more levels
#@export var levs_data_SG_sessions : Dictionary = {1:lev_one_SG_sessions}
	
	#var session_dict = create_SG_session_save(go_rt, prob_signal_response, stop_signal_rt)
	#levs_data_SG_sessions.get(current_SG_level).append(session_dict)
	
#not using yet, simply saving value to vars
func test_update_SG_overalls():
	pass
	
func test_increase_SG_level():
	var user = User_Data_Manager.load_resource()
	user.reset_stop_go_data()
	user.comp_of_level_SG = 7
	user.increase_SG_level()
	assert_eq(user.current_SG_level,2)
	assert_eq(user.comp_of_level_SG,0)

#~END STOP GO TESTS~


