extends Area3D

var checkpoint_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_manager = get_tree().get_first_node_in_group("Singleton")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		checkpoint_manager.last_location = $RespawnPoint.global_position
