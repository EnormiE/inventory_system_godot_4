extends Resource
class_name Item


@export var name: String
@export var description: String
@export var texture: Texture2D
@export var sell_price : float
@export var buy_price : float
#export var stack_size : int = 100
#export var weight : int
@export var currency_amount : float
@export var difficulty : int

@export var damage : int
@export var attack_range : int
@export var attack_speed : int
@export var knockback : int
@export var durability : int

@export var consumable : bool

@export var high : int
@export var damage_boost : float
@export var knockback_boost : float
@export var attack_speed_boost : float
@export var healing : float


var amount = 1
