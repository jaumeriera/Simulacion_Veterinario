package body clist is

	-- Definition of the information block
	type block is
		record
			k: integer;
			x: item;
			next: index;
		end record;

	-- Avaible memory
	type mem_space is array (index range..index'last) of block;
	memory : mem_space;
	free : index;

	-- Procedure to inicializate the avaible memory shared by all lists of
	-- this package
	procedure prep_mem_space is 
	begin
		for i in index range 1..index'last-1 loop
			memory(i).k := i;
			memory(i).next := i+1;
		end loop;
		memory(index'last).k := index'last;
		memory(index'last).next := 0;
		free := 1;
	end prep_mem_space;

	-- Get a block from the list of free blocks
	function get_block return index is
		to_return: index;
	begin
		if free = 0 then raise space_overflow; end if;
		to_return := free;
		free := memory(free).next;
		memory(to_return) := 0;
		return to_return;
	end get_block;

	-- Inicializate the list to a empty list
	procedure empty (l : out list) is
	begin
		l.first := 0;
	end empty;

	function is_empty (l : in list) return boolean is 
	begin
		return l.first = 0;
	end is_empty;

	--Insert a new element in last position
	procedure insert (l : in out list; x : in item) is
		p: index;
	begin
		p := get_block;
		memory(p).next := l.first;
		memory(p).x := x;
		l.first := p;
	exception
		when storage_error => raise space_overflow;
	end insert;

	-- Iterator procedures and functions
	
	-- Put the index of the first element in the list into the iterator
	procedure first (l : in list; it: out iterator) is
	begin
		it.i := l.first;
	end first;

	-- Put the index of the next element in the list into de iterator
	procedure next (l : in list; it: out iterator) is
	begin
		it.i := memory(it.i).next;
	end next;

	-- Check if the iterator is valid
	function is_valid (it : in iterator) is
	begin
		return it.i /= 0;
	end is_valid;

	-- Return the item in the iterator
	procedure get (it : in iterator; k : out integer; x : out item) is
	begin
		if not is_valid(it) then raise bad_use; end if;
		k := memory(it.i).k;
		x := memory(it.i).x;
	end get;

begin

	prep_mem_space;

end clist;
