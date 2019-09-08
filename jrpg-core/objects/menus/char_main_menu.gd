extends ItemList

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_item("Items",null,true);
	add_item("Abilities",null,true);
	add_item("Equipment",null,true);
	add_item("Status",null,true);
	add_item("Data",null,true);
	select(0,true);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
