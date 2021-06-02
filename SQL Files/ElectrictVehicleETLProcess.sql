/*
Script Name:   ElectrictVehicleETLProcess.sql
Author:        Lynn A Pettis
Site:          University of Denver, Data Analytics Boot Camp

Purpose of this script is complete the the ETL process started in the pndas_etl Jupyter Notebook.

The script will complete a full truncate/delete of all data currently in the EVData database then reload the data
from the csv and json text files.

Starting with the csv file as it has the most data to import and multiple lookup tables to populate.

First the the data in the csv file is staged to a staging table which is then used to complete the multiple steps needed
to populate the Make, Model, PowerTrain, BodyStyle, and PlugType lookup tables that were identified to reduce storing
redundant data in the main Vehicle table.

To facilitate the importing of the csv file, a view was created to accomplish parsing the Model and TrimPackage information
stored in the Model column of the file.

After populating the lookup tables, the staging table is then joined to the lookup tables to provide the id values for the main table.

Once the csv file is loaded it is time to work with the json file.

A JSON file was selected for the output from the web scraper utility as it seemed the easiest means of providing the data in a readily
usable format.

the first step in using the JSON file is to import the data using the openrowset system function to read the file and populate a string
variable in MS SQL Server 2019.  From there it is a simple matter to shred the JSON document using OPENJSON which provides a result set
that can be used directly parse and load the data.

Similarly to the csv file, the Make and Model of the vehicles were seperated and loaded in the the existing Make and Model tables if the
data does not already exist in the tables.  Capturing the current maximum value id values in the Make and Model tables insured that duplicate
keys would not be written to the tables.

As with the csv file, the JSON file also uses the Make and Model tables to populate the appropriate key values in the CDData table that holds
the data from the Car and Driver web site.

As the Make, Model, and Trim data is stored in a single column, and the data is much simplier than the data stored in the csv file, it was
a simple matter to split the data using the DelimitedSplit8K_LEAD inline table valued function.  This function was originally downloaded from
SQLServerCentral.com many years ago and the other of this version is currently unknown.  It was based on the original work of Jeff Moden which
can also be found on SQLServerCentral.com.  When working with varchar strings upto 8000 characters this function is comparable to many CLR
splitter functions that can be found on the internet.

*/

/* truncate or delete the data currently in the database if any */

truncate table dbo.EVStage;
truncate table dbo.CDStage;
delete from dbo.VehicleData;
delete from dbo.CarData;
delete from dbo.Make;
delete from dbo.Model;
delete from dbo.PowerTrain;
delete from dbo.BodyStyle;
delete from dbo.PlugType;

go

/* insert the data from the csv file in the resource directory.  The full path is used here. */

bulk insert dbo.EVStage
from 'C:\Users\lapet\Documents\Data Analytics Boot Camp\WeGotNoGasETL\Resources\ev_csv_transformed.csv'
with (firstrow = 2, format = 'csv');

/* Using CTEs (Common Table Expressions) to pull the distinct Make, Model, PowerTrain, BodyStyle, and PlugType
   information from the file to store in the lookup tables.  The ROW_NUMBER function is used to generate the
   id values to be used in the tables. */

with Makes as (select distinct Make from dbo.EVStaging)
insert into dbo.Make
select row_number() over (order by Make) as MakeID, Make from Makes;

with Models as (select distinct Model from dbo.EVStaging)
insert into dbo.Model
select row_number() over (order by Model) as ModelID, Model from Models;

with PowerTrains as (select distinct PowerTrain from dbo.EVStaging)
insert into dbo.PowerTrain
select row_number() over (order by PowerTrain) as PowerTrainID, PowerTrain from PowerTrains;

with BodyStyles as (select distinct BodyStyle from dbo.EVStaging)
insert into dbo.BodyStyle
select row_number() over (order by BodyStyle) as BodyStyleID, BodyStyle from BodyStyles;

with PlugTypes as (select distinct PlugType from dbo.EVStaging)
insert into dbo.PlugType
select row_number() over (order by PlugType) as PlugTypeID, PlugType from PlugTypes;

/* Once the lookup tables are populated, we can then load the main data table.  At this point the conversion of data is actually handled. */

insert into dbo.VehicleData(VehicleDataID, TrimPackage, AccelSec, Top_speed_mph, Range_miles, Seats, MakeID, ModelID, PowerTrainID, BodyStyleID, PlugTypeID)
select
  VehicleDataID = ROW_NUMBER() over (order by mk.MakeID, md.ModelID, pt.PowerTrainID, bs.BodyStyleID, plt.PlugType)
  , evs.TrimPackage
  , cast(evs.AccelSec as decimal(4,1))
  , cast(cast(evs.TopSpeed_mph as decimal(10,2)) as int)
  , cast(cast(evs.Range_miles as decimal(10,2)) as int)
  , cast(evs.Seats as int)
  , mk.MakeID
  , md.ModelID
  , pt.PowerTrainID
  , bs.BodyStyleID
  , plt.PlugTypeID
