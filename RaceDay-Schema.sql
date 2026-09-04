-- Create Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'RaceDayDB')
BEGIN
    CREATE DATABASE RaceDayDB;
END
GO

USE RaceDayDB;
GO

-- 1. Create Tables
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    PhoneNumber VARCHAR(20) NULL
);

CREATE TABLE EventTypes (
    EventTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(500) NULL,
    EventDate DATETIME NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Distance DECIMAL(5,2) NOT NULL, CHECK (Distance > 0),
    EventTypeID INT NOT NULL,
    OrganiserID INT NOT NULL,
    BannerImageUrl VARCHAR(255) NULL,
    FOREIGN KEY (EventTypeID) REFERENCES EventTypes(EventTypeID),
    FOREIGN KEY (OrganiserID) REFERENCES Users(UserID)
);

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName VARCHAR(50) NOT NULL,
    MinAge INT NULL,
    MaxAge INT NULL,
    FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);

CREATE TABLE Enrolments (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Confirmed' CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled')), 
    FOREIGN KEY (ParticipantID) REFERENCES Users(UserID),
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME NOT NULL,
    Position INT NOT NULL,
    FOREIGN KEY (EnrolmentID) REFERENCES Enrolments(EnrolmentID)
);
GO

-- 2. Seed Data
-- Event Types
INSERT INTO EventTypes (TypeName) VALUES ('Run'), ('Walk'), ('Cycle');

-- Users (2 Organisers, 2 Participants)

INSERT INTO Users (FirstName, LastName, Email, PasswordHash, Role, PhoneNumber) VALUES
('Thabo', 'Mokoena', 'thabo@raceday.co.za', 'HASHED_PASS_1', 'Organiser', '0821112222'),
('Sarah', 'Smith', 'sarah@raceday.co.za', 'HASHED_PASS_2', 'Organiser', '0823334444'),
('John', 'Doe', 'john.doe@email.com', 'HASHED_PASS_3', 'Participant', '0825556666'),
('Naledi', 'Dlamini', 'naledi.d@email.com', 'HASHED_PASS_4', 'Participant', '0827778888');

-- Events (3 Events)
INSERT INTO Events (Name, Description, EventDate, Location, Distance, EventTypeID, OrganiserID) VALUES
('Comrades Marathon 2026', 'The ultimate test of human endurance.', '2026-06-07 05:00:00', 'Pietermaritzburg to Durban', 89.0, 1, 1),
('Cape Town Cycle Tour', 'Africa''s greatest cycling experience.', '2026-03-08 06:00:00', 'Cape Town CBD', 109.0, 3, 2),
(' Soweto Marathon', 'Celebrating community and fitness.', '2026-05-17 06:00:00', 'Orlando Stadium, Soweto', 42.2, 1, 1);

-- Categories
INSERT INTO Categories (EventID, CategoryName, MinAge, MaxAge) VALUES
(1, 'Open Men', 18, 99),
(1, 'Open Women', 18, 99),
(2, 'Youth (Under 19)', 14, 18),
(2, 'Senior', 19, 59),
(3, '10km Fun Run', 10, 99),
(3, '42km Full Marathon', 18, 99);

-- Enrolments (Sample enrolments for Participants)
INSERT INTO Enrolments (ParticipantID, EventID, CategoryID, Status) VALUES
(3, 1, 1, 'Confirmed'), -- John Doe in Comrades Open Men
(4, 3, 5, 'Confirmed'); -- Naledi Dlamini in Soweto 10km Fun Run
GO
select * from Users;