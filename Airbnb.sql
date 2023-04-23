/* Instructions
   1. Download PostgreSQL and pgAdmin from postgresql.org. Click the Download tab and select your operating system. Choose the 
      Interactive Installer by EDB option for download.
   2. Create a database on pgAdmin. Select the database. Right click the database name and select Query Tool.
   3. Paste this code to the Query Tool and execute.
 */

/* Create database. Uncomment if using psql to execute code.
CREATE DATABASE "Airbnb"
    WITH
    OWNER = DEFAULT
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False; */

/* Create tables */

CREATE TABLE "Address" (
  "Address ID" serial,
  "Country" varchar(50) NOT NULL,
  "Street" varchar(70),
  "Apt/Suite" varchar(4),
  "City" varchar(50) NOT NULL,
  "Province" varchar(50),
  "Zip Code" varchar(20),
  PRIMARY KEY ("Address ID")
);

CREATE TABLE "Information" (
  "Info ID" serial,
  "SMS" bool NOT NULL,
  "Email" bool NOT NULL,
  "Marketing Emails" bool NOT NULL,
  PRIMARY KEY ("Info ID")
);

CREATE TABLE "User" (
  "User ID" serial,
  "Address ID" int NOT NULL,
  "Info ID" int NOT NULL,
  "First Name" varchar(50) NOT NULL,
  "Last Name" varchar(50) NOT NULL,
  "Email" varchar(50) NOT NULL,
  "Password" varchar(20) NOT NULL,
  "Birthday" varchar(10),
  "Language" varchar(20),
  "Gender" char(1),
  "Gov ID" varchar(50),
  PRIMARY KEY ("User ID"),
  CONSTRAINT fk_addressID
    FOREIGN KEY ("Address ID")
      REFERENCES "Address"("Address ID")
      ON DELETE CASCADE,
  CONSTRAINT fk_infoID
    FOREIGN KEY ("Info ID")
      REFERENCES "Information"("Info ID")
      ON DELETE CASCADE
);

CREATE TABLE "Session History" (
  "Session ID" serial,
  "User ID" int NOT NULL,
  "OS" varchar(10) NOT NULL,
  "Version" varchar(20) NOT NULL,
  "Web Browser" varchar(20) NOT NULL,
  "City" varchar(50) NOT NULL,
  "Province" varchar(50) NOT NULL,
  "Date" date NOT NULL,
  PRIMARY KEY ("Session ID"),
  CONSTRAINT fk_user 
   FOREIGN KEY("User ID") 
   REFERENCES "User"("User ID")
   ON DELETE CASCADE
);

CREATE TABLE "Credit Balance" (
  "Balance ID" serial,
  "User ID" int NOT NULL,
  "Balance" decimal(7,2) NOT NULL,
  PRIMARY KEY ("Balance ID"),
  CONSTRAINT fk_user
     FOREIGN KEY("User ID") 
       REFERENCES "User"("User ID")
       ON DELETE CASCADE
);

CREATE TABLE "Wishlists" (
  "Wishlist ID" serial,
  "Wishlist Name" varchar(50) NOT NULL,
  "Listing ID" int,
  "Listing Name" varchar(100),
  PRIMARY KEY ("Wishlist ID")
);

CREATE TABLE "Wishlist Composite" (
  "User ID" int NOT NULL,
  "Wishlist ID" int NOT NULL,
  PRIMARY KEY ("User ID", "Wishlist ID"),
  CONSTRAINT fk_userID
    FOREIGN KEY ("User ID")
      REFERENCES "User"("User ID")
      ON DELETE CASCADE,
  CONSTRAINT fk_wishlistID
     FOREIGN KEY("Wishlist ID") 
       REFERENCES "Wishlists"("Wishlist ID")
       ON DELETE CASCADE
);

CREATE TABLE "Messages" (
  "Message ID" serial,
  "User ID" int NOT NULL,
  "First Name" varchar(50) NOT NULL,
  "Message" text NOT NULL,
  PRIMARY KEY ("Message ID"),
  CONSTRAINT fk_user
     FOREIGN KEY("User ID") 
       REFERENCES "User"("User ID")
       ON DELETE CASCADE
);

CREATE TABLE "Host" (
  "Host ID" serial,
  "User ID" int NOT NULL,
  "Photo Url" varchar(50) NOT NULL,
  "Phone Number" varchar(30) NOT NULL,
  "Payout Method" varchar(13) NOT NULL,
  PRIMARY KEY ("Host ID"),
  CONSTRAINT fk_user 
   FOREIGN KEY("User ID") 
   REFERENCES "User"("User ID")
   ON DELETE CASCADE
);

CREATE TABLE "Listing" (
  "Listing ID" serial,
  "Host ID" int NOT NULL,
  "Availability ID" int NOT NULL UNIQUE,
  "Title" varchar(100) NOT NULL,
  "Average Rating" decimal(2,1),
  "Number of Reviews" int,
  "Location" varchar(50) NOT NULL,
  "Host Name" varchar(50) NOT NULL,
  "Max Guests" varchar(2) NOT NULL,
  "Bedrooms" char(1) NOT NULL,
  "Bathrooms" char(1) NOT NULL,
  "Description" text,
  "Place Type" varchar(12) NOT NULL,
  "Cancellation Policy" text,
  "House Rules" text,
  PRIMARY KEY ("Listing ID"),
  CONSTRAINT hostid_fk
    FOREIGN KEY ("Host ID")
      REFERENCES "Host"("Host ID")
      ON DELETE CASCADE
);

CREATE TABLE "Listing Availability" (
  "Availability ID" serial,
  "Listing ID" int NOT NULL,
  "Date" date NOT NULL,
  "Available" bool NOT NULL,
  PRIMARY KEY ("Availability ID"),
  CONSTRAINT listingid_fk
    FOREIGN KEY ("Listing ID")
      REFERENCES "Listing"("Listing ID")
);


CREATE TABLE "Listing Photos" (
  "Photo ID" serial,
  "Listing ID" int NOT NULL,
  "Photo Url" varchar(50) NOT NULL,
  PRIMARY KEY ("Photo ID"),
  CONSTRAINT fk_lisingID
    FOREIGN KEY ("Listing ID")
      REFERENCES "Listing"("Listing ID")
);

CREATE TABLE "Bank Transfer Details" (
  "Details ID" serial,
  "Host ID" int NOT NULL UNIQUE,
  "Billing Country" varchar(50) NOT NULL,
  "Account Holder Name" varchar(100) NOT NULL,
  "Street" varchar(70) NOT NULL,
  "City" varchar(50) NOT NULL,
  "Zip Code" varchar(20) NOT NULL,
  "Currency" char(3) NOT NULL,
  "Bank Name" varchar(100) NOT NULL,
  "Account Number" char(12) NOT NULL UNIQUE,
  "Account Type" varchar(10) NOT NULL,
  PRIMARY KEY ("Details ID"),
  CONSTRAINT fk_hostID
     FOREIGN KEY("Host ID") 
       REFERENCES "Host"("Host ID")
       ON DELETE CASCADE
);

