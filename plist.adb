package body plist is

	-- Inicializate the list to a empty list
	procedure empty (l : out list) is
	begin
		l.first := null;
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

	----------------------------------------------
	-- LIST_ITERATOR'S PROCEDURES AND FUNCTIONS --
	----------------------------------------------

	-- list_iterator's pointer point to first element of the list
	procedure first (l : in list; it: out list_iterator) is
	begin
		it.pointer := l.first;
	end first;

	-- Put the pointer of the next element in the list into de list_iterator
	procedure next (l : in list; it: in out list_iterator) is
	begin
		it.pointer := it.pointer.next;
	end next;

	-- Check if the list_iterator is valid
	function is_valid (it : in list_iterator) return boolean is
	begin
		return it.pointer /= null;
	end is_valid;

	-- Return the item in the list_iterator
	procedure get (it : in list_iterator; x : out item) is
	begin
		if not is_valid(it) then raise bad_use; end if;
		x := it.pointer.x;
	end get;

end plist;
