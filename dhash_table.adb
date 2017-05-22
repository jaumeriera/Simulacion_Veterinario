package body dhash_table is

	type block is
		record
			x : item;
			k : key;
			avisits : a_of_bool_by_enum;
			rec : pnode;
			next : cursor_index;
		end record;

	type memory_space is array (index range 1..index'last) of block;

	memory: memory_space;
	free : index;

	-- PROCEDURES AND FUNCTIONS RELATED TO IMPLEMENTATION WITH CURSORS

	-- Prepare the array of blocks
	procedure prep_mem_space is
	begin
		for i in cursor_index in range 1..index'last-1 loop
			memory(i).next := i+1;
			memory(i).k := i;
		end loop;
		memory(index'last).next := 0;
		memory(index'last).k := index'last;
		free := 1;
	end prep_mem_space;

	-- Check if there are memory avaible in the block array
	function avaible_memory return boolean is
	begin
		return free /= 0;
	end avaible_memory;

	-- Return a free cursor_index
	function get_block return cursor_index is
		free_block : cursor_index;
	begin
		if not avaible_memory then raise space_overflow; end if;
		free_block := free; free := memory(free).next; 
		memory(free_block).next := 0;
		return free_block;
	end get_block;

	procedure init_block (i : in cursor_index; x : in item) is
	begin

	end init_block;

	-- PROCEDURES AND FUNCTIONS OF SET

	-- Prepare the structure to empty
	procedure empty (h : out hash_table) is
	begin
		for i in hash_index loop
			h.dt(i) := 0;
		end loop;
		for i in enum loop
			h.lists := null;
		end loop;
	end empty;

	procedure insert (h : in out hash_table; x : in item) is
		hash_value : hash_index;
		index : cursor_index;
		index_aux : cursor_index;
	begin
		-- Get hash value and first block in the memory
		hash_value := hash(x,b);
		index := h.dt(hash_value);
		index_aux := index;

		-- Search if the item is in the hash table
		while index_aux /= 0 and then memory(index_aux).x /= x loop
			index_aux := memory(index_aux).next;
		end loop;
		if index_aux /= 0 then raise already_exists; end if;

		-- Get new block, allocate data in the block and reestructure indexes
		index_aux := get_block;
		init_block(index_aux, x);
		memory(index_aux).next := index;
		h.dt(hash_value):=index_aux;
		
	end insert;

begin

	prep_mem_space;

end dhash_table;
