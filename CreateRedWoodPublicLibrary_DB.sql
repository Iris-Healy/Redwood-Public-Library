IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'RedWood_Public_Library'
)
CREATE DATABASE RedWood_Public_Library;
GO

USE RedWood_Public_Library;

--Drop Tables From Database if they exist
DROP TABLE IF EXISTS Book_Genres;
DROP TABLE IF EXISTS Book_Authors;
DROP TABLE IF EXISTS Book_Lending;
DROP TABLE IF EXISTS Book_Copies;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS Member_Logins;
DROP TABLE IF EXISTS Staff_Logins;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Book_Language;
DROP TABLE IF EXISTS Book_Condition;
DROP TABLE IF EXISTS Book_Availability;
DROP TABLE IF EXISTS Publishers;
DROP TABLE IF EXISTS Genres;
DROP TABLE IF EXISTS Authors;

--Create Authors Table
CREATE TABLE Authors
(
    Author_ID INT IDENTITY PRIMARY KEY NOT NULL,
    A_Last_Name NVARCHAR(256) NOT NULL,
    A_Middle_Name NVARCHAR(256),
    A_First_Name NVARCHAR(256) NOT NULL
);

--Create Genres Table
CREATE TABLE Genres
(
    Genre_ID INT IDENTITY PRIMARY KEY NOT NULL,
    Genre NVARCHAR(256) NOT NULL
);

--Create Publishers Table
CREATE TABLE Publishers 
(
    Publisher_ID INT IDENTITY PRIMARY KEY NOT NULL,
    P_Name NVARCHAR(256) NOT NULL,
    P_Website NVARCHAR(256) NOT NULL
);

CREATE TABLE Book_Availability
(
    BA_ID INT IDENTITY PRIMARY KEY NOT NULL,
    Condition NVARCHAR(256) NOT NULL
);

CREATE TABLE Book_Condition
(
    BCon_ID INT IDENTITY PRIMARY KEY NOT NULL,
    Condition NVARCHAR(256) NOT NULL
);

CREATE TABLE Book_Language
(
    BL_ID INT IDENTITY PRIMARY KEY NOT NULL,
    Language NVARCHAR(256) NOT NULL
);

CREATE TABLE Staff_Logins
(
    S_Login_ID INT IDENTITY PRIMARY KEY NOT NULL,
    S_Username NVARCHAR(256) NOT NULL,
    S_Password NVARCHAR(256) NOT NULL
);

CREATE TABLE Member_Logins
(
    M_Login_ID INT IDENTITY PRIMARY KEY NOT NULL,
    M_Username NVARCHAR(256) NOT NULL,
    M_Password NVARCHAR(256) NOT NULL
);

CREATE TABLE Roles
(
    Role_ID INT IDENTITY PRIMARY KEY NOT NULL,
    Role NVARCHAR(256) NOT NULL
)

CREATE TABLE Staff
(
    Staff_ID INT IDENTITY PRIMARY KEY NOT NULL,
    S_Last_Name NVARCHAR(256) NOT NULL,
    S_Middle_Name NVARCHAR(256),
    S_First_Name NVARCHAR(256) NOT NULL,
    S_Phone NVARCHAR(256) NOT NULL,
    S_Login_ID INT NOT NULL,
    Role_ID INT NOT NULL,
    CONSTRAINT Staff_FK_Staff_Logins FOREIGN KEY (S_Login_ID)
        REFERENCES Staff_Logins (S_Login_ID),
    CONSTRAINT Staff_FK_Roles FOREIGN KEY (Role_ID)
        REFERENCES Roles (Role_ID)
);

CREATE TABLE Members
(
    Member_ID INT IDENTITY PRIMARY KEY NOT NULL,
    M_Last_Name NVARCHAR(256) NOT NULL,
    M_Middle_Name NVARCHAR(256),
    M_First_Name NVARCHAR(256) NOT NULL,
    M_Phone NVARCHAR(256) NOT NULL,
    M_Email NVARCHAR(256) NOT NULL,
    M_Address_L1 NVARCHAR(256) NOT NULL,
    M_Address_L2 NVARCHAR(256),
    M_City NVARCHAR(256) NOT NULL,
    M_State NVARCHAR(256) NOT NULL,
    M_Zip NVARCHAR(256) NOT NULL,
    Role_ID INT NOT NULL,
    M_Login_ID INT NOT NULL,
    CONSTRAINT Members_FK_Roles FOREIGN KEY (Role_ID)
        REFERENCES Roles (Role_ID),
    CONSTRAINT Members_FK_Member_Logins FOREIGN KEY (M_Login_ID)
        REFERENCES Member_Logins (M_Login_ID)
);

