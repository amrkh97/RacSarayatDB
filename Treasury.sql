USE RAC_SARAYAT
GO

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

