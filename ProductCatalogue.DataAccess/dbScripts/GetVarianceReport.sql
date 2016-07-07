
/****** Object:  StoredProcedure [dbo].[GetVarianceReport]    Script Date: 08/16/2013 12:09:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetVarianceReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetVarianceReport]
GO

/****** Object:  StoredProcedure [dbo].[GetVarianceReport]    Script Date: 08/16/2013 12:09:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetVarianceReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[GetVarianceReport] 
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
Select ao.totalUnitsSold, ao.productId
from AccommodationOccupancy ao
where year(ao.reportDate) = @startYear and MONTH(ao.reportDate) = @startMonth
) a
JOIN (
Select ao.totalUnitsSold, ao.productId
from AccommodationOccupancy ao
where year(ao.reportDate) = @endYear and MONTH(ao.reportDate) = @endMonth
) b on a.productId = b.productId
JOIN Product c on a.productId = c.id
where (@varianceByAmount = 1 and abs(a.totalUnitsSold - b.totalUnitsSold) > @variance) OR
	  (@varianceByAmount = 0 and abs(cast(Round((case a.totalUnitsSold when 0 then (case b.totalUnitsSold when 0 then 0 else 1 end) else (b.totalUnitsSold - a.totalUnitsSold)/cast(a.totalUnitsSold as numeric) end)*100, 2) as numeric(8,2))) > @variance)
 
--order by cast (c.licenseNumber as int)
order by amountDifference desc





' 
END
GO