--Create Books table with Publishers FK
CREATE TABLE Books
(
    Book_ID INT IDENTITY PRIMARY KEY NOT NULL,
    BK_Title NVARCHAR(256) NOT NULL,
    ISBN NVARCHAR(256) NOT NULL,
    BK_Publication_Year CHAR(4),
    Publisher_ID INT NOT NULL,
    CONSTRAINT Books_FK_Publishers FOREIGN KEY (Publisher_ID)
        REFERENCES Publishers (Publisher_ID)
);

--Create Many-Many Relationship Table Book_Authors
CREATE TABLE Book_Authors
(
    BA_ID INT IDENTITY PRIMARY KEY NOT NULL,
    Book_ID INT NOT NULL,
    Author_ID INT NOT NULL,
    CONSTRAINT Book_Authors_FK_Books FOREIGN KEY (Book_ID)
        REFERENCES Books (Book_ID),
    CONSTRAINT Book_Authors_FK_Authors FOREIGN KEY (Author_ID)
        REFERENCES Authors (Author_ID)
);

--Create Many-Many Relationship Table Book_Genres
CREATE TABLE Book_Genres
(
    BG_ID INT IDENTITY PRIMARY KEY NOT NULL,
    Book_ID INT NOT NULL,
    Genre_ID INT NOT NULL,
    CONSTRAINT Book_Genres_FK_Books FOREIGN KEY (Book_ID)
        REFERENCES Books (Book_ID),
    CONSTRAINT Book_Genres_FK_Genres FOREIGN KEY (Genre_ID)
        REFERENCES Genres (Genre_ID)
);

CREATE TABLE Book_Copies
(
    BC_ID INT IDENTITY PRIMARY KEY NOT NULL,
    BC_Date_Added DATE NOT NULL,
    BC_Price DECIMAL(10, 2) NOT NULL,
    BA_ID INT NOT NULL,
    BCon_ID INT NOT NULL,
    BL_ID INT NOT NULL,
    Book_ID INT NOT NULL,
    CONSTRAINT Book_Copies_FK_Book_Availability FOREIGN KEY (BA_ID)
        REFERENCES Book_Availability (BA_ID),
    CONSTRAINT Book_Copies_FK_Book_Condition FOREIGN KEY (BCon_ID)
        REFERENCES Book_Condition (BCon_ID),
    CONSTRAINT Book_Copies_FK_Book_Language FOREIGN KEY (BL_ID)
        REFERENCES Book_Language (BL_ID),
    CONSTRAINT Book_Copes_FK_Books FOREIGN KEY (Book_ID)
        REFERENCES Books (Book_ID)
);

CREATE TABLE Book_Lending
(
    Lend_ID INT IDENTITY PRIMARY KEY NOT NULL,
    Loan_Date DATE NOT NULL,
    Due_Date DATE NOT NULL,
    Return_Date DATE,
    Staff_ID INT NOT NULL,
    Member_ID INT NOT NULL,
    BC_ID INT NOT NULL,
    CONSTRAINT Book_Lending_FK_Staff FOREIGN KEY (Staff_ID)
        REFERENCES Staff (Staff_ID),
    CONSTRAINT Book_Lending_FK_Members FOREIGN KEY (Member_ID)
        REFERENCES Members (Member_ID),
    CONSTRAINT Book_Lending_FK_Book_Copies FOREIGN KEY (BC_ID)
        REFERENCES Book_Copies (BC_ID)
);

--The Following Insert Statements were generated with microsoft Copilot for brevity and to ensure a large dataset for testing purposes.
INSERT INTO Authors (A_First_Name, A_Middle_Name, A_Last_Name) VALUES
('Becky', NULL, 'Chambers'),
('Ursula', 'K.', 'Le Guin'),
('James', 'S. A.', 'Corey'),
('Ann', NULL, 'Leckie'),
('N.', 'K.', 'Jemisin'),
('Martha', NULL, 'Wells'),
('Ted', NULL, 'Chiang'),
('William', NULL, 'Gibson'),
('Neal', NULL, 'Stephenson'),
('Cixin', NULL, 'Liu'),
('Adrian', NULL, 'Tchaikovsky'),
('Octavia', NULL, 'Butler'),
('Andy', NULL, 'Weir'),
('Hugh', NULL, 'Howey'),
('Paolo', NULL, 'Bacigalupi'),
('Arkady', NULL, 'Martine'),
('Cory', NULL, 'Doctorow');

