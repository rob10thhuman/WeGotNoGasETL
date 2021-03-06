USE [EVData]
GO
/****** Object:  Table [dbo].[PowerTrain]    Script Date: 6/2/2021 4:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PowerTrain](
	[PowerTrainID] [smallint] NOT NULL,
	[PowerTrain] [char](3) NOT NULL,
 CONSTRAINT [PK_PowerTrain] PRIMARY KEY CLUSTERED 
(
	[PowerTrainID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Data]
) ON [Data]
GO
