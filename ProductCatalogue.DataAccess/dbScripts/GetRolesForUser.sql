/****** Object:  StoredProcedure [dbo].[GetRolesForUser]    Script Date: 08/16/2013 12:09:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRolesForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetRolesForUser]
GO

/****** Object:  StoredProcedure [dbo].[GetRolesForUser]    Script Date: 08/16/2013 12:09:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRolesForUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[GetRolesForUser]
@username nvarchar(50)
AS
Select roleName
from UserProfile up
JOIN UserProfileRole upr ON up.id = upr.profileId
JOIN UserRole ur ON upr.roleId = ur.id
where up.username = @username

' 
END
GO