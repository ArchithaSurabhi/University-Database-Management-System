CREATE TABLE StudentStatus (
    StudentStatusID INT IDENTITY(1,1) PRIMARY KEY,
    StudentStatus VARCHAR(255) NOT NULL CHECK (StudentStatus IN ('active','suspended','inactive'))
);

CREATE TABLE StudentType (
    StudentTypeID INT IDENTITY(1,1) PRIMARY KEY,
    StudentTypeValue VARCHAR(255) NOT NULL
);

CREATE TABLE State (
    StateID INT IDENTITY(1,1) PRIMARY KEY,
    StateName VARCHAR(255) NOT NULL
);

CREATE TABLE Country (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName VARCHAR(255) NOT NULL
);

CREATE TABLE Gender (
    GenderID INT IDENTITY(1,1) PRIMARY KEY,
    Gender VARCHAR(255) NOT NULL
);

CREATE TABLE Race (
    RaceID INT IDENTITY(1,1) PRIMARY KEY,
    Race VARCHAR(255) NOT NULL
);

CREATE TABLE College (
    CollegeID INT IDENTITY(1,1) PRIMARY KEY,
    CollegeName VARCHAR(255) NOT NULL
);

CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    Department VARCHAR(255) NOT NULL
);

CREATE TABLE CourseCode (
    CourseCodeID INT IDENTITY(1,1) PRIMARY KEY,
    Code VARCHAR(255) NOT NULL
);

CREATE TABLE CourseLevel (
    CourseLevelID INT IDENTITY(1,1) PRIMARY KEY,
    CourseLevel VARCHAR(20) NOT NULL CHECK (CourseLevel IN ('undergraduate', 'graduate'))
);

CREATE TABLE BenefitType (
    BenefitTypeID INT IDENTITY(1,1) PRIMARY KEY,
    BenefitType VARCHAR(255) NOT NULL
);

CREATE TABLE BenefitCoverage (
    BenefitCoverID INT IDENTITY(1,1) PRIMARY KEY,
    CoverageType VARCHAR(255) NOT NULL CHECK (CoverageType IN ('health', 'vision', 'dental'))
);

CREATE TABLE Buildings (
    BuildingID INT IDENTITY(1,1) PRIMARY KEY,
    BuildingText VARCHAR(255) NOT NULL
);

CREATE TABLE ProjectorInfo (
    ProjectorID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectorText VARCHAR(255) NOT NULL
);

CREATE TABLE SemesterType (
    SemesterTextID INT IDENTITY(1,1) PRIMARY KEY,
    Semester VARCHAR(255) NOT NULL
);

CREATE TABLE EnrollmentStatus (
    EnrollmentStatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusType VARCHAR(20) NOT NULL CHECK (StatusType IN ('enrolled', 'dropped', 'audit'))
);

CREATE TABLE JobTypeDetail (
    JobTypeDetailID INT IDENTITY(1,1) PRIMARY KEY,
    JobType VARCHAR(20) NOT NULL CHECK (jobType IN ('faculty', 'staff'))
);


CREATE TABLE CourseNumber (
    CourseNumberID INT IDENTITY(1,1) PRIMARY KEY,
    Number INT NOT NULL
);

CREATE TABLE Addresses (
    MailingAddressID INT IDENTITY(1, 1) PRIMARY KEY,
    Street1 VARCHAR(100) NOT NULL,
    Street2 VARCHAR(100),
    City VARCHAR(50) NOT NULL,
    StateID INT NOT NULL,
    CountryID INT NOT NULL,
    Zipcode VARCHAR(10) NOT NULL,
    CONSTRAINT FK_State FOREIGN KEY (StateID) REFERENCES State(StateID),
    CONSTRAINT FK_Country FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);


