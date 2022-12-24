extends Sprite

const randomMin: int = 100
const randomMax: int = 250
var speed: int
var velocity: Vector2 = Vector2()

func _ready():
	RandomSpeed()

func _physics_process(delta):
	velocity.x = speed * delta
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()

func RandomSpeed():
	var randomNumberGenerator: RandomNumberGenerator = RandomNumberGenerator.new()
	randomNumberGenerator.randomize()
	speed = randomNumberGenerator.randi_range(randomMin, randomMax)
