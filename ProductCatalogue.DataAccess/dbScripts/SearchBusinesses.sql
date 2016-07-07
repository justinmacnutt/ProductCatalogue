/****** Object:  StoredProcedure [dbo].[SearchBusinesses]    Script Date: 08/16/2013 12:09:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchBusinesses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SearchBusinesses]
GO

/****** Object:  StoredProcedure [dbo].[SearchBusinesses]    Script Date: 08/16/2013 12:09:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchBusinesses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[SearchBusinesses]
@businessId int,
@businessName varchar(50),
@communityName varchar(50),
@filterLetter varchar(1)

AS

SELECT b.id as businessId, b.businessName, c.id as contactId, c.firstName as contactFirstName, c.lastName as contactLastName, thePhone.phoneNumber as phoneNumber, c.email as email
from Business b
LEFT OUTER JOIN Contact c ON c.businessId = b.id and isnull(c.contactTypeId,1) = 1 
outer apply
(
	select top 1 p.*
	from ContactPhone cp
	JOIN Phone p ON cp.phoneId = p.id
	where p.phoneTypeId = 1 and cp.contactId = c.id
) thePhone
where b.isDeleted = 0
and (@businessId = b.id OR ISNULL(@businessId,-1) = -1)
and (b.businessName like ''%'' + @businessName + ''%'' OR ISNULL(@businessName,'''') = '''')
and (b.businessName like @filterLetter + ''%'' or ISNULL(@filterLetter,'''') = '''')
and ( ISNULL(@communityName,'''') = '''' OR exists (select 1 from Address a JOIN BusinessAddress ba ON a.id = ba.addressId where ba.businessId = b.id and a.city like ''%'' + @communityName + ''%''))
order by b.businessName



' 
END
GO