with dhash_table;
with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;
with ada.strings; use ada.strings;
procedure prueba_hashing is

  type t_enum is (cures, cirugies, emergencies, revisions);

  -- Package to print type t_enum wich is an enumeration
  package t_enum_io is new ada.text_io.enumeration_io(t_enum);
  use t_enum_io;

  e : t_enum := cures;

  -- Quadratic hash function extracted from the book "A primer on Program
  -- Construction IV. Data Structures" of Albert Llemosí
  function hash(s : in string; b : in positive) return natural is
    n : constant natural := s'last;
    m : constant natural := character'pos(character'last)+1;
    c : natural;
    k,l : integer;
    a : array (1..n) of natural;
    r : array (1..2*n) of natural;
  begin
    for i in s'range loop a(i) := character'pos(s(i)); end loop;

    for i in 1..2*n loop r(i) := 0; end loop;
    k := 2*n+1;
    for i in reverse 1..n loop
      k := k-1; l := k; c := 0;
      for j in reverse 1..n loop
        c := c + r(l) + a(i)*a(j);
        r(l) := c mod m; c := c/m;
        l := l-1;
      end loop;
      r(l) := c;
    end loop;
    c := (r(n)*m + r(n+1)) mod b;
    return c;
  end hash;

  subtype string20 is string (1..20);

  package animal_hash is new dhash_table (enum => t_enum, item => string20,
                                                    hash => prueba_hashing.hash);
  use animal_hash;

  my_hash : hash_table;
  ky, kt, kr, kd : key;

  procedure to_my_string (my_string : out string20; standar_string : in string) is
    len : natural := 20;
  begin
    my_string := (others => ' ');
    for index in standar_string'range loop
      my_string(index) := standar_string(index);
    end loop;
  end to_my_string;

  procedure show_animals_by_visit (my_hash : in hash_table; visit : t_enum) is
    iterator : hash_iterator;
    pet : string20;
  begin
    put_line("");
    put("Para el tipo de visita ");
    put(visit);
    put_line(" :");
    put(" - Ha habido un total de ");
    put(get_component_number(my_hash, visit));
    put_line("");
    put_line(" - Los animales que han pasado por este tipo de visita son: ");

    first(my_hash, iterator, visit);
    while is_valid(iterator) loop
      put("   - ");
      get(my_hash, iterator, pet);
      put_line(pet);
      next(my_hash, iterator);
    end loop;

  end show_animals_by_visit;

  o1, o2, o3, o4 : string20;
  n1, n2, n3, n4 : string20;
begin

  empty(my_hash);

  to_my_string(o1, "yolanda");
  to_my_string(o2, "toni");
  to_my_string(o3, "rafa");
  to_my_string(o4, "dayman");

  insert(my_hash, ky, o1);
  insert(my_hash, kt, o2);
  insert(my_hash, kr, o3);
  insert(my_hash, kd, o4);

  update(my_hash, ky, cures);
  update(my_hash, ky, emergencies);
  update(my_hash, ky, emergencies);
  update(my_hash, kt, revisions);
  update(my_hash, kr, emergencies);
  update(my_hash, kr, revisions);

  n1 := get_item(my_hash,ky);
  n2 := get_item(my_hash,kt);
  n3 := get_item(my_hash,kr);
  n4 := get_item(my_hash,kd);

  put_line("Nombres de mascotasen la tabla:");
  put_line(n1);
  put_line(n2);
  put_line(n3);
  put_line(n4);

  show_animals_by_visit(my_hash, emergencies);
end prueba_hashing;
