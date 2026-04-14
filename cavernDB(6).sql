-- =====================================================
-- ORIGINAL SQL ISLAND DATABASE
-- =====================================================

CREATE TYPE inhabitant_state AS ENUM ('friendly', 'evil', 'kidnapped', 'emigrated', '?');
CREATE TYPE inhabitant_gender AS ENUM ('m', 'f', 'd', '?');


-- =========================
-- VILLAGES
-- =========================

CREATE TABLE Village (
    villageid SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    chief INTEGER NOT NULL
);


-- =========================
-- INHABITANTS
-- =========================

CREATE TABLE Inhabitant (
    personid SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    villageid INTEGER NOT NULL
        REFERENCES Village(villageid),
    gender inhabitant_gender,
    job TEXT NOT NULL,
    gold INTEGER,
    state inhabitant_state,
    age INTEGER
);


-- =========================
-- ITEMS (original game items)
-- =========================

CREATE TABLE Item (
    item TEXT NOT NULL,
    owner INTEGER
);


INSERT INTO Village (name, chief)
VALUES
('Monkeycity', 1),
('Cucumbertown', 6),
('Onionville',13);


INSERT INTO Inhabitant (name, villageid, gender, job, gold, state, age)
VALUES
('Paul Bakerman', 1, 'm', 'baker', 850, 'friendly', 42),
('Ernest Perry', 3, 'm', 'weaponsmith', 280, 'friendly', 57),
('Rita Ox', 1, 'f', 'baker', 350, 'friendly', 31),
('Carl Ox', 1, 'm', 'merchant', 250, 'friendly', 46),
('Dirty Dieter', 3, 'm', 'smith', 650, 'evil', 61),
('Gerry Slaughterer', 2, 'm', 'butcher', 4850, 'evil', 54),
('Peter Slaughterer', 3, 'm', 'butcher', 3250, 'evil', 39),
('Arthur Tailor', 2, 'm', 'pilot', 490, 'kidnapped', 28),
('Tiffany Drummer', 1, 'f', 'baker', 550, 'evil', 22),
('Peter Drummer', 1, 'm', 'smith', 600, 'friendly', 34),
('Dirty Diane', 3, 'f', 'farmer', 10, 'evil', 63),
('Otto Alexander', 2, 'm', 'dealer', 680, 'friendly', 51),
('Fred Dix', 3, 'm', 'author', 420, 'friendly', 47),
('Enrico Carpenter', 3, 'm', 'weaponsmith', 510, 'evil', 36),
('Helen Grasshead', 2, 'f', 'dealer', 680, 'friendly', 44),
('Ivy Hatter', 1, 'f', 'dealer', 770, 'evil', 27),
('Edward Grasshead', 3, 'm', 'butcher', 990, 'friendly', 59),
('Ryan Horse', 3, 'm', 'blacksmith', 390, 'friendly', 33),
('Ann Meaty', 2, 'f', 'butcher', 2280, 'friendly', 41);


INSERT INTO Item (item, owner)
VALUES
('teapot', NULL),
('cane', 5),
('hammer', 2),
('ring', NULL),
('coffee cup', NULL),
('bucket', NULL),
('rope', 17),
('carton', NULL),
('lightbulb', NULL);



-- =====================================================
-- CAVEMAN EXTENSION
-- Aruk and Lena show the resources of their cave tribe
-- =====================================================

-- =========================
-- Insert the new village for the cave tribe.
-- =========================
INSERT INTO Village (name, chief)
VALUES ('Stonehaven', 1);

