# PgTap Test Constraints

## Introduction

The purpose of this repo is to show a quick demonstration on how to use
[pgtap](https://pgtap.org/) to validate data integrity for
[Postgres](https://www.postgresql.org/) databases. In this simple example, we
show how to **utilize and test indexes** to prevent a room being double booked
for a hotel suite. A summary of the steps are:
1. Create a database that has a bookings table
2. Create a series of tests for bookings table
  *(including failing test for conflict booking)*
3. Run tests to see failure
4. Update database with unique index to fix failing test
5. Re-run tests to ensure previous failing test now passes

## Requirements

* [Docker](https://docs.docker.com/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* Basic understanding of [unique
  indexes](https://www.postgresql.org/docs/current/indexes-unique.html)

## Steps

1. Start Postgres database server
```
docker-compose up -d db
```

2. Initialize Database

Create `awesome_hotel_booking` database and `bookings` table.

Review [init_db.sql](seeds/init_db.sql) to see details
```
docker-compose run db psql -h db -U test_pg_tap -f /seeds/init_db.sql
```

3. Run pgtap tests

Review [pgtap/bookings.sql](pgtap/bookings.sql) and [pgtap
documentation](https://pgtap.org/documentation.html) to understand the test
cases.

The 7th test should fail which tries to insert a double booking for the same
room.
```
docker-compose run pgtap

## OUTPUT
Running tests: /test/*.sql
/test/bookings.sql .. 1/8
# Failed test 7: "do not allow two bookings for the same room on the same date"
#     no exception thrown
# Looks like you failed 1 test of 8
/test/bookings.sql .. Failed 1/8 subtests

Test Summary Report
-------------------
/test/bookings.sql (Wstat: 0 Tests: 8 Failed: 1)
  Failed test:  7
  Files=1, Tests=8,  0 wallclock secs ( 0.02 usr +  0.00 sys =  0.02 CPU)
  Result: FAIL
```


3. Create unique index

See [create_uq_index.sql](seeds/create_uq_index.sql) for details.
```
docker-compose run db psql -h db -U test_pg_tap -d awesome_hotel_booking \
  -f /seeds/create_uq_index.sql
```

4. Re-run pg tap tests

All of the tests should pass now.
```
docker-compose run pgtap

## OUTPUT
Running tests: /test/*.sql
/test/bookings.sql .. ok
All tests successful.
Files=1, Tests=8,  0 wallclock secs ( 0.02 usr +  0.00 sys =  0.02 CPU)
Result: PASS
```

5. Stop Docker
```
docker-compose down
```
