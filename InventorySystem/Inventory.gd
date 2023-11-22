extends Resource
class_name Inventory


signal items_changed(indexes)


var drag_data = null


@export var name : String
@export var items : Array[Resource]


func set_item(item_index, item):
	var previous_item = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	make_this_item_unique(item_index)
#	make_items_unique() # Resets all items variables values!!!
	return previous_item


func swap_items(source_inventory, item_index, target_item_index):
	var target_item = items[target_item_index]
	var item = source_inventory.items[item_index]
	items[target_item_index] = item
	source_inventory.items[item_index] = target_item
	source_inventory.emit_signal("items_changed", [item_index])
	emit_signal("items_changed", [target_item_index])


func stack_items(source_inventory, item_index, target_item_index):
	var target_item = items[target_item_index]
	var item = source_inventory.items[item_index]
	target_item.amount += item.amount
	item = source_inventory.remove_item(item_index)
	source_inventory.emit_signal("items_changed", [item_index])
	emit_signal("items_changed", [target_item_index])


func split_items(source_inventory, item_index, target_item_index):
	var item = source_inventory.items[item_index]
	var target_item = items[target_item_index]
	if item.amount > 1:
		# There are multiple items in this spot
		if target_item is Item:
			# The target slot is taken
			if item_index != target_item_index:
				# The initial slot and the target slot are not the same slot
				if item.amount % 2 == 0:
					# There is an even amount of items to split
					if target_item.name == item.name:
						# There are the same items in both slots
						target_item.amount += item.amount /2
						item.amount /= 2
						source_inventory.emit_signal("items_changed", [item_index])
						emit_signal("items_changed", [target_item_index])
					else:
						# Items in initial slot and target slot are not the same item
						printerr("Items in initial slot and target slot are not the same item")
				else:
					# There is an uneven amount of items to split
					if target_item.name == item.name:
						# There are the same items in both slots
						target_item.amount = target_item.amount + (item.amount + 1) /2
						target_item.amount -= 1
						item.amount = (item.amount + 1) /2
						source_inventory.emit_signal("items_changed", [item_index])
						emit_signal("items_changed", [target_item_index])
					else:
						# Items in initial slot and target slot are not the same item
						printerr("Items in initial slot and target slot are not the same item")
		else:
			# The target slot is empty
			if item.amount % 2 == 0:
				# There is an even amount of items to split
				set_item(target_item_index, item)
				target_item = items[target_item_index]
				target_item.amount = item.amount /2
				item.amount /= 2
				source_inventory.emit_signal("items_changed", [item_index])
				emit_signal("items_changed", [target_item_index])
			else:
				# There is an uneven amount of items to split
				set_item(target_item_index, item)
				target_item = items[target_item_index]
				target_item.amount = (item.amount + 1) /2
				target_item.amount -= 1
				item.amount = (item.amount + 1) /2
				source_inventory.emit_signal("items_changed", [item_index])
				emit_signal("items_changed", [target_item_index])


func remove_item(item_index):
	var previous_item = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previous_item


func make_items_unique():
	var unique_items : Array[Resource] = []
	for item in items:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items


func make_this_item_unique(target_item_index):
	var target_item = items[target_item_index]
	for item in items:
		if item is Item and item == target_item:
			items.append(item.duplicate())
			items.remove_at(target_item_index)
			items.insert(target_item_index, items[items.size()-1])
			items.remove_at(items.size()-1)
			emit_signal("items_changed", [target_item_index])
			break
