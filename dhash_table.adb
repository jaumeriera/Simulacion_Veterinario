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

begin

	prep_mem_space;

end dhash_table;