from
  dbo.EVStaging evs
  inner join dbo.Make mk
    on evs.Make = mk.Make
  inner join dbo.Model md
    on evs.Model = md.Model
  inner join dbo.PowerTrain pt
    on evs.PowerTrain = pt.PowerTrain
  inner join dbo.BodyStyle bs
    on evs.BodyStyle = bs.BodyStyle
  inner join dbo.PlugType plt
    on evs.PlugType = plt.PlugType;

/* Display the data for a visual confirmation the data was properly imported */

select * from dbo.VehicleData;


/* Now begin the import of the JSON file to the database */

declare @TestJson nvarchar(max);

set @TestJson = (select * from openrowset(bulk 'C:\Users\lapet\Documents\Data Analytics Boot Camp\WeGotNoGasETL\Resources\CarAndDriver.json', single_clob) as import);

/* verify the data imported is aproperly formatted JSON document. As we are not using JSON schemas, there is currently no other form of validation beyod a visual check */

select ISJSON(@TestJson);

insert into dbo.CDStage
select
    Make = dt.Item1
    , Model = case when dt.Item1 = 'Tesla' then concat_ws(' ',dt.Item2,dt.Item3) else dt.Item2 end
    , TrimPackage = case when dt.Item1 = 'Tesla' then '' else isnull(dt.Item3,'') end
    , BasePrice = rtrim(ltrim(oj.BasePrice))
    , EPAFuelEconomy = rtrim(ltrim(oj.EPAFuelEconomy))
    , EPARange = rtrim(ltrim(oj.EPARange ))
from openjson(@TestJson)
with (
        Vehicle varchar(32) '$.vehicle',
        BasePrice varchar(12) '$.baseprice',
        EPAFuelEconomy varchar(24) '$.epafueleconomy',
        EPARange varchar(16) '$.eparange'
) oj
cross apply (select
               max(case when ItemNumber = 1 then Item else null end) as Item1
               , max(case when ItemNumber = 2 then Item else null end) as Item2
               , max(case when ItemNumber = 3 then Item else null end) as Item3
             from [dbo].[DelimitedSplit8K_LEAD](rtrim(ltrim(case when oj.Vehicle like 'Mini%' then replace(oj.Vehicle, 'Mini ','Mini Cooper ') else oj.Vehicle end )),' ')) dt;

with Makes as (
select distinct
  Make
from
  dbo.CDStage
),
MaxMakeID as (
select
  MaxMakeID = max(MakeID)
from
  dbo.Make
)
insert into dbo.Make(MakeID, Make)
select
  MakeID = ROW_NUMBER() over (order by Make) + dt.MaxMakeID
  , Make
from
  Makes mks
  cross apply (select MaxMakeID from MaxMakeID) dt
where
  not exists(select 1 from dbo.Make mk where mk.Make = mks.Make);

with Models as (
select distinct Model
from
  dbo.CDStage
),
MaxModelID as (
select
  MaxModelID = max(ModelID)
from
  dbo.Model
)
insert into dbo.Model(ModelID, Model)
select
  ModelID = ROW_NUMBER() over (order by Model) + dt.MaxModelID
  , Model
from
  Models mds
  cross apply (select MaxModelID from MaxModelID) dt
where
  not exists(select 1 from dbo.Model md where md.Model = mds.Model);

insert into dbo.CarData(CarDataID, MakeID, ModelID, TrimPackage, BasePrice, EPAFuelEconomy, EPARange)
select
  CarDataID = ROW_NUMBER() over (order by mk.MakeID, md.ModelID)
  , mk.MakeID
  , md.ModelID
  , cds.TrimPackage
  , cds.BasePrice
  , cds.EPAFuelEconomy
  , cds.EPARange
from
  dbo.CDStage cds
  inner join dbo.Make mk
    on mk.Make = cds.Make
  inner join dbo.Model md
    on md.Model = cds.Model;

select * from dbo.CarData;

/* show on means of joining the data between the Vehicle and CDData tables.  This join will return data the exists in both tables, linking the CDData to multiple
   records of the same make and model in the Vehicle table. */

select
  mk.Make
  , md.Model
  , plt.PlugType
  , pt.PowerTrain
  , bs.BodyStyle
  , vd.TrimPackage as VTrimPackage
  , cd.TrimPackage as CTrimPackage
  , vd.AccelSec
  , vd.Top_speed_mph
  , vd.Range_miles
  , cd.BasePrice
  , cd.EPAFuelEconomy as 'Fuel Economy (combined/city/highway)'
  , cd.EPARange
from
  dbo.VehicleData vd
  inner join dbo.CarData cd
    on vd.MakeID = cd.MakeID and vd.ModelID = cd.ModelID
  inner join dbo.Make mk
    on vd.MakeID = mk.MakeID
  inner join dbo.Model md
    on vd.ModelID = md.ModelID
  inner join dbo.PlugType plt
    on vd.PlugTypeID = plt.PlugTypeID
  inner join dbo.PowerTrain pt
    on vd.PowerTrainID = pt.PowerTrainID
  inner join dbo.BodyStyle bs
    on vd.BodyStyleID = bs.BodyStyleID;


