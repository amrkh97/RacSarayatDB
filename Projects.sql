USE RAC_SARAYAT
GO

CREATE OR ALTER PROC usp_Project_Add
@ProjectName NVARCHAR(100),
@ProjectDescription NVARCHAR(500),
@ProjectExpectedDate DATETIME,
@ProjectHead INT,
@ProjectYear NVARCHAR(10),
@ProjectCommittee INT,
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT
AS
BEGIN

IF NOT EXISTS(SELECT * FROM Committees WHERE ID = @ProjectCommittee)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'Committee Does Not Exist, Insertion of project failed!'
END

IF EXISTS(SELECT * FROM Projects WHERE ProjectName = @ProjectName AND ProjectYear = @ProjectYear)
BEGIN
SET @HexCode = '02'
SET @HexMsg = 'Project Already added'
RETURN -1
END

INSERT INTO Projects
(
    ProjectName,
    ProjectDescription,
    ProjectExpectedDate,
    ProjectHead,
    ProjectYear,
    ProjectCommittee
)
VALUES
(
    @ProjectName,
    @ProjectDescription,
    @ProjectExpectedDate,
    @ProjectHead,
    @ProjectYear,
    @ProjectCommittee
)

IF NOT EXISTS(SELECT * FROM Projects WHERE ProjectName = @ProjectName AND ProjectYear = @ProjectYear)
BEGIN
SET @HexCode = '03'
SET @HexMsg = 'Project Addition failed'
RETURN -1
END


SET @HexCode = '00'
SET @HexMsg = 'Project Added Successfully!'
END
GO

CREATE OR ALTER PROC usp_Project_getAll
AS
BEGIN

SELECT Projects.*,Committees.CommitteeName FROM Projects
INNER JOIN Committees
ON Projects.ProjectCommittee = Committees.ID

END
GO

CREATE OR ALTER PROC usp_Project_getByCommittee
@CommitteeID INT
AS
BEGIN

SELECT Projects.*,Committees.CommitteeName FROM Projects
INNER JOIN Committees
ON Projects.ProjectCommittee = Committees.ID
WHERE Projects.ProjectCommittee = @CommitteeID

END
GO

CREATE OR ALTER PROC usp_Project_getByYear
@ProjectYear NVARCHAR(10)
AS
BEGIN

SELECT Projects.*,Committees.CommitteeName FROM Projects
INNER JOIN Committees
ON Projects.ProjectCommittee = Committees.ID
WHERE Projects.ProjectYear = @ProjectYear 

END
GO

CREATE OR ALTER PROC usp_Project_getByMember
@ProjectHead INT
AS
BEGIN

SELECT Projects.*,Committees.CommitteeName FROM Projects
INNER JOIN Committees
ON Projects.ProjectCommittee = Committees.ID
WHERE Projects.ProjectHead = @ProjectHead 

END
GO