INSERT INTO Publishers (P_Name, P_Website) VALUES
('Tor Books', 'https://www.tor.com'),
('Orbit Books', 'https://www.orbitbooks.net'),
('Ace Books', 'https://www.penguinrandomhouse.com/imprints/ace'),
('Gollancz', 'https://www.gollancz.co.uk'),
('Del Rey', 'https://www.penguinrandomhouse.com/imprints/del-rey'),
('Harper Voyager', 'https://www.harpercollins.com/pages/harper-voyager'),
('Pantheon Books', 'https://www.penguinrandomhouse.com/imprints/pantheon');


INSERT INTO Genres (Genre) VALUES
('Science Fiction'),
('Space Opera'),
('Speculative Fiction'),
('Cyberpunk'),
('Hard Science Fiction'),
('Climate Fiction'),
('Post-Apocalyptic'),
('Experimental');


INSERT INTO Books (BK_Title, ISBN, BK_Publication_Year, Publisher_ID) VALUES
-- Becky Chambers (1–6)
('The Long Way to a Small, Angry Planet','9780062444137','2014',1),
('A Closed and Common Orbit','9780062444144','2016',1),
('Record of a Spaceborn Few','9780062444151','2018',1),
('The Galaxy, and the Ground Within','9780062958474','2021',1),
('A Psalm for the Wild-Built','9781250236210','2021',1),
('A Prayer for the Crown-Shy','9781250236234','2022',1),

-- Ursula K. Le Guin (7–14)
('The Left Hand of Darkness','9780441478125','1969',3),
('The Dispossessed','9780060512750','1974',3),
('The Word for World Is Forest','9780312855406','1976',3),
('The Telling','9780151005670','2000',3),
('A Wizard of Earthsea','9780547773742','1968',3),
('The Tombs of Atuan','9780689845362','1971',3),
('The Farthest Shore','9780689845386','1972',3),
('Tehanu','9780689845331','1990',3),

-- James S. A. Corey (15–24)
('Leviathan Wakes','9780316129084','2011',2),
('Caliban''s War','9780316129091','2012',2),
('Abaddon''s Gate','9780316129107','2013',2),
('Cibola Burn','9780316217613','2014',2),
('Nemesis Games','9780316217583','2015',2),
('Babylon''s Ashes','9780316217606','2016',2),
('Persepolis Rising','9780316332828','2017',2),
('Tiamat''s Wrath','9780316332910','2019',2),
('Leviathan Falls','9780316332934','2021',2),
('The Mercy of Gods','9780316489072','2024',2),

-- Ann Leckie (25–30)
('Ancillary Justice','9780316246620','2013',2),
('Ancillary Sword','9780316246637','2014',2),
('Ancillary Mercy','9780316246644','2015',2),
('Provenance','9780316387651','2017',2),
('The Raven Tower','9780316489447','2019',2),
('Translation State','9780316541374','2023',2),

-- N. K. Jemisin (31–38)
('The Fifth Season','9780316229296','2015',1),
('The Obelisk Gate','9780316229265','2016',1),
('The Stone Sky','9780316229241','2017',1),
('The City We Became','9780316509848','2020',1),
('The World We Make','9780316509923','2022',1),
('The Killing Moon','9780316033794','2012',1),
('The Shadowed Sun','9780316033824','2012',1),
('How Long ''til Black Future Month?','9780316491341','2018',1),

-- Martha Wells (39–44)
('All Systems Red','9780765397539','2017',1),
('Artificial Condition','9780765397546','2018',1),
('Rogue Protocol','9780765397553','2018',1),
('Exit Strategy','9780765397560','2018',1),
('Network Effect','9781250229847','2020',1),
('System Collapse','9781250826978','2023',1),

-- Ted Chiang (45–48)
('Stories of Your Life and Others','9781101972120','2002',5),
('Exhalation','9781101947883','2019',5),
('The Lifecycle of Software Objects','9781596063174','2011',5),
('Understand','9781596065413','2002',5),

-- William Gibson (49–54)
('Neuromancer','9780441569595','1984',5),
('Count Zero','9780441117734','1986',5),
('Mona Lisa Overdrive','9780441117741','1988',5),
('Pattern Recognition','9780425192931','2003',5),
('The Peripheral','9780425276235','2014',5),
('Agency','9781101986950','2020',5),

-- Neal Stephenson (55–60)
('Snow Crash','9780553380958','1992',5),
('The Diamond Age','9780553380965','1995',5),
('Anathem','9780061474101','2008',5),
('Seveneves','9780062334510','2015',5),
('Fall; or, Dodge in Hell','9780062457731','2019',5),
('Termination Shock','9780063028053','2021',5),

-- Liu Cixin (61–66)
('The Three-Body Problem','9780765377067','2006',1),
('The Dark Forest','9780765386632','2008',1),
('Death''s End','9780765377104','2010',1),
('Ball Lightning','9780765384195','2018',1),
('Supernova Era','9780765387400','2020',1),
('Of Ants and Dinosaurs','9781782275884','2021',1),

