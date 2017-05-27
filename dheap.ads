generic
  size : positive := 50;
  type key is (<>);
  type data is (<>);
  type item is private;
package dheap is

  type heap is limited private;

  space_overflow : exception;
  bad_use : exception;

  procedure empty (q : out heap);
  pragma inline(empty);

  procedure put (q : in out heap; k : in key; x : in item);

  procedure delete_least (q : in out heap);

  procedure get_least (q : in heap; x : out item; k : out key);
  pragma inline(get_least);

  function is_empty (q : in heap) return boolean;
  pragma inline(is_empty);

private

    type component is
      record
        x : item; -- Sera la key del animal
        k : key; -- Sera el enumerado
      end record;

    type mem_space is array (1..size) of components;

    type heap is
      record
        memory : mem_space;
        n : natural;
      end record;

end dheap;
