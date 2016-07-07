/****** Object:  StoredProcedure [dbo].[GetBusinessNames]    Script Date: 08/16/2013 12:09:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBusinessNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetBusinessNames]
GO
/****** Object:  StoredProcedure [dbo].[GetBusinessNames]    Script Date: 08/16/2013 12:09:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetBusinessNames]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[GetBusinessNames]
@string varchar(50)
AS

Select distinct id, businessName
from Business
where businessName like ''%'' + @string + ''%''
and isDeleted = 0
order by businessName



' 
END
GO