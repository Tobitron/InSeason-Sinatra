DROP TABLE boston

CREATE TABLE boston (
  id serial PRIMARY KEY,
  vegetable varchar(255) NOT NULL,
  start_day int,
  end_day int,
  winter_vegetable boolean
  );


INSERT INTO boston (vegetable, start_day, end_day, winter_vegetable) VALUES

  ('broccoli', 135, 288, false),
  ('cauliflower', 166, 319, false),
  ('corn', 196, 319, false),
  ('cucumber', 181, 319, false),
  ('eggplant', 121, 319, false),
  ('kale', 166, 486, true),
  ('leek', 227, 471, true),
  ('lettuce', 106, 350, false),
  ('pepper', 135, 319, false),
  ('potato', 212, 319, false),
  ('spinach', 135, 350, false),
  ('brussel sprouts', 274, 470, true),
  ('carrot', 182, 360, false),
  ('onion', 121, 320, false),
  ('tomato', 135, 305, false);

-- April 15 = 106
-- May 1 = 121
-- May 15 = 135
-- June 1 = 153
-- June 15 = 166
-- July 1st = 181
-- July 15 = 196
-- Aug 15 = 227
-- Oct 1 = 274
-- Oct 15 = 288
-- Nov 1 = 305
-- Nov 15 = 319
