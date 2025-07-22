
CREATE PROCEDURE asurabhi.GetEmployeeJobDetails
AS
BEGIN
    DECLARE @EmployeeID INT,
            @FirstName VARCHAR(20),
            @LastName VARCHAR(20),
            @JobTitle VARCHAR(50),
            @AnnualSalary MONEY;

    -- Declare cursor
    DECLARE EmployeeCursor CURSOR FOR
    SELECT EI.EmployeeID, PI.FirstName, PI.LastName, JI.JobTitle, EI.AnnualSalary
    FROM EmployeeInfo EI
    JOIN PersonInfo PI ON EI.PersonInfoID = PI.PersonID
    JOIN EmployeeJobs EJ ON EI.EmployeeID = EJ.EmployeeID
    JOIN JobInfo JI ON EJ.JobID = JI.JobID;

    OPEN EmployeeCursor;

    -- Fetch the first row
    FETCH NEXT FROM EmployeeCursor INTO @EmployeeID, @FirstName, @LastName, @JobTitle, @AnnualSalary;

    -- Loop through the result set
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'EmployeeID: ' + CAST(@EmployeeID AS VARCHAR(10)) +
              ', Name: ' + @FirstName + ' ' + @LastName +
              ', Job Title: ' + @JobTitle +
              ', Annual Salary: ' + CAST(@AnnualSalary AS VARCHAR(20));

        -- Fetch the next row
        FETCH NEXT FROM EmployeeCursor INTO @EmployeeID, @FirstName, @LastName, @JobTitle, @AnnualSalary;
    END

    CLOSE EmployeeCursor;
    DEALLOCATE EmployeeCursor;
END;

-- Stored Procedure to update the email address for a person in the PersonInfo table, 
-- validating the provided PersonID and requiring the new email to be in the '@syr.edu' format.

CREATE PROCEDURE asurabhi.UpdatePersonEmail
    @PersonID INT,
    @NewEmail VARCHAR(50)
AS
BEGIN
    -- Check if PersonID exists
    IF NOT EXISTS (SELECT 1 FROM PersonInfo WHERE PersonID = @PersonID)
    BEGIN
        PRINT 'PersonID ' + CAST(@PersonID AS VARCHAR(10)) + ' does not exist.';
        RETURN;
    END

    -- Validate the new email format
    IF @NewEmail IS NULL OR LEN(@NewEmail) > 50 OR RIGHT(@NewEmail, 8) != '@syr.edu'
    BEGIN
        PRINT 'Invalid email format. Please enter an email in the @syr.edu format.';
        RETURN; 
    END

    UPDATE PersonInfo
    SET Email = @NewEmail
    WHERE PersonID = @PersonID;

    PRINT 'Email updated successfully for PersonID ' + CAST(@PersonID AS VARCHAR(10)) + '.';
END;


CREATE PROCEDURE asurabhi.DeleteCourseCatalogueById
    @CourseID INT
AS
BEGIN
    DELETE FROM CourseCatalogue
    WHERE CourseID = @CourseID;

    IF @@ROWCOUNT > 0
        PRINT 'Course removed from catalog successfully.';
    ELSE
        PRINT 'CourseID ' + CAST(@CourseID AS VARCHAR(10)) + ' does not exist.';
END;

CREATE PROCEDURE asurabhi.CalculateEmployeeBenefitsCost
    @DepartmentID INT
AS
BEGIN
    -- Declare variable to store the total cost of employee benefits
    DECLARE @TotalBenefitsCost MONEY;

    -- Calculate the total cost of employee benefits for the specified department
    SELECT @TotalBenefitsCost = SUM(EB.EmployeePremium + EB.EmployerPremium)
    FROM EmployeeBenefits EB
    JOIN EmployeeInfo EI ON EB.EmployeeID = EI.EmployeeID
    JOIN CourseSchedule CS ON EI.EmployeeID = CS.ProfessorID
    JOIN CourseCatalogue CC ON CS.CourseCodeID = CC.CourseID
    WHERE CC.DepartmentID = @DepartmentID;

    -- Display the total cost of employee benefits
    PRINT 'Total Benefits Cost for Department ' + CAST(@DepartmentID AS VARCHAR(10)) + ': $' + ISNULL(CAST(@TotalBenefitsCost AS VARCHAR(20)), '0');
END;


CREATE VIEW asurabhi.Benefits
AS
SELECT
    Person.FirstName + ' ' + Person.LastName AS EmployeeName,
    Employee.EmployeeID,
    BT.BenefitType,
    CT.CoverageType,
    EB.EmployeePremium,
    EB.EmployerPremium
FROM
    EmployeeBenefits EB
JOIN EmployeeInfo Employee ON EB.EmployeeID = Employee.EmployeeID
JOIN BenefitType BT ON EB.BenefitTypeID = BT.BenefitTypeID
JOIN BenefitCoverage CT ON EB.BenefitCoverID = CT.BenefitCoverID
JOIN PersonInfo Person ON Employee.PersonInfoID = Person.PersonID;


-- Function to get the average credit hours for a specified department.
CREATE FUNCTION asurabhi.GetAverageCreditHoursInDepartment
    (@DepartmentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        CAST(AVG(CAST(CreditHours AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS AverageCreditHours,
        D.Department
    FROM
        Department D
    LEFT JOIN
        CourseCatalogue CC ON D.DepartmentID = CC.DepartmentID
    WHERE
        D.DepartmentID = @DepartmentID
    GROUP BY
        D.Department
);


-- VIEW to select the data from BenefitView
SELECT * FROM asurabhi.Benefits;

-- Stored Procedure 1
select * from asurabhi.EmployeeInfo;
select * from asurabhi.EmployeeJobs;
select * from asurabhi.JobInfo;

EXEC asurabhi.GetEmployeeJobDetails;

-- Stored Procedure 2
select * from asurabhi.PersonInfo;
EXEC asurabhi.UpdatePersonEmail @PersonID = 1, @NewEmail = 'djohn@syr.edu'

-- Stored Procedure 3
select * from asurabhi.CourseCatalogue;
EXEC asurabhi.DeleteCourseCatalogueById @CourseID = 11


-- Stored Procedure 4
select * from asurabhi.CourseCatalogue;
select * from asurabhi.CourseSchedule;
select * from asurabhi.EmployeeBenefits;

EXEC asurabhi.CalculateEmployeeBenefitsCost @DepartmentID = 1


-- Function
SELECT * FROM asurabhi.GetAverageCreditHoursInDepartment(1);

