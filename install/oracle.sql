--
-- Dropping table tblblogcategories : 
--
 
DROP TABLE tblblogcategories;

--
-- Dropping table tblblogcomments : 
--

DROP TABLE tblblogcomments;

--
-- Dropping table tblblogentries : 
--

DROP TABLE tblblogentries;

--
-- Dropping table tblblogentriescategories : 
--

DROP TABLE tblblogentriescategories;

--
-- Dropping table tblblogentriesrelated : 
--

DROP TABLE tblblogentriesrelated;

--
-- Dropping table tblblogpages : 
--

DROP TABLE tblblogpages;

--
-- Dropping table tblblogroles : 
--

DROP TABLE tblblogroles;

--
-- Dropping table tblblogsearchstats : 
--

DROP TABLE tblblogsearchstats;

--
-- Dropping table tblblogsubscribers : 
--

DROP TABLE tblblogsubscribers;

--
-- Dropping table tblblogtextblocks : 
--

DROP TABLE tblblogtextblocks;

--
-- Dropping table tbluserroles : 
--

DROP TABLE tbluserroles;

--
-- Dropping table tblusers : 
--

DROP TABLE tblusers;

--
-- Definition for table tblblogcategories : 
--

CREATE TABLE tblblogcategories (
  categoryid VARCHAR2(35) NOT NULL,
  categoryname VARCHAR2(50) NULL,
  categoryalias VARCHAR2(50) NULL,
  blog VARCHAR2(50) NULL
)
;

--
-- Definition for table tblblogcomments : 
--

CREATE TABLE tblblogcomments (
  id VARCHAR2(35) NOT NULL,
  entryidfk VARCHAR2(35) NULL,
  name VARCHAR2(50) NULL,
  email VARCHAR2(50) NULL,
  comments VARCHAR2(2000) NULL,
  posted DATE NULL,
  subscribe NUMBER(10) NULL,
  website VARCHAR2(255) NULL,
  moderated NUMBER(3) NULL,
  subscribeonly NUMBER(3) NULL,
  killcomment VARCHAR2(35) NULL
)
;

--
-- Definition for table tblblogentries : 
--

CREATE TABLE tblblogentries (
  id VARCHAR2(35) NOT NULL,
  title VARCHAR2(100) NULL,
  body VARCHAR2(2000) NULL,
  posted DATE NULL,
  morebody VARCHAR2(2000) NULL,
  alias VARCHAR2(100) NULL,
  username VARCHAR2(50) NULL,
  blog VARCHAR2(50) NULL,
  allowcomments NUMBER(3) NULL,
  enclosure VARCHAR2(255) NULL,
  filesize NUMBER(10) NULL,
  mimetype VARCHAR2(255) NULL,
  views NUMBER(10) NULL,
  released NUMBER(3) NULL,
  mailed NUMBER(3) NULL,
  summary VARCHAR2(255) NULL,
  subtitle VARCHAR2(100) NULL,
  keywords VARCHAR2(100) NULL,
  duration VARCHAR2(10) NULL
)
;

--
-- Definition for table tblblogentriescategories : 
--

CREATE TABLE tblblogentriescategories (
  categoryidfk VARCHAR2(35) NULL,
  entryidfk VARCHAR2(35) NULL
)
;

--
-- Definition for table tblblogentriesrelated : 
--

CREATE TABLE tblblogentriesrelated (
  entryid VARCHAR2(35) NULL,
  relatedid VARCHAR2(35) NULL
)
;

--
-- Definition for table tblblogpages : 
--

CREATE TABLE tblblogpages (
  id VARCHAR2(35) NOT NULL,
  blog VARCHAR2(50) NULL,
  title VARCHAR2(255) NULL,
  alias VARCHAR2(100) NULL,
  body VARCHAR2(2000) NULL,
  showlayout NUMBER(3) NULL
)
;

--
-- Definition for table tblblogroles : 
--

CREATE TABLE tblblogroles (
  id VARCHAR2(35) NOT NULL,
  role VARCHAR2(50) NULL,
  description VARCHAR2(255) NULL
)
;

--
-- Definition for table tblblogsearchstats : 
--

CREATE TABLE tblblogsearchstats (
  searchterm VARCHAR2(255) NULL,
  searched DATE NULL,
  blog VARCHAR2(50) NULL
)
;

--
-- Definition for table tblblogsubscribers : 
--

CREATE TABLE tblblogsubscribers (
  email VARCHAR2(50) NULL,
  token VARCHAR2(35) NULL,
  blog VARCHAR2(50) NULL,
  verified NUMBER(3) NULL
)
;

--
-- Definition for table tblblogtextblocks : 
--

CREATE TABLE tblblogtextblocks (
  id VARCHAR2(35) NULL,
  label VARCHAR2(255) NULL,
  body VARCHAR2(2000) NULL,
  blog VARCHAR2(50) NULL
)
;

--
-- Definition for table tbluserroles : 
--

