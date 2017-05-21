package body dhash_table is

	type block is
		record
			x : item;
			k : key;
			avisits : a_of_bool_by_enum;
			rec : pnode;
			next : index;
		end record;

	type memory_space is array (index range 1..index'last) of block;

	memory: memory_space;
	free : index;

end dhash_table;
