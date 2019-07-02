BEGIN;

SELECT plan(8);
SELECT has_table('bookings');
SELECT col_not_null('bookings', 'id');
SELECT col_not_null('bookings', 'room_number');
SELECT col_not_null('bookings', 'date');
SELECT col_not_null('bookings', 'name');

PREPARE insert_310_july_4_booking AS INSERT INTO bookings (
  id, room_number, date, name
) VALUES (1, 310, '2019-07-04', 'Kevin Hart');
SELECT lives_ok(
  'insert_310_july_4_booking',
  'can insert booking with all attributes'
);

PREPARE insert_conflict_310_july_4_booking AS INSERT INTO bookings (
  id, room_number, date, name
) VALUES (2, 310, '2019-07-04', 'Dave Chappelle');
SELECT throws_ilike(
  'insert_conflict_310_july_4_booking',
  'duplicate key value violates unique constraint%',
  'do not allow two bookings for the same room on the same date'
);

PREPARE insert_814_july_4_booking AS INSERT INTO bookings (
  id, room_number, date, name
) VALUES (3, 814, '2019-07-04', 'Tina Fey');
SELECT lives_ok(
  'insert_814_july_4_booking',
  'can insert booking in another room on the same date'
);

SELECT * FROM finish();

ROLLBACK;