CREATE TABLE "Guest" (
  "Guest ID" serial,
  "User ID" int NOT NULL UNIQUE,
  "Photo Url" varchar(50) NOT NULL,
  "Phone Number" varchar(30) NOT NULL UNIQUE,
  "About Description" text,
  "City" varchar(30) NOT NULL,
  "Country" varchar(30) NOT NULL,
  PRIMARY KEY ("Guest ID"),
  CONSTRAINT fk_user 
   FOREIGN KEY("User ID") 
   REFERENCES "User"("User ID")
   ON DELETE CASCADE
);

CREATE TABLE "Credit Card" (
  "Card ID" serial,
  "Guest ID" int NOT NULL UNIQUE,
  "First Name" varchar(50) NOT NULL,
  "Last Name" varchar(50) NOT NULL,
  "Card Number" char(12) NOT NULL,
  "Expiry Date" date NOT NULL,
  "CVV" varchar(4) NOT NULL,
  "Zip Code" varchar(20) NOT NULL,
  "Country/Region" varchar(50) NOT NULL,
  PRIMARY KEY ("Card ID"),
  CONSTRAINT fk_guestID
     FOREIGN KEY("Guest ID") 
       REFERENCES "Guest"("Guest ID")
       ON DELETE CASCADE
);


CREATE TABLE "Transaction History" (
  "Transaction ID" serial,
  "User ID" int NOT NULL,
  "Transaction Type" char(7) NOT NULL,
  "Amount" decimal(7,2) NOT NULL,
  "Transaction Date" date NOT NULL,
  "Description" varchar(100) NOT NULL,
  PRIMARY KEY ("Transaction ID"),
  CONSTRAINT fk_user
     FOREIGN KEY("User ID") 
       REFERENCES "User"("User ID")
       ON DELETE CASCADE
);

CREATE TABLE "Listing Amenities" (
  "Amenity ID" serial,
  "Wifi" bool NOT NULL,
  "TV" bool NOT NULL,
  "Washer" bool NOT NULL,
  "AC" bool NOT NULL,
  PRIMARY KEY ("Amenity ID")
);

CREATE TABLE "Amenity Composite" (
  "Listing ID" int NOT NULL UNIQUE,
  "Amenity ID" int NOT NULL,
  PRIMARY KEY ("Listing ID", "Amenity ID"),
  CONSTRAINT FK_AmenityID
    FOREIGN KEY ("Amenity ID")
      REFERENCES "Listing Amenities"("Amenity ID")
      ON DELETE CASCADE,
  CONSTRAINT FK_ListingID
     FOREIGN KEY("Listing ID") 
       REFERENCES "Listing"("Listing ID")
       ON DELETE CASCADE
);


CREATE TABLE "Paypal Details" (
  "Paypal ID" serial,
  "Host ID" int NOT NULL UNIQUE,
  "Billing Country" varchar(50) NOT NULL,
  "Account Holder Name" varchar(100) NOT NULL,
  "Account Type" varchar(10) NOT NULL,
  PRIMARY KEY ("Paypal ID"),
  CONSTRAINT fk_hostID
    FOREIGN KEY ("Host ID")
      REFERENCES "Host"("Host ID")
      ON DELETE CASCADE
);

CREATE TABLE "Social Accounts" (
  "Socials ID" serial,
  "User ID" int NOT NULL UNIQUE,
  "Facebook" bool NOT NULL,
  "Google" bool NOT NULL,
  PRIMARY KEY ("Socials ID"),
  CONSTRAINT fk_user
     FOREIGN KEY("User ID") 
       REFERENCES "User"("User ID")
       ON DELETE CASCADE
);

CREATE TABLE "Listing Reviews" (
  "Review ID" serial,
  "Listing ID" int NOT NULL,
  "Guest Name" varchar(50) NOT NULL,
  "Rating" int NOT NULL,
  "Review" text NOT NULL,
  PRIMARY KEY ("Review ID"),
  CONSTRAINT listingid_fk
    FOREIGN KEY ("Listing ID")
      REFERENCES "Listing"("Listing ID")
      ON DELETE CASCADE
);

CREATE TABLE "Reservations" (
  "Reservation ID" serial,
  "Listing ID" int NOT NULL,
  "First Name" varchar(50) NOT NULL,
  "Start Date" date NOT NULL,
  "End Date" date NOT NULL,
  "Nights" int NOT NULL,
  "Guests" int NOT NULL,
  PRIMARY KEY ("Reservation ID"),
  CONSTRAINT FK_ListingID
    FOREIGN KEY ("Listing ID")
      REFERENCES "Listing"("Listing ID")
      ON DELETE CASCADE
);

CREATE TABLE "Coupon Codes" (
  "Coupon ID" serial,
  "Codes" char(8) NOT NULL UNIQUE,
  "User ID" int,
  PRIMARY KEY ("Coupon ID"),
  CONSTRAINT fk_user 
   FOREIGN KEY("User ID") 
   REFERENCES "User"("User ID")
   ON DELETE CASCADE
);

CREATE TABLE "Guest Reviews" (
  "Review ID" serial,
  "Guest ID" int NOT NULL,
  "Host Name" varchar(50) NOT NULL,
  "Review" text NOT NULL,
  PRIMARY KEY ("Review ID"),
  CONSTRAINT fk_guest 
   FOREIGN KEY("Guest ID") 
   REFERENCES "Guest"("Guest ID")
   ON DELETE CASCADE
);

CREATE TABLE "Gift Card Pins" (
  "Pin ID" serial,
  "Pins" char(8) NOT NULL UNIQUE,
  "User ID" int,
  PRIMARY KEY ("Pin ID"),
  CONSTRAINT fk_user 
   FOREIGN KEY("User ID") 
   REFERENCES "User"("User ID")
   ON DELETE CASCADE
);

CREATE TABLE "Phone Numbers" (
  "Number ID" serial,
  "User ID" int NOT NULL,
  "Country Code" varchar(6) NOT NULL,
  "Number" varchar(20) NOT NULL,
  PRIMARY KEY ("Number ID"),
  CONSTRAINT fk_user
     FOREIGN KEY("User ID") 
       REFERENCES "User"("User ID")
       ON DELETE CASCADE
);