CREATE TABLE tbluserroles (
  username VARCHAR2(50) NULL,
  roleidfk VARCHAR2(35) NULL,
  blog VARCHAR2(50) NULL
)
;

--
-- Definition for table tblusers : 
--

CREATE TABLE tblusers (
  username VARCHAR2(50) NULL,
  password VARCHAR2(256) NULL,
  salt VARCHAR2(256) NULL,
  name VARCHAR2(50) NULL,
  blog VARCHAR2(255) NULL
)
;

--
-- Definition for indices : 
--

ALTER TABLE tblblogcategories ADD CONSTRAINT tblblogcategories_pk PRIMARY KEY (categoryid);

CREATE INDEX blogCategories_blog ON tblblogcategories (blog);

CREATE INDEX blogCategories_categoryalias ON tblblogcategories (categoryalias);

CREATE INDEX blogCategories_categoryname ON tblblogcategories (categoryname);

ALTER TABLE tblblogcomments ADD CONSTRAINT tblblogcomments_pk PRIMARY KEY (id);

CREATE INDEX blogComments_email ON tblblogcomments (email);

CREATE INDEX blogComments_entryid ON tblblogcomments (entryidfk);

CREATE INDEX blogComments_moderated ON tblblogcomments (moderated);

CREATE INDEX blogComments_name ON tblblogcomments (name);

CREATE INDEX blogComments_posted ON tblblogcomments (posted);

ALTER TABLE tblblogentries ADD CONSTRAINT tblblogentries_pk PRIMARY KEY (id);

CREATE INDEX blogEntries_alias ON tblblogentries (alias);

CREATE INDEX blogEntries_blog ON tblblogentries (blog);

CREATE INDEX blogEntries_posted ON tblblogentries (posted);

CREATE INDEX blogEntries_released ON tblblogentries (released);

CREATE INDEX blogEntries_title ON tblblogentries (title);

CREATE INDEX blogEntries_username ON tblblogentries (username);

CREATE INDEX blogEntriesCats_entryidfk ON tblblogentriescategories (entryidfk, categoryidfk);

CREATE INDEX blogEntriesRelated_entryid ON tblblogentriesrelated (entryid);

CREATE INDEX blogEntriesRelated_relatedid ON tblblogentriesrelated (relatedid);

CREATE INDEX blogPages_alias ON tblblogpages (alias);

CREATE INDEX blogPages_blog ON tblblogpages (blog);

CREATE INDEX blogPages_title ON tblblogpages (title);

ALTER TABLE tblblogroles ADD CONSTRAINT tblblogroles_pk PRIMARY KEY (id);

CREATE INDEX blogRoles_role ON tblblogroles (role);

CREATE INDEX blogSubscribers_blog ON tblblogsubscribers (blog);

CREATE INDEX blogSubscribers_email ON tblblogsubscribers (email);

CREATE INDEX blogSubscribers_token ON tblblogsubscribers (token);

CREATE INDEX blogSubscribers_verified ON tblblogsubscribers (verified);

CREATE INDEX blogTextBlocks_blog ON tblblogtextblocks (blog);

CREATE INDEX blogTextBlocks_label ON tblblogtextblocks (label);

CREATE INDEX blogUserRoles_blog ON tbluserroles (blog);

CREATE INDEX blogUserRoles_roleidfk ON tbluserroles (roleidfk);

CREATE INDEX blogUserRoles_username ON tbluserroles (username);

CREATE INDEX blogUsers_blog ON tblusers (blog);

CREATE INDEX blogUsers_username ON tblusers (username);

--
-- Seed tables
--

INSERT INTO tblblogroles(role,id,description) VALUES ('AddCategory','7F183B27-FEDE-0D6F-E2E9C35DBC7BFF19','The ability to create a new category when editing a blog entry.');
INSERT INTO tblblogroles(role,id,description) VALUES('ManageCategories','7F197F53-CFF7-18C8-53D0C85FCC2CA3F9','The ability to manage blog categories.');
INSERT INTO tblblogroles(role,id,description) VALUES('Admin','7F25A20B-EE6D-612D-24A7C0CEE6483EC2','A special role for the admin. Allows all functionality.');
INSERT INTO tblblogroles(role,id,description) VALUES('ManageUsers','7F26DA6C-9F03-567F-ACFD34F62FB77199','The ability to manage blog users.');
INSERT INTO tblblogroles(role,id,description) VALUES('ReleaseEntries','800CA7AA-0190-5329-D3C7753A59EA2589','The ability to both release a new entry and edit any released entry.');

INSERT INTO tbluserroles VALUES ('admin','7F25A20B-EE6D-612D-24A7C0CEE6483EC2','Default');

INSERT INTO tblUsers (username,password,salt,name,blog) VALUES ('admin','74FAE06F4B7BB31F16FA3CB4C873C88FB3669E413603CD103D714CC8C6B153188CEE84D3172F60027D96BAB4A79F275543865C80A927312D5CF00F7DD3F1753A','2XlAbs2fFEESboQCMue3N7yATpwT1QKAFNGIU0hZ35g=','name','Default');

COMMIT;

