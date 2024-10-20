extends GutTest

func test_set_card_type():
	var trial = wcstTrialInfo.new()
	trial.set_card_type(1)
	#assert_true(trial.shape == wcstTrialInfo.Shapes.CIRCLE || trial.shape == wcstTrialInfo.Shapes.TRIANGLE || trial.shape == wcstTrialInfo.Shapes.SQUARE)
	#assert_true(trial.color == wcstTrialInfo.Colors.BLUE || trial.color == wcstTrialInfo.Colors.GREEN || trial.color == wcstTrialInfo.Colors.PURPLE)
	#assert_true(trial.count == wcstTrialInfo.Counts.ONE || trial.count == wcstTrialInfo.Counts.TWO || trial.count == wcstTrialInfo.Counts.THREE)
	trial.set_card_type(2)
	#assert_true(trial.shape == wcstTrialInfo.Shapes.CIRCLE || trial.shape == wcstTrialInfo.Shapes.TRIANGLE || trial.shape == wcstTrialInfo.Shapes.SQUARE || trial.shape == wcstTrialInfo.Shapes.STAR)
	#assert_true(trial.color == wcstTrialInfo.Colors.BLUE || trial.color == wcstTrialInfo.Colors.GREEN || trial.color == wcstTrialInfo.Colors.PURPLE || trial.color == wcstTrialInfo.Colors.ORANGE)
	#assert_true(trial.count == wcstTrialInfo.Counts.ONE || trial.count == wcstTrialInfo.Counts.TWO || trial.count == wcstTrialInfo.Counts.THREE || trial.count == wcstTrialInfo.Counts.FOUR)

func test_get_card_info_string():
	var trial = wcstTrialInfo.new()
	#trial.color = wcstTrialInfo.Colors.ORANGE
	#trial.count = wcstTrialInfo.Counts.THREE
	#trial.shape = wcstTrialInfo.Shapes.SQUARE
	assert_eq(trial.get_card_info_string(),["orange","square","three"])
