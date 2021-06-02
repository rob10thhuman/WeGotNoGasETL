USE [EVData]
GO

/****** Object:  View [dbo].[EVStaging]    Script Date: 6/2/2021 3:43:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[EVStaging] as
select
    Make
    , Model = rtrim(ltrim(case
                              when Make in ('Kia','Nissan','Volkswagen') then replace(substring(Model,1,charindex(' ',Model)-1),'e-','')
                              when Make = 'Tesla' then case when Model like 'Model%' then substring(Model,1,charindex(' ',Model,charindex(' ',Model)+1)) else substring(Model,1,charindex(' ',Model)-1) end
                              else substring(Model,1,charindex(' ',Model)-1)
                          end))
    , TrimPackage = rtrim(ltrim(case
                                    when Make = 'Tesla' and Model like 'Model%' then substring(Model,charindex(' ',Model,charindex(' ',Model)+1),len(Model)) else substring(Model,charindex(' ',Model),len(Model))
                                end))
    , PowerTrain
    , BodyStyle
    , Seats
    , PlugType
    , TopSpeed_mph
    , Range_miles
    , AccelSec
from
   dbo.EVStage;
GO


