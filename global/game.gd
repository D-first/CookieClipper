extends Node

var PERFECT = 1
var SUCCESS = 2
var BAD     = 3

var best_score = 0
var perfect_count = 0
var success_count = 0
var bad_count     = 0

func _ready():
	var load_data = load_play_data("user://play.data")
	if load_data != null:
		best_score = load_data["best_score"]

func calculate_score():
	var score = 0
	
	score += game.perfect_count * 10000
	score += game.success_count * 1000
	score += game.bad_count * -500
	
	return score

func is_best_score():
	return calculate_score() > best_score


func save_play_data(path, data):
    var f = File.new()
    f.open(path, File.WRITE)
    f.store_var(data)
    f.close()

func load_play_data(path):
    var f = File.new()
    if f.file_exists(path):
        f.open(path, File.READ)
        var data = f.get_var()
        f.close()
        return data
    return null