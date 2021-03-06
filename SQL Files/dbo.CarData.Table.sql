USE [EVData]
GO
/****** Object:  Table [dbo].[CarData]    Script Date: 6/2/2021 4:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarData](
	[CarDataID] [int] NOT NULL,
	[MakeID] [smallint] NOT NULL,
	[ModelID] [smallint] NOT NULL,
	[BasePrice] [varchar](10) NOT NULL,
	[EPAFuelEconomy] [varchar](16) NOT NULL,
	[EPARange] [varchar](12) NOT NULL,
	[TrimPackage] [varchar](10) NOT NULL,
 CONSTRAINT [PK_CarData] PRIMARY KEY CLUSTERED 
(
	[CarDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Data]
) ON [Data]
GO
ALTER TABLE [dbo].[CarData]  WITH CHECK ADD  CONSTRAINT [FK_CarData_Make] FOREIGN KEY([MakeID])
REFERENCES [dbo].[Make] ([MakeID])
GO
ALTER TABLE [dbo].[CarData] CHECK CONSTRAINT [FK_CarData_Make]
GO
ALTER TABLE [dbo].[CarData]  WITH CHECK ADD  CONSTRAINT [FK_CarData_Model] FOREIGN KEY([ModelID])
REFERENCES [dbo].[Model] ([ModelID])
GO
ALTER TABLE [dbo].[CarData] CHECK CONSTRAINT [FK_CarData_Model]
GO
