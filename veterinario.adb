-- Falta modificar el put del heap para que introduzca ciclos
with ada.numerics.discrete_random;
with dhash_table;
procedure veterinario is

  subtype rand_range is positive;
  package rand_int is new ada.numerics.discrete_random(rand_range);
  use ada.numerics.discrete_random;


  -- Types and subtypes that we well use for the vet
  type t_enum is (cures, cirugies, emergencies, revisions);
  type a_of_delay is array (t_enum) of integer;
  subtype string30 is string (1..30);


  -- Variables related to vet
  cycle : integer := 1;
  vet_office_free : boolean;
  pet_name : string30;
  pet_visit_type : t_visit;
  delayed : integer;
  a_of_delayed : constant a_of_delay (1 .. 4);

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

  -- Package for the vet's database
  package vet_hash is new dhash_table(enum => t_visit, item => string30,
                                                      hash => veterinario.hash);
  use vet_hash;

  package vet_queue is new dheap(key => integer, item => vet_hash.key,
                                                                  t => t_visit);
  use vet_queue;

  package vet_offices is new consulta(enum => t_visit, item => vet_hash.key,
                                                                time => integer);
  use vet_offices;

  pet_key : dvet_hash.key;
  my_offices : offices;

  -- Database for the vet
  vet_DB : hash_table;
  -- Queue for the vet
  vet_queue : heap;

  -- Probability constants
  probability_open_office : constant integer := 10;
  probability_close_office : constant integer := 10;
  probability_new_pet : constant integer := 75;
  probability_of_each_visit : constant integer := 25;

  -- Variables to work with random numbers
  rnd : generator;
  seed : integer;

  -- Return a random number in %
  function get_random_number return integer is
  begin
    return random(rnd) mod 100;
  end get_random_number;

  -- This function generate a random number and check if this number is in a
  -- probability passed by arguments
  function probability_is_met (probability : in integer) return boolean is
    num_rand : integer;
  begin
    -- Check if is in probability
    return get_random_number<=probability;
  end enter_new_pet;

  -- This procedure check if the pet exist, if the pet doesn't exists register
  -- the pet and put the pet's key into a variable introduced by arguments, if
  -- exists then only put the pet's key into the argument
  procedure check_in_pet(DB : in out hash_table; pet_name : in string30;
                                                  pet_key : out vet_hash.key) is
  begin
    if is_in(DB, pet_name) then
      pet_key := get_key(DB, pet_name);
    else
      insert(DB, pet_key, pet_name);
    end if
  end check_in_pet;

  -- Function that returns the type of visit, this type is calculated by
  -- probability
  function get_visit_type return t_visit is
    num_rand : integer;
    acumulated_prob : integer;
    counter : integer := 1;
  begin

    num_rand := get_random_number;

    acumulated_prob := probability_of_each_visit;
    while not probability_is_met(acumulated_prob) loop
      acumulated_prob := acumulated_prob + probability_of_each_visit;
      counter := counter + 1;
    end loop;

    return t_visit(counter);
  end get_visit_type;

  -- Fucntion that calculate the delay for a pet depending on the type of visit
  function calculate_delay (cycles : in integer, visit : in t_visit)
                                                              return integer is
  begin
    return cycles-delayed(visit);
  end calculate_delay;

  procedure get_next_pet (q : in out heap; pet_key : out vet_hash.key;
                                                pet_visit_type : out t_visit) is
    aux : integer;
  begin
    get_least(q, pet_key, aux, pet_visit_type);
    delete_least(q);
  end get_next_pet;

begin

  -- Prepare random generator
  reset(rnd,seed);

  -- Prepare structures
  vet_hash.empty(vet_DB);
  dheap.empty(vet_queue);
  consulta.empty(offices);

  while not end_of_simulation loop

    -- Check if some office is free and update the boolean passed by arguments
    update_office(vet_office_free);

    if probability_is_met(probability_new_pet) then
      check_in_pet(vet_DB, pet_name, pet_key);
      pet_visit_type := get_visit_type;
      delayed := calculate_delay(cycle, pet_visit_type);
      --enter_in_waiting_room();
      vet_queue.put(vet_queue, delayed, pet_key, pet_visit_type);
      update_pet_history(pet_key, pet_visit_type, cycle);
    end if;

    if there_are_free_consults(offices) then
      get_next_pet(vet_queue, pet_key, pet_visit_type);
      nurse_pet(pet_key, pet_visit_type);
    end if;

    -- Next cycle
    cycle := cycle + 1;

  end loop;

end veterinario;
