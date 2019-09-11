USE RAC_SARAYAT
GO

CREATE OR ALTER PROC usp_Positions_Add
@PositionName NVARCHAR(100),
@PositionDescription NVARCHAR(500),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT
AS
BEGIN

IF EXISTS(SELECT * FROM Positions WHERE PositionName = @PositionName)
BEGIN
SET @HexCode ='01'
SET @HexMsg = 'Position Already Exists'
RETURN -1
END

INSERT INTO Positions
(
    PositionName,
    PositionDescription
)
VALUES
(
    @PositionName,
    @PositionDescription
)


IF NOT EXISTS(SELECT * FROM Positions WHERE PositionName = @PositionName)
BEGIN
SET @HexCode ='01'
SET @HexMsg = 'Failed To Add Position'
RETURN -1
END


SET @HexCode = '00'
SET @HexMsg = 'Position Added Successfully!'
END
GO


CREATE OR ALTER PROC usp_Positions_GetAll
AS
BEGIN

SELECT * FROM Positions

END
GO

CREATE OR ALTER PROC usp_Positions_EditDescription
@PositionID INT,
@PositionDescription NVARCHAR(500),
@HexCode NVARCHAR(2) OUTPUT,
@HexMsg NVARCHAR(100) OUTPUT
AS
BEGIN

IF NOT EXISTS(SELECT * FROM Positions WHERE ID = @PositionID)
BEGIN
SET @HexCode  = '01'
SET @HexMsg = 'Position Does Not Exist, Check Position ID'
RETURN -1
END

UPDATE Positions
SET PositionDescription = @PositionDescription
WHERE ID = @PositionID

IF NOT EXISTS(SELECT * FROM Positions WHERE ID = @PositionID AND PositionDescription = @PositionDescription)
BEGIN
SET @HexCode  = '01'
SET @HexMsg = 'Position Update Failed!'
RETURN -1
END

SET @HexCode = '00'
SET @HexMsg = 'Description Updated Successfully!'
END
GO