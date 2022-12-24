extends Sprite

var speed

var randomMin = 100
var randomMax = 250
var velocity = Vector2()

func _ready():
	var randomNumberGenerator = RandomNumberGenerator.new()
	randomNumberGenerator.randomize()
	speed = floor(randomNumberGenerator.randf_range(randomMin, randomMax))

func _physics_process(delta):
	velocity.x = speed * delta
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
