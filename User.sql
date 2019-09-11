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