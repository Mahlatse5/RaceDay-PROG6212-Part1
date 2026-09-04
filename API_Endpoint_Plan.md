# RaceDay API Endpoint Plan

This document outlines the RESTful API endpoints for the RaceDay Event Management System.

## Authentication & User Profile

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/auth/register` | Registers a new user (Organiser or Participant) and hashes their password. | None (Public) | `{ firstName, lastName, email, password, role, phone }` | **201 Created** - User profile<br>**409 Conflict** - Email exists |
| **POST** | `/api/auth/login` | Authenticates user credentials and creates a session. | None (Public) | `{ email, password }` | **200 OK** - Session created<br>**401 Unauthorized** - Invalid credentials |
| **GET** | `/api/users/profile` | Retrieves the logged-in user's profile details. | Any (Logged in) | None | **200 OK** - User profile data |
| **PUT** | `/api/users/profile` | Updates the logged-in user's profile information. | Any (Logged in) | `{ firstName, lastName, phone }` | **200 OK** - Updated profile |

## Events & Categories

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **GET** | `/api/events` | Retrieves a list of all upcoming events. | Any (Logged in) | None | **200 OK** - List of events |
| **GET** | `/api/events/{id}` | Retrieves full details and categories for a specific event. | Any (Logged in) | None | **200 OK** - Event details<br>**404 Not Found** |
| **POST** | `/api/events` | Creates a new event. | Organiser | `{ name, description, date, location, distance, eventTypeId }` | **201 Created** - New event<br>**403 Forbidden** |
| **PUT** | `/api/events/{id}` | Updates an existing event's details. | Organiser | `{ name, description, date, location, distance }` | **200 OK** - Updated event |
| **DELETE** | `/api/events/{id}` | Deletes an event and its associated categories/enrolments. | Organiser | None | **204 No Content** |
| **POST** | `/api/events/{eventId}/categories` | Adds a new age/distance category to an event. | Organiser | `{ categoryName, minAge, maxAge }` | **201 Created** - New category |

## Enrolments & Results

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/events/{eventId}/enrol` | Enrols the logged-in participant into an event and category. | Participant | `{ categoryId }` | **201 Created** - Enrolment record<br>**409 Conflict** - Already enrolled |
| **GET** | `/api/users/enrolments` | Views the logged-in participant's personal enrolments. | Participant | None | **200 OK** - List of my enrolments |
  | **POST** | `/api/events/{eventId}/enrol` | Enrols the logged-in Participant into a specific event by selecting a category. Records the link between the Participant, the event, and the selected category. | Participant | `{ "categoryId": 1 }` | **201 Created** - Enrolment confirmed successfully<br>**400 Bad Request** - Invalid or missing category ID<br>**401 Unauthorized** - User is not logged in<br>**403 Forbidden** - User is not a Participant<br>**404 Not Found** - Event or category does not exist<br>**409 Conflict** - Participant is already enrolled in this event |
| **GET** | `/api/users/results` | Retrieves the logged-in participant's race history and results. | Participant | None | **200 OK** - List of results |