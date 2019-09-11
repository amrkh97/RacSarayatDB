USE RAC_SARAYAT
GO

CREATE OR ALTER PROC usp_User_login
@Email NVARCHAR(100),
@Password NVARCHAR(250),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT,
@MemberID INT OUTPUT,
@Privilege INT OUTPUT
AS
BEGIN

IF NOT EXISTS(SELECT * FROM Members WHERE Mail=@Email)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'Wrong Email/Password'
RETURN -1
END


IF NOT EXISTS(SELECT * FROM Members WHERE Mail=@Email AND MemberPassword = @Password)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'Wrong Email/Password'
RETURN -1
END

IF EXISTS( SELECT * FROM Members WHERE Mail=@Email
AND LogInStatus = '01')
BEGIN
SET @HexCode = '02'
SET @HexMsg = 'User is already logged in on another device'
RETURN -1
END

UPDATE Members
SET LogInStatus = '01' --Logged In
WHERE Mail = @Email
AND MemberPassword = @Password
AND LogInStatus = '00' --Was Already Logged Out
AND MemberStatus <> '04' --Suspended

SET @MemberID = (
    SELECT MemberID FROM Members WHERE Mail = @Email
)

SET @Privilege = (
    SELECT PositionID FROM Members WHERE Mail = @Email
)

SET @HexCode = '00'
SET @HexMsg = 'Logged In Successfully'

END
GO

CREATE OR ALTER PROC usp_User_Logout
@Email NVARCHAR(100),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT
AS
BEGIN

IF NOT EXISTS(SELECT * FROM Members WHERE Mail=@Email)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'Wrong Email/Password'
RETURN -1
END

UPDATE Members
SET LogInStatus = '00' --Logged In
WHERE Mail = @Email
AND LogInStatus = '01' --Was Already Logged Out
AND MemberStatus <> '04' --Suspended

SET @HexCode = '00'
SET @HexMsg = 'Logged Out Successfully'

END
GO


CREATE OR ALTER PROC usp_User_ChangeStatus
@MemberID INT,
@NewStatus NVARCHAR(2),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT
AS
BEGIN


IF NOT EXISTS(SELECT * FROM Members WHERE MemberID = @MemberID)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'User Not Found'
RETURN -1
END


IF NOT EXISTS(SELECT * FROM MemberStatus WHERE StatusCode = @NewStatus)
BEGIN
SET @HexCode = '02'
SET @HexMsg = 'Sent Status Is Not Defined'
RETURN -1
END

DECLARE @CurrentStatus NVARCHAR(2)
SET @CurrentStatus = (
    SELECT MemberStatus FROM Members WHERE MemberID =@MemberID
)

IF(@CurrentStatus = @NewStatus)
BEGIN
SET @HexCode = '00'
SET @HexMsg = 'User Is Already: ' + (SELECT StatusMeaning FROM MemberStatus WHERE StatusCode = @CurrentStatus)
END

UPDATE Members
SET MemberStatus = @NewStatus
WHERE MemberID = @MemberID

SET @HexCode ='00'
SET @HexMsg = 'Updated Successfully'
END
GO


CREATE OR ALTER PROC usp_User_AssignPosition
@MemberID INT,
@PositionID INT,
@RotarianYear NVARCHAR(10),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT
AS
BEGIN

IF NOT EXISTS(SELECT * FROM Members WHERE MemberID = @MemberID)
BEGIN
SET @HexCode ='01'
SET @HexMsg = 'Member Does Not Exist, Please Check The ID'
RETURN -1
END

IF NOT EXISTS(SELECT * FROM Positions WHERE ID=@PositionID)
BEGIN
SET @HexCode ='01'
SET @HexMsg = 'Position Does Not Exist'
RETURN -1
END

IF EXISTS(SELECT * FROM MemberPositions WHERE MemberID = @MemberID AND RotarianYear = @RotarianYear
AND MemberPositionID = @PositionID)
BEGIN
SET @HexCode ='01'
SET @HexMsg = 'Member Already Assigned With This Position'
RETURN -1
END

DECLARE @CurrentPosition INT
DECLARE @CurrentRY NVARCHAR(10)

SET @CurrentPosition = (SELECT PositionID FROM Members WHERE MEmberID = @MemberID)
SET @CurrentRY = (SELECT TOP 1 RotarianYear FROM GeneralParameters ORDER BY ID DESC)

IF(@CurrentPosition = @PositionID)
BEGIN
SET @HexCode ='01'
SET @HexMsg = 'Member Already Assigned With This Position'
RETURN -1
END
ELSE
BEGIN

UPDATE Members
SET PositionID = @PositionID
WHERE MemberID = @MemberID 

END

INSERT INTO MemberPositions
(
    MemberID ,
    MemberPositionID ,
    RotarianYear
)
VALUES
(
    @MemberID,
    @PositionID,
    @RotarianYear
)

SET @HexCode = '00'
SET @HexMsg = 'Position Assigned Successfully'
END
GO


