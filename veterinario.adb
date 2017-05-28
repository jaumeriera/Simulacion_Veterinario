
with ada.numerics.float_random;
use ada.numerics.float_random;
procedure veterinario is

  cycle : integer := 1;

  vet_office_free : boolean;

  probability_open_office : float := 10.0;
  probability_close_office : float := 10.0;
  probability_new_pet : float := 75.0;
  probability_of_visit : float := 25.0;


  function probability_is_met (probability : in float) return boolean is
    rnd : generator;
    num_rand : float;
  begin
    -- Prepare random generator
    reset(rnd);
    -- Random number and convert it into %
    num_rand := random(rnd);
    num_rand := num_rand*100.0;

    -- Check if is in probability
    return num_rand<probability;

  end enter_new_pet;

begin

  while not end_of_simulation loop

    -- Check if some office is free and update the boolean passed by arguments
    check_office(vet_office_free);

    if probability_is_met(probability_new_pet) then
      check_in_pet;
      waiting_room;
    end if;

    if vet_office_free then
      next_pet;
      update_pet_history;
      nurse_pet;
    end if;

    -- Next cycle
    cycle := cycle + 1;

  end loop;

end veterinario;
