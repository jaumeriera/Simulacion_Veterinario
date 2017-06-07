package body consulta is

  procedure empty (c : out offices) is
  begin
    c.opened_offices := 1;
    c.free_offices := 1;
    openedOffices.empty(c.offices);
  end empty;

  procedure enter_in_consult (c : in out offices; e : in enum; x : in item; t : in time) is
    poff : poffice;

  begin
    if c.free_offices = 0 then raise bad_use; end if;
    c.free_offices := c.free_offices - 1;
    poff := new office;
    poff.e := e; poff.x := x; poff.t := t;
    openedOffices.insert(c.offices, poff);

  end enter_in_consult;

  procedure free_consult (c : in out offices) is
  begin
    c.free_offices := c.free_offices + 1;
  end free_consult;

  procedure close_consult (c : in out offices) is
  begin
    if c.free_offices = 0 then raise bad_use; end if;
    if c.opened_offices > 1 then
      c.opened_offices := c.opened_offices - 1;
      c.free_offices := c.free_offices -1;
    end if;
  end close_consult;

  procedure open_consult (c : in out offices) is
  begin
    if c.opened_offices = size then raise bad_use; end if;
    c.opened_offices := c.opened_offices + 1;
    c.free_offices := c.free_offices + 1;
  end open_consult;

  function there_are_free_consults (c : in offices) return boolean is
  begin
    return c.free_offices > 0;
  end there_are_free_consults;

end consulta;
