generic
  size : positive := 50;
  type key is (<>);
  type item is private;
package dheap is

  type heap is limited private;

  space_overflow : exception;
  bad_use : exception;

  procedure empty (q : out heap);
  pragma inline(empty);

  procedure put (q : in out heap; k : in key; x : in item);
  procedure delete_least (q : in out heap);

  function get_least (q : in heap) return item;
  function is_empty (q : in heap) return boolean;
  pragma inline(is_empty);

private

    type component is
      record
        x : item;
        k : key;
      end record;

    type mem_space is array (1..size) of components;

    type heap is
      record
        memory : mem_space;
        n : natural;
      end record;

end dheap;
