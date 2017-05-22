package body dhash_table is

	-- Inicializate the dispersion table to null and inicializate all the lists
	-- in the lists array to null
	procedure empty (h : out hash_table) is 
	begin
		h.dt := (others => null);
		for posenum in enum loop
			empty(h.lists(posenum));
		end loop;
	end empty;

	-- Check if the key introduced is in the dispersion table
	function exist (h : in hash_table; k : in key) return boolean is
		hash_result : natural;
		pointer : pnode;
	begin
		hash_result := hash(k, size); 
		pointer := h.dt(hash_result);

		while p /= null and then p.k /= k loop
			p := p.next_int;
		end loop;

		return p /= null;
	end exist;

	-- Insert new intern node into hash table
	procedure put (h : in out hash_table; k : in key; x : in item) is
		hash_result : natural;
		pointer : pnode;
	begin
		if exist(h, k) then raise already_exists; end if;

		hash_result := hash(k, size);

		-- Create new node
		pointer := new node;
		pointer.all := (k, x, null, null);

		-- Insert in the dispersion table
		pointer.next_int := h.dt(hash_result);
		h.dt(hash_result) := pointer;
	exception
		when storage_error => raise space_overflow;
	end put;

	-- Insert new extern node into an intern node by a key passed by arguments
	-- hola

end dhash_table;
