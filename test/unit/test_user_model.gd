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

#~WCST TESTS~
func test_create_wcst_trial_save():
	var user = User_Data_Manager.load_resource()
	user.reset_wcst_data()
	assert_eq(user.create_wcst_trial_save(456.34,true),{"reaction time": 456.34, "successful": 1})
	
func test_create_rule_dict():
	var user = User_Data_Manager.load_resource()
	user.reset_wcst_data()
	assert_eq(user.create_rule_dict(.75,[2,3,4,5]),{"adaption rate": .75,"trials":[2,3,4,5]})#fake trial objs
	
func test_create_phase_dict():
	var user = User_Data_Manager.load_resource()
	user.reset_wcst_data()
	assert_eq(user.create_phase_dict([1,2,3,4],0.78,543.6,.46),{"rule blocks": [1,2,3,4], "accuracy rate": 0.78, "avg_r_t": 543.6, "adaption rate": .46})#fake rule blocks

	
func test_save_phase_data():
	var user = User_Data_Manager.load_resource()
	user.reset_wcst_data()
	user.save_phase_data({"rule blocks": [1,2,3,4], "accuracy rate": 0.78, "avg_r_t": 543.6, "adaption rate": .46},{"rule blocks": [4,3,2,1], "accuracy rate": 0.52, "avg_r_t": 243.7, "adaption rate": .92})
	assert_eq(user.phase_one_data, [{"rule blocks": [1,2,3,4], "accuracy rate": 0.78, "avg_r_t": 543.6, "adaption rate": .46}])
	assert_eq(user.phase_two_data, [{"rule blocks": [4,3,2,1], "accuracy rate": 0.52, "avg_r_t": 243.7, "adaption rate": .92}])
	
func test_update_accuracy_rate():
	var user = User_Data_Manager.load_resource()
	user.reset_wcst_data()
	user.update_accuracy_rate(.98)
	assert_eq(user.accuracy_rate["all rates"],.98)
	assert_eq(user.accuracy_rate["total phases"], 1)
	assert_eq(user.accuracy_rate["overall accuracy rate"],.98)

	user.update_accuracy_rate(0.72)
	assert_eq(user.accuracy_rate["all rates"],1.7)
	assert_eq(user.accuracy_rate["total phases"], 2)
	assert_eq(user.accuracy_rate["overall accuracy rate"],.85)
	
func test_update_avg_rt():
	var user = User_Data_Manager.load_resource()
	user.reset_wcst_data()
	user.update_avg_rt(.45)
	assert_eq(user.avg_r_t["all averages"],.45)
	assert_eq(user.avg_r_t["total phases"],1)
	assert_eq(user.avg_r_t["overall average RT"],.45)
	
	user.update_avg_rt(.63)
	assert_eq(user.avg_r_t["all averages"],1.08)
	assert_eq(user.avg_r_t["total phases"],2)
	assert_eq(user.avg_r_t["overall average RT"],.54)

func test_update_adaption_rate():
	var user = User_Data_Manager.load_resource()
	user.reset_wcst_data()
	user.update_adaption_rate(.64)
	assert_eq(user.adaption_rate["all rates"],.64)
	assert_eq(user.adaption_rate["total phases"],1)
	assert_eq(user.adaption_rate["overall adaption rate"],.64)
	
	user.update_adaption_rate(.72)
	assert_eq(user.adaption_rate["all rates"],1.36)
	assert_eq(user.adaption_rate["total phases"],2)
	assert_eq(user.adaption_rate["overall adaption rate"],.68)
	
func test_update_prev_adaption_rate():
	var user = User_Data_Manager.load_resource()
	user.reset_wcst_data()
	assert_eq(user.prev_overall_adaption_rate,.65)
	user.update_prev_adaption_rate(.78)
	assert_eq(user.prev_overall_adaption_rate,.78)

#~END WCST TESTS~