-- Adrian Tchaikovsky (67–74)
('Children of Time','9781447273288','2015',4),
('Children of Ruin','9781529050028','2019',4),
('Children of Memory','9781529050066','2022',4),
('Cage of Souls','9781760872987','2019',4),
('Shards of Earth','9781529051902','2021',4),
('Eyes of the Void','9781529051926','2022',4),
('Lords of Uncreation','9781529051971','2023',4),
('Alien Clay','9781529099386','2024',4),

-- Octavia Butler (75–80)
('Kindred','9780807083697','1979',6),
('Parable of the Sower','9780446675505','1993',6),
('Parable of the Talents','9780446676663','1998',6),
('Dawn','9780446603775','1987',6),
('Adulthood Rites','9780446619943','1988',6),
('Imago','9780446619950','1989',6),

-- Andy Weir (81–84)
('The Martian','9780553418026','2011',5),
('Artemis','9780553448122','2017',5),
('Project Hail Mary','9780593135204','2021',5),
('The Egg (Collected)','9781975375483','2022',5),

-- Hugh Howey (85–88)
('Wool','9781476733951','2011',2),
('Shift','9781476733968','2013',2),
('Dust','9781476733975','2013',2),
('Sand','9780544836129','2014',2),

-- Paolo Bacigalupi (89–92)
('The Windup Girl','9781597801584','2009',1),
('Ship Breaker','9780316056212','2010',1),
('The Water Knife','9780385352871','2015',1),
('Pump Six and Other Stories','9781597802666','2008',1),

-- Arkady Martine (93–96)
('A Memory Called Empire','9781250186430','2019',1),
('A Desolation Called Peace','9781250186447','2021',1),
('Rose/House','9781250332301','2023',1),
('Between Other Worlds','9781250347879','2024',1),

-- Cory Doctorow (97–100)
('Little Brother','9780765319852','2008',1),
('Homeland','9780765330420','2013',1),
('Walkaway','9780765392763','2017',1),
('Red Team Blues','9781250865847','2023',1);


INSERT INTO Book_Authors (Book_ID, Author_ID) VALUES
-- Becky Chambers (1–6)
(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),

-- Ursula K. Le Guin (7–14)
(7,2),(8,2),(9,2),(10,2),(11,2),(12,2),(13,2),(14,2),

-- James S. A. Corey (15–24)
(15,3),(16,3),(17,3),(18,3),(19,3),
(20,3),(21,3),(22,3),(23,3),(24,3),

-- Ann Leckie (25–30)
(25,4),(26,4),(27,4),(28,4),(29,4),(30,4),

-- N. K. Jemisin (31–38)
(31,5),(32,5),(33,5),(34,5),(35,5),(36,5),(37,5),(38,5),

-- Martha Wells (39–44)
(39,6),(40,6),(41,6),(42,6),(43,6),(44,6),

-- Ted Chiang (45–48)
(45,7),(46,7),(47,7),(48,7),

-- William Gibson (49–54)
(49,8),(50,8),(51,8),(52,8),(53,8),(54,8),

-- Neal Stephenson (55–60)
(55,9),(56,9),(57,9),(58,9),(59,9),(60,9),

-- Liu Cixin (61–66)
(61,10),(62,10),(63,10),(64,10),(65,10),(66,10),

-- Adrian Tchaikovsky (67–74)
(67,11),(68,11),(69,11),(70,11),(71,11),(72,11),(73,11),(74,11),

-- Octavia Butler (75–80)
(75,12),(76,12),(77,12),(78,12),(79,12),(80,12),

-- Andy Weir (81–84)
(81,13),(82,13),(83,13),(84,13),

-- Hugh Howey (85–88)
(85,14),(86,14),(87,14),(88,14),

-- Paolo Bacigalupi (89–92)
(89,15),(90,15),(91,15),(92,15),

-- Arkady Martine (93–96)
(93,16),(94,16),(95,16),(96,16),

-- Cory Doctorow (97–100)
(97,17),(98,17),(99,17),(100,17);


