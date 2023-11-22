extends CenterContainer


@onready var item_texture_rect = $ItemTextureRect
@onready var item_amount_label = $ItemTextureRect/ItemAmountLabel


var inventory : Resource

var mouse_over := false # Whether mouse is over slot or not
var hold_time = 0 # Amount of time you held right mouse button clicked on slot


func _process(delta: float) -> void:
	if inventory == null:
		inventory = self.get_parent().inventory

	if mouse_over and Input.is_action_pressed("ui_right_mouse"):
		hold_time += delta

	if Input.is_action_just_released("ui_right_mouse"):
		hold_time = 0

	if hold_time >= 0.5:
		var item_index = get_index()
		var item = inventory.items[item_index]
		if item is Item and item.consumable:
			GlobalSignals.emit_signal("item_consumed", item)
			inventory.remove_item(item_index)



func display_item(item):
	if item is Item:
		item_texture_rect.texture = item.texture
		item_amount_label.text = str(item.amount)
		var description_string = str(item.description)
		tooltip_text = wrap_words(description_string)

	else:
		item_texture_rect.texture = null#load("res://Assets/Items/EmptyInventorySlot.png")
		item_amount_label.text = ""


func wrap_words(string):
	var words = string.split(" ")
	var max_chars_per_line = 20
	var wrapped_description = ""
	var line_length = 0
	
	for word in words:
		if (line_length + len(word)) > max_chars_per_line:
			wrapped_description += "\n"
			line_length = 0
		wrapped_description += word + " "
		line_length += len(word) + 1
	return wrapped_description


func _get_drag_data(_position: Vector2):
	var source_inventory := inventory
	var item_index = get_index()
	var item = source_inventory.items[item_index]
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		data.source_inventory = source_inventory
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.texture
		set_drag_preview(drag_preview)
		source_inventory.drag_data = data
		return data


func _can_drop_data(_position: Vector2, data) -> bool:
	if inventory.name == "Weapon Slot":
		return data is Dictionary and data.has("item") and data.item.damage != 0
	else:
		return data is Dictionary and data.has("item")


func _drop_data(_position: Vector2, data) -> void:
	var target_inventory := inventory
	var target_item_index = get_index()
	var target_item = target_inventory.items[target_item_index]

	# Spliting items
	if Input.is_action_pressed("ui_split_item") and data.item.amount > 1:
		target_inventory.split_items(data.source_inventory, data.item_index, target_item_index)

	# Stacking items
	elif target_item is Item and target_item.name == data.item.name and target_item != data.item:
		target_inventory.stack_items(data.source_inventory, data.item_index, target_item_index)

	# Swaping items
	else:
		target_inventory.swap_items(data.source_inventory, data.item_index, target_item_index)

	data.source_inventory.drag_data = null


func _on_InventorySlotDisplay_mouse_entered() -> void:
	mouse_over = true


func _on_InventorySlotDisplay_mouse_exited() -> void:
		mouse_over = false
