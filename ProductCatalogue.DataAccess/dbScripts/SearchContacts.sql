/****** Object:  StoredProcedure [dbo].[SearchContacts]    Script Date: 08/16/2013 12:09:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchContacts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SearchContacts]
GO

/****** Object:  StoredProcedure [dbo].[SearchContacts]    Script Date: 08/16/2013 12:09:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchContacts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[SearchContacts]
@contactId int,
@firstName varchar(50),
@lastName varchar(50),
@telephone varchar(50),
@email varchar(50),
@businessName varchar(50),
@communityName varchar(50),
@filterLetter varchar(1)

AS

SELECT c.id as contactId, c.firstName as firstName, c.lastName as lastName, c.contactTypeId, c.isPrimary, thePhone.phoneNumber as phoneNumber, c.email as email, c.jobTitle as jobTitle
from Contact c
JOIN Business b ON c.businessId = b.id
outer apply
(
    select top 1 ip.*
    from ContactPhone icp
    JOIN Phone ip ON icp.phoneId = ip.id
    where ip.phoneTypeId = 1 and icp.contactId = c.id
) thePhone
where c.isDeleted = 0
and (@contactId = c.id OR ISNULL(@contactId,-1) = -1)
and (c.firstName like ''%'' + @firstName + ''%'' OR ISNULL(@firstName,'''') = '''')
and (c.lastName like ''%'' + @lastName + ''%'' OR ISNULL(@lastName,'''') = '''')
and (c.email like ''%'' + @email + ''%'' OR ISNULL(@email,'''') = '''')
and ( (ISNULL(@businessName,'''') = '''')  OR (b.businessName like ''%'' + @businessName + ''%'') )
and (c.lastName like @filterLetter + ''%'' or ISNULL(@filterLetter,'''') = '''')
and ( ISNULL(@telephone,'''') = '''' OR exists (select 1 from Phone p JOIN ContactPhone cp ON p.id = cp.phoneId where cp.contactId = c.id and p.phoneNumber like ''%'' + @telephone + ''%''))
and ( ISNULL(@communityName,'''') = '''' OR exists (select 1 from Address a JOIN ContactAddress ca ON a.id = ca.addressId where ca.contactId = c.id and a.city like ''%'' + @communityName + ''%''))
order by c.lastName

' 
END
GO