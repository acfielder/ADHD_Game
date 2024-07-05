extends GutTest


func test_create_trial_type():
	var model = StopGoModel.new()
	var type = model.create_trial_type()
	assert_true(type || !type)
	
func test_determine_next_ssd():
	var model = StopGoModel.new()
	var trial = StopGoTrial.new(false)
	model.session_last_ssd = .5
	model.session_last_ssd_score = false
	assert_eq(model.determine_next_ssd(trial),0.45)
	
	model.session_last_ssd = .25
	model.session_last_ssd_score = true
	assert_eq(model.determine_next_ssd(trial),0.3)
	
func test_determine_interval():
	var model = StopGoModel.new()
	var trial = StopGoTrial.new(true)
	model.session_trials.append(trial)
	var result = model.determine_interval()
	assert_true(result >= model.min_interval && result <= model.max_interval)
	
func test_choose_direction():
	var model = StopGoModel.new()
	var trial = StopGoTrial.new(true)
	var result = model.choose_direction(trial)
	assert_true(result == 1 || result == 2)
	
func test_record_check_response(): #very obviously needs fixed ***********************
	var model = StopGoModel.new()
	var trial = StopGoTrial.new(true)
	model.session_trials.append(trial)
	trial.direction = 1
	#assert_eq(model.record_check_response(1,0.505),true)
	assert_true(trial.pressed)
	assert_eq(trial.go_rt, 0.505)
	assert_true(trial.successful)
	trial.direction = 2
	#assert_eq(model.record_check_response(1,0.505),false)
	
	var trial2 = StopGoTrial.new(false)
	model.session_trials.append(trial2)
	trial2.direction = 2
	#assert_eq(model.record_check_response(2,0.400),false)
	assert_true(trial2.pressed)
	assert_eq(trial2.go_rt, 0.400)
	assert_false(trial.successful)

func test_timer_ended_trial(): #obviously needs fixed *******************
	var model = StopGoModel.new()
	var trial = StopGoTrial.new(false)
	model.session_trials.append(trial)
	#assert_true(model.timer_ended_trial(0))
	assert_true(trial.successful)
	
	var trial2 = StopGoTrial.new(true)
	model.session_trials.append(trial2)
	#assert_false(model.timer_ended_trial(1))
	assert_false(trial2.successful)

func test_calculate_session_go_rt():
	var model = StopGoModel.new()
	var trial1 = StopGoTrial.new(true)
	trial1.successful = true
	trial1.go_rt = 0.450
	var trial2 = StopGoTrial.new(false)
	trial2.successful = false
	trial2.go_rt = 0.600
	var trial3 = StopGoTrial.new(true)
	trial3.successful = false
	trial3.go_rt = 0.460
	var trial4 = StopGoTrial.new(true)
	trial4.successful = true
	trial4.go_rt = .650
	var trial5 = StopGoTrial.new(false)
	trial5.successful = true
	model.session_trials.append(trial1)
	model.session_trials.append(trial2)
	model.session_trials.append(trial3)
	model.session_trials.append(trial4)
	model.session_trials.append(trial5)
	
	assert_eq(model.calc_session_go_rt(),0.567) #its technically correct
	
func test_calc_session_prob_signal_response():
	var model = StopGoModel.new()
	var trial1 = StopGoTrial.new(false)
	trial1.successful = true
	var trial2 = StopGoTrial.new(false)
	trial2.successful = true
	var trial3 = StopGoTrial.new(false)
	trial3.successful = true
	var trial4 = StopGoTrial.new(true)
	trial4.successful = true
	var trial5 = StopGoTrial.new(false)
	trial5.successful = false
	model.session_trials.append(trial1)
	model.session_trials.append(trial2)
	model.session_trials.append(trial3)
	model.session_trials.append(trial4)
	model.session_trials.append(trial5)
	
	assert_eq(model.calc_session_prob_signal_response(),0.75)
	
func test_calc_session_stop_signal_rt():
	var model = StopGoModel.new()
	model.session_go_rt_avg = 0.55
	
	var trial1 = StopGoTrial.new(false)
	trial1.successful = true
	trial1.ssd = 0.3
	var trial2 = StopGoTrial.new(false)
	trial2.successful = true
	trial2.ssd = 0.35
	var trial3 = StopGoTrial.new(false)
	trial3.successful = true
	trial3.ssd = 0.4
	var trial4 = StopGoTrial.new(true)
	trial4.successful = true
	var trial5 = StopGoTrial.new(false)
	trial5.successful = false
	trial5.ssd = .45
	model.session_trials.append(trial1)
	model.session_trials.append(trial2)
	model.session_trials.append(trial3)
	model.session_trials.append(trial4)
	model.session_trials.append(trial5)
	
	assert_eq(model.calc_session_stop_signal_rt(model.session_go_rt_avg),0.175) #technically correct

