CREATE DATABASE awesome_hotel_booking;
\c awesome_hotel_booking
CREATE TABLE bookings(
  id bigint NOT NULL,
  room_number bigint NOT NULL,
  date date NOT NULL,
  name character varying NOT NULL
);