INSERT INTO Book_Genres (Book_ID, Genre_ID) VALUES
-- Default Science Fiction (all)
(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),
(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),
(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),
(25,1),(26,1),(27,1),(28,1),(29,1),(30,1),
(31,1),(32,1),(33,1),(34,1),(35,1),(36,1),(37,1),(38,1),
(39,1),(40,1),(41,1),(42,1),(43,1),(44,1),
(45,1),(46,1),(47,1),(48,1),
(49,1),(50,1),(51,1),(52,1),(53,1),(54,1),
(55,1),(56,1),(57,1),(58,1),(59,1),(60,1),
(61,1),(62,1),(63,1),(64,1),(65,1),(66,1),
(67,1),(68,1),(69,1),(70,1),(71,1),(72,1),(73,1),(74,1),
(75,1),(76,1),(77,1),(78,1),(79,1),(80,1),
(81,1),(82,1),(83,1),(84,1),
(85,1),(86,1),(87,1),(88,1),
(89,1),(90,1),(91,1),(92,1),
(93,1),(94,1),(95,1),(96,1),
(97,1),(98,1),(99,1),(100,1);

-- Additional genre specialization
INSERT INTO Book_Genres (Book_ID, Genre_ID) VALUES
-- Space Opera
(1,2),(15,2),(16,2),(17,2),(18,2),(19,2),(20,2),
(21,2),(22,2),(23,2),(24,2),(67,2),(68,2),(71,2),

-- Cyberpunk
(49,4),(50,4),(51,4),(52,4),(97,4),(99,4),

-- Hard SF
(61,5),(62,5),(63,5),(81,5),(83,5),(58,5),

-- Climate Fiction
(89,6),(90,6),(91,6),

-- Post‑Apocalyptic
(76,7),(77,7),(85,7),(86,7),(87,7),(88,7),

-- Experimental
(48,8),(52,8),(55,8);


INSERT INTO Book_Availability (Condition) VALUES
('Available'),
('Checked Out'),
('Reserved');


INSERT INTO Book_Condition (Condition) VALUES
('New'),
('Excellent'),
('Good'),
('Fair'),
('Poor'),
('Damaged');


INSERT INTO Book_Language (Language) VALUES
('English'),
('Spanish'),
('French'),
('German'),
('Chinese');


INSERT INTO Roles (Role) VALUES
('Administrator'),
('Librarian'),
('Member');


INSERT INTO Staff_Logins (S_Username, S_Password) VALUES
-- Librarians
('lib_alice_j','Lib#Alice2024'),
('lib_brian_s','Lib#Brian2024'),
('lib_carol_n','Lib#Carol2024'),
('lib_david_m','Lib#David2024'),
('lib_ella_b','Lib#Ella2024'),
('lib_michael_r','Lib#Michael2024'),
('lib_susan_k','Lib#Susan2024'),
('lib_peter_l','Lib#Peter2024'),

-- Administrators
('admin_frank_w','Admin#Frank!01'),
('admin_grace_t','Admin#Grace!02');


INSERT INTO Member_Logins (M_Username, M_Password) VALUES
('m_jdoe001','Read@Doe001'),
('m_jdoe002','Read@Doe002'),
('m_akim003','Read@Kim003'),
('m_mgarcia004','Read@Garcia004'),
('m_cpatel005','Read@Patel005'),

('m_swilson006','Read@Wilson006'),
('m_tng007','Read@Ng007'),
('m_lzhang008','Read@Zhang008'),
('m_randerson009','Read@Anderson009'),
('m_ethomas010','Read@Thomas010'),

('m_nmartin011','Read@Martin011'),
('m_olee012','Read@Lee012'),
('m_ehall013','Read@Hall013'),
('m_syoung014','Read@Young014'),
('m_dhernandez015','Read@Hernandez015'),

('m_kroberts016','Read@Roberts016'),
('m_amurphy017','Read@Murphy017'),
('m_blopez018','Read@Lopez018'),
('m_cwalker019','Read@Walker019'),
('m_jallen020','Read@Allen020'),

('m_pscott021','Read@Scott021'),
('m_dadams022','Read@Adams022'),
('m_lnelson023','Read@Nelson023'),
('m_framirez024','Read@Ramirez024'),
('m_ktaylor025','Read@Taylor025'),

('m_mturner026','Read@Turner026'),
('m_hphillips027','Read@Phillips027'),
('m_rperez028','Read@Perez028'),
('m_dcarter029','Read@Carter029'),
('m_ewright030','Read@Wright030'),

('m_jking031','Read@King031'),
('m_lgreen032','Read@Green032'),
('m_swilliams033','Read@Williams033'),
('m_mmorris034','Read@Morris034'),
('m_creed035','Read@Reed035'),

('m_pbaker036','Read@Baker036'),
('m_jcooper037','Read@Cooper037'),
('m_emorgan038','Read@Morgan038'),
('m_hbell039','Read@Bell039'),
('m_afoster040','Read@Foster040'),

('m_tkelly041','Read@Kelly041'),
('m_rhoward042','Read@Howard042'),
('m_lward043','Read@Ward043'),
('m_jcox044','Read@Cox044'),
('m_sdiaz045','Read@Diaz045'),

