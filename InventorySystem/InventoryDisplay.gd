extends GridContainer


var inventory: Resource
var inventory_slot = preload("res://InventorySystem/InventorySlotDisplay.tscn") 


func inventory_ready():
	instance_slots()
# warning-ignore:return_value_discarded
	inventory.connect("items_changed", Callable(self, "on_items_changed"))
	inventory.make_items_unique()
	update_inventory_display()


func instance_slots():
	var j := 0
	for i in inventory.items:
		add_child(inventory_slot.instantiate())
		j += 1
		if j > 3:
			j = 0
			self.columns += 1


func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)


func update_inventory_slot_display(item_index):
	var inventory_slot_display = get_child(item_index)
	var item = inventory.items[item_index]
	inventory_slot_display.display_item(item)


func on_items_changed(indexes):
	if inventory.name == "Weapon Slot":
		GlobalSignals.emit_signal("weapon_equipped", inventory.items[0])

	for item_index in indexes:
		update_inventory_slot_display(item_index)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			printerr("unhandled_input")
#			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