CREATE TABLE PersonInfo (
   PersonID INT IDENTITY(1, 1) PRIMARY KEY,
   NTID INT NOT NULL,
   Password  VARCHAR(20) NOT NULL,
   SSN VARCHAR(20),
   FirstName VARCHAR(20) NOT NULL,
   MiddleName VARCHAR(20),
   LastName VARCHAR(20) NOT NULL,
   DOB Date NOT NULL,
   GenderID INT NOT NULL,
   RaceID INT NOT NULL,
   MailingAddressID INT NOT NULL,
   CellPhone VARCHAR(15),
   Email VARCHAR(50) NOT NULL,
   CONSTRAINT FK_Gender FOREIGN KEY (GenderID) REFERENCES Gender(GenderID),
   CONSTRAINT FK_Race FOREIGN KEY (RaceID) REFERENCES Race(RaceID),
   CONSTRAINT FK_MailingAddress FOREIGN KEY (MailingAddressID) REFERENCES Addresses(MailingAddressID)
);


CREATE TABLE StudentInfo (
    StudentID INT IDENTITY(1, 1) PRIMARY KEY,
    StudentTypeID INT NOT NULL,
    StudentStatusID INT NOT NULL,
    PersonInfoID INT NOT NULL,
    IsGraduate BIT NOT NULL
    CONSTRAINT FK_StudentType FOREIGN KEY (StudentTypeID) REFERENCES StudentType(StudentTypeID),
    CONSTRAINT FK_StudentStatus FOREIGN KEY (StudentStatusID) REFERENCES StudentStatus(StudentStatusID),
    CONSTRAINT FK_StudentInfo FOREIGN KEY (PersonInfoID) REFERENCES PersonInfo(PersonID)
);


CREATE TABLE EmployeeInfo (
    EmployeeID INT IDENTITY(1, 1) PRIMARY KEY,
    PersonInfoID INT NOT NULL,
    AnnualSalary MONEY NOT NULL,
    CONSTRAINT FK_EmployeeInfo FOREIGN KEY (PersonInfoID) REFERENCES PersonInfo(PersonID)
);

CREATE TABLE JobInfo (
    JobID INT IDENTITY(1, 1) PRIMARY KEY,
    JobCode VARCHAR(20) NOT NULL,
    JobTitle VARCHAR(50) NOT NULL,
    JobDescription VARCHAR(200),
    JobRequirements VARCHAR(200) NOT NULL,
    MinPay Money NOT NULL,
    MaxPay Money NOT NULL,
    IsFaculty BIT NOT NULL,
    JobTypeDetailID INT NOT NULL,
    CONSTRAINT FK_JobTypeDetail FOREIGN KEY (JobTypeDetailID) REFERENCES JobTypeDetail(JobTypeDetailID)
);

CREATE TABLE EmployeeBenefits (
    EmployeeID INT NOT NULL,
    BenefitTypeID INT NOT NULL,
    BenefitCoverID INT NOT NULL,
    EmployeePremium Money NOT NULL,
    EmployerPremium Money NOT NULL,
    PRIMARY KEY (EmployeeID, BenefitTypeID, BenefitCoverID),
    CONSTRAINT FK_Employee FOREIGN KEY (EmployeeID) REFERENCES EmployeeInfo(EmployeeID),
    CONSTRAINT FK_BenefitType FOREIGN KEY (BenefitTypeID) REFERENCES BenefitType(BenefitTypeID),
    CONSTRAINT FK_BenefitCover FOREIGN KEY (BenefitCoverID) REFERENCES BenefitCoverage(BenefitCoverID)
);


CREATE TABLE MajorMinor (
    AreaID INT IDENTITY(1, 1) PRIMARY KEY,
    CollegeID INT NOT NULL,
    StudyTitle VARCHAR(100) NOT NULL,
    CONSTRAINT FK_College FOREIGN KEY (CollegeID) REFERENCES College(CollegeID) 
);

CREATE TABLE AreaOfStudy (
    StudentID INT NOT NULL,
    AreaID INT NOT NULL,
    IsMajor BIT NOT NULL,
    PRIMARY KEY (StudentID, AreaID),
    CONSTRAINT FK_Student FOREIGN KEY (StudentID) REFERENCES StudentInfo(StudentID),
    CONSTRAINT FK_Area FOREIGN KEY (AreaID) REFERENCES MajorMinor(AreaID)
);