-- =========================
-- Insert new inhabitants and let the player move them to the new table 'TribeMember', so we can test CTEs handling.
-- =========================
INSERT INTO Inhabitant (name, villageid, gender, job, gold, state, age)
VALUES
('Aruk', 4, 'm', 'hunter', 0, 'friendly', 44),
('Lena', 4, 'f', 'gatherer', 0, 'friendly', 23),
('Bruk', 4, 'm', 'toolmaker', 0, 'friendly', 38),
('Nala', 4, 'f', 'cook', 0, 'friendly', 29),
('Thog', 4, 'm', 'hunter', 0, 'friendly', 52),
('Zara', 4, 'f', 'gatherer', 0, 'friendly', 17),
('Korg', 4, 'm', 'gatherer', 0, 'friendly', 61),
('Mira', 4, 'f', 'toolmaker', 0, 'friendly', 34),
('Tara', 4, 'f', 'hunter', 0, 'friendly', 12),
('Grok', 4, 'm', 'hunter', 0, 'friendly', 47);



-- =========================
-- TRIBE MEMBERS
-- =========================

CREATE TABLE TribeMember (
    personid SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    gender inhabitant_gender,
    age INTEGER
);

-- Let the player add tribe members as they meet them in the game, so we can test CTEs handling.
/* INSERT INTO TribeMember (name, role, gender, age) VALUES
('Aruk', 'hunter', 'm', 44),
('Lena', 'gatherer', 'f', 23),
('Bruk', 'toolmaker', 'm', 38),
('Nala', 'cook', 'f', 29); etc...*/


-- =========================
-- THINGS
-- Simple table for everything the tribe has
-- (animals, plants, materials, tools)
-- =========================

CREATE TABLE Thing (
    thingid SERIAL PRIMARY KEY,
    name TEXT,
    category TEXT,
    amount INTEGER
);

INSERT INTO Thing (name, category, amount) VALUES
('wood','material',1),
('stone','material',2),
('sharp stone','tool',0),
('knife','tool',0),
('spear','tool',0),
('fire','resource',NULL),
('water','resource',2),
('mammoth','animal',0),
('deer','animal',0),
('fish','animal',0),
('boar','animal',0),
('berries','plant',5),
('roots','plant',6);

INSERT INTO Thing (name, category, amount) VALUES
('rope', 'material', 0),
('stone weight', 'material', 0),
('trigger mechanism', 'tool', 0),
('mammoth trap', 'tool', 0);



-- =========================
-- CRAFTING
-- Defines how things are crafted
-- Enables recursive crafting queries
-- =========================

CREATE TABLE Crafting (
    product_thing INTEGER REFERENCES Thing(thingid),
    required_thing INTEGER REFERENCES Thing(thingid),
    amount INTEGER
);

-- Crafting rules
-- (product_thing, required_thing, amount)

INSERT INTO Crafting VALUES
(3,2,2), -- sharp stone requires 2 stones
(4,3,1), -- knife requires 1 sharp stone
(4,1,1), -- knife requires 1 wood
(5,4,1), -- spear requires 1 knife
(5,1,3); -- spear requires 3 wood

-- Crafting rules for mammoth trap
INSERT INTO Crafting VALUES (14, 1, 2); -- rope requires 2 wood (twisted fibers)
INSERT INTO Crafting VALUES (15, 2, 3); -- stone weight requires 3 stones
INSERT INTO Crafting VALUES (16, 3, 1); -- trigger mechanism requires 1 sharp stone + 1 wood
INSERT INTO Crafting VALUES (16, 1, 1);
-- mammoth trap requires rope + stone weight + trigger mechanism
INSERT INTO Crafting VALUES (17, 14, 1);
INSERT INTO Crafting VALUES (17, 15, 1);
INSERT INTO Crafting VALUES (17, 16, 1);

-- =========================
-- COOKING METHODS
-- =========================

CREATE TABLE CookingMethod (
    methodid SERIAL PRIMARY KEY,
    name TEXT,
    required_thing INTEGER REFERENCES Thing(thingid)
);

INSERT INTO CookingMethod (name, required_thing) VALUES
('roast',6),
('boil',7);


-- =========================
-- FOOD
-- =========================

