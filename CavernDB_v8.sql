-- =====================================================
-- ORIGINAL SQL ISLAND DATABASE (snake_case version)
-- =====================================================

CREATE TYPE inhabitant_state AS ENUM ('friendly', 'evil', 'kidnapped', 'emigrated', '?');
CREATE TYPE inhabitant_gender AS ENUM ('m', 'f', 'd', '?');


-- =========================
-- VILLAGES
-- =========================

CREATE TABLE village (
    village_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    chief INTEGER NOT NULL
);


-- =========================
-- INHABITANTS
-- =========================

CREATE TABLE inhabitant (
    person_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    village_id INTEGER NOT NULL
        REFERENCES village(village_id),
    gender inhabitant_gender,
    job TEXT NOT NULL,
    gold INTEGER,
    state inhabitant_state,
    age INTEGER
);


-- =========================
-- ITEMS
-- =========================

CREATE TABLE item (
    item_name TEXT NOT NULL,
    owner INTEGER
);


INSERT INTO village (name, chief)
VALUES
('Monkeycity', 1),
('Cucumbertown', 6),
('Onionville',13);


INSERT INTO inhabitant (name, village_id, gender, job, gold, state, age)
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


INSERT INTO item (item_name, owner)
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
-- =====================================================

INSERT INTO village (name, chief)
VALUES ('Stonehaven', 1);


INSERT INTO inhabitant (name, village_id, gender, job, gold, state, age)
VALUES
('Anuk', 4, 'm', 'hunter', 0, 'friendly', 44),
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

CREATE TABLE tribe_member (
    person_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    gender inhabitant_gender,
    age INTEGER
);


-- =========================
-- THINGS
-- =========================

CREATE TABLE thing (
    thing_id SERIAL PRIMARY KEY,
    name TEXT,
    category TEXT,
    amount INTEGER
);


INSERT INTO thing (name, category, amount) VALUES
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
('roots','plant',6),
('rope', 'material', 0),
('stone weight', 'material', 0),
('trigger mechanism', 'tool', 0),
('mammoth trap', 'tool', 0);


-- =========================
-- CRAFTING
-- =========================

CREATE TABLE crafting (
    product_thing INTEGER REFERENCES thing(thing_id),
    required_thing INTEGER REFERENCES thing(thing_id),
    amount INTEGER
);


INSERT INTO crafting VALUES
(3,2,2),
(4,3,1),
(4,1,1),
(5,4,1),
(5,1,3),
(14,1,2),
(15,2,3),
(16,3,1),
(16,1,1),
(17,14,1),
(17,15,1),
(17,16,1);


-- =========================
-- COOKING METHODS
-- =========================

CREATE TABLE cooking_method (
    method_id SERIAL PRIMARY KEY,
    name TEXT,
    required_thing INTEGER REFERENCES thing(thing_id)
);

INSERT INTO cooking_method (name, required_thing) VALUES
('roast',6),
('boil',7);


-- =========================
-- FOOD
-- =========================

CREATE TABLE food (
    food_id SERIAL PRIMARY KEY,
    name TEXT,
    source_thing INTEGER REFERENCES thing(thing_id),
    method_id INTEGER REFERENCES cooking_method(method_id),
    tool_thing INTEGER REFERENCES thing(thing_id)
);

INSERT INTO food (name, source_thing, method_id, tool_thing) VALUES
('roasted deer',9,1,5),
('roasted boar',11,1,5),
('mammoth steak',8,1,4),
('berries',12,NULL,NULL),
('raw roots',13,NULL,NULL);


-- =========================
-- CAVE CONNECTIONS
-- =========================

CREATE TABLE cave_connection (
    cave_from TEXT,
    cave_to TEXT
);

INSERT INTO cave_connection VALUES
('entrance','cave_a'),
('cave_a','cave_b'),
('cave_b','cave_c'),
('cave_c','cave_d'),
('cave_d','cave_b'),
('cave_c','mammoth_room');


-- =========================
-- HIERARCHY
-- =========================

CREATE TABLE hierarchy (
    hierarchy_id SERIAL PRIMARY KEY,
    boss_id INTEGER REFERENCES inhabitant(person_id),
    worker_id INTEGER REFERENCES inhabitant(person_id),
    category TEXT
);


INSERT INTO hierarchy (boss_id, worker_id, category) VALUES
((SELECT person_id FROM inhabitant WHERE name = 'Anuk'), (SELECT person_id FROM inhabitant WHERE name = 'Nala'), 'food'),
((SELECT person_id FROM inhabitant WHERE name = 'Anuk'), (SELECT person_id FROM inhabitant WHERE name = 'Tara'), 'crafting'),
((SELECT person_id FROM inhabitant WHERE name = 'Anuk'), (SELECT person_id FROM inhabitant WHERE name = 'Bruk'), 'hunting'),
((SELECT person_id FROM inhabitant WHERE name = 'Anuk'), (SELECT person_id FROM inhabitant WHERE name = 'Lena'), 'hunting'),
((SELECT person_id FROM inhabitant WHERE name = 'Nala'), (SELECT person_id FROM inhabitant WHERE name = 'Thog'), 'food'),
((SELECT person_id FROM inhabitant WHERE name = 'Nala'), (SELECT person_id FROM inhabitant WHERE name = 'Grok'), 'food'),
((SELECT person_id FROM inhabitant WHERE name = 'Nala'), (SELECT person_id FROM inhabitant WHERE name = 'Zara'), 'food'),
((SELECT person_id FROM inhabitant WHERE name = 'Tara'), (SELECT person_id FROM inhabitant WHERE name = 'Korg'), 'crafting'),
((SELECT person_id FROM inhabitant WHERE name = 'Tara'), (SELECT person_id FROM inhabitant WHERE name = 'Mira'), 'crafting');


WITH hunting_team AS (
    SELECT boss_id, worker_id, category
    FROM hierarchy
    WHERE category = 'crafting'
)
SELECT 
    b.name AS boss,
    w.name AS worker,
    w.job AS worker_job,
    h.category
FROM hunting_team h
JOIN inhabitant b ON h.boss_id = b.person_id
JOIN inhabitant w ON h.worker_id = w.person_id;