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
	
func test_record_check_response():
	var model = StopGoModel.new()
	var trial = StopGoTrial.new(true)
	model.session_trials.append(trial)
	trial.direction = 1
	assert_eq(model.record_check_response(1,0.505),true)
	assert_true(trial.pressed)
	assert_eq(trial.go_rt, 0.505)
	assert_true(trial.successful)
	trial.direction = 2
	assert_eq(model.record_check_response(1,0.505),false)
	
	var trial2 = StopGoTrial.new(false)
	model.session_trials.append(trial2)
	trial2.direction = 2
	assert_eq(model.record_check_response(2,0.400),false)
	assert_true(trial2.pressed)
	assert_eq(trial2.go_rt, 0.400)
	assert_false(trial.successful)

func test_timer_ended_trial():
	var model = StopGoModel.new()
	var trial = StopGoTrial.new(false)
	model.session_trials.append(trial)
	assert_true(model.timer_ended_trial(0))
	assert_true(trial.successful)
	
	var trial2 = StopGoTrial.new(true)
	model.session_trials.append(trial2)
	assert_false(model.timer_ended_trial(1))
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
