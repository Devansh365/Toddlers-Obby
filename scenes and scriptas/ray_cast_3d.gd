extends RayCast3D
@onready var interact = $"../../../CanvasLayer/interact"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact.visible = false  


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if is_colliding():
		var hit = get_collider()  
		if hit.has_method("interact"):
			interact.visible = true  
			if Input.is_action_just_pressed("interact"):
				hit.interact()  
		else:
			interact.visible = false  
	else:
		interact.visible = false  
