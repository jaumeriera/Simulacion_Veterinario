with exceptions; use exceptions;
generic 
	type item;
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

	-- Procedures and functions of the iterator
	
	-- Put in the iterator the pointer wich points to first element
	procedure first (l : in list; it : out iterator);
	pragma inline(first);

	-- Put in the iterator the succesor element
	procedure next (l : in list; it : in out iterator);
	pragma inline(next);

	-- Check if the actual iterator is valid
	function is_valid (it : in iterator) return boolean;
	pragma inline(is_valid);

	-- Put the item into the actual iterator into an item introduced by 
	-- arguments
	procedure get(it : in iterator; x : out item);
	pragma inline(get);

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

	type iterator is
		record
			pointer : pcell;
		end record;

end plist;
