package body dheap is

  procedure empty (q : out heap) is
  begin
    q.n := 0;
  end empty;

  function is_empty (q : out heap) return boolean is
  begin
    return q.n = 0;
  end is_empty;

  function get_last (q : in heap) return item is
  begin
    if is_empty(q) then raise bad_use; end if;
    return q.memory(1).x;
  end get_last;


end dheap;