CREATE TABLE Food (
    foodid SERIAL PRIMARY KEY,
    name TEXT,
    source_thing INTEGER REFERENCES Thing(thingid),
    methodid INTEGER REFERENCES CookingMethod(methodid),
    tool_thing INTEGER REFERENCES Thing(thingid)
);

-- Food preparation
-- (food name, source animal/plant, cooking method, required tool)

INSERT INTO Food (name, source_thing, methodid, tool_thing) VALUES
('roasted deer',9,1,5),   -- deer roasted with fire using a spear
('roasted boar',11,1,5),  -- boar roasted with fire using a spear
('mammoth steak',8,1,4),  -- mammoth roasted with fire using a knife
('berries',12,NULL,NULL), -- berries can be eaten raw
('raw roots',13,NULL,NULL); -- roots eaten raw


-- =========================
-- CAVE CONNECTIONS
-- Used for recursive CTE exploration
-- =========================

CREATE TABLE CaveConnection (
    cave_from TEXT,
    cave_to TEXT
);

INSERT INTO CaveConnection VALUES
('entrance','cave_a'),
('cave_a','cave_b'),
('cave_b','cave_c'),
('cave_c','cave_d'),
('cave_d','cave_b'),
('cave_c','mammoth_room');
-----------------------------------
--Boss Hierarchy
-----------------------------------

CREATE TABLE hierarchy (
    hierarchyid SERIAL PRIMARY KEY,
    boss_id INTEGER REFERENCES Inhabitant(personid),
    worker_id INTEGER REFERENCES Inhabitant(personid),
    category TEXT
);

-- Chief Aruk leads tribe 
INSERT INTO hierarchy (boss_id, worker_id, category) VALUES
((SELECT personid FROM Inhabitant WHERE name = 'Aruk'), (SELECT personid FROM Inhabitant WHERE name = 'Nala'), 'food'),
((SELECT personid FROM Inhabitant WHERE name = 'Aruk'), (SELECT personid FROM Inhabitant WHERE name = 'Tara'), 'crafting');

-- Team 1: Hunting
INSERT INTO hierarchy (boss_id, worker_id, category) VALUES
((SELECT personid FROM Inhabitant WHERE name = 'Aruk'), (SELECT personid FROM Inhabitant WHERE name = 'Bruk'), 'hunting'),
((SELECT personid FROM Inhabitant WHERE name = 'Aruk'), (SELECT personid FROM Inhabitant WHERE name = 'Lena'), 'hunting');

-- Team 2: Food
INSERT INTO hierarchy (boss_id, worker_id, category) VALUES
((SELECT personid FROM Inhabitant WHERE name = 'Nala'), (SELECT personid FROM Inhabitant WHERE name = 'Thog'), 'food'),
((SELECT personid FROM Inhabitant WHERE name = 'Nala'), (SELECT personid FROM Inhabitant WHERE name = 'Grok'), 'food'),
((SELECT personid FROM Inhabitant WHERE name = 'Nala'), (SELECT personid FROM Inhabitant WHERE name = 'Zara'), 'food');

-- Team 3: Crafting
INSERT INTO hierarchy (boss_id, worker_id, category) VALUES
((SELECT personid FROM Inhabitant WHERE name = 'Tara'), (SELECT personid FROM Inhabitant WHERE name = 'Korg'), 'crafting'),
((SELECT personid FROM Inhabitant WHERE name = 'Tara'), (SELECT personid FROM Inhabitant WHERE name = 'Mira'), 'crafting');


WITH hunting_team AS (
    SELECT 
        h.boss_id,
        h.worker_id,
        h.category
    FROM hierarchy h
    WHERE h.category = 'crafting'
)
SELECT 
    b.name AS boss,
    w.name AS worker,
    w.job AS worker_job,
    h.category
FROM hunting_team h
JOIN inhabitant b ON h.boss_id = b.personid
JOIN inhabitant w ON h.worker_id = w.personid;

---------------------------------------------