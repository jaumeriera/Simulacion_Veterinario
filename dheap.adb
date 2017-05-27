package body dheap is

  procedure empty (q : out heap) is
  begin
    q.n := 0;
  end empty;

  function is_empty (q : in heap) return boolean is
  begin
    return q.n = 0;
  end is_empty;

  procedure get_least (q : in heap; x : out item; k : out key) is
  begin
    if is_empty(q) then raise bad_use; end if;
    x := q.memory(1).x;
    k := q.memory(1).k;
  end get_least;

  procedure put (q : in out heap; k : in key; x : in item) is
    index, parent : natural;
  begin
    if q.n = size then raise space_overflow; end if;

    q.n := q.n +1;
    index := q.n;
    parent := q.n/2;

    while parent > 0 and then q.memory(parent).k > k loop
      q.memory(index).k := q.memory(parent).k;
      q.memory(index).x := q.memory(parent).x;
      index := parent;
      parent := index/2;
    end loop;
    q.memory(index).x := x;
    q.memory(index).k := k;
  end put;

  procedure delete_least(q : in out heap) is
    index, child : natural;
    x : item;
    k : key;
  begin

    if q.n = size then raise space_overflow; end if;

    -- Save the information of last element
    x := q.memory(q.n).x;
    k := q.memory(q.n).k;

    -- Decrement the size
    q.n := q.n - 1;

    -- Set the patern and the child index
    index := 1;
    child := index*2;

    -- If child in range and right child less than patern index get right child
    if child < q.n and then q.memory(child+1).k < q.memory(index).k then
      child := child + 1;
    end if;

    -- Reestructure the heap
    while child < q.n and then q.memory(child).k < k loop
      q.memory(index).k := q.memory(child).k;
      q.memory(index).x := q.memory(child).x;
      index := child;
      child := 2*index;
      if child < q.n and then q.memory(child+1).k < q.memory(index).k then
        child := child + 1;
      end if;
    end loop;

    q.memory(index).k := q.memory(child).k;
    q.memory(index).x := q.memory(child).x;

  end delete_least;

end dheap;
