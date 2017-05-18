with exceptions; use exceptions;
generic 
	type item;
	max : integer := 200;
package clist is
	
	type list is limited private;
	type iterator is private;
	
	-- Prepare the list to empty list
	procedure empty (l : out list);
	pragma inline(empty);

	-- Introduce item in the list
	procedure insert  (l : in out list; x : in item);

	-- Return a boolean depending on the state of the list
	function is_empty (l : in list) return boolean;
	pragma inline(is_empty);
	
	-- Procedures and fuctions related to iterators
	
	-- Put in the iterator the index to the first item in the list
	procedure first (l : in list; it : out iterator);
	pragma inline(first);

	-- Put in the iterator the succesor index
	procedure next (l : in list; it : in out iterator);
	pragma inline(next);

	-- Check if the actual iterator is valid
	function is_valid (it : in iterator) return boolean;
	pragma inline(is_valid);

	-- Put the item into the actual iterator into an item introduced by 
	-- arguments
	procedure get(it : in iterator; k : out integer; x : out item);
	pragma inline(get);

private
	
	subtype index is integer range 0..max;

	type list is 
		record
			first : index;
		end record;

	type iterator is
		record
			i : index;
		end record;

end clist;
