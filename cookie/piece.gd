extends Control

const DOT_SCALE = 32
var tex_path_format = "res://cookie/textures/%s/%s_%s_%s.png"

var is_mark
var is_shaved
var crack_texture

signal click_or_mouse_enter

func init(name, row, col, is_mark):
	set_normal_texture(load(tex_path_format % [name + "_A", name + "_A", str(row), str(col)]))
	crack_texture = load(tex_path_format % [name + "_B", name + "_B", str(row), str(col)])
	set_pos(Vector2((col- 1) * DOT_SCALE, (row - 1) * DOT_SCALE))
	self.is_mark = is_mark

func _ready():
	pass

func shave():
	is_shaved = true
	get_node("texture").hide()
	get_node("shave").set_emitting(true)
	get_node("se").play("shave")

func crack():
	get_node("anim").play("crack")

func highlight():
	if is_mark:
		return

	get_node("anim").play("highlight")

func set_normal_texture(texture):
	get_node("texture").set_normal_texture(texture)

func set_crack_texture():
	get_node("texture").set_normal_texture(crack_texture)

func _on_click_or_mouse_enter():
	emit_signal("click_or_mouse_enter")
