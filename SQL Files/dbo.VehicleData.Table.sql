USE [EVData]
GO
/****** Object:  Table [dbo].[VehicleData]    Script Date: 6/2/2021 4:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleData](
	[VehicleDataID] [int] NOT NULL,
	[TrimPackage] [varchar](50) NULL,
	[AccelSec] [decimal](4, 1) NOT NULL,
	[Top_speed_mph] [int] NOT NULL,
	[Range_miles] [int] NOT NULL,
	[PowerTrainID] [smallint] NOT NULL,
	[MakeID] [smallint] NOT NULL,
	[ModelID] [smallint] NOT NULL,
	[BodyStyleID] [smallint] NOT NULL,
	[PlugTypeID] [smallint] NOT NULL,
	[Seats] [int] NOT NULL,
 CONSTRAINT [PK_VehicleData] PRIMARY KEY CLUSTERED 
(
	[VehicleDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Data]
) ON [Data]
GO
ALTER TABLE [dbo].[VehicleData]  WITH CHECK ADD  CONSTRAINT [FK_VehicleData_BodyStyle] FOREIGN KEY([BodyStyleID])
REFERENCES [dbo].[BodyStyle] ([BodyStyleID])
GO
ALTER TABLE [dbo].[VehicleData] CHECK CONSTRAINT [FK_VehicleData_BodyStyle]
GO
ALTER TABLE [dbo].[VehicleData]  WITH CHECK ADD  CONSTRAINT [FK_VehicleData_Make] FOREIGN KEY([MakeID])
REFERENCES [dbo].[Make] ([MakeID])
GO
ALTER TABLE [dbo].[VehicleData] CHECK CONSTRAINT [FK_VehicleData_Make]
GO
ALTER TABLE [dbo].[VehicleData]  WITH CHECK ADD  CONSTRAINT [FK_VehicleData_Model] FOREIGN KEY([ModelID])
REFERENCES [dbo].[Model] ([ModelID])
GO
ALTER TABLE [dbo].[VehicleData] CHECK CONSTRAINT [FK_VehicleData_Model]
GO
ALTER TABLE [dbo].[VehicleData]  WITH CHECK ADD  CONSTRAINT [FK_VehicleData_PlugType] FOREIGN KEY([PlugTypeID])
REFERENCES [dbo].[PlugType] ([PlugTypeID])
GO
ALTER TABLE [dbo].[VehicleData] CHECK CONSTRAINT [FK_VehicleData_PlugType]
GO
ALTER TABLE [dbo].[VehicleData]  WITH CHECK ADD  CONSTRAINT [FK_VehicleData_PowerTrain] FOREIGN KEY([PowerTrainID])
REFERENCES [dbo].[PowerTrain] ([PowerTrainID])
GO
ALTER TABLE [dbo].[VehicleData] CHECK CONSTRAINT [FK_VehicleData_PowerTrain]
GO