CREATE OR ALTER PROC usp_User_GetByPosition
@PositionID INT,
@RY NVARCHAR(10)
AS
BEGIN

IF (@RY IS NULL) -- SELECT LATEST ENTRY IN GENERAL PARAMETERS
BEGIN
SET @RY = (SELECT TOP 1 RotarianYear FROM GeneralParameters ORDER BY ID DESC)
END

SELECT Positions.PositionName,Members.* FROM Members
INNER JOIN Positions
ON Members.PositionID = Positions.ID
INNER JOIN MemberPositions
ON Members.MemberID = MemberPositions.MemberID
WHERE MemberPositions.MemberPositionID = @PositionID AND
MemberPositions.RotarianYear LIKE '%' + @RY + '%'

END
GO

-----------------------------------------------------------------------------------------------------------------

CREATE OR ALTER PROC usp_Fees_Insert
@MemberID INT,
@Amount INT,
@PaymentMonth NVARCHAR(10),
@PaymentYear NVARCHAR(10),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(50) OUTPUT
AS
BEGIN

IF NOT EXISTS(SELECT * FROM Members WHERE MemberID = @MemberID)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'Failed to find user'
RETURN -1
END

IF(@Amount <= 0)
BEGIN
SET @HexCode = '02'
SET @HexMsg = 'Invalid Amount'
RETURN -1
END

INSERT INTO Fees
(
    MemberID,
    PaidAmount,
    PaymentMonth,
    PaymentYear
)
VALUES
(
    @MemberID,
    @Amount,
    @PaymentMonth,
    @PaymentYear
)

INSERT INTO Treasury
(
    CurrentAmount
)
VALUES
(
    @Amount + (SELECT TOP 1 CurrentAmount FROM Treasury ORDER BY ID DESC)
)

SET @HexCode = '00'
SET @HexMsg = 'Successfully Registered'

END
GO


CREATE OR ALTER PROC usp_Treasury_GetByYear
@Year NVARCHAR(10)
AS
BEGIN

SELECT * FROM Treasury
WHERE DATEPART(YEAR, DateOfChange) Like '%' + @Year + '%'

END
GO


CREATE OR ALTER PROC usp_Treasury_GetByMonthAndYear
@Year NVARCHAR(10),
@Month NVARCHAR(10)
AS
BEGIN

SELECT * FROM Treasury
WHERE DATEPART(YEAR, DateOfChange) Like '%' + @Year + '%'
AND DATEPART(MONTH, DateOfChange) = @Month

END
GO

CREATE OR ALTER PROC usp_Payment_Pay
@PaidAmount INT,
@RecieverOfPayment NVARCHAR(100),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(50) OUTPUT
AS
BEGIN

DECLARE @MinimumThreshold INT
SET @MinimumThreshold = (SELECT TOP 1  MinimumThreshold
FROM GeneralParameters ORDER BY ID DESC)

IF(@PaidAmount < 0)
BEGIN
SET @HexCode = '01'
SET @HexMsg = 'You entered a negative amount'
RETURN -1
END
DECLARE @CheckAmount INT
SET @CheckAmount = (SELECT TOP 1 CurrentAmount FROM Treasury ORDER BY ID DESC)-@PaidAmount
IF(@CheckAmount < @MinimumThreshold)
BEGIN
SET @HexCode = '02'
SET @HexMsg = 'Amount Exceeds Currently Allowed Threshold'
RETURN -1
END

INSERT INTO Treasury
(
    CurrentAmount
)
VALUES
(
    @CheckAmount
)

INSERT INTO Payments
(
    PaidAmount,
    RecieverOfPayment
)
VALUES
(
    @PaidAmount,
    @RecieverOfPayment
)


SET @HexCode = '00'
SET @HexMsg = 'Payment Succeeded'
END
GO


CREATE OR ALTER PROC usp_Treasury_GetMembersPaid
@Month NVARCHAR(2),
@Year NVARCHAR(4)
AS
BEGIN

SELECT Members.*,Fees.* FROM Fees
INNER JOIN Members
ON Members.MemberID = Fees.MemberID
WHERE PaymentYear Like '%' + @Year + '%'
AND PaymentMonth = @Month
AND Fees.MemberID IS NOT NULL

END
GO

CREATE OR ALTER PROC usp_Treasury_GetHistoryMember
@MemberID INT
AS
BEGIN

SELECT Members.*,Fees.* FROM Fees
INNER JOIN Members
ON Members.MemberID = Fees.MemberID
AND Fees.MemberID = @MemberID

END
GO

CREATE OR ALTER PROC usp_Treasury_GetHistoryMemberByYear
@MemberID INT,
@Year NVARCHAR(4)
AS
BEGIN

SELECT Members.*,Fees.* FROM Fees
INNER JOIN Members
ON Members.MemberID = Fees.MemberID
AND Fees.MemberID = @MemberID
AND PaymentYear = @Year

END
GO
--------------------------------------------------------------------------------------------------