('m_brichardson046','Read@Richardson046'),
('m_wood047','Read@Wood047'),
('m_jwatson048','Read@Watson048'),
('m_chughes049','Read@Hughes049'),
('m_flong050','Read@Long050');


INSERT INTO Staff
    (S_First_Name, S_Middle_Name, S_Last_Name, S_Phone, S_Login_ID, Role_ID)
VALUES
-- Librarians (Role_ID = 2)
('Alice',  NULL, 'Johnson',  '555-3001',  1, 2),
('Brian',  NULL, 'Smith',    '555-3002',  2, 2),
('Carol',  NULL, 'Nguyen',   '555-3003',  3, 2),
('David',  NULL, 'Miller',   '555-3004',  4, 2),
('Ella',   NULL, 'Brown',    '555-3005',  5, 2),
('Michael',NULL, 'Reed',     '555-3006',  6, 2),
('Susan',  NULL, 'Kim',      '555-3007',  7, 2),
('Peter',  NULL, 'Lee',      '555-3008',  8, 2),

-- Administrators (Role_ID = 1)
('Frank',  NULL, 'Williams', '555-3101',  9, 1),
('Grace',  NULL, 'Thompson', '555-3102', 10, 1);


INSERT INTO Members
(M_First_Name, M_Middle_Name, M_Last_Name, M_Phone, M_Email,
 M_Address_L1, M_Address_L2, M_City, M_State, M_Zip,
 Role_ID, M_Login_ID)
VALUES
('John',NULL,'Doe','555-4001','john.doe01@library.com','100 Main St',NULL,'Redwood','CA','94061',3,1),
('Jane',NULL,'Doe','555-4002','jane.doe02@library.com','101 Main St',NULL,'Redwood','CA','94061',3,2),
('Alex',NULL,'Kim','555-4003','alex.kim03@library.com','102 Main St',NULL,'Redwood','CA','94061',3,3),
('Maria',NULL,'Garcia','555-4004','maria.garcia04@library.com','103 Main St',NULL,'Redwood','CA','94061',3,4),
('Chris',NULL,'Patel','555-4005','chris.patel05@library.com','104 Main St',NULL,'Redwood','CA','94061',3,5),

('Sarah',NULL,'Wilson','555-4006','sarah.wilson06@library.com','105 Main St',NULL,'Redwood','CA','94061',3,6),
('Tom',NULL,'Ng','555-4007','tom.ng07@library.com','106 Main St',NULL,'Redwood','CA','94061',3,7),
('Lily',NULL,'Zhang','555-4008','lily.zhang08@library.com','107 Main St',NULL,'Redwood','CA','94061',3,8),
('Ryan',NULL,'Anderson','555-4009','ryan.anderson09@library.com','108 Main St',NULL,'Redwood','CA','94061',3,9),
('Emma',NULL,'Thomas','555-4010','emma.thomas10@library.com','109 Main St',NULL,'Redwood','CA','94061',3,10),

('Noah',NULL,'Martin','555-4011','noah.martin11@library.com','110 Main St',NULL,'Redwood','CA','94061',3,11),
('Olivia',NULL,'Lee','555-4012','olivia.lee12@library.com','111 Main St',NULL,'Redwood','CA','94061',3,12),
('Ethan',NULL,'Hall','555-4013','ethan.hall13@library.com','112 Main St',NULL,'Redwood','CA','94061',3,13),
('Sophia',NULL,'Young','555-4014','sophia.young14@library.com','113 Main St',NULL,'Redwood','CA','94061',3,14),
('Daniel',NULL,'Hernandez','555-4015','daniel.hernandez15@library.com','114 Main St',NULL,'Redwood','CA','94061',3,15),

('Kelly',NULL,'Roberts','555-4016','kelly.roberts16@library.com','115 Main St',NULL,'Redwood','CA','94061',3,16),
('Aaron',NULL,'Murphy','555-4017','aaron.murphy17@library.com','116 Main St',NULL,'Redwood','CA','94061',3,17),
('Brianna',NULL,'Lopez','555-4018','brianna.lopez18@library.com','117 Main St',NULL,'Redwood','CA','94061',3,18),
('Caleb',NULL,'Walker','555-4019','caleb.walker19@library.com','118 Main St',NULL,'Redwood','CA','94061',3,19),
('Julia',NULL,'Allen','555-4020','julia.allen20@library.com','119 Main St',NULL,'Redwood','CA','94061',3,20),

