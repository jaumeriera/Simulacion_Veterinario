with exceptions; use exceptions;
generic 
	type item is (<>);
package plist is
	
	type list is limited private;
	
	-- Prepare the list to empty list
	procedure empty (l : out list);
	pragma inline(empty);

	-- Introduce item in the list
	procedure insert  (l : in out list; x : in item);

	-- Return a boolean depending on the state of the list
	function is_empty (l : in list) return boolean;
	pragma inline(is_empty);

	-- Return a boolean if the item is found in the list
	function is_found (l : in list; x : in item) return boolean;
	
private

	type cell;
	type pcell is access cell;

	type cell is
		record
			x : item;
			next : pcell;
		end record;

	type list is 
		record
			first : pcell;
		end record;

end plist;
