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
    ('Past-President', 'Past-President'),
    --1
    ('President', 'President'),
    --2
    ('Vice President', 'Vice President'),
    --3
    ('Secretary', 'Secretary'),
    --4
    ('Treasurer', 'Treasurer'),
    --5
    ('Public Relations', 'Public Relations'),
    --6
    ('Fundraising', 'Fundraising'),
    --7
    ('International', 'International'),
    --8
    ('Community', 'Community'),
    --9
    ('Club Service', 'Club Service'),
    --10
    ('Member', 'Member')
    --11

CREATE TABLE Members
(
    MemberID Int IDENTITY,
    --1
    ID NVARCHAR(14) UNIQUE NOT NULL,
    --2
    FName NVARCHAR(64),
    --3
    LName NVARCHAR(64),
    --4
    BirthDate DATETIME DEFAULT GETDATE(),
    --5
    Age as DATEDIFF(YEAR, BirthDate, GETDATE()),
    --6
    Mail NVARCHAR(100) UNIQUE NOT NULL,
    --7
    MemberPassword NVARCHAR(250),
    --8
    YearsInClub NVARCHAR(2) DEFAULT '0',
    --9
    PositionID INT,
    --10
    MemberStatus NVARCHAR(2) DEFAULT '00',
    --11
    LogInStatus NVARCHAR(2) DEFAULT '00',
    --12
    RotaryID NVARCHAR(25),
    --13

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

CREATE TABLE MemberPositions
(
    ID INT IDENTITY,

    PRIMARY KEY(ID)
);

CREATE TABLE Treasury
(
    ID INT IDENTITY,
    CurrentAmount INT,
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


-- FOR TESTING PURPOSES ONLY
INSERT INTO Members
    (
    ID,
    FName,
    LName,
    Mail,
    MemberPassword,
    YearsInClub,
    PositionID
    )
VALUES
    (
        N'29704090101931',
        N'Amr',
        N'Khaled',
        N'amrkh97@gmail.com',
        N'12345678',
        N'3',
        3
),
    (
        N'32104090101931',
        N'Sondos',
        N'Khaled',
        N'sondoskh99@gmail.com',
        N'12345678',
        N'1',
        11
)

INSERT INTO Treasury
    (
    CurrentAmount
    )
VALUES
    (
        1000
    )
