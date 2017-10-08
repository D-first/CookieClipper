extends HBoxContainer

func _ready():
	pass


func _on_main_time_changed(time):
	get_node("value").set_text(str(round(time * 10) / 10))


func _on_main_time_bonus(time):
	get_node("value/bonas_time").set_text("+" + str(time))
	get_node("value/bonas_time/anim").play("bonus")
