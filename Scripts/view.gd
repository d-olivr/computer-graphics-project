extends Node3D

@export_group("Properties")
@export var target: CharacterBody3D

@export_group("Zoom")
@export var zoom_minimum: float = 4.0
@export var zoom_maximum: float = 14.0
@export var zoom_speed: float = 1.5

@export_group("Rotation")
@export var rotation_speed: float = 120.0
@export var min_rotation_x: float = 5.0   # era 20.0
@export var max_rotation_x: float = 35.0  # era 50.0

var camera_rotation := Vector3(15.0, -90.0, 0.0)  # era 35.0, baixa o ângulo
var zoom: float = 8.0

@onready var camera = $Camera


func _ready() -> void:
	if target:
		self.position = target.position
	rotation_degrees = camera_rotation
	camera.position = Vector3(0.0, 0.0, zoom)


func _physics_process(delta: float) -> void:
	if not target:
		return
	self.position = self.position.lerp(target.position, delta * 6.0)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 8.0)
	camera.position = camera.position.lerp(Vector3(0.0, 0.0, zoom), delta * 8.0)
	handle_input(delta)


func handle_input(delta: float) -> void:
	var input := Vector3.ZERO
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, min_rotation_x, max_rotation_x)
	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_minimum, zoom_maximum)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				zoom -= zoom_speed
			MOUSE_BUTTON_WHEEL_DOWN:
				zoom += zoom_speed
		zoom = clamp(zoom, zoom_minimum, zoom_maximum)
