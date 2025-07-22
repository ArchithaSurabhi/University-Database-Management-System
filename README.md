# University-Database-Management-System

## Project Overview

This project implements a fully normalized relational database for a university system. It models core academic and administrative entities such as students, employees, courses, and enrollment, along with advanced database components like stored procedures, views, and functions. The goal is to build a database that reflects the day-to-day data operations of a university—from student enrollment and course scheduling to staff management and reporting.

## Motivation

Universities deal with large volumes of interconnected data—students, faculty, courses, grades, and benefits. This project is built to explore how structured relational databases can manage that complexity effectively, enforce data integrity, and support advanced queries and business operations.

## Objectives

1. Design a normalized database schema (3NF) based on a realistic university scenario.

2. Populate the database with sample data to simulate real-world relationships.

3. Create stored procedures, views, and functions to support complex operations.

## Data

All data is synthetically generated and represents key entities:

Students – Demographics, academic status, majors

Employees – Job details, benefits, and personal data

Courses – Catalog info, scheduling, prerequisites

Semesters – Time windows for course offerings

Enrollment – Student registrations and grading

## Methodology

### 1. Database Design

- Designed ER diagram using Visio.

- Normalized to 3NF to eliminate redundancy.

### 2. Database Implementation

- SQL scripts (Data.sql) used to create all tables, keys, and constraints.

- Dummy data (~6 records per table) inserted to simulate functionality.

### 3. Advanced DB Objects

- Used SQL extensively for schema design, data population, and query operations
  
- Stored procedures, views, and user-defined functions are implemented to simulate real-world database workflows and logic.

## Key Features

1. Relational schema covering full academic lifecycle

2. Multi-table joins, data validations, and constraints

3. Procedural logic via stored procedures

4. Reusable function and readable view for reporting

## Key Insights / Findings

1. Database normalization significantly improves data integrity and avoids duplication.

2. Stored procedures help encapsulate business logic in the DB layer.

3. Views and functions are useful abstractions for reporting and analysis tasks.

## Challenges

1. Balancing schema normalization with query simplicity.

2. Simulating realistic data relationships (e.g., prerequisite chains).

3. Validating updates/deletes while maintaining referential integrity.

## Conclusion

This database system reflects the foundational architecture required for a scalable university information system. It handles core academic entities and administrative processes while demonstrating practical SQL concepts such as normalization, constraints, views, functions, and stored procedures.
