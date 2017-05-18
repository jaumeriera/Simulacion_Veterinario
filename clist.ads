with exceptions; use exceptions;
generic 
	type item is (<>);
	max : integer := 200;
package clist is
	
	type list is limited private;
	
	-- Prepare the list to empty list
	procedure empty (l : out list);
	pragma inline(empty);

	-- Introduce item in the list
	procedure insert  (l : in out list; x : in item);

	-- Advance the current pointer to next ilement on the list
	procedure advance_pointer (l : out list);
	pragma inline(advance_pointer);

	-- Reset the value of the pointer
	procedure reset_pointer (l : out list);
	pragma inline(reset_pointer);

	-- Return a boolean depending on the value of the pointer
	function current_is_empty (l : in list) return boolean;
	pragma inline(current_is_empty);

	-- Return the item pointed by the current pointer
	function current_item (l : in list) return item;
	pragma inline(current_item);

	-- Return a boolean depending on the state of the list
	function is_empty (l : in list) return boolean;
	pragma inline(is_empty);

	-- Return a boolean if the item is found in the list
	function is_found (l : in list; x : in item) return boolean;
	
private
	
	type index is new integer range 0..max;

	type list is 
		record
			first : index;
		end record;

end clist;
