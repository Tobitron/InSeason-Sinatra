-- DROP TABLE boston

CREATE TABLE boston (
  id serial PRIMARY KEY,
  vegetable varchar(255) NOT NULL,
  start_day int,
  end_day int,
  winter_vegetable boolean
  );
