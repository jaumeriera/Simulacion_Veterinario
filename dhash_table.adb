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

	procedure insert (h : in out hash_table; k : in key; x : in item) is
	begin

	end insert;

end dhash_table;
