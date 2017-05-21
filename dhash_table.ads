-- REVISAR TYPE KEY!!!
with exceptions; use exceptions;
generic

	type enum is private;
	type item is private;
	with function hash(k: in key; b : in positive) return natural; 
	size : positive := 53; -- Prime number

package dhash_table is

	type key is private;
	type dispersion_table is limited private;
	type pnode is private;

	-- List package
	package pointerlist is new dlist (item => pnode);
	use pointerlist;

	-- Prepare the dispersion table to empty
	procedure empty (h : out hash_table);

	-- Insert new element into the dispersion table
	procedure put (h : in out hash_table; k : in key; x : in item);

	-- Insert new extern node into an intern node 
	procedure put_intern (h : in out hash_table; k : in key; x : in item; 
																   e : in enum);

	-- Check if the item is in the dispersion table
	function is_in (h : in out hash_table; k : in key; x : in item) 
																 return boolean;

	-- Update one element inserted in the dispersion table
	procedure update (h : in out hash_table; k : in key; x : in item);

	-- Get the information of one element in the dispersion table by a key 
	-- introducied by parameters
	procedure get_item (h : in hash_table; k : in key; x : in item);

private 
	
	-- Constants with the size of the structures
	b : constant natural := size;
	max_memory : constant integer := 3*b;

	type node;
	type pnode is access node;

	-- Nodes for the list of record
	type node (tn : t_node) is 
		record 
			visit : enum;
			next : pnode;
		end record;

	subtype index is integer range 0..max_memory;
	type key is new index range index'first..index'last;

	type dispersion_table is array (natural range 0..size-1) of index;
	type a_of_lists is array (enum) of list;
	type a_of_bool_by_enum is array (enum) of boolean;

	type hash_table is
		record 
			dt : dispersion_table;
			lists : a_of_lists;
		end record;

end dhash_table;