CREATE TABLE Prerequisites (
    PrereqID INT IDENTITY(1, 1) PRIMARY KEY,
    ParentCodeID INT NOT NULL,
    ParentNumberID INT NOT NULL,
    ChildCodeID INT NOT NULL,
    ChildNumberID INT NOT NULL,
    CONSTRAINT FK_ParentCode FOREIGN KEY (ParentCodeID) REFERENCES CourseCode(CourseCodeID),
    CONSTRAINT FK_ParentNumber FOREIGN KEY (ParentNumberID) REFERENCES CourseNumber(CourseNumberID),
    CONSTRAINT FK_ChildCode FOREIGN KEY (ChildCodeID) REFERENCES CourseCode(CourseCodeID),
    CONSTRAINT FK_ChildNumber FOREIGN KEY (ChildNumberID) REFERENCES CourseNumber(CourseNumberID) 
);

CREATE TABLE CourseCatalogue (
    CourseID INT IDENTITY(1, 1) PRIMARY KEY,
    CourseCodeID INT NOT NULL,
    CourseNumberID INT NOT NULL,
    CourseTitle VARCHAR(100) NOT NULL,
    CourseDesc VARCHAR(200),
    DepartmentID INT NOT NULL,
    CourseLevelID INT NOT NULL,
    PrereqID INT NOT NULL,
    CreditHours INT NOT NULL,
    CONSTRAINT FK_CourseCode FOREIGN KEY (CourseCodeID) REFERENCES CourseCode(CourseCodeID),
    CONSTRAINT FK_CourseNumber FOREIGN KEY (CourseNumberID) REFERENCES CourseNumber(CourseNumberID),
    CONSTRAINT FK_Department FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    CONSTRAINT FK_CourseLevel FOREIGN KEY (CourseLevelID) REFERENCES CourseLevel(CourseLevelID),
    CONSTRAINT FK_Prerequisites FOREIGN KEY (PrereqID) REFERENCES Prerequisites(PrereqID)
);

CREATE TABLE SemesterInfo (
    SemesterID INT IDENTITY(1, 1) PRIMARY KEY,
    SemesterTypeID INT NOT NULL,
    Year INT NOT NULL,
    FirstDay VARCHAR(20) NOT NULL,
    LastDay VARCHAR(20) NOT NULL,
    CONSTRAINT FK_SemesterType FOREIGN KEY (SemesterTypeID) REFERENCES SemesterType(SemesterTextID)
);

CREATE TABLE ClassRoom (
    ClassRoomID INT IDENTITY(1, 1) PRIMARY KEY,
    BuildingID INT NOT NULL,
    Level INT NOT NULL,
    RoomNumber INT NOT NULL,
    ProjectorID INT NOT NULL,
    WhiteBoardCount INT NOT NULL,
    MaximumSeating INT NOT NULL,
    TypeIndicator VARCHAR(20),
    CONSTRAINT FK_Building FOREIGN KEY (BuildingID) REFERENCES Buildings(BuildingID),
    CONSTRAINT FK_Projector FOREIGN KEY (ProjectorID) REFERENCES ProjectorInfo(ProjectorID)
);

CREATE TABLE CourseSchedule (
    CRN BIGINT PRIMARY KEY,
    CourseCodeID INT NOT NULL,
    CourseNumberID INT NOT NULL,
    Section VARCHAR(10) NOT NULL,
    SemesterID INT NOT NULL,
    ClassRoomID INT NOT NULL,
    ProfessorID INT NOT NULL,
    CONSTRAINT FK_CourseCodeID FOREIGN KEY (CourseCodeID) REFERENCES CourseCode(CourseCodeID),
    CONSTRAINT FK_CourseNumberID FOREIGN KEY (CourseNumberID) REFERENCES CourseNumber(CourseNumberID),
    CONSTRAINT FK_Semester FOREIGN KEY (SemesterID) REFERENCES SemesterInfo(SemesterID),
    CONSTRAINT FK_ClassRoom FOREIGN KEY (ClassRoomID) REFERENCES ClassRoom(ClassRoomID),
    CONSTRAINT FK_Instructor FOREIGN KEY (ProfessorID) REFERENCES EmployeeInfo(EmployeeID)
);

