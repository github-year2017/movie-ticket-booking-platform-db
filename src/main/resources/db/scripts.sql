-- SET search_path = movie-ticket-booking-platform-db, "postgres", public; -- For current session only

ALTER ROLE postgres SET search_path = 'movie-ticket-booking-platform-db', "postgres", public; -- Persistent, for role


--Enumerated data type

CREATE TYPE VALID_USER_TYPES AS ENUM ('B2B', 'B2C');
CREATE TYPE VALID_BOOKING_STATUS AS ENUM('Confirmed', 'Cancelled');
CREATE TYPE VALID_PAYMENT_STATUS AS ENUM('Pending', 'Completed', 'Failed');

-- Users table
CREATE TABLE Users (
    user_id BIGSERIAL PRIMARY KEY ,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    user_type VALID_USER_TYPES NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Theatres table
CREATE TABLE Theatres (
    theatre_id BIGSERIAL PRIMARY KEY ,
    user_id INT,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,
    zipcode VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Movies table
CREATE TABLE Movies (
    movie_id BIGSERIAL PRIMARY KEY ,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    language VARCHAR(50) NOT NULL,
    duration INT NOT NULL, -- duration in minutes
    release_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Shows table
CREATE TABLE Shows (
    show_id BIGSERIAL PRIMARY KEY ,
    theatre_id INT,
    movie_id INT,
    show_date DATE NOT NULL,
    show_time TIME NOT NULL,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (theatre_id) REFERENCES Theatres(theatre_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

-- Bookings table
CREATE TABLE Bookings (
    booking_id BIGSERIAL PRIMARY KEY ,
    user_id INT,
    show_id INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_tickets INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status  VALID_BOOKING_STATUS NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id)
);

-- Payments table
CREATE TABLE Payments (
    payment_id BIGSERIAL PRIMARY KEY ,
    booking_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VALID_PAYMENT_STATUS NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

-- Offers table
CREATE TABLE Offers (
    offer_id BIGSERIAL PRIMARY KEY ,
    offer_description VARCHAR(255) NOT NULL,
    discount_percentage DECIMAL(5, 2) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seats table
CREATE TABLE Seats (
    seat_id BIGSERIAL PRIMARY KEY ,
    show_id INT,
    seat_number VARCHAR(10) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (show_id) REFERENCES Shows(show_id)
);