/* Insert data into tables */
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (1, 'South Africa', '13 Boston St', NULL, 'Cape Town', NULL, '7441');
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (2, 'Germany', '1 Deutsch St', NULL, 'Stuttgart', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (3, 'China', 'Wujian Street', '2A', 'Shanghai', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (4, 'France', '44 Cliqueot Rd', NULL, 'Nice', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (5, 'Norway', '3 Fytte Rd', NULL, 'Trømso', 'Nord-Norge', NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (6, 'Hong Kong', '6 Tong St', '4F', 'Hong Kong', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (7, 'Spain', 'Madrelina St', NULL, 'Madrid', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (8, 'Argentina', 'San Juan Ave', NULL, 'Buenos Aires', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (9, 'Japan', '22 Watara St', '45A', 'Tokyo', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (10, 'Australia', '7 Wollongong Rd', NULL, 'Sydney', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (11, 'Canada ', '12 Maple Ave', NULL, 'Toronto', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (12, 'Mexico', '9 Chinchon Rd', NULL, 'Guadalajara', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (13, 'Ukraine', '1 Vitavia St', '12C', 'Kyiv', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (14, 'Indonesia', '33 Seaview Dr', NULL, 'Bali', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (15, 'Singapore', '444 Millionaire Rd', '3G', 'Singapore', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (16, 'USA', '4th Ave', '5B', 'New York', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (17, 'USA', 'Freedom Dr', NULL, 'Washington DC', NULL, NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (18, 'South Africa', '6 Main Rd', NULL, 'Cape Town', 'Western Cape', NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (19, 'South Africa', '13 Strelitzia St', NULL, 'Parklands', 'Western Cape', NULL);
INSERT INTO public."Address" ("Address ID", "Country", "Street", "Apt/Suite", "City", "Province", "Zip Code") VALUES (20, 'Namibia', '12 Army Rd', NULL, 'Windhoek', NULL, NULL);

INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (1, false, false, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (2, false, true, false);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (3, false, false, false);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (4, true, true, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (5, false, false, false);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (6, true, false, false);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (7, true, true, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (8, false, true, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (9, false, true, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (10, false, true, false);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (11, true, true, false);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (12, false, true, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (13, false, false, false);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (14, true, true, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (15, false, true, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (16, true, true, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (17, false, false, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (18, false, true, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (19, false, true, true);
INSERT INTO public."Information" ("Info ID", "SMS", "Email", "Marketing Emails") VALUES (20, true, true, false);

INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (1, 1, 1, 'Steven', 'Ing', 'sting93_sa@hotmail.com', 'Sxing', '24/10/1993', 'English', 'M', '1024935090');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (2, 2, 2, 'Daniela', 'Ing', 'dving@gmail.com', 'Dving1', '23/03/1995', 'English', 'F', '10234567');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (3, 1, 3, 'Adriana', 'Ing', 'adriana@yahoo.com', 'ming2', '02/28/1969', 'English', 'F', '234568778');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (4, 3, 4, 'John', 'Wu', 'jwu@gmail.com', 'WuDog', '08/07/1994', 'English', 'M', '6757575757');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (5, 4, 5, 'Oyvind', 'Saebo', 'saebo@hotmail.com', 'vindS!', '04/04/2023', 'Norwegian', 'M', '87654321');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (6, 6, 6, 'Margarita', 'Chavez', 'm.chavez@gmail.com', 'GumJo34', '06/08/1989', 'Spanish', 'F', '4567098721');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (7, 7, 2, 'Trent', 'Hodgeson', 't.hodgeson@aol.com', 'theHodge', '20/02/1975', 'English', 'M', '754587657');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (8, 7, 9, 'Trentina', 'Hodgeson', 'trentina@hotmail.com', 'TinaT3', '05/05/2001', 'English', 'F', '34222456');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (9, 8, 9, 'Tiril', 'Holmquist', 'holmquist@gmail.com', 'Hquist!', '07/10/1990', 'Swedish', 'F', '7776665432');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (10, 9, 10, 'Mila', 'Tucci', 'mtucci@gmail.com', 'Tucci123', '06/25/1989', 'Italian', 'F', '2345768988');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (11, 10, 11, 'Zwiswa', 'Nphambe', 'zwisa@yahoo.com', 'npambeZ', '08/23/1995', 'English', 'F', '657483927');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (12, 11, 12, 'Yelin', 'Wong', 'ywong@hotmail.com', 'yeLwong!', '02/03/2002', 'Chinese', 'F', '897547389');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (13, 12, 13, 'Craig', 'Roberts', 'c.roberts@gmail.com', 'CrobertZ', '11/11/1987', 'English', 'M', '9754765267');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (14, 13, 14, 'Santiago', 'Fuentes', 'sfuentes@gmail.com', 'FuerteFuentes', '01/01/1992', 'Spanish', 'M', '1238743863');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (15, 14, 15, 'Joscka', 'Opitz', 'opitz@aol.com', 'Opel43%', '12/08/1994', 'German', 'M', '1234758456');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (16, 14, 15, 'Nadia', 'Opitz', 'nopitz@gmail.com', 'NadiaFrei', '07/06/1997', 'German', 'F', '6578969693');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (17, 13, 16, 'Juana', 'Nunez', 'j.nunez@yahoo.com', 'LaNuna76', '03/02/1986', 'Spanish', 'F', '765967394973');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (18, 15, 17, 'Veronica', 'Toussant', 'vtouss@hotmail.com', 'ToussQQQ', '12/25/1996', 'French', 'F', '6548438338');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (19, 16, 18, 'Leopoldo', 'Versace', 'leopoldo@hello.com', 'LeoTheLion', '01/04/2001', 'Italian', 'M', '7548959345');
INSERT INTO public."User" ("User ID", "Address ID", "Info ID", "First Name", "Last Name", "Email", "Password", "Birthday", "Language", "Gender", "Gov ID") VALUES (20, 17, 3, 'Hitomi', 'Takashi', 'h.takashi@gmail.com', 'Hitmoi58', '11/13/1990', 'Japanese', 'F', '128657438756');

INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (1, 2, 'Windows', '10', 'Chrome', 'San Diego', 'California', '2023-11-02');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (2, 2, 'Windows', '10', 'Chrome', 'San Diego', 'California', '2023-11-02');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (3, 2, 'Windows', '10', 'Firefox', 'Toronto', 'Ontario', '2023-09-02');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (4, 2, 'Windows', '10', 'Firefox', 'Toronto', 'Ontario', '2023-08-02');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (5, 2, 'Windows', '10', 'Chrome', 'San Diego', 'California', '2023-01-22');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (6, 3, 'MacOS', 'High Sierra', 'Safari', 'Hong Kong', 'Hong Kong', '2023-01-23');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (7, 3, 'MacOS', 'High Sierra', 'Safari', 'Hong Kong', 'Hong Kong', '2023-02-02');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (8, 3, 'MacOS', 'High Sierra', 'Chrome', 'Singapore', 'Singapore', '2023-02-03');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (9, 3, 'MacOS', 'High Sierra', 'Safari', 'Hong Kong', 'Hong Kong', '2023-02-02');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (10, 3, 'MacOS', 'High Sierra', 'Safari', 'Hong Kong', 'Hong Kong', '2023-02-11');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (11, 4, 'Linux', '20.2', 'Firefox', 'Paris', 'Ile-De-France', '2023-01-23');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (12, 4, 'Linux', '20.2', 'Firefox', 'Paris', 'Ile-De-France', '2023-01-23');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (13, 4, 'Linux', '20.2', 'Firefox', 'Paris', 'Ile-De-France', '2023-01-25');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (14, 4, 'Linux', '20.2', 'Firefox', 'Johannesburg', 'Gauteng', '2023-01-27');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (15, 4, 'Linux', '20.2', 'Firefox', 'Johannesburg', 'Gauteng', '2023-01-24');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (16, 5, 'Windows', '10', 'Chrome', 'Cape Town', 'Western Cape', '2023-02-04');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (17, 5, 'Windows', '10', 'Chrome', 'Cape Town', 'Western Cape', '2023-02-05');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (18, 5, 'Windows', '10', 'Chrome', 'Cape Town', 'Western Cape', '2023-02-07');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (19, 5, 'Windows', '10', 'Chrome', 'Durban', 'Kwazulu Natal', '2023-02-08');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (20, 5, 'Windows', '10', 'Chrome', 'Durban', 'Kwazulu Natal', '2023-02-08');
INSERT INTO public."Session History" ("Session ID", "User ID", "OS", "Version", "Web Browser", "City", "Province", "Date") VALUES (21, 5, 'Windows', '10', 'Chrome', 'Durban', 'Kwazulu Natal', '2023-02-09');

INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (1, 1, 20.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (2, 2, 50.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (3, 3, 0.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (4, 4, 0.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (5, 5, 0.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (6, 6, 0.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (7, 7, 75.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (8, 8, 100.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (10, 9, 0.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (11, 10, 12.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (12, 11, 0.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (13, 12, 100.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (14, 13, 150.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (15, 14, 0.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (16, 15, 200.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (17, 16, 0.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (18, 17, 0.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (19, 18, 50.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (20, 19, 0.00);
INSERT INTO public."Credit Balance" ("Balance ID", "User ID", "Balance") VALUES (22, 20, 0.00);

INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (1, 'Southern Europe', 1, 'Modern flat in heart of Rome');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (2, 'Southern Europe', NULL, NULL);
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (3, 'Norway', 2, 'Cottage by the fjord');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (4, 'Cape Town', 3, 'Camps Bay mansion with a sea view');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (5, 'South Africa', 4, 'Cottage by Kruger National Park');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (6, 'Argentina', 5, 'Chique house by the Mendozan wine farms');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (7, 'Argentina', NULL, NULL);
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (8, 'Dream Stays', 6, 'Luxury apartment in Venice');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (9, 'Dream Stays', NULL, NULL);
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (10, 'Romantic Getaways', 7, 'Apartment by the Eiffel Tower');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (11, 'Big Cities', 8, 'Manhattan apartment with Central Park views');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (12, 'Tropical Holiday', 9, 'Affordable villa in Bali');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (13, 'Adventure Holiday', NULL, NULL);
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (14, 'Adventure Holiday', 10, 'Flat close to the Boston Marathon startline');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (15, 'Staycation', 11, 'Villa in Montagu');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (16, 'Staycation', 12, 'Sea view house in Yzerfontein');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (17, 'Holiday List', 13, 'Lodge in the Kenyan bush');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (18, 'Cultural Holiday', 14, 'Quaint Flat in Jerusalem');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (19, 'Art Holiday', 15, 'Apartment by the Louvre');
INSERT INTO public."Wishlists" ("Wishlist ID", "Wishlist Name", "Listing ID", "Listing Name") VALUES (20, 'Holiday', NULL, NULL);

INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (1, 1);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (2, 2);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (3, 3);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (4, 4);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (5, 5);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (6, 6);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (7, 7);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (8, 8);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (9, 9);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (10, 10);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (11, 11);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (12, 12);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (13, 13);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (14, 14);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (15, 15);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (16, 16);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (17, 17);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (18, 18);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (19, 19);
INSERT INTO public."Wishlist Composite" ("User ID", "Wishlist ID") VALUES (20, 20);

INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (1, 2, 'Steven', 'Hi Paul. I''m coming to New York for a business trip and will be staying at your place.');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (2, 3, 'Paul', 'Hi Steven. Thanks for choosing to stay at my place!');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (3, 2, 'Steven', 'Will you be there for the check-in?');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (4, 3, 'Paul', 'No. The door opens with a code. The code is 6753');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (5, 2, 'Steven', 'Perfect. Looking forward to the stay');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (6, 3, 'Paul', 'Feel free to message me if you have any questions.');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (7, 2, 'Steven', 'Will do. Do you have a whatsapp number? I''d prefer to communicate that way.');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (8, 2, 'Paul', 'My whatsapp number is +278912345');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (9, 4, 'Emily', 'Hi Miranda. I am doing a Euro trip and will be staying in Paris for 4 days.');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (10, 5, 'Miranda', 'Hi Emily. That is great. I can give you some advice on places to see.');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (11, 4, 'Emily', 'I''d greatly appreciate that. What is the check-in procedure?');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (12, 5, 'Miranda', 'Checkin is at 1pm. I''ll be waiting to give you the keys.');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (13, 4, 'Emily', 'Okay. My flight arrives at 8am. Is there a place where I can store my luggage before check-in.?');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (14, 5, 'Miranda', 'All the train stations have storage area for luggage.');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (15, 4, 'Emily', 'Thank you for the information,');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (16, 6, 'John', 'Hi Juan. I''m coming to Puerto Rico for a honeymoon. You place seems like the perfect choice!');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (17, 7, 'Juan', 'Hi John. Thank you for choosing to stay at the villa. Let me know if there''s anything you need assistance with.');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (18, 6, 'John', 'Actually, there is. What suggestions do you have for a romanctic dinner?');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (19, 7, 'Juan', 'Try El Chivo. ');
INSERT INTO public."Messages" ("Message ID", "User ID", "First Name", "Message") VALUES (20, 6, 'John', 'Thanks. And is there a pharmacy close by? I''m going to need a lot of condoms!');

INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (1, 1, 'https://airbnb-photos.s3.amazonaws.com/host_2.jpg', '083457874', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (2, 2, 'https://airbnb-photos.s3.amazonaws.com/host_3.jpg', '0710227628', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (3, 3, 'https://airbnb-photos.s3.amazonaws.com/host_4.jpg', '0730227628', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (4, 4, 'https://airbnb-photos.s3.amazonaws.com/host_5.jpg', '0983747564', 'Bank Transfer');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (5, 5, 'https://airbnb-photos.s3.amazonaws.com/host_1.jpg', '0783453663', 'Bank Transfer');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (6, 6, 'https://airbnb-photos.s3.amazonaws.com/host_6.jpg', '0710227629', 'Bank Transfer');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (7, 7, 'https://airbnb-photos.s3.amazonaws.com/host_7.jpg', '072345678', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (8, 8, 'https://airbnb-photos.s3.amazonaws.com/host_8.jpg', '063456786', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (9, 9, 'https://airbnb-photos.s3.amazonaws.com/host_9.jpg', '0632676849', 'Bank Transfer');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (10, 10, 'https://airbnb-photos.s3.amazonaws.com/host_10.jpg', '0632478438', 'Bank Transfer');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (11, 11, 'https://airbnb-photos.s3.amazonaws.com/host_11.jpg', '0710235478', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (12, 12, 'https://airbnb-photos.s3.amazonaws.com/host_12.jpg', '123465787', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (13, 13, 'https://airbnb-photos.s3.amazonaws.com/host_13.jpg', '334457933', 'Bank Transfer');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (14, 14, 'https://airbnb-photos.s3.amazonaws.com/host_14.jpg', '0837548484', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (15, 15, 'https://airbnb-photos.s3.amazonaws.com/host_15.jpg', '0923574483', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (16, 16, 'https://airbnb-photos.s3.amazonaws.com/host_16.jpg', '082475848', 'Bank Transfer');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (17, 17, 'https://airbnb-photos.s3.amazonaws.com/host_17.jpg', '0710345784', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (18, 18, 'https://airbnb-photos.s3.amazonaws.com/host_18.jpg', '765858449', 'Paypal');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (19, 19, 'https://airbnb-photos.s3.amazonaws.com/host_20.jpg', '0943475754', 'Bank Transfer');
INSERT INTO public."Host" ("Host ID", "User ID", "Photo Url", "Phone Number", "Payout Method") VALUES (20, 20, 'https://airbnb-photos.s3.amazonaws.com/host_21.jpg', '4357478333', 'Paypal');

INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (1, 1, 1, 'Lovely flat in Cape Town centre', 4.3, 17, 'Cape Town', 'Steven', '4', '2', '2', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (2, 2, 5, 'Lovely flat in Palermo', 4.5, 23, 'Italy', 'Lucia', '2', '1', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (3, 3, 6, 'Lovely flat in Venice', 4.5, 23, 'Venice', 'Luca', '2', '1', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. 
		Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (4, 4, 7, 'Lovely house in Paris', 4.8, 31, 'Paris', 'Veronica', '4', '2', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'House', 'No refund 48 hours before booking', 'No smoking');
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (5, 5, 8, 'Lovely cottage in Dublin', 4.1, 5, 'Dublin', 'Tom', '1', '1', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Cottage', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (6, 6, 9, 'Lovely flat in New York', 4.6, 13, 'New York', 'David', '2', '1', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', 'No refund 24 hours before stay', 'No smoking');
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (7, 7, 10, 'Lovely house in San Diego', 4.6, 3, 'San Diego', 'Patty', '4', '2', '2', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'House', NULL, 'No smoking. No parties');
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (8, 8, 11, 'Beach paradise in Newport Beach', 4.9, 45, 'Newport Beach', 'Graham', '6', '3', '3', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'House', 'No refund 48 hours before stay', NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (9, 9, 12, 'Luxury apartment in Oslo', 4.8, 22, 'Oslo', 'Fredrik', '2', '1', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (10, 10, 13, 'Luxury flat in London', 4.8, 7, 'London', 'Richard', '2', '1', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (11, 11, 14, 'Luxury apartment in Hong Kong', 4.7, 42, 'Hong Kong', 'Zero', '4', '2', '2', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', NULL, 'No smoking or parties');
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (12, 14, 15, 'House in English countryside', 4.5, 12, 'Surrey', 'Gregory', '4', '2', '2', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'House', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (13, 15, 16, 'Flat in Sydney Centre', 4.7, 5, 'Sydney', 'Zendaya', '2', '1', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', 'No refund 24 hours before stay', NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (14, 16, 17, 'House in Bondi', 4.6, 9, 'Sydney', 'Paul', '6', '3', '2', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'House', NULL, 'No parties');
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (15, 17, 18, 'Traditional Norwegian House by Fjord', 4.7, 21, 'Bergen', 'Vilde', '4', '2', '2', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'House', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (16, 18, 19, 'Apartment in Shinjuku', 4.8, 43, 'Tokyo', 'Haruka', '2', '1', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', 'No refund 48 hours before stay', NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (17, 19, 20, 'Apartment in Dubai', 4.3, 3, 'Dubai', 'Mohammed', '4', '2', '2', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (18, 20, 21, 'Scottish countryside cottage', 4.3, 11, 'Glasgow', 'Timothy', '2', '1', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Cottage', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (19, 20, 22, 'House in Chamonix', 4.5, 6, 'Chamonix', 'Serge', '2', '1', '1', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'House', NULL, NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (20, 19, 23, 'Luxury House in Bali', 4.9, 23, 'Bali', 'Dita', '6', '3', '2', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'House', 'No refund before 48 hours of stay', NULL);
INSERT INTO public."Listing" ("Listing ID", "Host ID", "Availability ID", "Title", "Average Rating", "Number of Reviews", "Location", "Host Name", "Max Guests", "Bedrooms", "Bathrooms", "Description", "Place Type", "Cancellation Policy", "House Rules") VALUES (21, 18, 24, 'Luxury apartment in Bali', 4.9, 12, 'Bali', 'Dita', '4', '2', '2', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book', 'Apartment', NULL, NULL);

INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (1, 1, '2023-02-03', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (2, 1, '2023-03-02', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (3, 1, '2023-03-03', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (4, 1, '2023-04-03', false);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (5, 2, '2023-03-02', false);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (6, 3, '2023-03-03', false);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (7, 4, '2023-04-03', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (8, 5, '2023-03-02', false);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (9, 6, '2023-03-02', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (10, 7, '2023-03-02', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (11, 8, '2023-03-02', false);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (12, 9, '2023-03-02', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (13, 10, '2023-03-02', false);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (14, 11, '2023-03-02', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (15, 12, '2023-03-02', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (16, 13, '2023-03-02', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (17, 14, '2023-03-02', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (18, 15, '2023-03-02', false);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (19, 16, '2023-03-02', false);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (20, 17, '2023-03-02', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (21, 18, '2023-03-02', false);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (22, 19, '2023-03-02', true);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (23, 20, '2023-03-02', false);
INSERT INTO public."Listing Availability" ("Availability ID", "Listing ID", "Date", "Available") VALUES (24, 21, '2023-03-02', true);

ALTER TABLE "Listing"
ADD CONSTRAINT availabilityid_fk
FOREIGN KEY ("Availability ID")
REFERENCES "Listing Availability"("Availability ID")
ON DELETE CASCADE;

INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (1, 1, 'https://airbnb-photos.s3.amazonaws.com/photo1.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (2, 1, 'https://airbnb-photos.s3.amazonaws.com/photo2.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (3, 1, 'https://airbnb-photos.s3.amazonaws.com/photo3.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (4, 1, 'https://airbnb-photos.s3.amazonaws.com/photo4.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (5, 2, 'https://airbnb-photos.s3.amazonaws.com/photo5.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (6, 2, 'https://airbnb-photos.s3.amazonaws.com/photo6.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (7, 2, 'https://airbnb-photos.s3.amazonaws.com/photo7.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (8, 2, 'https://airbnb-photos.s3.amazonaws.com/photo8.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (9, 2, 'https://airbnb-photos.s3.amazonaws.com/photo9.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (10, 3, 'https://airbnb-photos.s3.amazonaws.com/photo10.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (11, 3, 'https://airbnb-photos.s3.amazonaws.com/photo11.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (12, 3, 'https://airbnb-photos.s3.amazonaws.com/photo12.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (13, 4, 'https://airbnb-photos.s3.amazonaws.com/photo13.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (14, 4, 'https://airbnb-photos.s3.amazonaws.com/photo14.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (15, 4, 'https://airbnb-photos.s3.amazonaws.com/photo15.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (16, 4, 'https://airbnb-photos.s3.amazonaws.com/photo16.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (17, 5, 'https://airbnb-photos.s3.amazonaws.com/photo17.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (18, 5, 'https://airbnb-photos.s3.amazonaws.com/photo18.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (19, 5, 'https://airbnb-photos.s3.amazonaws.com/photo19.jpg');
INSERT INTO public."Listing Photos" ("Photo ID", "Listing ID", "Photo Url") VALUES (20, 6, 'https://airbnb-photos.s3.amazonaws.com/photo20.jpg');

INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (1, 1, 'South Africa', 'Mr S A Ing', '15 Trelitzia St.', 'Cape Town', '8001', 'ZAR', 'FNB', '54373547939 ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (2, 2, 'South Africa', 'Mrs A I Ing', '30 Juniper St.', 'Cape Town', '8001', 'ZAR', 'Absa', '54373547659 ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (3, 3, 'Hong Kong', 'Mr John Wu', '2A Gambler Rd.', 'Hong Kong', '00000', 'HKD', 'HSBC', '6578494938  ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (4, 4, 'Hong Kong', 'Li Ching Wong', '3B Queen St.', 'Hong Kong', '00000', 'HKD', 'City Bank', '67589499484 ', 'Savings');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (5, 5, 'Germany', 'Bern Hertz', '6 Dasburger Rd.', 'Berlin', '6544', 'EUR', 'Deutcshe Bank', '5437337484  ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (6, 6, 'France', 'Francois Coutoise', '6 Veronique Rd.', 'Nice', '7655', 'EUR', 'BNP Paribas', '7656456456  ', 'Savings');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (7, 7, 'United States', 'Charles Sampson', '4 Hacienda St.', 'San Diego', '70028', 'USD', 'Chase', '54378479537 ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (8, 8, 'United States', 'Jamie-Lee Sexton', '34 Jamestown Dr.', 'Boston', '70134', 'USD', 'Chase', '54636444678 ', 'Savings');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (9, 9, 'Australia', 'Pierce Holton', '3 Grahams Rd.', 'Sydney', '4433', 'AUD', 'ANZ', '76549875644 ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (10, 10, 'Australia', 'Ken Dong', '1 Newmans Ave.', 'Melbourne', '4344', 'AUD', 'ANZ', '75483939843 ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (11, 11, 'South Africa', 'Derek Mazaham', '2 Blackpool Rd.', 'Johannesburg', '0001', 'ZAR', 'Standard Bank', '48503853453 ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (12, 12, 'Namibia', 'Joschka Opitz', '12 Beluga Dr.', 'Windhoek', '5656', 'NAD', 'Absa', '54363366465 ', 'Savings');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (13, 13, 'Argentina', 'Karina Bosco', '33 Cordobez St.', 'Cordoba', '4555', 'ARS', 'Banco Credicoop', '87668686567 ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (14, 14, 'China', 'Dong Huan Wu', '1 1st Street', 'Shanghai', '8888', 'CNY', 'HSBC', '65784949845 ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (15, 15, 'China', 'Xi Ling Ling', '3a 44th Street', 'Beijing', '8881', 'CNY', 'Construction Bank', '65478484943 ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (16, 16, 'Mexico', 'Juan Pepito', '4 Grancho Dr.', 'Mexico City', '99948', 'MXN', 'Banco Nacional', '5436676757  ', 'Savings');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (17, 17, 'Bahamas', 'Dymond Smith', '77 Heaven Dr.', 'Nassau', '67676', 'BSD', 'Fidelity Bank', '4444577575  ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (18, 18, 'Puerto Rico', 'Fernanda Chula', '9 Helena Rd.', 'San Juan', '33311', 'USD', 'City Bank', '5646456574  ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (19, 19, 'Spain', 'Itziar Bruja', '11 Minota St.', 'Madrid', '22222', 'EUR', 'Santander', '6548479454  ', 'Checking');
INSERT INTO public."Bank Transfer Details" ("Details ID", "Host ID", "Billing Country", "Account Holder Name", "Street", "City", "Zip Code", "Currency", "Bank Name", "Account Number", "Account Type") VALUES (20, 20, 'Japan', 'Daito Kawuchi', '66 Hiroshi St.', 'Tokyo', '12345', 'JPY', 'Mizuho', '51234535529 ', 'Savings');

INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (1, 2, 'payment', 2550.00, '2023-01-15', 'Comfortable flat in Sicily');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (2, 2, 'payment', 1500.00, '2023-02-03', 'Upmarket apartment in Paris');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (3, 2, 'payment', 2100.00, '2022-12-23', 'German cottage in Black Forest');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (4, 2, 'refund ', 3400.00, '2022-11-02', '4 nights at Seaside apartment in Oslo');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (5, 3, 'payment', 1530.00, '2022-11-02', '2 nights at Authentic Irish Villa');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (6, 3, 'refund ', -1300.00, '2023-01-07', '1 night at Central Apartment in Amsterdam');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (7, 4, 'payment', 2000.00, '2023-02-02', '2 nights at Seapoint Apartment with Sea View');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (8, 8, 'payment', 2000.00, '2023-02-02', '2 nights at Seapoint Apartment with Sea View');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (9, 5, 'payment', 1050.00, '2023-02-02', '1 night at Central Park apartment');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (10, 5, 'payment', 1050.00, '2023-02-09', '1 night at Central Park apartment');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (11, 5, 'payment', 1050.00, '2023-01-31', '1 night at Central Park apartment');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (12, 5, 'payment', 1050.00, '2023-01-22', '1 night at Central Park apartment');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (13, 6, 'refund ', -2500.00, '2023-01-03', '2 nights at Luxury Suite in Nice');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (14, 7, 'payment', 1200.00, '2023-01-25', '1 night in CBD Apartment');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (15, 7, 'payment', 1200.00, '2023-02-07', '1 night at Century City Apartment');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (16, 7, 'payment', 3000.00, '2022-12-15', '2 nights in Albertan Luxury Villa');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (17, 9, 'payment', 4000.00, '2022-12-01', '1 night at Apartment in the heart of Paris');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (18, 11, 'payment', 8000.00, '2022-12-05', '2 nights at Apartment in the heart of Paris');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (19, 12, 'payment', 8000.00, '2022-12-07', '2 nights at Apartment in the heart of Paris');
INSERT INTO public."Transaction History" ("Transaction ID", "User ID", "Transaction Type", "Amount", "Transaction Date", "Description") VALUES (20, 13, 'payment', 2100.00, '2023-02-03', 'German cottage in Black Forest');

INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (1, true, true, true, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (2, true, true, true, false);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (3, true, false, false, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (4, true, false, false, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (5, true, true, true, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (6, true, true, true, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (7, false, false, false, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (8, true, true, true, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (9, false, true, false, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (10, true, false, false, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (11, true, true, true, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (12, true, false, false, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (13, true, true, true, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (14, true, false, false, false);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (15, false, false, false, false);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (16, true, true, true, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (17, true, true, true, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (18, true, true, false, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (19, true, true, true, true);
INSERT INTO public."Listing Amenities" ("Amenity ID", "Wifi", "TV", "Washer", "AC") VALUES (20, true, true, false, true);


INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (1, 1);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (2, 2);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (3, 3);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (4, 4);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (5, 5);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (6, 6);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (7, 7);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (8, 8);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (9, 9);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (10, 10);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (11, 11);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (12, 12);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (13, 13);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (14, 14);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (15, 15);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (16, 16);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (17, 17);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (18, 18);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (19, 19);
INSERT INTO public."Amenity Composite" ("Listing ID", "Amenity ID") VALUES (20, 20);


INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (1, 1, 'South Africa', 'Steven Ing', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (2, 2, 'Norway', 'Oyvind Sandbakk', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (3, 3, 'Germany', 'Fritz Neier', 'Savings');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (4, 4, 'Germany', 'Lidia Hamburg', 'Savings');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (5, 5, 'France', 'Martina Francois', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (6, 6, 'South Africa', 'Daniela Ing', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (7, 7, 'United States', 'Tom Krazinski', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (8, 8, 'Peru', 'Santiago Compostela', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (9, 9, 'Argentina', 'Marizia Centinelli', 'Savings');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (10, 10, 'Mexico', 'Juan Martinez', 'Savings');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (11, 11, 'Hong Kong', 'Ying Ling Wong', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (12, 12, 'Australia', 'Hamish Thornton', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (13, 13, 'Japan', 'Yuki Kawasaki', 'Savings');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (14, 14, 'Sweden', 'Turid Svartstad', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (15, 15, 'Switzerland', 'Peter Horsten', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (16, 16, 'China', 'Xi Ping Wu', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (17, 17, 'Kenya', 'Mukami Njeru', '
Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (18, 18, 'Singapore', 'James Wu', 'Savings');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (19, 19, 'United Arab Emirates', 'Mohammed Abdullah', 'Checking');
INSERT INTO public."Paypal Details" ("Paypal ID", "Host ID", "Billing Country", "Account Holder Name", "Account Type") VALUES (20, 20, 'United Arab Emirates', 'Mohammed Abdul', 'Savings');


INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (1, 1, true, true);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (2, 2, true, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (3, 3, false, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (4, 4, false, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (5, 5, true, true);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (6, 6, true, true);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (7, 7, false, true);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (8, 8, false, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (9, 9, false, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (10, 10, true, true);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (11, 11, false, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (12, 12, false, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (13, 13, true, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (14, 14, false, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (15, 15, true, true);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (16, 16, true, true);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (17, 17, false, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (18, 18, true, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (19, 19, false, false);
INSERT INTO public."Social Accounts" ("Socials ID", "User ID", "Facebook", "Google") VALUES (20, 20, true, false);

INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (1, 1, 'Jeff', 5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (2, 1, 'John', 4, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (3, 2, 'Justine', 5, 'Lorem Ipsum is simply 
dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s 
standard dummy text ever since the 1500s, when an unknown printer took a galley of type 
and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (4, 2, 'Lorena', 5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (5, 3, 'Laura', 4, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (6, 3, 'Layne', 4, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (7, 4, 'Greg', 3, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (8, 4, 'Kyle', 4, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (9, 5, 'Tracy', 4, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (10, 5, 'Trent', 5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (11, 6, 'Trudy', 5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (12, 7, 'James', 3, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (13, 7, 'Jaimes', 3, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (14, 8, 'Helena', 5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (15, 8, 'Henry', 5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (16, 8, 'Henrietta', 5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (17, 9, 'Paulo', 4, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (18, 9, 'Paula', 4, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (19, 10, 'Juanita', 5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');
INSERT INTO public."Listing Reviews" ("Review ID", "Listing ID", "Guest Name", "Rating", "Review") VALUES (20, 11, 'Juan', 4, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book');


INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (1, 1, 'Steven', '2023-03-07', '2023-03-09', 2, 1);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (2, 1, 'John', '2023-03-10', '2023-03-13', 3, 2);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (3, 2, 'Danielle', '2023-03-07', '2023-03-09', 2, 1);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (4, 2, 'Michelle', '2023-03-11', '2023-03-18', 7, 2);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (5, 2, 'Quentin', '2023-04-01', '2023-04-05', 4, 2);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (6, 3, 'Zwiswa', '2023-03-08', '2023-03-11', 3, 1);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (7, 3, 'Wendy', '2023-03-11', '2023-03-15', 4, 4);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (8, 4, 'Richard', '2023-03-08', '2023-03-28', 19, 4);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (9, 5, 'Charles', '2023-03-07', '2023-03-15', 7, 2);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (10, 5, 'Harry', '2023-03-15', '2023-03-25', 9, 4);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (11, 6, 'Juniper', '2023-03-07', '2023-04-07', 30, 2);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (12, 7, 'Lydia', '2023-03-07', '2023-03-08', 1, 1);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (13, 7, 'Kevin', '2023-03-09', '2023-03-11', 2, 2);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (14, 7, 'Frank', '2023-03-12', '2023-03-19', 7, 1);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (15, 7, 'Santiago', '2023-03-20', '2023-03-23', 3, 4);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (16, 8, 'Ursula', '2023-03-07', '2023-03-14', 7, 3);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (17, 8, 'Velma', '2023-03-14', '2023-03-17', 3, 2);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (18, 9, 'Monique', '2023-04-02', '2023-04-04', 2, 2);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (19, 10, 'Mattias', '2023-03-15', '2023-03-20', 5, 4);
INSERT INTO public."Reservations" ("Reservation ID", "Listing ID", "First Name", "Start Date", "End Date", "Nights", "Guests") VALUES (20, 11, 'Matilda', '2023-03-07', '2023-03-09', 2, 1);


INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (1, '11111   ', NULL);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (2, '22222   ', 2);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (3, '33333   ', 3);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (4, '44444   ', NULL);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (5, '12345   ', NULL);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (6, '54321   ', NULL);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (7, '12121   ', 4);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (8, '11112   ', 5);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (9, '22221   ', NULL);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (10, '34789   ', NULL);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (11, '43555   ', NULL);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (12, '98734   ', 5);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (13, '23421   ', 6);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (14, '99991   ', NULL);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (15, '19999   ', 7);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (16, '92345   ', NULL);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (17, '62626   ', NULL);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (18, '09890   ', 9);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (19, '67854   ', 9);
INSERT INTO public."Coupon Codes" ("Coupon ID", "Codes", "User ID") VALUES (20, '00008   ', NULL);


INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (1, 1, 'https://airbnb-photos.s3.amazonaws.com/guest1.jpg', '0710227628', NULL, 'Cape Town', 'South Africa');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (2, 2, 'https://airbnb-photos.s3.amazonaws.com/guest2.jpg', '0710227629', NULL, 'Johannesburg', 'South Africa');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (3, 3, 'https://airbnb-photos.s3.amazonaws.com/guest3.jpg', '0723474536', 'I''m epic', 'Durban', 'South Africa');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (4, 4, 'https://airbnb-photos.s3.amazonaws.com/guest4.jpg', '0723476856', 'The best guest', 'Durban', 'South Africa');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (5, 5, 'https://airbnb-photos.s3.amazonaws.com/guest5.jpg', '0710233478', 'Respectful traveler', 'Cape Town', 'South Africa');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (6, 6, 'https://airbnb-photos.s3.amazonaws.com/guest6.jpg', '4357839393', NULL, 'Paris', 'France');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (7, 7, 'https://airbnb-photos.s3.amazonaws.com/guest7.jpg', '4354834593', 'Parisian princess with a heart for travel.', 'Paris', 'France');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (8, 8, 'https://airbnb-photos.s3.amazonaws.com/guest8.jpg', '4954785494', 'World explorer', 'Berlin', 'Germany');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (9, 9, 'https://airbnb-photos.s3.amazonaws.com/guest9.jpg', '4954783993', NULL, 'Hamburg', 'Germany');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (10, 10, 'https://airbnb-photos.s3.amazonaws.com/guest10.jpg', '345783844', 'Lover of travel', 'Oslo', 'Norway');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (11, 11, 'https://airbnb-photos.s3.amazonaws.com/guest11.jpg', '3454896794', 'Fjord and northern lights chaser', 'Bergen ', 'Norway');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (12, 12, 'https://airbnb-photos.s3.amazonaws.com/guest12.jpg', '6548493934', NULL, 'London', 'United Kingdom');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (13, 13, 'https://airbnb-photos.s3.amazonaws.com/guest13.jpg', '6538384728', 'Bringing London spice to the world', 'London', 'United Kingdom');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (14, 14, 'https://airbnb-photos.s3.amazonaws.com/guest14.jpg', '7894845945', 'Avid explorer', 'Los Angeles', 'United States');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (15, 15, 'https://airbnb-photos.s3.amazonaws.com/guest15.jpg', '7843258963', 'Born and bred New Yorker', 'New York', 'United States');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (16, 16, 'https://airbnb-photos.s3.amazonaws.com/guest16.jpg', '0710344854', 'Well-travelled South African', 'Johannesburg', 'South Africa');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (17, 17, 'https://airbnb-photos.s3.amazonaws.com/guest17.jpg', '8520549393', NULL, 'Hong Kong', 'Hong Kong');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (18, 18, 'https://airbnb-photos.s3.amazonaws.com/guest18.jpg', '8523843933', 'Solo adventurer', 'Hong Kong', 'Hong Kong');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (19, 19, 'https://airbnb-photos.s3.amazonaws.com/guest19.jpg', '6554747335', 'Hola. Me llamo Juan', 'Mexico City', 'Mexico');
INSERT INTO public."Guest" ("Guest ID", "User ID", "Photo Url", "Phone Number", "About Description", "City", "Country") VALUES (20, 20, 'https://airbnb-photos.s3.amazonaws.com/guest20.jpg', '8547849933', 'Hosts love me and want to date me.', 'Sydney', 'Australia');

INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (1, 'Steven', 'Ing', '123456789098', '05/11/2023', '234', '7441', 'South Africa');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (2, 'John', 'Wu', '123456956795', '05/13/2023', '123', '0000', 'United States');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (3, 'Jacob', 'Derain', '548935639342', '12/02/2023', '793', '9001', 'Germany');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (4, 'Jacobus', 'Hansberg', '548935639343', '11/23/2023', '098', '8001', 'Austria');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (5, 'Magnus', 'Aagard', '548935639347', '02/02/2024', '322', '1001', 'United States');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (6, 'Milton', 'Mews', '548935639342', '02/11/2024', '599', '45450', 'Norway');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (7, 'Mary', 'Magdaline', '548935639344', '04/20/2024', '909', '10008', 'Japan');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (8, 'Ana', 'Dos Santos', '548935639333', '04/19/2024', '654', '2206', 'China');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (9, 'Daniela', 'Viviana', '548935639356', '06/24/2023', '1235', '2207', 'China');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (10, 'Eva', 'Choo', '548935639387', '06/15/2023', '5387', '9002', 'Germany');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (11, 'Juan ', 'Gutierrez', '548935639340', '07/25/2023', '432', '4001', 'United Kingdom');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (12, 'Jemma', 'Gutierrez', '548935639341', '04/25/2023', '590', '8002', 'Austria');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (13, 'Daisuke', 'Kawasaki', '548935639432', '09/02/2023', '509', '3003', 'Mexico');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (14, 'Lena', 'Heady', '548935639312', '04/24/2025', '1446', '3080', 'Mexico');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (15, 'Agatha', 'Christie', '548935639340', '03/03/2025', '888', '00000', 'Hong Kong');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (16, 'Norah', 'Jones', '548935639398', '02/16/2024', '8888', '97280', 'Argentina');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (17, 'Yuri', 'Borsakov', '54893563932', '08/22/2023', '2323', '97281', 'Argentina');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (18, 'Kevin', 'Hart', '123456789099', '12/25/2023', '111', '91210', 'Brazil');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (19, 'Lara', 'Larsson', '123456789097', '12/12/2024', '001', '6060', 'Bahamas');
INSERT INTO public."Credit Card" ("Guest ID", "First Name", "Last Name", "Card Number", "Expiry Date", "CVV", "Zip Code", "Country/Region") VALUES (20, 'Emma', 'Jones', '123456789088', '02/26/2024', '002', '6088', 'Bahamas');

INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (1, 1, 'Steven', 'Sally was a great guest.');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (2, 2, 'Paul', 'Steven was a great guest.');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (3, 3, 'John', 'Trudy was horrible.');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (4, 3, 'Kevin', 'Trudy was a disaster.');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (5, 3, 'Louis', 'Trudy smoked pot all day.');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (6, 4, 'Louis', 'Magnus was a lovely guest');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (7, 5, 'Harry', 'Harry was a respecful guest');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (8, 5, 'Helena', 'Harry was awesome');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (9, 6, 'Kyle', 'Would host Greta again');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (10, 7, 'Fiona', 'Ximena stole from me.');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (11, 7, 'Diana', 'Ximena stole my cupboard!');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (12, 7, 'Simon', 'Ximena left the bathroom a mess');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (13, 10, 'Theodore', 'Wendy is a shining star');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (14, 10, 'Angela', 'Wendy was a sweetheart');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (15, 10, 'Bob', 'Wendy was a great guest');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (16, 11, 'Theodore', 'Elizabeth was noisy late in the night');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (17, 11, 'Greta', 'Elizabeth was drunk and rambunctuous all the time.');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (18, 12, 'Juan', 'Juan followed all the rules');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (19, 13, 'Daniela', 'Juanita was easy to work with');
INSERT INTO public."Guest Reviews" ("Review ID", "Guest ID", "Host Name", "Review") VALUES (20, 14, 'Jolene', 'My place looked like a bombed exploded in it after Lisa left.');


INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (1, '1234    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (2, '2345    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (3, '5559    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (4, '4343    ', 2);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (5, '9876    ', 3);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (6, '8888    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (7, '0003    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (8, '8954    ', 6);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (9, '8955    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (10, '0909    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (11, '9090    ', 9);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (12, '7771    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (13, '7779    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (14, '7654    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (15, '4666    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (16, '5123    ', 12);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (17, '9123    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (18, '3789    ', 5);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (19, '2933    ', NULL);
INSERT INTO public."Gift Card Pins" ("Pin ID", "Pins", "User ID") VALUES (20, '0863    ', 19);


INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (1, 2, '+27', '710227628');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (2, 2, '+1', '98712126');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (3, 3, '+1', '66690334');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (4, 4, '+852', '90876435');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (5, 5, '+852', '657845793');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (6, 6, '+49', '235463258');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (7, 6, '+1', '564783583');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (8, 7, '+49', '547389333');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (9, 8, '+27', '734675438');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (10, 9, '+47', '574389397');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (11, 11, '+27', '723785495');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (12, 12, '+1', '463764386');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (13, 13, '+1', '56478383');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (14, 14, '+49', '987456733');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (15, 15, '+49', '678549749');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (18, 15, '+27', '98564666');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (19, 16, '+36', '345679359');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (20, 17, '+36', '356897979');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (21, 18, '+36', '386578455');
INSERT INTO public."Phone Numbers" ("Number ID", "User ID", "Country Code", "Number") VALUES (22, 19, '+27', '73668553');