CREATE TABLE CourseEnrollment (
    StudentID INT NOT NULL,
    CRN BIGINT NOT NULL,
    EnrollmentStatusID INT NOT NULL,
    MidtermGrade VARCHAR(3) CHECK (MidtermGrade IN ('A', 'A-', 'B+', 'B', 'B-', 'C', 'F')),
    FinalGrade VARCHAR(3) CHECK (FinalGrade IN ('A', 'A-', 'B+', 'B', 'B-', 'C', 'F')),
    PRIMARY KEY (StudentID, CRN),
    CONSTRAINT FK_StudentID FOREIGN KEY (StudentID) REFERENCES StudentInfo(StudentID),
    CONSTRAINT FK_CRN FOREIGN KEY (CRN) REFERENCES CourseSchedule(CRN),
    CONSTRAINT FK_EnrollmentStatus FOREIGN KEY (EnrollmentStatusID) REFERENCES EnrollmentStatus(EnrollmentStatusID)
);

CREATE TABLE CourseDailySchedule (
    ScheduleID INT IDENTITY(1, 1) PRIMARY KEY,
    CRN BIGINT NOT NULL,
    DayOfWeek VARCHAR(10) NOT NULL,
    StartHour INT NOT NULL,
    StartMinute INT NOT NULL,
    EndHour INT NOT NULL,
    EndMinute INT NOT NULL,
    CONSTRAINT FK_CRN_Schedule FOREIGN KEY (CRN) REFERENCES CourseSchedule(CRN)
);

CREATE TABLE EmployeeJobs (
    EmployeeID INT NOT NULL,
    JobID INT NOT NULL,
    PRIMARY KEY (EmployeeID, JobID),
    CONSTRAINT FK_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES EmployeeInfo(EmployeeID),
    CONSTRAINT FK_Job FOREIGN KEY (JobID) REFERENCES JobInfo(JobID)    
);


INSERT INTO StudentStatus (StudentStatus)
VALUES
    ('active'),
    ('suspended'),
    ('inactive');


INSERT INTO StudentType (StudentTypeValue)
VALUES
    ('new freshmen'),
    ('continue'),
    ('transfer'),
    ('re-admitted'),
    ('new graduate'),
    ('continue graduate');


INSERT INTO State (StateName)
VALUES
    ('Alabama'),
    ('Alaska'),
    ('Arizona'),
    ('Arkansas'),
    ('California'),
    ('Colorado'),
    ('Connecticut'),
    ('Delaware'),
    ('Florida'),
    ('Georgia');


INSERT INTO Country (CountryName)
VALUES
    ('United States'),
    ('Canada'),
    ('United Kingdom'),
    ('Germany'),
    ('France'),
    ('Australia'),
    ('India'),
    ('Japan'),
    ('Brazil'),
    ('South Africa');



INSERT INTO Gender (Gender)
VALUES
    ('Male'),
    ('Female'),
    ('Non-Binary');



INSERT INTO Race (Race)
VALUES
    ('White'),
    ('Black or African American'),
    ('Asian'),
    ('Native American or Alaska Native'),
    ('Native Hawaiian or Other Pacific Islander'),
    ('Two or More Races');


INSERT INTO College (CollegeName)
VALUES
    ('College of Arts and Sciences'),
    ('School of Architecture'),
    ('College of Engineering and Computer Science'),
    ('Whitman School of Management'),
    ('Maxwell School of Citizenship and Public Affairs'),
    ('S.I. Newhouse School of Public Communications'),
    ('Falk College of Sport and Human Dynamics'),
    ('College of Law'),
    ('School of Information Studies'),
    ('David B. Falk College of Sport and Human Dynamics');


INSERT INTO Department (Department)
VALUES
    ('Computer Science'),
    ('Electrical Engineering'),
    ('Physics'),
    ('Chemistry'),
    ('Biology'),
    ('History'),
    ('English Literature'),
    ('Mathematics'),
    ('Psychology'),
    ('Business Administration');



INSERT INTO CourseCode (Code)
VALUES
    ('MAE'),
    ('ECS'),
    ('CSE'),
    ('EEE'),
    ('SCM'),
    ('CEE'),
    ('MFE'),
    ('MBC'),
    ('LAW'),
    ('CIS');


INSERT INTO CourseLevel (CourseLevel)
VALUES
    ('undergraduate'),
    ('graduate');


INSERT INTO BenefitType (BenefitType)
VALUES
    ('Employee Only'),
    ('Employee with Children Only'),
    ('Employee with Spouse Only'),
    ('Employee with Family');


