USE [EVData]
GO
/****** Object:  Table [dbo].[EVStage]    Script Date: 6/2/2021 4:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVStage](
	[Make] [char](64) NULL,
	[Model] [char](64) NULL,
	[PowerTrain] [char](64) NULL,
	[BodyStyle] [char](64) NULL,
	[Seats] [char](1) NULL,
	[PlugType] [char](64) NULL,
	[TopSpeed_mph] [char](5) NULL,
	[Range_miles] [char](5) NULL,
	[AccelSec] [char](5) NULL
) ON [Data]
GO
