extends Node2D

var time = 60
signal time_changed
signal time_bonus

func _ready():
	set_process(true)
	get_node("workspace/cookie").connect("failed", self, "_on_clip_failed")
	next_cookie()

func _process(delta):
	time -= delta
	emit_signal("time_changed", time)
	
	if time <= 0:
		time_up()

func time_up():
	set_process(false)
	get_tree().change_scene("res://result/result.tscn")

func time_bonus(value):
	time += value
	emit_signal("time_bonus", value)

func submit_cookie(judge):
	if judge == game.PERFECT:
		get_node("judge").set_text("Perfect!!")
		get_node("judge").add_color_override("font_color", Color(0, 0, 1))
		get_node("anim").play("submit")
		get_node("se").play("perfect")
		time_bonus(20)
		game.perfect_count += 1
		return
	
	if judge == game.SUCCESS:
		get_node("judge").set_text("Success")
		get_node("judge").add_color_override("font_color", Color(0, 1, 0))
		get_node("anim").play("submit")
		get_node("se").play("success")
		time_bonus(10)
		game.success_count += 1
		return
	
	if judge == game.BAD:
		get_node("judge").set_text("bad")
		get_node("judge").add_color_override("font_color", Color(1, 0, 0))
		get_node("anim").play("submit")
		get_node("se").play("bad")
		game.bad_count += 1
		return

func next_cookie():
	get_node("anim").play("stamp")
	get_node("workspace/cookie").create()

func _on_clip_failed():
	get_node("submit").set_disabled(true)
	get_node("interval").start()

func _on_interval_timeout():
	next_cookie()

func _on_anim_finished():
	if get_node("anim").get_current_animation() == "stamp":
		get_node("submit").set_disabled(false)
		get_node("workspace/cookie").set_process_input(true)
	
	if get_node("anim").get_current_animation() == "submit":
		next_cookie()

func _on_submit_pressed():
	get_tree().call_group(0, "piece", "highlight")
	submit_cookie(get_node("workspace/cookie").judge())
	get_node("submit").set_disabled(true)


func _on_cookie_cookie_shaved():
	time_bonus(0.05)



func _on_submit_button_down():
	get_node("se").play("next")
