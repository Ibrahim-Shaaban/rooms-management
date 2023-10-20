# README

## Install Guide
### To make it easy for you i make a docker compose to contain four services :
* web(rails) 
* postgres 
* redis
* sidekiq

## to run the project all you need is :
* to run `docker compose up --build`

### if you face a problem or the docker stuck at postgres container all you have to do is to stop the docker and run again `docker compose up --build`

### if you want to to run rspec test :
* run `docker exec -it <web_container_name> bash `
* then run `bundle exec rspec spec/<path_to_rspec_file>`

## database schema 

### User model attributes
* user_name (index and make it unique)
* password

### Room model attributes
* number (index and make it unique)
* room_type
* price_per_night

### Relation between User and Room
* relation between user and room is many to many so we create pivot table/model called reservation 

### Reservation model attributes 
* user_id
* room_id
* start_date
* end_date 
* we make index on (user_id , room_id , start_date)

## API Documentation 
### here is the link : https://documenter.getpostman.com/view/2558932/2s9YRB3C5F

## Assumptions

* user can make reservations with start date is more advanced than current date 
* APIs require user to be authenticated : make_reservation , cancel_reservation and get all rooms
* user can cancel reservation by using resevation_id
* cancel reservation API reuires authroization to check if user made the request is the same user who made this reservation

## What will i do if I have more time ? 
* register user with email and confirm his email by sending otp code to his email 
* make admin management to protect APIs like add room and get all rooms
* make API to get all reservations
* make pagination for get all available rooms API


