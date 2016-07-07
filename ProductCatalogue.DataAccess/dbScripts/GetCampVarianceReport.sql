/****** Object:  StoredProcedure [dbo].[GetCampVarianceReport]    Script Date: 08/16/2013 12:09:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCampVarianceReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCampVarianceReport]
GO

/****** Object:  StoredProcedure [dbo].[GetCampVarianceReport]    Script Date: 08/16/2013 12:09:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCampVarianceReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[GetCampVarianceReport] 
@startMonth int,
@startYear int,
@endMonth int,
@endYear int,
@variance int,
@varianceByAmount bit

AS

Select c.id, c.licenseNumber, c.productName, a.totalUnitsSold as startUnitsSold, b.totalUnitsSold as endUnitsSold, cast(Round((case a.totalUnitsSold when 0 then (case b.totalUnitsSold when 0 then 0 else 9.99 end) else (b.totalUnitsSold - a.totalUnitsSold)/cast(a.totalUnitsSold as numeric) end)*100, 2) as numeric(8,2)) as percentageDifference, b.totalUnitsSold - a.totalUnitsSold as amountDifference
FROM 
(
Select ((co.seasonalSold * co.daysOpen) + co.shortTermSold) as totalUnitsSold, co.productId
from CampgroundOccupancy co
where year(co.reportDate) = @startYear and MONTH(co.reportDate) = @startMonth
) a
JOIN (
Select ((co.seasonalSold * co.daysOpen) + co.shortTermSold) as totalUnitsSold, co.productId
from CampgroundOccupancy co
where year(co.reportDate) = @endYear and MONTH(co.reportDate) = @endMonth
) b on a.productId = b.productId
JOIN Product c on a.productId = c.id
where (@varianceByAmount = 1 and abs(a.totalUnitsSold - b.totalUnitsSold) > @variance) OR
	  (@varianceByAmount = 0 and cast(Round((case a.totalUnitsSold when 0 then (case b.totalUnitsSold when 0 then 0 else 1 end) else (b.totalUnitsSold - a.totalUnitsSold)/cast(a.totalUnitsSold as numeric) end)*100, 2) as numeric(8,2)) > @variance)
 
order by c.licenseNumber



' 
END
GO