INSERT INTO BenefitCoverage (CoverageType)
VALUES
    ('health'),
    ('vision'),
    ('dental');


INSERT INTO Buildings (BuildingText)
VALUES
    ('Main Building'),
    ('Engineering Building'),
    ('Science Center'),
    ('Liberal Arts Building'),
    ('Business School'),
    ('Health Sciences Building'),
    ('Student Center'),
    ('Library'),
    ('Fine Arts Building'),
    ('Athletics Complex');


INSERT INTO ProjectorInfo (ProjectorText)
VALUES
    ('Room 101 Projector'),
    ('Engineering Lab Projector'),
    ('Conference Room Projector'),
    ('Lecture Hall Projector'),
    ('Business School Auditorium Projector'),
    ('Health Sciences Classroom Projector'),
    ('Student Center Meeting Room Projector'),
    ('Library Presentation Room Projector'),
    ('Fine Arts Studio Projector'),
    ('Athletics Complex Multi-Purpose Room Projector');


INSERT INTO SemesterType (Semester)
VALUES
    ('Fall'),
    ('Spring'),
    ('Summer Session I'),
    ('Summer Session II'),
    ('Combined Summer Session');


INSERT INTO EnrollmentStatus (StatusType)
VALUES
    ('enrolled'),
    ('dropped'),
    ('audit');


INSERT INTO JobTypeDetail (JobType)
VALUES
    ('faculty'),
    ('staff');



INSERT INTO CourseNumber (Number)
VALUES
    (123),
    (456),
    (789),
    (234),
    (567),
    (890),
    (345),
    (678),
    (901),
    (432);


INSERT INTO Addresses (Street1, Street2, City, StateID, CountryID, Zipcode)
VALUES
    ('456 Pine St', 'Apt 789', 'Town1', 1, 1, '54321'),
    ('789 Oak St', NULL, 'Town2', 2, 2, '98765'),
    ('123 Maple St', 'Suite 202', 'Town3', 3, 3, '23456'),
    ('987 Cedar St', NULL, 'Town4', 4, 4, '87654'),
    ('210 Elm St', 'Unit 303', 'Town5', 5, 5, '65432'),
    ('543 Birch St', NULL, 'Town6', 6, 6, '12345'),
    ('876 Redwood St', 'Apt 404', 'Town7', 7, 7, '89012'),
    ('109 Sequoia St', NULL, 'Town8', 8, 8, '34567'),
    ('321 Spruce St', 'Suite 101', 'Town9', 9, 9, '67890'),
    ('654 Cedar St', NULL, 'Town10', 10, 10, '45678');


INSERT INTO PersonInfo (NTID, Password, SSN, FirstName, MiddleName, LastName, DOB, GenderID, RaceID, MailingAddressID, CellPhone, Email)
VALUES
   (123001, 'pass123', '123-45-6789', 'John', 'A', 'Doe', '1990-01-15', 1, 1, 1, '555-1234', 'john.doe@email.com'),
   (234002, 'securepass', '987-65-4321', 'Jane', 'B', 'Smith', '1985-05-20', 2, 2, 2, '555-5678', 'jane.smith@email.com'),
   (345003, 'mypassword', '567-89-0123', 'Robert', 'C', 'Johnson', '1995-09-08', 3, 3, 3, '555-9876', 'robert.johnson@email.com'),
   (456004, 'pass123', '345-67-8901', 'Alice', NULL, 'Williams', '1988-03-12', 1, 4, 4, '555-6543', 'alice.williams@email.com'),
   (567005, 'secretpass', '890-12-3456', 'Chris', 'D', 'Miller', '1992-07-25', 2, 5, 5, '555-7890', 'chris.miller@email.com'),
   (678006, 'password123', '234-56-7890', 'Emma', 'E', 'Taylor', '1998-11-30', 3, 6, 6, '555-2345', 'emma.taylor@email.com'),
   (789007, 'pass456', '876-54-3210', 'Michael', 'F', 'Anderson', '1993-04-05', 1, 1, 7, '555-7890', 'michael.anderson@email.com'),
   (890008, 'secure123', '210-98-7654', 'Sophia', NULL, 'Brown', '1996-08-18', 2, 2, 8, '555-1234', 'sophia.brown@email.com'),
   (901009, 'mypass', '543-21-0987', 'Daniel', 'G', 'Davis', '1991-02-22', 3, 3, 9, '555-8765', 'daniel.davis@email.com'),
   (101010, 'password456', '987-65-4321', 'Olivia', 'H', 'Harris', '1987-06-14', 1, 4, 10, '555-2345', 'olivia.harris@email.com');


