extends Node2D

export (PackedScene) var mob_scene

var mobs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_mob()
	


func spawn_mob():
	var cells = $Ground.get_used_cells()
	var position = $Ground.map_to_world(cells[randi() % cells.size()])
	var mob = mob_scene.instance()
	$Walls.add_child(mob)
	mob.set_position(position)
	mob.connect("tree_exited", self, "on_mob_exit")

func on_mob_exit():
	print("muette")
