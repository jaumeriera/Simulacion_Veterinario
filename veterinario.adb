with ada.numerics.discrete_random;
with dhash_table;
with dheap;
with doffices;
procedure veterinario is

  subtype rand_range is positive;
  package rand_int is new ada.numerics.discrete_random(rand_range);


  -- Types and subtypes that we well use for the vet
  type t_visit is (cures, cirugies, emergencies, revisions);
  --type a_of_delay is array (t_visit) of integer;
  subtype string30 is string (1..30);


  -- Variables related to vet
  cycle : integer := 1;
  pet_name : string30;
  pet_visit_type : t_visit;
  delayed : integer;
  --a_of_delayed : constant a_of_delay (1, 2, 3, 4);

  procedure to_my_string (my_string : out string30; standar_string : in string) is
    len : natural := 30;
  begin
    my_string := (others => ' ');
    for index in standar_string'range loop
      my_string(index) := standar_string(index);
    end loop;
  end to_my_string;

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

  package priority_vet_queue is new dheap(key => integer, item => vet_hash.key,
                                                                enum => t_visit);
  use priority_vet_queue;

  package vet_offices is new doffices(enum => t_visit, item => vet_hash.key,
                                                                time => integer);
  use vet_offices;

  pet_key : vet_hash.key;
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
  rnd : rand_int.generator;
  seed : integer := 100;

  -- Return a random number in %
  function get_random_number return integer is
  begin
    return rand_int.random(rnd) mod 100;
  end get_random_number;

  -- This function generate a random number and check if this number is in a
  -- probability passed by arguments
  function probability_is_met (probability : in integer) return boolean is
  begin
    -- Check if is in probability
    return get_random_number<=probability;
  end probability_is_met;

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
    end if;
  end check_in_pet;

  -- Function that returns the type of visit, this type is calculated by
  -- probability
  function get_visit_type return t_visit is
    num_rand : integer;
    acumulated_prob : integer;
    type enum_index is new integer range 1..4;
    counter : enum_index := 1;
  begin

    num_rand := get_random_number;

    acumulated_prob := probability_of_each_visit;
    while not probability_is_met(acumulated_prob) loop
      acumulated_prob := acumulated_prob + probability_of_each_visit;
      counter := counter + 1;
    end loop;
    case counter is
      when 1 => return cures;
      when 2 => return cirugies;
      when 3 => return emergencies;
      when 4 => return revisions;
    end case;
  end get_visit_type;

  -- Fucntion that calculate the delay for a pet depending on the type of visit
  function calculate_delay (cycles : in integer; visit : in t_visit)
                                                              return integer is
  begin
    case visit is
      when cures => return 1;
      when revisions => return 2;
      when cirugies => return 3;
      when emergencies => return 4;
    end case;
  end calculate_delay;

  procedure get_next_pet (q : in out heap; pet_key : out vet_hash.key;
                                                pet_visit_type : out t_visit) is
    aux : integer;
  begin
    get_least(q, pet_key, aux, pet_visit_type);
    delete_least(q);
  end get_next_pet;

  function calculate_time(pet_visit_type : in t_visit; cy : in integer) return integer is
  begin
    case pet_visit_type is
      when cures => return 5 + cy;
      when cirugies => return 8 + cy;
      when emergencies => return 4 + cy;
      when revisions => return 3 + cy;
    end case;
  end calculate_time;

  procedure nurse_pet (ofi : in out offices; pet_key : in vet_hash.key;
                                pet_visit_type : in t_visit; cy : in integer) is
    atend_time : integer;
  begin
    atend_time := calculate_time(pet_visit_type, cy);
    enter_in_consult(ofi, pet_visit_type, pet_key, atend_time);
  end nurse_pet;

  procedure update_office(offi : in out offices; c : in integer) is
  begin
    check_time(offi, c);
    if can_open(offi) and then probability_is_met(probability_open_office) then
      open_consult(offi);
    end if;
    if there_are_free_consults(offi) and then can_remove(offi) then
      if probability_is_met(probability_close_office) then
        close_consult(offi);
      end if;
    end if;
  end update_office;

  procedure update_pet_history (history : in out hash_table; key : in vet_hash.key;
                                  visit_type : in t_visit; cycles : in integer) is
  begin
    vet_hash.update(history, key, visit_type, cycles);
  end update_pet_history;

begin
  to_my_string(pet_name,"yolanda");
  -- Prepare random generator
  rand_int.reset(rnd,seed);

  -- Prepare structures
  vet_hash.empty(vet_DB);
  priority_vet_queue.empty(vet_queue);
  vet_offices.empty(my_offices);

  --while not end_of_simulation loop

    -- Check if some office is free and update the boolean passed by arguments
    update_office(my_offices, cycle);

    if probability_is_met(probability_new_pet) then
      -- Generar animal

      check_in_pet(vet_DB, pet_name, pet_key);
      pet_visit_type := get_visit_type;
      delayed := calculate_delay(cycle, pet_visit_type);
      --enter_in_waiting_room();
      priority_vet_queue.put(vet_queue, delayed, pet_key, pet_visit_type);
      update_pet_history(vet_DB, pet_key, pet_visit_type, cycle);
    end if;

    if there_are_free_consults(my_offices) then
      get_next_pet(vet_queue, pet_key, pet_visit_type);
      nurse_pet(my_offices, pet_key, pet_visit_type, cycle);
    end if;

    -- Next cycle
    cycle := cycle + 1;

  --end loop;

end veterinario;