INSERT INTO StudentInfo (StudentTypeID, StudentStatusID, PersonInfoID, IsGraduate)
VALUES
    (1, 1, 1, 0),
    (2, 2, 2, 1),
    (3, 3, 3, 0),
    (4, 1, 4, 1),
    (5, 2, 5, 0);


INSERT INTO EmployeeInfo (PersonInfoID, AnnualSalary)
VALUES
    (6, 60000.00),
    (7, 75000.50),
    (8, 55000.75),
    (9, 90000.25),
    (10, 80000.50);


INSERT INTO JobInfo (JobCode, JobTitle, JobDescription, JobRequirements, MinPay, MaxPay, IsFaculty, JobTypeDetailID)
VALUES
    ('JC006', 'Professor of Computer Science', 'Teach and lead research in Computer Science', 'Ph.D. in Computer Science, Extensive teaching and research experience', 80000.00, 150000.00, 1,1),
    ('JC007', 'Assistant Professor of Mathematics', 'Teach mathematics courses and conduct research', 'Ph.D. in Mathematics, Strong research background', 75000.00, 130000.00, 1, 1),
    ('JC008', 'Associate Professor of Chemistry', 'Teach chemistry courses and supervise research projects', 'Ph.D. in Chemistry, Substantial teaching and research experience', 85000.00, 140000.00, 1, 1),
	('JC004', 'HR Specialist', 'Manage human resources functions', 'Bachelors degree in Human Resources', 55000.00, 85000.00, 0, 2),
    ('JC005', 'Network Administrator', 'Maintain and optimize computer networks', 'Bachelors degree in Network Administration', 65000.00, 100000.00, 0, 2);


INSERT INTO EmployeeBenefits (EmployeeID, BenefitTypeID, BenefitCoverID, EmployeePremium, EmployerPremium)
VALUES
    (1, 1, 1, 50.00, 150.00),
    (2, 2, 2, 75.50, 200.00),
    (3, 3, 3, 60.25, 180.00),
    (4, 1, 1, 90.25, 250.00),
    (5, 4, 2, 80.50, 210.00);


INSERT INTO MajorMinor (CollegeID, StudyTitle)
VALUES
    (1, 'Computer Science'),
    (10, 'Electrical Engineering'),
    (2, 'Business Administration'),
    (6, 'Marketing'),
    (3, 'Psychology'),
    (7, 'Sociology'),
    (4, 'Physics'),
    (8, 'Chemistry'),
    (5, 'English Literature'),
    (9, 'History');


INSERT INTO AreaOfStudy (StudentID, AreaID, IsMajor)
VALUES
    (1, 1, 1),
    (1, 2, 0),
    (2, 3, 1),
    (2, 4, 0),
    (3, 5, 1),
    (3, 6, 0),
    (4, 7, 1),
    (4, 8, 0),
    (5, 9, 1),
    (5, 10, 0);


INSERT INTO Prerequisites (ParentCodeID, ParentNumberID, ChildCodeID, ChildNumberID)
VALUES
    (1, 1, 2, 3),
    (2, 4, 3, 5),
    (3, 6, 4, 7),
    (4, 8, 5, 9),
    (5, 10, 6, 1),
    (6, 2, 7, 3),
    (7, 4, 8, 5),
    (8, 6, 9, 7),
    (9, 8, 10, 9),
    (10, 10, 1, 2);


