package body plist is

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

end plist;
