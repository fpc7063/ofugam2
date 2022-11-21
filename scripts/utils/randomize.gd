#random_utils_file
func rand_array_element(list: Array) -> int:
	randomize()
	return list[randi() % list.size()]

func rand_array_index(list: Array) -> int:
	randomize()
	return randi() % list.size()
