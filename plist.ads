with exceptions; use exceptions;
with ada.text_io; use ada.text_io;
generic
	type item is private;
package plist is

	type list is private;
	type list_iterator is private;

	-- Prepare the list to empty list
	procedure empty (l : out list);
	pragma inline(empty);

	-- Introduce item in the list
	procedure insert (l : in out list; x : in item);

	-- Remove the element in the position specificated
	procedure remove (l : in out list; x : in integer);

	-- Return a boolean depending on the state of the list
	function is_empty (l : in list) return boolean;
	pragma inline(is_empty);

	-------------------------------------------------------
	-- PROCEDURES AND FUNCTIONS RELATED TO LIST_ITERATOR --
	-------------------------------------------------------

	-- Put in the list_iterator the pointer wich points to first element
	procedure first (l : in list; it : out list_iterator);
	pragma inline(first);

	-- Put in the list_iterator the succesor element
	procedure next (l : in list; it : in out list_iterator);
	pragma inline(next);

	-- Check if the actual list_iterator is valid
	function is_valid (it : in list_iterator) return boolean;
	pragma inline(is_valid);

	-- Put the item into the actual list_iterator into an item introduced by
	-- arguments
	procedure get(it : in list_iterator; x : out item);
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

	type list_iterator is
		record
			pointer : pcell;
		end record;

end plist;
