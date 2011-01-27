--
-- Dropping table tblblogcategories : 
-- 

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblblogcategories]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblblogcategories]
GO

--
-- Dropping table tblblogcomments : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblblogcomments]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblblogcomments]
GO

--
-- Dropping table tblblogentries : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblblogentries]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblblogentries]
GO

--
-- Dropping table tblblogentriescategories : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblblogentriescategories]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblblogentriescategories]
GO

--
-- Dropping table tblblogentriesrelated : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblblogentriesrelated]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblblogentriesrelated]
GO

--
-- Dropping table tblblogpages : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblblogpages]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblblogpages]
GO

--
-- Dropping table tblblogroles : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblblogroles]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblblogroles]
GO

--
-- Dropping table tblblogsearchstats : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblblogsearchstats]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblblogsearchstats]
GO

--
-- Dropping table tblblogsubscribers : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblblogsubscribers]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblblogsubscribers]
GO

--
-- Dropping table tblblogtextblocks : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblblogtextblocks]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblblogtextblocks]
GO

--
-- Dropping table tbluserroles : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tbluserroles]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tbluserroles]
GO

--
-- Dropping table tblusers : 
--

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[tblusers]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[tblusers]
GO

--
-- Definition for table tblblogcategories : 
--

CREATE TABLE [dbo].[tblblogcategories] (
  [categoryid] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [categoryname] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [categoryalias] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [blog] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tblblogcomments : 
--

CREATE TABLE [dbo].[tblblogcomments] (
  [id] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [entryidfk] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [name] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [email] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [comment] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [posted] datetime NULL,
  [subscribe] tinyint NULL,
  [website] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [moderated] tinyint NULL,
  [subscribeonly] tinyint NULL,
  [killcomment] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tblblogentries : 
--

CREATE TABLE [dbo].[tblblogentries] (
  [id] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [title] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [body] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [posted] datetime NULL,
  [morebody] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [alias] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [username] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [blog] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [allowcomments] tinyint NULL,
  [enclosure] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [filesize] int NULL,
  [mimetype] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [views] int NULL,
  [released] tinyint NULL,
  [mailed] tinyint NULL,
  [summary] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [subtitle] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [keywords] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [duration] nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tblblogentriescategories : 
--

CREATE TABLE [dbo].[tblblogentriescategories] (
  [categoryidfk] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [entryidfk] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tblblogentriesrelated : 
--

CREATE TABLE [dbo].[tblblogentriesrelated] (
  [entryid] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [relatedid] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tblblogpages : 
--

CREATE TABLE [dbo].[tblblogpages] (
  [id] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [blog] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [title] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [alias] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [body] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [showlayout] tinyint NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tblblogroles : 
--

CREATE TABLE [dbo].[tblblogroles] (
  [id] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [role] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [description] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tblblogsearchstats : 
--

CREATE TABLE [dbo].[tblblogsearchstats] (
  [searchterm] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [searched] datetime NULL,
  [blog] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tblblogsubscribers : 
--

CREATE TABLE [dbo].[tblblogsubscribers] (
  [email] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [token] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [blog] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [verified] tinyint NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tblblogtextblocks : 
--

CREATE TABLE [dbo].[tblblogtextblocks] (
  [id] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [label] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [body] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [blog] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tbluserroles : 
--

CREATE TABLE [dbo].[tbluserroles] (
  [username] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [roleidfk] nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [blog] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for table tblusers : 
--

CREATE TABLE [dbo].[tblusers] (
  [username] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [password] nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [salt] nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [name] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [blog] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
ON [PRIMARY]
GO

--
-- Definition for indices : 
--

ALTER TABLE [dbo].[tblblogcategories]
ADD PRIMARY KEY CLUSTERED ([categoryid])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogcategories_blogCategories_blog] ON [dbo].[tblblogcategories]
  ([blog])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogcategories_blogCategories_categoryalias] ON [dbo].[tblblogcategories]
  ([categoryalias])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogcategories_blogCategories_categoryname] ON [dbo].[tblblogcategories]
  ([categoryname])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblblogcomments]
ADD PRIMARY KEY CLUSTERED ([id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogcomments_blogComments_email] ON [dbo].[tblblogcomments]
  ([email])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogcomments_blogComments_entryid] ON [dbo].[tblblogcomments]
  ([entryidfk])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogcomments_blogComments_moderated] ON [dbo].[tblblogcomments]
  ([moderated])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogcomments_blogComments_name] ON [dbo].[tblblogcomments]
  ([name])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogcomments_blogComments_posted] ON [dbo].[tblblogcomments]
  ([posted])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblblogentries]
ADD PRIMARY KEY CLUSTERED ([id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogentries_blogEntries_alias] ON [dbo].[tblblogentries]
  ([alias])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogentries_blogEntries_blog] ON [dbo].[tblblogentries]
  ([blog])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogentries_blogEntries_posted] ON [dbo].[tblblogentries]
  ([posted])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogentries_blogEntries_released] ON [dbo].[tblblogentries]
  ([released])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogentries_blogEntries_title] ON [dbo].[tblblogentries]
  ([title])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogentries_blogEntries_username] ON [dbo].[tblblogentries]
  ([username])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogentriescategories_blogEntriesCategories_entryidfk] ON [dbo].[tblblogentriescategories]
  ([entryidfk], [categoryidfk])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogentriesrelated_blogEntriesRelated_entryid] ON [dbo].[tblblogentriesrelated]
  ([entryid])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogentriesrelated_blogEntriesRelated_relatedid] ON [dbo].[tblblogentriesrelated]
  ([relatedid])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogpages_blogPages_alias] ON [dbo].[tblblogpages]
  ([alias])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogpages_blogPages_blog] ON [dbo].[tblblogpages]
  ([blog])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogpages_blogPages_title] ON [dbo].[tblblogpages]
  ([title])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblblogroles]
