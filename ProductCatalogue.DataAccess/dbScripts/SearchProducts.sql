/****** Object:  StoredProcedure [dbo].[SearchProducts]    Script Date: 08/16/2013 12:09:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchProducts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SearchProducts]
GO

/****** Object:  StoredProcedure [dbo].[SearchProducts]    Script Date: 08/16/2013 12:09:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchProducts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [dbo].[SearchProducts]
@productId int,
@productName varchar(50),
@productTypeId tinyint,
@communityId smallint,
@regionId tinyint,
@checkInId varchar(50),
@fileMakerId varchar(50),
@licenseNumber varchar(50),
@businessName varchar(50),
@contactFirstName varchar(50),
@contactLastName varchar(50),
@filterLetter varchar(1),
@isActive tinyint,
@isValid tinyint,
@overrideErrors tinyint

AS

Select p.id as productId, p.productName as productName, p.productTypeId as productTypeId, rc.communityName, c.id as contactId, c.firstName, c.lastName, b.id as businessId, b.businessName, p.isActive as isActive, p.isValid as isValid, p.overrideErrors as overrideErrors
from Product p
JOIN ContactProduct cp ON p.id = cp.productId and cp.contactTypeId = 1
JOIN Contact c ON cp.contactId = c.id
JOIN Business b ON c.businessId = b.id
LEFT OUTER JOIN refCommunity rc ON p.communityId = rc.id
WHERE p.isDeleted = 0
AND (ISNULL(@productId,0) = 0 OR @productId = p.id)
AND (ISNULL(@productName,'''') = '''' OR p.productName LIKE ''%'' + @productName + ''%'')
AND (ISNULL(@productTypeId,0) = 0 OR p.productTypeId = @productTypeId)
AND (ISNULL(@communityId,0) = 0 OR p.communityId = @communityId)
AND (ISNULL(@regionId,0) = 0 OR rc.regionId = @regionId)
AND (ISNULL(@checkInId,'''') = '''' OR @checkinId = p.checkInId)
AND (ISNULL(@fileMakerId,'''') = '''' OR @filemakerId = p.fileMakerId)
AND (ISNULL(@businessName,'''') = '''' OR b.businessName LIKE ''%'' + @businessName + ''%'')
AND (ISNULL(@contactFirstName,'''') = '''' OR c.firstName LIKE ''%'' + @contactFirstName + ''%'')
AND (ISNULL(@contactLastName,'''') = '''' OR c.lastName LIKE ''%'' + @contactLastName + ''%'')
AND (ISNULL(@filterLetter,'''') = '''' OR p.productName like @filterLetter + ''%'')
AND (@isActive is null OR @IsActive = isActive)
AND (@isValid is null OR @isValid = isValid)
AND (@overrideErrors is null OR @overrideErrors = overrideErrors)
AND (ISNULL(@licenseNumber,'''') = '''' OR @licenseNumber = p.licenseNumber)

order by p.productName


' 
END
GO