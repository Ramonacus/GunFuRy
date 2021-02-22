extends Node2D

export (PackedScene) var mob_scene

var mob_count = 0
var mob_group_size = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_mob_group()
	
func spawn_mob_group():
	for i in range(mob_group_size):
		spawn_mob()

func spawn_mob():
	var cells = $Ground.get_used_cells()
	var position = $Ground.map_to_world(cells[randi() % cells.size()])
	var mob = mob_scene.instance()
	$Walls.add_child(mob)
	mob.set_position(position)
	mob.connect("tree_exited", self, "on_mob_exit")
	mob_count += 1

func on_mob_exit():
	mob_count -= 1
	if mob_count <= 0:
		mob_count = 0
		mob_group_size += 1
		spawn_mob_group()
