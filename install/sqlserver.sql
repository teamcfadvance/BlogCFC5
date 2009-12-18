/****** Object:  Table [dbo].[tblBlogCategories]    Script Date: 4/28/2006 1:44:48 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblBlogCategories]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblBlogCategories]
GO

/****** Object:  Table [dbo].[tblBlogComments]    Script Date: 4/28/2006 1:44:48 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblBlogComments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblBlogComments]
GO

/****** Object:  Table [dbo].[tblBlogEntries]    Script Date: 4/28/2006 1:44:48 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblBlogEntries]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblBlogEntries]
GO

/****** Object:  Table [dbo].[tblBlogEntriesCategories]    Script Date: 4/28/2006 1:44:48 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblBlogEntriesCategories]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblBlogEntriesCategories]
GO

/****** Object:  Table [dbo].[tblBlogSearchStats]    Script Date: 4/28/2006 1:44:48 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblBlogSearchStats]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblBlogSearchStats]
GO

/****** Object:  Table [dbo].[tblBlogSubscribers]    Script Date: 4/28/2006 1:44:48 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblBlogSubscribers]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblBlogSubscribers]
GO

/****** Object:  Table [dbo].[tblBlogTrackBacks]    Script Date: 4/28/2006 1:44:48 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblBlogTrackBacks]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblBlogTrackBacks]
GO

/****** Object:  Table [dbo].[tblUsers]    Script Date: 4/28/2006 1:44:48 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblUsers]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblUsers]
GO

/****** Object:  Table [dbo].[tblblogentriesrelated]    Script Date: 4/28/2006 1:44:48 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblblogentriesrelated]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblblogentriesrelated]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblblogtextblocks]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblblogtextblocks]
GO

/****** Object:  Table [dbo].[tblblogpages]    Script Date: 7/13/2006 10:02:34 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblblogpages]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblblogpages]
GO

/****** Object:  Table [dbo].[tblBlogCategories]    Script Date: 4/28/2006 1:44:49 PM ******/
CREATE TABLE [dbo].[tblBlogCategories] (
	[categoryid] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[categoryname] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[categoryalias] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[blog] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblBlogComments]    Script Date: 4/28/2006 1:44:49 PM ******/
CREATE TABLE [dbo].[tblBlogComments] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[entryidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[comment] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[posted] [datetime] NULL ,
	[subscribe] [bit] NULL ,
	[website] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[moderated] [bit] NULL,
	[killcomment] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[subscribeonly] [bit] NULL 	
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblBlogEntries]    Script Date: 4/28/2006 1:44:49 PM ******/
CREATE TABLE [dbo].[tblBlogEntries] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[body] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[posted] [datetime] NULL ,
	[morebody] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[alias] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[username] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[blog] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[allowcomments] [bit] NULL ,
	[enclosure] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[filesize] [numeric](18, 0) NULL ,
	[mimetype] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[views] [int] NULL ,
	[released] [bit] NULL ,
	[mailed] [bit] NULL,
	[summary] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[subtitle] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[keywords] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[duration] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblBlogEntriesCategories]    Script Date: 4/28/2006 1:44:49 PM ******/
CREATE TABLE [dbo].[tblBlogEntriesCategories] (
	[categoryidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[entryidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblBlogSearchStats]    Script Date: 4/28/2006 1:44:49 PM ******/
CREATE TABLE [dbo].[tblBlogSearchStats] (
	[searchterm] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[searched] [datetime] NOT NULL ,
	[blog] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblBlogSubscribers]    Script Date: 4/28/2006 1:44:49 PM ******/
CREATE TABLE [dbo].[tblBlogSubscribers] (
	[email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[token] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[blog] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[verified] [bit] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblBlogTrackBacks]    Script Date: 4/28/2006 1:44:50 PM ******/
CREATE TABLE [dbo].[tblBlogTrackBacks] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[blogname] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[posturl] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[excerpt] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[created] [datetime] NOT NULL ,
	[entryid] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[blog] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblUsers]    Script Date: 4/28/2006 1:44:50 PM ******/
CREATE TABLE [dbo].[tblUsers] (
	[username] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[password] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[blog] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 	
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblblogentriesrelated]    Script Date: 4/28/2006 1:44:50 PM ******/
CREATE TABLE [dbo].[tblblogentriesrelated] (
	[entryid] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[relatedid] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblBlogCategories] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblBlogCategories] PRIMARY KEY  CLUSTERED 
	(
		[categoryid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tblBlogComments] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblBlogComments] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tblBlogEntries] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblBlogEntries] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tblBlogEntriesCategories] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblBlogEntriesCategories] PRIMARY KEY  CLUSTERED 
	(
		[categoryidfk],
		[entryidfk]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tblBlogTrackBacks] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblTrackBacks] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tblBlogComments] ADD 
	CONSTRAINT [DF_tblBlogComments_subscribe] DEFAULT (0) FOR [subscribe]
GO

ALTER TABLE [dbo].[tblBlogEntries] ADD 
	CONSTRAINT [DF_tblBlogEntries_allowcomments] DEFAULT (1) FOR [allowcomments],
	CONSTRAINT [DF_tblBlogEntries_views] DEFAULT (0) FOR [views]
GO

/****** Object:  Table [dbo].[tblblogtextblocks]    Script Date: 7/13/2006 10:02:34 PM ******/
CREATE TABLE [dbo].[tblblogtextblocks] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[label] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[body] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[blog] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tblblogpages]    Script Date: 7/13/2006 10:02:35 PM ******/
CREATE TABLE [dbo].[tblblogpages] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[blog] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[alias] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[body] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[showlayout] [bit] NULL
	 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblblogtextblocks] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblblogtextblocks] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tblblogpages] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblblogpages] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO


CREATE TABLE dbo.tblblogroles
	(
	role nvarchar(50) NOT NULL,
	id nvarchar(35) NOT NULL,
	description nvarchar(255) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tblblogroles ADD CONSTRAINT
	PK_Table_1 PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

INSERT INTO [dbo].[tblblogroles](role,id,description) VALUES ('AddCategory','7F183B27-FEDE-0D6F-E2E9C35DBC7BFF19','The ability to create a new category when editing a blog entry.')
go
INSERT INTO [dbo].[tblblogroles](role,id,description) VALUES('ManageCategories','7F197F53-CFF7-18C8-53D0C85FCC2CA3F9','The ability to manage blog categories.')
go
INSERT INTO [dbo].[tblblogroles](role,id,description) VALUES('Admin','7F25A20B-EE6D-612D-24A7C0CEE6483EC2','A special role for the admin. Allows all functionality.')
go
INSERT INTO [dbo].[tblblogroles](role,id,description) VALUES('ManageUsers','7F26DA6C-9F03-567F-ACFD34F62FB77199','The ability to manage blog users.')
go
INSERT INTO [dbo].[tblblogroles](role,id,description) VALUES('ReleaseEntries','800CA7AA-0190-5329-D3C7753A59EA2589','The ability to both release a new entry and edit any released entry.')
go

CREATE TABLE dbo.tbluserroles
	(
	username nvarchar(50) NOT NULL,
	roleidfk nvarchar(35) NOT NULL,
	blog nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO

INSERT INTO [dbo].[tbluserroles] VALUES ('admin','7F25A20B-EE6D-612D-24A7C0CEE6483EC2','Default')
go

insert into [dbo].[tblUsers](username,password,name,blog) values('admin','admin','name','Default')
go