('Paul',NULL,'Scott','555-4021','paul.scott21@library.com','120 Main St',NULL,'Redwood','CA','94061',3,21),
('Diana',NULL,'Adams','555-4022','diana.adams22@library.com','121 Main St',NULL,'Redwood','CA','94061',3,22),
('Lucas',NULL,'Nelson','555-4023','lucas.nelson23@library.com','122 Main St',NULL,'Redwood','CA','94061',3,23),
('Fernanda',NULL,'Ramirez','555-4024','fernanda.ramirez24@library.com','123 Main St',NULL,'Redwood','CA','94061',3,24),
('Kevin',NULL,'Taylor','555-4025','kevin.taylor25@library.com','124 Main St',NULL,'Redwood','CA','94061',3,25),

('Megan',NULL,'Turner','555-4026','megan.turner26@library.com','125 Main St',NULL,'Redwood','CA','94061',3,26),
('Henry',NULL,'Phillips','555-4027','henry.phillips27@library.com','126 Main St',NULL,'Redwood','CA','94061',3,27),
('Rosa',NULL,'Perez','555-4028','rosa.perez28@library.com','127 Main St',NULL,'Redwood','CA','94061',3,28),
('Derek',NULL,'Carter','555-4029','derek.carter29@library.com','128 Main St',NULL,'Redwood','CA','94061',3,29),
('Emily',NULL,'Wright','555-4030','emily.wright30@library.com','129 Main St',NULL,'Redwood','CA','94061',3,30),

('Jordan',NULL,'King','555-4031','jordan.king31@library.com','130 Main St',NULL,'Redwood','CA','94061',3,31),
('Lauren',NULL,'Green','555-4032','lauren.green32@library.com','131 Main St',NULL,'Redwood','CA','94061',3,32),
('Samuel',NULL,'Williams','555-4033','samuel.williams33@library.com','132 Main St',NULL,'Redwood','CA','94061',3,33),
('Mia',NULL,'Morris','555-4034','mia.morris34@library.com','133 Main St',NULL,'Redwood','CA','94061',3,34),
('Connor',NULL,'Reed','555-4035','connor.reed35@library.com','134 Main St',NULL,'Redwood','CA','94061',3,35),

('Priya',NULL,'Baker','555-4036','priya.baker36@library.com','135 Main St',NULL,'Redwood','CA','94061',3,36),
('James',NULL,'Cooper','555-4037','james.cooper37@library.com','136 Main St',NULL,'Redwood','CA','94061',3,37),
('Elena',NULL,'Morgan','555-4038','elena.morgan38@library.com','137 Main St',NULL,'Redwood','CA','94061',3,38),
('Hannah',NULL,'Bell','555-4039','hannah.bell39@library.com','138 Main St',NULL,'Redwood','CA','94061',3,39),
('Anthony',NULL,'Foster','555-4040','anthony.foster40@library.com','139 Main St',NULL,'Redwood','CA','94061',3,40),

('Tina',NULL,'Kelly','555-4041','tina.kelly41@library.com','140 Main St',NULL,'Redwood','CA','94061',3,41),
('Robert',NULL,'Howard','555-4042','robert.howard42@library.com','141 Main St',NULL,'Redwood','CA','94061',3,42),
('Linda',NULL,'Ward','555-4043','linda.ward43@library.com','142 Main St',NULL,'Redwood','CA','94061',3,43),
('Jason',NULL,'Cox','555-4044','jason.cox44@library.com','143 Main St',NULL,'Redwood','CA','94061',3,44),
('Sofia',NULL,'Diaz','555-4045','sofia.diaz45@library.com','144 Main St',NULL,'Redwood','CA','94061',3,45),

('Ben',NULL,'Richardson','555-4046','ben.richardson46@library.com','145 Main St',NULL,'Redwood','CA','94061',3,46),
('Will',NULL,'Wood','555-4047','will.wood47@library.com','146 Main St',NULL,'Redwood','CA','94061',3,47),
('Jessica',NULL,'Watson','555-4048','jessica.watson48@library.com','147 Main St',NULL,'Redwood','CA','94061',3,48),
('Carlos',NULL,'Hughes','555-4049','carlos.hughes49@library.com','148 Main St',NULL,'Redwood','CA','94061',3,49),
('Faith',NULL,'Long','555-4050','faith.long50@library.com','149 Main St',NULL,'Redwood','CA','94061',3,50);


DECLARE @BookID INT = 1;

