with dhash_table;
procedure prueba_hashing is

  type t_enum is (cures, cirugies, emergencies, revisions);

  package animal_hash is new dhash_table (enum => t_enum, item => string,
                                                              hash => my_hash);
  use animal_hash;

  my_hash : hash_table;
  ky, kt, kr, kd : key;

begin

  empty(my_hash);

  insert(my_hash, ky, "yolanda");
  insert(my_hash, kt, "toni");
  insert(my_hash, kr, "rafa");
  insert(my_hash, kd, "dayman");

  update(my_hash, ky, cures);
  update(my_hash, ky, emergencies);
  update(my_hash, kt, revisions);
  update(my_hash, kr, emergencies);
  update(my_hash, kr, revisions);

  

end prueba_hashing;