INSERT INTO CourseCatalogue (CourseCodeID, CourseNumberID, CourseTitle, CourseDesc, DepartmentID, CourseLevelID, PrereqID, CreditHours)
VALUES
    (3, 1, 'Introduction to Computer Science', 'Fundamental concepts of computer science', 1, 1, 1, 3),
    (3, 2, 'Data Structures', 'Study of data organization and algorithms', 1, 2, 2, 4),
    (5, 3, 'Principles of Marketing', 'Basic principles of marketing strategies', 10, 1, 3, 3),
    (5, 4, 'Financial Accounting', 'Basic principles of financial accounting', 10, 2, 4, 4),
    (8, 5, 'Introduction to Psychology', 'Overview of basic psychological concepts', 9, 1, 5, 3),
    (9, 6, 'Sociological Theories', 'Study of major sociological theories', 3, 2, 6, 4),
    (10, 7, 'Classical Physics', 'Fundamental principles of classical physics', 3, 1, 7, 3),
    (10, 8, 'Organic Chemistry', 'Study of organic compounds and reactions', 4, 2, 8, 4),
    (7, 9, 'American Literature', 'Survey of American literature', 7, 1, 9, 3),
    (7, 10, 'World History', 'Overview of major events in world history', 6, 2, 10, 4);


INSERT INTO SemesterInfo (SemesterTypeID, Year, FirstDay, LastDay)
VALUES
    (1, 2023, '2023-09-01', '2023-12-15'),
    (2, 2024, '2024-01-15', '2024-05-15'),
    (3, 2024, '2024-06-01', '2024-07-15'),
    (4, 2024, '2024-07-16', '2024-08-30'),
    (5, 2024, '2024-06-01', '2024-08-30');


INSERT INTO ClassRoom (BuildingID, Level, RoomNumber, ProjectorID, WhiteBoardCount, MaximumSeating, TypeIndicator)
VALUES
    (5, 2, 202, 5, 2, 40, 'Lecture Hall'),
    (1, 1, 101, 1, 2, 30, 'Lecture Hall'),
    (3, 1, 102, 3, 2, 35, 'Conference Room'),
    (2, 2, 201, 2, 1, 25, 'Classroom'),
    (4, 3, 301, 4, 1, 20, 'Classroom'),
    (6, 1, 103, 6, 3, 45, 'Lab'),
    (7, 2, 203, 7, 1, 28, 'Classroom'),
    (8, 1, 104, 8, 2, 33, 'Conference Room'),
    (9, 3, 302, 9, 1, 22, 'Classroom'),
    (10, 2, 204, 10, 2, 38, 'Lecture Hall');


INSERT INTO CourseSchedule (CRN, CourseCodeID, CourseNumberID, Section, SemesterID, ClassRoomID, ProfessorID)
VALUES
    (123456, 1, 2, 'A', 1, 2, 1),
    (234567, 3, 4, 'B', 2, 5, 2),
    (345678, 5, 6, 'C', 3, 8, 3),
    (456789, 7, 8, 'B', 4, 1, 1),
    (567890, 9, 10, 'B', 5, 4, 2),
    (678901, 2, 3, 'A', 1, 7, 3),
    (789012, 4, 5, 'C', 2, 10, 1),
    (890123, 6, 7, 'A', 3, 3, 2),
    (901234, 8, 9, 'A', 4, 6, 3),
    (123045, 10, 1, 'A', 5, 9, 1);


INSERT INTO CourseEnrollment (StudentID, CRN, EnrollmentStatusID, MidtermGrade, FinalGrade)
VALUES
    (1, 123456, 1, 'B+', 'A-'),
    (2, 234567, 1, 'A', 'A'),
    (3, 345678, 2, 'B', 'B+'),
    (4, 456789, 2, 'A-', 'B'),
    (5, 567890, 3, 'C', 'B-'),
    (1, 678901, 1, 'B', 'A-'),
    (2, 789012, 2, 'A', 'A'),
    (3, 890123, 1, 'B+', 'B+'),
    (4, 901234, 3, 'B-', 'C'),
    (5, 123045, 3, 'C', 'C');


INSERT INTO CourseDailySchedule (CRN, DayOfWeek, StartHour, StartMinute, EndHour, EndMinute)
VALUES
    (123456, 'Monday', 9, 0, 11, 30),
    (234567, 'Wednesday', 13, 30, 15, 0),
    (345678, 'Friday', 10, 0, 12, 0),
    (456789, 'Tuesday', 11, 0, 12, 30),
    (567890, 'Thursday', 14, 0, 16, 0),
    (678901, 'Monday', 15, 30, 17, 0),
    (789012, 'Wednesday', 8, 0, 10, 30),
    (890123, 'Friday', 16, 0, 17, 30),
    (901234, 'Tuesday', 13, 0, 14, 30),
    (123045, 'Thursday', 9, 30, 11, 0);