ADD PRIMARY KEY CLUSTERED ([id])
WITH (
  PAD_INDEX = OFF,
  IGNORE_DUP_KEY = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogroles_blogRoles_role] ON [dbo].[tblblogroles]
  ([role])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogsubscribers_blogSubscribers_blog] ON [dbo].[tblblogsubscribers]
  ([blog])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogsubscribers_blogSubscribers_email] ON [dbo].[tblblogsubscribers]
  ([email])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogsubscribers_blogSubscribers_token] ON [dbo].[tblblogsubscribers]
  ([token])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogsubscribers_blogSubscribers_verified] ON [dbo].[tblblogsubscribers]
  ([verified])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogtextblocks_blogTextBlocks_blog] ON [dbo].[tblblogtextblocks]
  ([blog])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblblogtextblocks_blogTextBlocks_label] ON [dbo].[tblblogtextblocks]
  ([label])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tbluserroles_blogUserRoles_blog] ON [dbo].[tbluserroles]
  ([blog])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tbluserroles_blogUserRoles_roleidfk] ON [dbo].[tbluserroles]
  ([roleidfk])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tbluserroles_blogUserRoles_username] ON [dbo].[tbluserroles]
  ([username])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblusers_blogUsers_blog] ON [dbo].[tblusers]
  ([blog])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [tblusers_blogUsers_username] ON [dbo].[tblusers]
  ([username])
WITH (
  PAD_INDEX = OFF,
  DROP_EXISTING = OFF,
  STATISTICS_NORECOMPUTE = OFF,
  SORT_IN_TEMPDB = OFF,
  ONLINE = OFF,
  ALLOW_ROW_LOCKS = ON,
  ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

INSERT INTO [tblblogroles](role,id,description) VALUES ('AddCategory','7F183B27-FEDE-0D6F-E2E9C35DBC7BFF19','The ability to create a new category when editing a blog entry.')
go
INSERT INTO [tblblogroles](role,id,description) VALUES('ManageCategories','7F197F53-CFF7-18C8-53D0C85FCC2CA3F9','The ability to manage blog categories.')
go
INSERT INTO [tblblogroles](role,id,description) VALUES('Admin','7F25A20B-EE6D-612D-24A7C0CEE6483EC2','A special role for the admin. Allows all functionality.')
go
INSERT INTO [tblblogroles](role,id,description) VALUES('ManageUsers','7F26DA6C-9F03-567F-ACFD34F62FB77199','The ability to manage blog users.')
go
INSERT INTO [tblblogroles](role,id,description) VALUES('ReleaseEntries','800CA7AA-0190-5329-D3C7753A59EA2589','The ability to both release a new entry and edit any released entry.')
go

INSERT INTO [tbluserroles] VALUES ('admin','7F25A20B-EE6D-612D-24A7C0CEE6483EC2','Default')
go

insert into [tblUsers](username,password,salt,name,blog) values('admin','74FAE06F4B7BB31F16FA3CB4C873C88FB3669E413603CD103D714CC8C6B153188CEE84D3172F60027D96BAB4A79F275543865C80A927312D5CF00F7DD3F1753A','2XlAbs2fFEESboQCMue3N7yATpwT1QKAFNGIU0hZ35g=','name','Default')
go

