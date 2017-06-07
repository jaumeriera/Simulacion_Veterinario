generic

  size : positive := 5;
  type enum is (<>);
  type item is private;
  type time is (<>);

package offices is

  -- Put to empty the structure to start working
  procedure empty (c : out offices);

  -- Insert new element into a free consult
  procedure enter_in_consult (c : in out offices; e : in enum; x : in item; t : in time);

  -- Liberate a free consult
  procedure free_consult (c : in out offices);

  -- Close one free consult
  procedure close_consult (c : in out offices);

  -- Open new consult and put it into free consults
  procedure open_consult (c : in out offices);

  -- Return if there are free consults
  function there_are_free_consults (c : in offices) return boolean;

private

  type office;
  type poffice is access office;

  -- One component of the list
  type office is
    record
      e : enum;
      t : time;
      x : item;
    end record;

  -- list of ocuped offices
  package openedOffices is new plist (item => poffice);
  use openedOffices;

  type offices is
    record
      opened_offices : integer;
      free_offices : integer;
      offices : list;
    end record;

end offices;
