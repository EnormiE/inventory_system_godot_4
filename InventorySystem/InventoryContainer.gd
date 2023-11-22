extends ColorRect


signal inventory_ready


@export var inventory : Resource


@onready var InventoryDisplay = $CenterContainer/InventoryDisplay


func _ready() -> void:
# warning-ignore:return_value_discarded
	self.connect("inventory_ready", Callable(InventoryDisplay, "inventory_ready"))
	InventoryDisplay.inventory = inventory
	emit_signal("inventory_ready")

