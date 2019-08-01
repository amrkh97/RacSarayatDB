USE RAC_SARAYAT
GO

CREATE TABLE Members
(
    ID NVARCHAR(14),
    FName NVARCHAR(64),
    LName NVARCHAR(64),
    BirthDate DATETIME DEFAULT GETDATE(),
    Age INT,
    Mail NVARCHAR(64),
    YearsInClub NVARCHAR(14)

    PRIMARY KEY(MemberID)

);

CREATE TABLE Positions
(
    ID INT IDENTITY,
    PositionName NVARCHAR(64),
    PositionDescription NVARCHAR(MAX)

    PRIMARY KEY(PositionName)
);


CREATE TABLE MemberPositions
(
    ID INT IDENTITY,
    MemberID NVARCHAR(14),
    MemberPosition NVARCHAR(64),

    FOREIGN KEY (MemberID) REFERENCES Members(ID),
    FOREIGN KEY (MemberPosition) REFERENCES Positions(PositionName)
);