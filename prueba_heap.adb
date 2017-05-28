with dheap;
with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;
procedure prueba_heap is

  type t_enum is (emergencies, cirugies, cures, revisions);

  package priority_queue is new dheap(key => t_enum, item => integer);
  use priority_queue;

  package t_enum_io is new ada.text_io.enumeration_io(t_enum);
  use t_enum_io;

  my_queue : heap;

  visit : t_enum;
  cycles : integer;

  procedure print_queue (q : in heap) is
    it : heap_iterator;
    k : t_enum;
    c : integer;
  begin

    put_line("Contenido de la cola: ");

    first(q,it);
    while is_valid(it) loop
      get(q, it, c, k);
      put(k);
      put(" ");
      put(c);
      put_line("");
      next(q, it);
    end loop;

  end print_queue;

begin

  empty(my_queue);

  put(my_queue, revisions, 10);
  put(my_queue, cirugies, 25);
  put(my_queue, revisions, 28);
  put(my_queue, cures, 78);
  put(my_queue, emergencies, 52);
  put(my_queue, emergencies, 87);
  put(my_queue, cures, 35);

  print_queue(my_queue);

  while not is_empty(my_queue) loop
    get_least(my_queue, cycles, visit);
    put("Sale elemento : ");
    delete_least(my_queue);
    put(visit);
    put(" ");
    put(cycles);
    put_line("");

    --print_queue(my_queue);

  end loop;

end prueba_heap;
