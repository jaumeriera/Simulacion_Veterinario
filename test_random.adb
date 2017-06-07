
with ada.float_text_io;
use ada.float_text_io;
with ada.numerics.float_random;
use ada.numerics.float_random;
procedure test_random is
  g : generator;
  f : float;
  mil : float := 1000.0;
begin
  reset(g);
  for i in integer range 1..3 loop
    f := random(g);
    f := f*100.0;
    if f < mil then
      put(f);
    end if;
  end loop;

end test_random;
