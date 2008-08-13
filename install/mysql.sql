-- MySQL dump 10.11
--
-- Host: localhost    Database: blogcfc
-- ------------------------------------------------------
-- Server version	5.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tblblogcategories`
--

DROP TABLE IF EXISTS `tblblogcategories`;
CREATE TABLE `tblblogcategories` (
  `categoryid` varchar(35) character set latin1 NOT NULL default '',
  `categoryname` varchar(50) character set latin1 NOT NULL default '',
  `categoryalias` varchar(50) default NULL,
  `blog` varchar(50) character set latin1 NOT NULL default '',
  PRIMARY KEY  (`categoryid`),
  KEY `blogCategories_blog` (`blog`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `tblblogcomments`
--

DROP TABLE IF EXISTS `tblblogcomments`;
CREATE TABLE `tblblogcomments` (
  `id` varchar(35) character set latin1 NOT NULL default '',
  `entryidfk` varchar(35) character set latin1 default NULL,
  `name` varchar(50) character set latin1 default NULL,
  `email` varchar(50) character set latin1 default NULL,
  `comment` text character set latin1,
  `posted` datetime default NULL,
  `subscribe` tinyint(1) default NULL,
  `website` varchar(255) default NULL,
  `moderated` tinyint(1) default NULL,
  `killcomment` varchar(35) default NULL,
  `subscribeonly` tinyint(4) default NULL,
  PRIMARY KEY  (`id`),
  KEY `blogComments_entryid` (`entryidfk`),
  KEY `blogComments_posted` (`posted`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `tblblogentries`
--

DROP TABLE IF EXISTS `tblblogentries`;
CREATE TABLE `tblblogentries` (
  `id` varchar(35) character set latin1 NOT NULL default '',
  `title` varchar(100) character set latin1 NOT NULL default '',
  `body` longtext character set latin1 NOT NULL,
  `posted` datetime NOT NULL default '0000-00-00 00:00:00',
  `morebody` longtext character set latin1,
  `alias` varchar(100) character set latin1 default NULL,
  `username` varchar(50) character set latin1 default NULL,
  `blog` varchar(50) character set latin1 NOT NULL default '',
  `allowcomments` tinyint(1) NOT NULL default '0',
  `enclosure` varchar(255) character set latin1 default NULL,
  `filesize` int(11) unsigned default '0',
  `mimetype` varchar(255) character set latin1 default NULL,
  `views` int(11) default NULL,
  `released` tinyint(1) default '0',
  `mailed` tinyint(1) default '0',
  `summary` varchar(255) default NULL,
  `subtitle` varchar(100) default NULL,
  `keywords` varchar(100) default NULL,
  `duration` varchar(10) default NULL,
  PRIMARY KEY  (`id`),
  KEY `blogEntries_blog` (`blog`),
  KEY `blogEntries_released` (`released`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `tblblogentriescategories`
--

DROP TABLE IF EXISTS `tblblogentriescategories`;
CREATE TABLE `tblblogentriescategories` (
  `categoryidfk` varchar(35) character set latin1 default NULL,
  `entryidfk` varchar(35) character set latin1 default NULL,
  KEY `blogEntriesCategories_entryid` (`entryidfk`,`categoryidfk`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `tblblogentriesrelated`
--

DROP TABLE IF EXISTS `tblblogentriesrelated`;
CREATE TABLE `tblblogentriesrelated` (
  `id` int(11) default NULL,
  `entryid` varchar(35) NOT NULL default '',
  `relatedid` varchar(35) default '',
  KEY `blogEntriesRelated_entryid` (`entryid`,`relatedid`),
  KEY `blogEntriesRelated_relatedid` (`relatedid`,`entryid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `tblblogpages`
--

DROP TABLE IF EXISTS `tblblogpages`;
CREATE TABLE `tblblogpages` (
  `id` varchar(35) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `alias` varchar(100) NOT NULL default '',
  `body` text NOT NULL,
  `blog` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `tblblogsearchstats`
--

DROP TABLE IF EXISTS `tblblogsearchstats`;
CREATE TABLE `tblblogsearchstats` (
  `searchterm` varchar(255) character set latin1 NOT NULL default '',
  `searched` datetime NOT NULL default '0000-00-00 00:00:00',
  `blog` varchar(50) character set latin1 NOT NULL default ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `tblblogsubscribers`
--

DROP TABLE IF EXISTS `tblblogsubscribers`;
CREATE TABLE `tblblogsubscribers` (
  `email` varchar(50) character set latin1 NOT NULL default '',
  `token` varchar(35) character set latin1 NOT NULL default '',
  `blog` varchar(50) character set latin1 default NULL,
  `verified` tinyint(1) NOT NULL default '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `tblblogtextblocks`
--

DROP TABLE IF EXISTS `tblblogtextblocks`;
CREATE TABLE `tblblogtextblocks` (
  `id` varchar(35) NOT NULL default '',
  `label` varchar(255) NOT NULL default '',
  `body` text NOT NULL,
  `blog` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `tblblogtrackbacks`
--

DROP TABLE IF EXISTS `tblblogtrackbacks`;
CREATE TABLE `tblblogtrackbacks` (
  `Id` varchar(35) character set latin1 NOT NULL default '',
  `title` varchar(255) character set latin1 NOT NULL default '',
  `blogname` varchar(255) character set latin1 NOT NULL default '',
  `posturl` varchar(255) character set latin1 NOT NULL default '',
  `excerpt` text character set latin1 NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `entryid` varchar(35) character set latin1 NOT NULL default '',
  `blog` varchar(50) character set latin1 NOT NULL default '',
  PRIMARY KEY  (`Id`),
  KEY `blogTrackBacks_entryid` (`entryid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `tblusers`
--

DROP TABLE IF EXISTS `tblusers`;
CREATE TABLE `tblusers` (
  `username` varchar(50) character set latin1 default NULL,
  `password` varchar(50) character set latin1 default NULL,
  `name` varchar(50) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert into tblusers(username,password,name) values('admin','admin','Admin');


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2008-07-30 15:08:46
