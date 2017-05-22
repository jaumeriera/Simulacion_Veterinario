package body dhash_table is

	type block is
		record
			x : item;
			avisits : a_of_bool_by_enum;
			rec : pnode;
			next : cursor_index;
		end record;

	type memory_space is array (cursor_index range 1..cursor_index'last) of block;

	memory: memory_space;
	free : cursor_index;

	-- PROCEDURES AND FUNCTIONS RELATED TO IMPLEMENTATION WITH CURSORS

	-- Prepare the array of blocks
	procedure prep_mem_space is
	begin
		for i in cursor_index range 1..cursor_index'last-1 loop
			memory(i).next := i+1;
		end loop;
		memory(cursor_index'last).next := 0;
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
		memory(i).x := x;
		memory(i).avisits := (others => false);
		memory(i).rec := null;
	end init_block;

	-- PROCEDURES AND FUNCTIONS OF SET

	-- Prepare the structure to empty
	procedure empty (h : out hash_table) is
	begin
		for i in hash_size loop
			h.dt(i) := 0;
		end loop;
		for i in enum loop
			empty(h.lists(i));
		end loop;
	end empty;

	-- Insert new element into the dispersion table
	procedure insert (h : in out hash_table; k : out key; x : in item) is
		hash_value : natural;
		index_aux : cursor_index;
	begin
		-- Get hash value and first block in the memory
		hash_value := hash(x,hash_size);

		if is_in(h,x) then raise already_exist; end if;

		-- Get new block, allocate data in the block and reestructure indexes
		index_aux := get_block;
		init_block(index_aux, x);
		memory(index_aux).next := h.dt(hash_value);
		h.dt(hash_value):=index_aux;

		-- Set the key
		k := index_aux;

	end insert;

	-- Check if the item is in the hash table
	function is_in (h : in  hash_table; x : in item) return boolean is
		hash_value : natural;
		index : cursor_index;
	begin
		-- Get hash value
		hash_value := hash(x,hash_size);
		index := h.dt(hash_value);

		-- Search if the item is in
		while index /= 0 and then memory(index).x /= x loop
			index := memory(index).next;
		end loop;

		return index /= 0;
	end is_in;

	-- Insert one visit into a record of the block
	procedure update (h : in out hash_table; k : in key; e : in enum) is
		p : pnode;
		l : list;
	begin

		-- Check if this type of enum is in the visits done by this item
		if memory(k).avisits(e) = false then
			-- Udate array of booleans and insert into list
			memory(k).avisits(e) := true;
			l := h.lists(e);
			pointerlist.insert(l, k);
		end if;

		-- Create new node of record and update record
		p := new node;
		p.visit := e;
		p.next := memory(k).rec;

		memory(k).rec := p;

	end update;

	-- Get the key of the item passed by arguments
	function get_key (h : in hash_table; x : in item) return key is
		hash_value : natural;
		index, index_aux : cursor_index;
		k : key;
	begin
		-- Get hash value and cursor index
		hash_value := hash(x,hash_size);
		index := h.dt(hash_value);

		-- Search the item
		while index /= 0 and then memory(index).x /= x loop
			index := memory(index).next;
		end loop;
		if index = 0 then raise does_not_exist;end if;

		k := index;

		return k;

	end get_key;

begin

	prep_mem_space;

end dhash_table;