INSERT INTO EmployeeJobs (EmployeeID, JobID)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);
    
    
    
    
    
    
    


GRANT SELECT ON asurabhi.StudentStatus TO graders;
GRANT SELECT ON asurabhi.StudentType TO graders;
GRANT SELECT ON asurabhi.State TO graders;
GRANT SELECT ON asurabhi.Country TO graders;
GRANT SELECT ON asurabhi.Gender TO graders;
GRANT SELECT ON asurabhi.Race TO graders;
GRANT SELECT ON asurabhi.College TO graders;
GRANT SELECT ON asurabhi.Department TO graders;
GRANT SELECT ON asurabhi.CourseCode TO graders;
GRANT SELECT ON asurabhi.CourseLevel TO graders;
GRANT SELECT ON asurabhi.BenefitType TO graders;
GRANT SELECT ON asurabhi.BenefitCoverage TO graders;
GRANT SELECT ON asurabhi.Buildings TO graders;
GRANT SELECT ON asurabhi.ProjectorInfo TO graders;
GRANT SELECT ON asurabhi.SemesterType TO graders;
GRANT SELECT ON asurabhi.EnrollmentStatus TO graders;
GRANT SELECT ON asurabhi.JobTypeDetail TO graders;
GRANT SELECT ON asurabhi.CourseNumber TO graders;
GRANT SELECT ON asurabhi.Addresses TO graders;
GRANT SELECT ON asurabhi.PersonInfo TO graders;
GRANT SELECT ON asurabhi.StudentInfo TO graders;
GRANT SELECT ON asurabhi.EmployeeInfo TO graders;
GRANT SELECT ON asurabhi.JobInfo TO graders;
GRANT SELECT ON asurabhi.EmployeeBenefits TO graders;
GRANT SELECT ON asurabhi.MajorMinor TO graders;
GRANT SELECT ON asurabhi.AreaOfStudy TO graders;
GRANT SELECT ON asurabhi.Prerequisites TO graders;
GRANT SELECT ON asurabhi.CourseCatalogue TO graders;
GRANT SELECT ON asurabhi.SemesterInfo TO graders;
GRANT SELECT ON asurabhi.ClassRoom TO graders;
GRANT SELECT ON asurabhi.CourseSchedule TO graders;
GRANT SELECT ON asurabhi.CourseEnrollment TO graders;
GRANT SELECT ON asurabhi.CourseDailySchedule TO graders;
GRANT SELECT ON asurabhi.EmployeeJobs TO graders;



select * from asurabhi.StudentStatus;

select * from asurabhi.StudentType;

select * from asurabhi.State;

select * from asurabhi.Country;

select * from asurabhi.Gender;

select * from asurabhi.Race;

select * from asurabhi.College;

select * from asurabhi.Department;

select * from asurabhi.CourseCode;

select * from asurabhi.CourseLevel;

select * from asurabhi.BenefitType;

select * from asurabhi.BenefitCoverage;

select * from asurabhi.Buildings;

select * from asurabhi.ProjectorInfo;

select * from asurabhi.SemesterType;

select * from asurabhi.EnrollmentStatus;

select * from asurabhi.JobTypeDetail;

select * from asurabhi.CourseNumber;

select * from asurabhi.Addresses;

select * from asurabhi.PersonInfo;

select * from asurabhi.StudentInfo;

select * from asurabhi.EmployeeInfo;

select * from asurabhi.JobInfo;

select * from asurabhi.EmployeeBenefits;

select * from asurabhi.MajorMinor;

select * from asurabhi.AreaOfStudy;

select * from asurabhi.PreRequisites;

select * from asurabhi.CourseCatalogue;

select * from asurabhi.SemesterInfo;

select * from asurabhi.ClassRoom;

select * from asurabhi.CourseSchedule;

select * from asurabhi.CourseEnrollment;

select * from asurabhi.CourseDailySchedule;

select * from asurabhi.EmployeeJobs;



    
    