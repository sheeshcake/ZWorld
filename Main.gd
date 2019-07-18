extends Node2D

export (PackedScene) var Player

export (int) var enemy_number = 1


func _ready():
	randomize()
	var i = 0
	while enemy_number != i:
		var pos = Vector2(rand_range(0,1500),rand_range(0,1500))
		var rename = str(self.get_name())
		var import = load("res://Turret.tscn").instance()
		import.set_name(str(import.get_name())+rename)
		import.position = pos 
		self.add_child(import)
		i += 1



func _process(delta):
	update()
	if $Player:
		$GameOver.set_text("Kill DEM ALL!!")
	else:
		$GameOver.set_text("U DED U NOOB!!")

func _on_TileMap_draw():
	pass # Replace with function body.
