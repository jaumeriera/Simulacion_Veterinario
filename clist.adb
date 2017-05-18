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

	-- Release a block introducing it into the list of free blocks
	procedure release_block(to_release: in out index) is
	begin
		memory(to_release).next := free;
		free := to_release; to_release := 0;
	end release_block;

	-- Inicializate the list to a empty list
	procedure empty (l : out list) is
	begin
		l.first := null;
		l.current := null;
	end empty;

	function is_empty (l : in list) return boolean is 
	begin
		return l.first = null;
	end is_empty;

	--Get the last element in the list
	function get_last (l : in list) return pcell is
		p : pcell;
	begin
		p := l.first;
		if p /= null then
			while p.next /= null loop
				p := p.next;
			end loop;
		end if;
		return p;
	end get_last;

	--Insert a new element in last position
	procedure insert (l : in out list; x : in item) is
		p, paux : pcell;
	begin
		p := new cell; 
		p.x := x;
		paux := get_last(l);
		if paux = null then
			l.first := p;
			l.current := p;
		else
			paux.next := p;
		end if;
	exception
		when storage_error => raise space_overflow;
	end insert;

	-- Check if the element is in the list
	function is_found (l : in list; x : in item) return boolean is
		paux : pcell;
		found : boolean;
	begin
		found := false;
		paux := l.first;
		while paux /= null and not found loop
			if paux.x = x then found := true; end if;
			paux := paux.next;
		end loop;
		return found;
	end is_found;

	-- Advance de current pointer to next item.
	procedure advance_pointer (l : out list) is
	begin
		l.current := l.current.next;
	exception
		when constraint_error => raise bad_use;
	end advance_pointer;

	-- Reset the value of the pointer
	procedure reset_pointer (l : out list) is
	begin
		l.current := l.first;
	exception 
		when constraint_error => raise bad_use;
	end reset_pointer;

	-- Return a boolean depending on the value of the pointer
	function current_is_empty (l : in list) return boolean is
	begin
		return l.current = null;
	end current_is_empty;

	-- Return the item pointed by the current pointer
	function current_item (l : in list) return item is
	begin
		return l.current.x;
	exception
		when constraint_error => raise bad_use;
	end current_item;

begin
	prep_mem_space;

end clist;
