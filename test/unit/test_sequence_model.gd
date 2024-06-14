extends GutTest



func test_check_update_response():
	var model = Sequence_Game.new()
	var trial = SequenceTrialInfo.new([0,-1],4,[1,2,3,4])
	trial.answer_order = [1,2,3,4]
	model.trial_history.append(trial)
	
	assert_true(model.check_update_response(1),"should be true as response was correct")
	assert_eq(model.pins_pressed,1,"should be 1 after one check")
	
	trial = SequenceTrialInfo.new([1,-1],3,[1,2,3])
	trial.answer_order = [3,2,1]
	model.trial_history.append(trial)

	assert_true(model.check_update_response(3),"should be true as response was correct")
	assert_eq(model.pins_pressed,2,"should be 2 after a second run")
	assert_false(model.check_update_response(1), "should be false as response was incorrect")


func test_create_sequence_order():
	var model = Sequence_Game.new()
	model.current_trial = 3
	var trial1 = SequenceTrialInfo.new([0,-1],4,[1,2,3,4])
	var trial2 = SequenceTrialInfo.new([1,-1],5,[1,2,3,4,3])
	
	model.trial_history.append(trial1)
	model.trial_history.append(trial2)
	trial1.score = 4
	trial2.score = 4
	
	var mem_order = model.create_sequence_order([0,-1])
	assert_eq(model.trial_history[model.trial_history.size()-1].length,5,"should be 5")
	for i in range(mem_order.size()-1):
		assert(mem_order[i] >= 1 && mem_order[i] <= 8)
		
	mem_order = model.create_sequence_order([1,-1])
	assert_eq(model.trial_history[model.trial_history.size()-1].length,4,"should be 4")
	for i in range(mem_order.size()-1):
		assert(mem_order[i] >= 1 && mem_order[i] <= 8)
		
	model.trial_history[model.trial_history.size()-1].score = 2
	mem_order = model.create_sequence_order([1,-1])
	assert_eq(model.trial_history[model.trial_history.size()-1].length,3,"should be 3")
	for i in range(mem_order.size()-1):
		assert(mem_order[i] >= 1 && mem_order[i] <= 5)

func test_determine_new_length():
	var model = Sequence_Game.new()
	assert_eq(model.determine_new_length([0,-1]),3,"first trial should be 3")
	var trial = SequenceTrialInfo.new([0,-1],3,[2,5,3])
	model.trial_history.append(trial)
	trial.score = 3
	model.current_trial += 1
	assert_eq(model.determine_new_length([0,-1]),4,"all correct increases")
	assert_eq(model.determine_new_length([1,-1]),3,"should be back down to three for reverse")
	
	var trial2 = SequenceTrialInfo.new([1,-1],3,[3,1,2])
	model.trial_history.append(trial2)
	trial2.score = 3
	model.current_trial += 1
	trial.score = 3
	assert_eq(model.determine_new_length([0,-1]),4,"should go up despite break in forward")
	
	
func test_update_overall_performance():
	var model = Sequence_Game.new()
	var trial = SequenceTrialInfo.new([0,-1],4,[4,4,2,3])
	model.trial_history.append(trial)
	trial.response = [1,0,1,1]
	trial.calculate_score()
	model.update_overall_performance()
	assert_eq(model.overall_performance, [1,0,1,1,0,0,0,0], "initial trial performance")
	
	var trial2 = SequenceTrialInfo.new([1,-1],6,[4,4,2,3,1,2])
	model.trial_history.append(trial2)
	trial2.response = [1,0,1,1,0,1]
	trial2.calculate_score()
	model.update_overall_performance()
	assert_eq(model.overall_performance, [2,0,2,2,0,1,0,0], "after trial after the intial, adding more")
	
func test_reset_trial_info():
	var model = Sequence_Game.new()
	model.pins_pressed = 6
	model.current_trial = 9
	model.reset_trial_info()
	assert_eq(model.pins_pressed, 0, "reset pins pressed to 0")
	assert_eq(model.current_trial, 10, "current trial should increase by 1")

func test_choose_sequence_type():
	var model = Sequence_Game.new()
	assert_eq(model.choose_sequence_type(), [0,-1], "first trial should always be forward")
	var chosen_type = model.choose_sequence_type()
	assert(chosen_type[0] > -1 && chosen_type[0] < 4)
	assert(chosen_type[1] >= -1 && chosen_type[1] < 3)
	
func test_update_session_length():
	var model = Sequence_Game.new()
	var user = User_Data_Manager.load_resource()
	model.set_user(user)
	user.reset_user_data()
	assert_eq(model.update_session_length(user.sequence_session_count, user.sequence_session_performance_level),10,"first should be 10")
	assert_eq(user.sequence_session_performance_level[1],10,"should also change in user")
	
	user.sequence_session_count = 1
	user.sequence_session_performance_level[0] = 9
	assert_eq(model.update_session_length(user.sequence_session_count, user.sequence_session_performance_level),15,"well done should increase by 5")
	assert_eq(user.sequence_session_performance_level[1],15,"should also change in user")
	
	user.sequence_session_count = 2
	user.sequence_session_performance_level[0] = 12
	assert_eq(model.update_session_length(user.sequence_session_count,user.sequence_session_performance_level),15,"good performance at upper limit should remain same")
	assert_eq(user.sequence_session_performance_level[1],15,"should also stay same in user")
	
	user.sequence_session_count = 3
	user.sequence_session_performance_level[0] = 3
	assert_eq(model.update_session_length(user.sequence_session_count,user.sequence_session_performance_level),10,"bad performance should decrease it by 5")
	assert_eq(user.sequence_session_performance_level[1],10,"should also decrease in user")
	
	user.sequence_session_count = 4
	user.sequence_session_performance_level[0] = 3
	assert_eq(model.update_session_length(user.sequence_session_count,user.sequence_session_performance_level),5,"bad performance should decrease it by 5")
	assert_eq(user.sequence_session_performance_level[1],5,"should also decrease in user")
	
	user.sequence_session_count = 5
	user.sequence_session_performance_level[0] = 2
	assert_eq(model.update_session_length(user.sequence_session_count,user.sequence_session_performance_level),5,"bad performance at min should stay same")
	assert_eq(user.sequence_session_performance_level[1],5,"should also stay same in user")
	
	
	
#func test_choose_sequence_type_static():
#	var model = Sequence_Game.new()
#	assert_eq(model.choose_sequence_type_static_test(), 0, "1st trial should always be forward")
#	model.current_trial += 1
#	assert_eq(model.choose_sequence_type_static_test(), 0, "2nd is set for forward")
#	model.current_trial += 1
#	assert_eq(model.choose_sequence_type_static_test(), 1, "3rd is set for forward")
#	model.current_trial += 1
#	assert_eq(model.choose_sequence_type_static_test(), 0, "4th is set for forward")
#	model.current_trial += 1
#	assert_eq(model.choose_sequence_type_static_test(), 1, "5th is set for forward")
#	model.current_trial += 1
#	assert_eq(model.choose_sequence_type_static_test(), 1, "6th is set for forward")