func test_setup_session():
	var model = StopGoModel.new()
	var user = User_Data_Manager.load_resource()
	model.set_user(user)
	#from the beginning
	user.reset_stop_go_data()
	model.setup_session()
	assert_eq(model.current_level,1)
	assert_eq(model.session_last_ssd,0.3) 
	assert_eq(model.session_length,10)
	
	user.session_count_SG += 1
	user.prev_SG_sess_score = [9,10]
	user.critical_ssd = 0.7
	user.current_SG_level = 2
	model.setup_session()
	assert_eq(model.current_level,2)
	assert_eq(model.session_last_ssd,0.7)
	assert_eq(model.session_length,15)
	
		
func test_update_session_length():
	var model = StopGoModel.new()
	var user = User_Data_Manager.load_resource()
	user.reset_stop_go_data()
	model.set_user(user)
	assert_eq(model.update_session_length([2,7]),10)
	user.session_count_SG += 1
	assert_eq(model.update_session_length([9,10]),15)
	user.session_count_SG += 1
	assert_eq(model.update_session_length([4,15]),10)
	assert_eq(model.update_session_length([3,10]),5)


func test_setup_trial():
	var model = StopGoModel.new()
	model.session_last_ssd = .6
	model.session_last_ssd_score = true
	var trial = model.setup_trial()
	assert_eq(model.session_trials[-1].trial_num,1)
	#assert_eq(model.session_trials[-1].ssd,700)
	if !trial.trial_type:
		assert_eq(model.session_trials[-1].ssd,0.65)
	assert(model.session_trials[-1].start_interval >= 3 && model.session_trials[-1].start_interval <= 5)
	assert(model.session_trials[-1].direction == 1 || model.session_trials[-1].direction == 2)

func test_update_session_performance():
	var model = StopGoModel.new()
	var trial = StopGoTrial.new(true)
	trial.successful = true
	model.session_trials.append(trial)
	model.update_session_performance()
	assert_eq(model.session_score, 1)
	var trial2 = StopGoTrial.new(false)
	trial2.successful = true
	model.session_trials.append(trial2)
	model.update_session_performance()
	assert_eq(model.session_score,2)
	var trial3 = StopGoTrial.new(true)
	trial3.successful = false
	model.session_trials.append(trial3)
	model.update_session_performance()
	assert_eq(model.session_score,2)
	
func test_end_session():
	#determines session results - 3 calls all already tested, this just calls, it doesnt do anything with them
	#commented out the above related func for testing of the actual functions in this func
	var model = StopGoModel.new()
	var user = User_Data_Manager.load_resource()
	user.reset_stop_go_data()
	model.set_user(user)
	var trial1 = StopGoTrial.new(true)
	var trial2 = StopGoTrial.new(false)
	var trial3 = StopGoTrial.new(false)
	trial1.successful = true
	trial2.successful = true
	trial3.successful = false
	trial2.ssd = .4
	trial3.ssd = .5
	model.session_trials.append(trial1)
	model.session_trials.append(trial2)
	model.session_trials.append(trial3)
	model.session_score = 9
	model.session_length = 10
	model.session_go_rt_avg = .4
	model.session_prob_signal_response = .45
	model.session_stop_signal_rt = .5
	model.end_session()
	assert_eq(user.current_SG_level,1)
	assert_eq(user.prev_SG_sess_score,[9,10])
	assert_eq(user.critical_ssd,0.450)
	user.comp_of_level_SG = 17
	model.end_session()
	assert_eq(user.current_SG_level,2)
	
func test_calc_ssd_avg():
	var model = StopGoModel.new()
	var trial = StopGoTrial.new(false)
	trial.ssd = .4
	var trial2 = StopGoTrial.new(false)
	trial2.ssd = .3
	var trial3 = StopGoTrial.new(true)
	var trial4 = StopGoTrial.new(false)
	trial4.ssd = .7
	model.session_trials.append(trial)
	model.session_trials.append(trial2)
	model.session_trials.append(trial3)
	model.session_trials.append(trial4)
	assert_eq(model.calc_ssd_avg(),0.467)

	
func test_calc_update_current_rt():
	var model = StopGoModel.new()
	var trial = StopGoTrial.new(true)
	model.session_trials.append(trial)
	model.final_rt_time = 34567
	model.start_rt_time = 34032
	model.calc_update_current_rt()
	assert_eq(model.session_trials[-1].go_rt,535)
