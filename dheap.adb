package body dheap is

  procedure empty (q : out heap) is
  begin
    q.n := 0;
  end empty;

  function is_empty (q : in heap) return boolean is
  begin
    return q.n = 0;
  end is_empty;

  procedure get_least (q : in heap; x : out item; k : out key; t : out enum) is
  begin
    if is_empty(q) then raise bad_use; end if;
    x := q.memory(1).x;
    k := q.memory(1).k;
    t := q.memory(1).t;
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
      q.memory(index).t := q.memory(parent).t;
      index := parent;
      parent := index/2;
    end loop;
    q.memory(index).x := x;
    q.memory(index).k := k;
    q.memory(index).t := t;
  end put;

  procedure delete_least(q : in out heap) is
    index, child : natural;
    x : item;
    k : key;
    t : enum;
  begin

    if q.n = 0 then raise bad_use; end if;

    -- Save the information of last element
    x := q.memory(q.n).x;
    k := q.memory(q.n).k;
    t := q.memory(q.n).k;

    -- Decrement the size
    q.n := q.n - 1;

    -- Set the patern and the child index
    index := 1;
    child := index*2;

    -- If child in range and right child less than patern index get right child
    if child < q.n and then q.memory(child+1).k < q.memory(child).k then
      child := child + 1;
    end if;

    -- Reestructure the heap
    while child <= q.n and then q.memory(child).k < k loop
      q.memory(index).k := q.memory(child).k;
      q.memory(index).x := q.memory(child).x;
      q.memory(index).t := q.memory(child).t;
       index := child;
      child := 2*index;
      if child < q.n and then q.memory(child+1).k < q.memory(child).k then
        child := child + 1;
      end if;
    end loop;

    q.memory(index).k := k;
    q.memory(index).x := x;
    q.memory(index).t := t;

  end delete_least;

  ---------------------------------------------------
  -- PROCEDURES AND FUNCTIONS RELATED TO ITERATORS --
  ---------------------------------------------------

  procedure first (q : in heap; it : out heap_iterator) is
  begin
    -- if the queue is empty, q.n=0 then is not valid
    it.valid := (q.n /= 0);
    it.index := 1;
  end first;

  procedure next (q : in heap; it : in out heap_iterator) is
  begin
    if not is_valid(it) then raise bad_use; end if;
    it.index := it.index+1;
    it.valid := (it.index <= q.n);
  end next;

  procedure get (q : in heap; it : in heap_iterator; x : out item; k : out key;
                                                                t : out enum) is
  begin
    if not is_valid(it) then raise bad_use; end if;
    x := q.memory(it.index).x;
    k := q.memory(it.index).k;
    k := q.memory(ti.index).t;
  end get;

  function is_valid (it : in heap_iterator) return boolean is
  begin
    return it.valid;
  end is_valid;

end dheap;
