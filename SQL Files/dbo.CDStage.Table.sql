USE [EVData]
GO
/****** Object:  Table [dbo].[CDStage]    Script Date: 6/2/2021 4:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CDStage](
	[Make] [char](64) NULL,
	[Model] [char](64) NULL,
	[TrimPackage] [char](64) NULL,
	[BasePrice] [char](64) NULL,
	[EPAFuelEconomy] [char](64) NULL,
	[EPARange] [char](64) NULL
) ON [Data]
GO
