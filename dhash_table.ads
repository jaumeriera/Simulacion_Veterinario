with exceptions; use exceptions;
with plist;
generic

	type enum is (<>);
	type item is private;
	with function hash(x: in item; b : in positive) return natural;
	size : positive := 53; -- Prime number

package dhash_table is

	type key is private;
	type hash_table is limited private;
	type pnode is private;

	-- Prepare the dispersion table to empty
	procedure empty (h : out hash_table);

	-- Insert new element into the dispersion table
	procedure insert (h : in out hash_table; k : out key; x : in item);

	-- Check if the item is in the dispersion table
	function is_in (h : in  hash_table; x : in item) return boolean;

	-- Update one element inserted in the dispersion table
	procedure update (h : in out hash_table; k : in key; e : in enum);

	-- Get the key of one element in the dispersion table by an item
	-- introducied by parameters
	function get_key (h : in hash_table; x : in item) return key;

private

	-- Constants with the size of the structures
	hash_size : constant natural := size;
	max_memory : constant integer := 3*hash_size;

	type node;
	type pnode is access node;

	-- Nodes for the list of record
	type node is
		record
			visit : enum;
			next : pnode;
		end record;

	type key is new integer range 0..max_memory;

	-- List package
	package pointerlist is new plist (item => key);
	use pointerlist;

	type dispersion_table is array (natural range 0..hash_size-1) of key;
	type a_of_lists is array (enum) of list;
	type a_of_bool_by_enum is array (enum) of boolean;

	type hash_table is
		record
			dt : dispersion_table;
			lists : a_of_lists;
		end record;

end dhash_table;