WHILE @BookID <= 100
BEGIN
    -- First copy (newer, usually available)
    INSERT INTO Book_Copies
        (BC_Date_Added, BC_Price, BA_ID, BCon_ID, BL_ID, Book_ID)
    VALUES
        (
            DATEADD(DAY, @BookID * -3, '2024-01-01'),          -- staggered add dates
            CAST(14.99 + (@BookID % 7) AS DECIMAL(10,2)),     -- realistic price range
            1,                                                -- Available
            1,                                                -- New
            1,                                                -- English
            @BookID
        );

    -- Second copy (older, more wear, sometimes checked out)
    INSERT INTO Book_Copies
        (BC_Date_Added, BC_Price, BA_ID, BCon_ID, BL_ID, Book_ID)
    VALUES
        (
            DATEADD(DAY, @BookID * -6, '2023-01-01'),
            CAST(12.99 + (@BookID % 6) AS DECIMAL(10,2)),
            CASE WHEN @BookID % 3 = 0 THEN 2 ELSE 1 END,       -- Checked Out sometimes
            3,                                                -- Good
            1,                                                -- English
            @BookID
        );

    SET @BookID += 1;
END;


INSERT INTO Book_Lending
    (Loan_Date, Due_Date, Return_Date, Staff_ID, Member_ID, BC_ID)
VALUES
-- Returned loans
('2024-02-01','2024-02-15','2024-02-14', 1,  1,  2),
('2024-02-03','2024-02-17','2024-02-16', 2,  2,  4),
('2024-02-05','2024-02-19','2024-02-18', 3,  3,  6),
('2024-02-07','2024-02-21','2024-02-20', 4,  4,  8),
('2024-02-09','2024-02-23','2024-02-22', 5,  5, 10),
('2024-02-11','2024-02-25','2024-02-24', 6,  6, 12),
('2024-02-13','2024-02-27','2024-02-26', 7,  7, 14),
('2024-02-15','2024-02-29','2024-02-28', 8,  8, 16),
('2024-02-17','2024-03-02','2024-03-01', 9,  9, 18),
('2024-02-19','2024-03-04','2024-03-03',10, 10, 20),

-- Active loans (not yet returned)
('2025-03-01','2025-03-15', NULL, 1, 11, 22),
('2025-03-02','2025-03-16', NULL, 2, 12, 24),
('2025-03-03','2025-03-17', NULL, 3, 13, 26),
('2025-03-04','2025-03-18', NULL, 4, 14, 28),
('2025-03-05','2025-03-19', NULL, 5, 15, 30),
('2025-03-06','2025-03-20', NULL, 6, 16, 32),
('2025-03-07','2025-03-21', NULL, 7, 17, 34),
('2025-03-08','2025-03-22', NULL, 8, 18, 36),
('2025-03-09','2025-03-23', NULL, 9, 19, 38),
('2025-03-10','2025-03-24', NULL,10, 20, 40),

('2025-03-11','2025-03-25',NULL, 1, 21, 52),
('2025-03-12','2025-03-26',NULL, 2, 22, 54),
('2025-03-13','2025-03-27',NULL, 3, 23, 56),
('2025-03-14','2025-03-28',NULL, 4, 24, 58),
('2025-03-15','2025-03-29',NULL, 5, 25, 60),

('2025-03-16','2025-03-30',NULL, 6, 26, 62),
('2025-03-17','2025-03-31',NULL, 7, 27, 64),
('2025-03-18','2025-04-01',NULL, 8, 28, 66),
('2025-03-19','2025-04-02',NULL, 9, 29, 68),
('2025-03-20','2025-04-03',NULL,10, 30, 70),

('2025-03-21','2025-04-04',NULL, 1, 31, 72),
('2025-03-22','2025-04-05',NULL, 2, 32, 74),
('2025-03-23','2025-04-06',NULL, 3, 33, 76),
('2025-03-24','2025-04-07',NULL, 4, 34, 78),
('2025-03-25','2025-04-08',NULL, 5, 35, 80),

('2025-03-26','2025-04-09',NULL, 6, 36, 82),
('2025-03-27','2025-04-10',NULL, 7, 37, 84),
('2025-03-28','2025-04-11',NULL, 8, 38, 86),
('2025-03-29','2025-04-12',NULL, 9, 39, 88),
('2025-03-30','2025-04-13',NULL,10, 40, 90),

('2025-04-01','2025-04-15',NULL, 1, 41, 92),
('2025-04-02','2025-04-16',NULL, 2, 42, 94),
('2025-04-03','2025-04-17',NULL, 3, 43, 96),
('2025-04-04','2025-04-18',NULL, 4, 44, 98),
('2025-04-05','2025-04-19',NULL, 5, 45,100),

-- Mixed older loans
('2024-10-01','2024-10-15','2024-10-13', 3, 21, 42),
('2024-10-05','2024-10-19','2024-10-18', 4, 22, 44),
('2024-10-10','2024-10-24', NULL,        5, 23, 46),
('2024-10-12','2024-10-26','2024-10-25', 6, 24, 48),
('2024-10-15','2024-10-29', NULL,        7, 25, 50);
