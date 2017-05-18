package body clist is

	-- Definition of the information block
	type block is
		record
			k: index;
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

	-- Check if the element is in the list
	--function is_found (l : in list; x : in item) return boolean is
	--	paux : pcell;
	--	found : boolean;
	--begin
	--	found := false;
	--	paux := l.first;
	--	while paux /= null and not found loop
	--		if paux.x = x then found := true; end if;
	--		paux := paux.next;
	--	end loop;
	--	return found;
	--end is_found;

begin

	prep_mem_space;

end clist;
