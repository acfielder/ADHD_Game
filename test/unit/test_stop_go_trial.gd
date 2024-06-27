extends GutTest

func test_init():
	var trial = StopGoTrial.new(false)
	assert_eq(trial.trial_type,false)
	var trial2 = StopGoTrial.new(true)
	assert_eq(trial2.trial_type,true)
	
func test_determine_ssd():
	var trial = StopGoTrial.new(false)
	assert_eq(trial.determine_ssd(1,1),1.05)
	assert_eq(trial.determine_ssd(1.2,1),1.2)
	assert_eq(trial.determine_ssd(0.15,0),0.1)
	assert_eq(trial.determine_ssd(0.4,0),0.35) #its technically correct
	assert_eq(trial.determine_ssd(0.1,0),0.1)
	
func test_determine_next_interval():
	var trial = StopGoTrial.new(true)
	var interval = trial.determine_next_interval(2,4)
	assert_true(interval >= 2 && interval <= 4)
	
func test_choose_direction():
	var trial = StopGoTrial.new(true)
	var direction = trial.choose_direction()
	assert_true(direction == 1 || direction == 2)

	
