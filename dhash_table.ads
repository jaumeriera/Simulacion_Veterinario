with exceptions; use exceptions;
generic

	type enum is private;
	type key is private;
	type item is private;
	with function hash(k: in key; b : in positive) return natural; 
	size : positive := 151; -- Prime number

package dhash_table is

	type dispersion_table is limited private;
	type pnode is private;

	-- List package
	package pointerlist is new dlist (item => pnode);
	use pointerlist;

	-- Prepare the dispersion table to empty
	procedure empty (h : out hash_table);

	-- Insert new element into the dispersion table
	procedure put (h : in out hash_table; k : in key; x : in item);

	-- Insert new intern node into a extern node 
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
	
	b : constant natural := size;

	type t_node is (extern, intern);
	type node;
	type pnode is access node;

	type node (tn : t_node) is 
		record 
			case tn is
				when extern =>
					k : key;
					x : item;
					next_int : pnode;
					next_ext : pnode;
				when intern =>
					x : enum;
					next_int : pnode;
			end case;
		end record;

	type dispersion_table is array (natural range 0..b-1) of pnode;
	type a_of_lists is array (enum) of list;

	type hash_table is
		record 
			dt : dispersion_table;
			lists : a_of_lists;
		end record;

end dhash_table;

