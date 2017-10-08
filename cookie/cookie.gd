extends Node2D

var PieceScene= preload("res://cookie/piece.tscn")

var dragging = false
var cookie_types = {}
var first = true
var name
var marks = []

signal cookie_shaved
signal successful
signal failed

func _ready():
	randomize()
	load_cookie_types()

func create():
	choice_cookie()
	clear_pieces()
	assemble_pieces()


func assemble_pieces():
	for row in range(1, 17):
		for col in range(1, 17):
			var piece = PieceScene.instance()
			piece.init(name, row, col, is_marked_piece(row, col))
			piece.connect("click_or_mouse_enter", self, "_on_piece_clicked", [piece, row, col])
			get_node("container").add_child(piece)

func _on_piece_clicked(piece, row, col):
	if !dragging:
		return

	piece.shave()
	emit_signal("cookie_shaved")
	
	if piece.is_mark:
		failed()

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON):
		if (event.button_index == BUTTON_LEFT and event.pressed):     dragging = true
		elif(event.button_index == BUTTON_LEFT and not event.pressed): dragging = false

func load_cookie_types():
	var file = File.new()
	file.open("res://cookie/cookie_list.json", file.READ)
	cookie_types.parse_json(file.get_as_text())
	
	file.close()

func choice_cookie():
	if first:
		name = "APPLE"
		marks = cookie_types[name]
		first = false
		return

	var keys = cookie_types.keys()
	
	name = keys[randi() % keys.size()]
	marks = cookie_types[name]

func failed():
	get_tree().call_group(0, "piece", "crack")
	set_process_input(false)
	dragging = false
	
	emit_signal("failed")

func judge():
	var no_mark_piece_count = count_no_mark_pieces()
	var shaved_count = 0
	for piece in get_node("container").get_children():
		if piece.is_shaved:
			shaved_count += 1

	if shaved_count == no_mark_piece_count:
		return game.PERFECT
	
	if shaved_count >= (no_mark_piece_count / 2):
		return game.SUCCESS
	
	return game.BAD

func clear_pieces():
	for c in get_node("container").get_children():
		c.queue_free()

func is_marked_piece(row, col):
	return true if marks[row - 1][col - 1] == "1" else false

func count_no_mark_pieces():
	var count = 0
	for row_mark in marks:
		for mark in row_mark:
			if mark == "0":
				count += 1
	
	return count

func array_to_string(array):
	var string = ""
	for x in array:
		string += x
	
	return string
