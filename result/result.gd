extends Node2D

func _ready():
	get_node("judge/perfect/value").set_text(str(game.perfect_count))
	get_node("judge/success/value").set_text(str(game.success_count))
	get_node("judge/bad/value").set_text(str(game.bad_count))
	get_node("score/value").set_text(str(game.calculate_score()))
	get_node("best_score/value").set_text(str(game.best_score))
	
	if game.is_best_score():
		game.best_score = game.calculate_score()
		var save_data = { "best_score" : game.best_score }
		game.save_play_data("user://play.data", save_data)


func _on_cookies_button_down():
	get_node("shave").set_emitting(true)
	get_node("shave_1").set_emitting(true)
	get_node("shave_2").set_emitting(true)
	get_node("shave_3").set_emitting(true)
	get_node("shave_4").set_emitting(true)
	get_node("se").play("shave")


func _on_retry_pressed():
	game.perfect_count = 0
	game.success_count = 0
	game.bad_count = 0
	get_tree().change_scene("res://main/main.tscn")
