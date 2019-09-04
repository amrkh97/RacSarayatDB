USE RAC_SARAYAT
GO


CREATE TABLE MemberStatus
(
    ID INT IDENTITY,
    StatusCode NVARCHAR(2),
    StatusMeaning NVARCHAR(50),
    PRIMARY KEY(StatusCode)
);

INSERT INTO MemberStatus
(
    StatusCode,
    StatusMeaning
)
VALUES
(
    N'00',
    N'Active Member'
),
(
    N'01',
    N'Freeze'
),
(
    N'02',
    N'Friend Of Club'
),
(
    N'03',
    N'Old Member'
),
(
    N'04',
    N'Suspended Member'
)

CREATE TABLE Positions
(
    ID INT IDENTITY,
    PositionName NVARCHAR(64),
    PositionDescription NVARCHAR(MAX)

    PRIMARY KEY(ID)
);

INSERT INTO Positions
(PositionName, PositionDescription)
VALUES
('Past-President','Past-President'),
('President','President'),
('Vice President', 'Vice President'),
('Secretary', 'Secretary'),
('Treasurer','Treasurer'),
('Public Relations', 'Public Relations'),
('Fundraising','Fundraising'),
('International','International'),
('Community','Community'),
('Club Service','Club Service'),
('Member','Member')

CREATE TABLE Members
(
    MemberID Int IDENTITY,
    ID NVARCHAR(14) UNIQUE NOT NULL,
    FName NVARCHAR(64),
    LName NVARCHAR(64),
    BirthDate DATETIME DEFAULT GETDATE(),
    Age as DATEDIFF(YEAR, BirthDate, GETDATE()),
    Mail NVARCHAR(100) UNIQUE NOT NULL,
    MemberPassword NVARCHAR(250),
    YearsInClub NVARCHAR(2) DEFAULT '0',
    PositionID INT,
    MemberStatus NVARCHAR(2) DEFAULT '00',
    LogInStatus NVARCHAR(2) DEFAULT '00',

    PRIMARY KEY(MemberID),
    FOREIGN KEY(PositionID) REFERENCES Positions(ID),
    FOREIGN KEY(MemberStatus) REFERENCES MemberStatus(StatusCode)

);

CREATE TABLE MemberToBe
(
    ID NVARCHAR(14),
    FName NVARCHAR(64),
    LName NVARCHAR(64),
    BirthDate DATETIME DEFAULT GETDATE(),
    Age INT,
    Mail NVARCHAR(64),
    ReferedBy NVARCHAR(64),

    PRIMARY KEY(ID)
);

CREATE TABLE GeneralParameters
(
    ID INT IDENTITY,
    MemberShipFees INT NOT NULL,
    RotarianYear NVARCHAR(10),
    MinimumThreshold INT DEFAULT 0,
    PRIMARY KEY(ID)
);

INSERT INTO GeneralParameters
(
    MemberShipFees,
    RotarianYear,
    MinimumThreshold
)
VALUES
(
    50, --MemberShipFees
    N'2019/2020', --RotarianYear
    0 --MinimumThreshold
)

CREATE TABLE Treasury
(
    ID INT IDENTITY,
    CurrentAmount FLOAT,
    DateOfChange DATETIME DEFAULT GETDATE(),

    PRIMARY KEY(ID)
);

CREATE TABLE Fees
(
    ID INT IDENTITY,
    MemberID INT,
    PaidAmount INT CHECK(PaidAmount > 0),
    PaymentMonth NVARCHAR(10),
    PaymentYear NVARCHAR(10)
    PRIMARY KEY(ID),
    FOREIGN KEY(MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE Payments
(
    ID INT IDENTITY,
    PaidAmount INT CHECK(PaidAmount > 0),
    PaymentDate DATETIME DEFAULT GETDATE(),
    RecieverOfPayment NVARCHAR(100),

    PRIMARY KEY(ID),

);