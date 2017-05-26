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

  procedure put (q : in out heap; k : in key; x : in item) is
    index, parent : natural;
  begin
    if q.n = size then raise space_overflow; end if;

    q.n := q.n +1;
    index := q.n;
    parent := q.n/2;

    while parent > 0 and then q.memory(parent).k > k loop
      
    end loop;
  end put;

end dheap;
