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
		else
			paux.next := p;
		end if;
	exception
		when storage_error => raise space_overflow;
	end insert;

end plist;
