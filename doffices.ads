with plist;
with exceptions;
use exceptions;
generic

  size : positive := 5;
  type enum is (<>);
  type item is private;
  type time is (<>);

package doffices is

  type offices is limited private;

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

  -- Check if is posible remove
  function can_remove (c : in offices) return boolean;

  -- Check if is posible open new office
  function can_open (c : in offices) return boolean;

  -- Reduce the time of consult and delete empty offices
  procedure check_time (c : in out offices; t : in time);

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
      off : list;
    end record;

end doffices;
