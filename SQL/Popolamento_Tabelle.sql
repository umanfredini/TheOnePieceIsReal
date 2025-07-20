-- 1. Popolamento tabella personaggi
INSERT INTO characters (name) VALUES
('Luffy'), ('Zoro'), ('Sanji'), ('Jinbei'), ('Robin'), ('Brook'), 
('Franky'), ('Nami'), ('Chopper'), ('Usopp'), ('Law'), ('Kidd'), 
('Ace'), ('Sabo'), ('Shanks'), ('Kaido'), ('Barbabianca'), 
('Barbanera'), ('Roger');

-- 2. Popolamento prodotti
-- PRODOTTI PER PERSONAGGI
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
-- Luffy
('Poster 1.5m', 'Poster ufficiale Monkey D. Luffy (1.5 metri)', 24.99, '/images/posters/luffy_1.5m.jpg', 'Poster', 15, TRUE),
('Maglia Bandiera', 'Maglietta bandiera pirati di Cappello di Paglia', 29.99, '/images/abbigliamento/luffy_bandiera.jpg', 'Abbigliamento', 20, FALSE),
('Maglia Legend', 'Maglietta "Future King of Pirates"', 32.99, '/images/abbigliamento/luffy_legend.jpg', 'Abbigliamento', 18, TRUE),
('Maglia Occhiata', 'Maglietta con occhiata caratteristica di Luffy', 31.99, '/images/abbigliamento/luffy_occhiata.jpg', 'Abbigliamento', 15, FALSE),
('Cosplay', 'Completo cosplay Monkey D. Luffy completo', 89.99, '/images/cosplay/luffy_completo.jpg', 'Abbigliamento', 8, TRUE),
('Quadro Gear4', 'Quadro Luffy Gear Fourth - Stampa artistica', 59.99, '/images/quadri/luffy_gear4.jpg', 'Quadro', 12, TRUE),
('Quadro Wano', 'Quadro Luffy a Wano Kuni - Edizione limitata', 54.99, '/images/quadri/luffy_wano.jpg', 'Quadro', 10, FALSE),
('Figure', 'Action Figure Monkey D. Luffy - Classica', 49.99, '/images/figure/luffy_classic.jpg', 'Figure', 25, FALSE),
('Maglia Snakeman', 'Maglietta Luffy Snakeman design esclusivo', 34.99, '/images/abbigliamento/luffy_snakeman.jpg', 'Abbigliamento', 16, TRUE),
('Cosplay Wano', 'Completo cosplay Luffy stile Wano', 94.99, '/images/cosplay/luffy_wano.jpg', 'Abbigliamento', 6, TRUE),
('Quadro Colorful', 'Quadro colorato Luffy - Tecnica mista', 49.99, '/images/quadri/luffy_colorful.jpg', 'Quadro', 8, FALSE),
('Figure Gear4', 'Action Figure Luffy Gear Fourth Boundman', 79.99, '/images/figure/luffy_gear4_bound.jpg', 'Figure', 7, TRUE),
('Figure ASL', 'Action Figure Luffy, Ace e Sabo da bambini', 74.99, '/images/figure/asl_trio.jpg', 'Figure', 9, TRUE),
('Figure King', 'Action Figure Luffy Re dei Pirati Edition', 89.99, '/images/figure/luffy_king.jpg', 'Figure', 5, TRUE),
('Figure w/Law', 'Action Figure Luffy & Trafalgar Law', 69.99, '/images/figure/luffy_law.jpg', 'Figure', 6, FALSE),
('Figure w/Ace', 'Action Figure Luffy & Portgas D. Ace', 72.99, '/images/figure/luffy_ace.jpg', 'Figure', 8, TRUE),

-- Zoro
('Quadro Wano', 'Stampa artistica Roronoa Zoro a Wano', 49.99, '/images/quadri/zoro_wano.jpg', 'Quadro', 11, FALSE),
('Poster 120m', 'Poster bounty Zoro (120 milioni)', 19.99, '/images/posters/zoro_120m.jpg', 'Poster', 20, FALSE),
('Poster 320m', 'Poster bounty Zoro (320 milioni)', 22.99, '/images/posters/zoro_320m.jpg', 'Poster', 18, TRUE),
('Maglia Albero', 'Maglietta Zoro "Nothing Happened"', 31.99, '/images/abbigliamento/zoro_albero.jpg', 'Abbigliamento', 15, TRUE),
('Maglia Luna', 'Maglietta Zoro taglia la luna', 29.99, '/images/abbigliamento/zoro_luna.jpg', 'Abbigliamento', 14, FALSE),
('Cosplay Wano', 'Completo cosplay Zoro stile Wano', 99.99, '/images/cosplay/zoro_wano.jpg', 'Abbigliamento', 5, TRUE),
('Maglia Santoryu', 'Maglietta Zoro Santoryu style', 33.99, '/images/abbigliamento/zoro_santoryu.jpg', 'Abbigliamento', 12, FALSE),
('Cosplay', 'Completo cosplay Roronoa Zoro classico', 84.99, '/images/cosplay/zoro_classic.jpg', 'Abbigliamento', 7, FALSE),
('Quadro Asura', 'Quadro Zoro Asura - Edizione speciale', 64.99, '/images/quadri/zoro_asura.jpg', 'Quadro', 6, TRUE),
('Quadro Colorful', 'Quadro colorato Zoro - Tecnica mista', 47.99, '/images/quadri/zoro_colorful.jpg', 'Quadro', 9, FALSE),
('Figure', 'Action Figure Roronoa Zoro - Classica', 54.99, '/images/figure/zoro_classic.jpg', 'Figure', 22, FALSE),
('Figure King', 'Action Figure Zoro King of Hell', 89.99, '/images/figure/zoro_king.jpg', 'Figure', 4, TRUE),
('Figure BountyHunter', 'Action Figure Zoro cacciatore di taglie', 59.99, '/images/figure/zoro_bountyhunter.jpg', 'Figure', 8, FALSE),

-- Sanji
('Figure New World', 'Action Figure Sanji New World', 67.99, '/images/figure/sanji_newworld.jpg', 'Figure', 10, FALSE),
('Poster 330m', 'Poster bounty Sanji (330 milioni)', 21.99, '/images/posters/sanji_330m.jpg', 'Poster', 17, FALSE),
('Cosplay', 'Completo cosplay Vinsmoke Sanji', 79.99, '/images/cosplay/sanji_classic.jpg', 'Abbigliamento', 6, FALSE),
('Cosplay Wano', 'Completo cosplay Sanji stile Wano', 89.99, '/images/cosplay/sanji_wano.jpg', 'Abbigliamento', 5, TRUE),
('Quadro Colorful', 'Quadro colorato Sanji - Tecnica mista', 44.99, '/images/quadri/sanji_colorful.jpg', 'Quadro', 8, FALSE),
('Figure SobaMask', 'Action Figure Sanji Soba Mask', 74.99, '/images/figure/sanji_sobamask.jpg', 'Figure', 7, TRUE),
('Figure King', 'Action Figure Sanji Germa 66', 69.99, '/images/figure/sanji_king.jpg', 'Figure', 6, FALSE),

-- Jinbei
('Figure', 'Action Figure Jinbei - Versione classica', 64.99, '/images/figure/jinbei_classic.jpg', 'Figure', 9, FALSE),
('Poster 400m', 'Poster bounty Jinbei (438 milioni)', 23.99, '/images/posters/jinbei_400m.jpg', 'Poster', 13, TRUE),
('Figure King', 'Action Figure Jinbei Cavaliere di Mari', 79.99, '/images/figure/jinbei_king.jpg', 'Figure', 5, TRUE),

-- Robin
('Poster 130m', 'Poster bounty Robin (130 milioni)', 18.99, '/images/posters/robin_130m.jpg', 'Poster', 16, FALSE),
('Cosplay', 'Completo cosplay Nico Robin classico', 82.99, '/images/cosplay/robin_classic.jpg', 'Abbigliamento', 7, FALSE),
('Cosplay Wano', 'Completo cosplay Robin stile Wano', 92.99, '/images/cosplay/robin_wano.jpg', 'Abbigliamento', 4, TRUE),
('Figure', 'Action Figure Nico Robin - Classica', 59.99, '/images/figure/robin_classic.jpg', 'Figure', 11, FALSE),
('Figure Queen', 'Action Figure Robin Demonio dei Mari', 72.99, '/images/figure/robin_queen.jpg', 'Figure', 6, TRUE),
('Figure New World', 'Action Figure Robin New World', 67.99, '/images/figure/robin_newworld.jpg', 'Figure', 8, FALSE),

-- Brook
('Poster 83m', 'Poster bounty Brook (83 milioni)', 17.99, '/images/posters/brook_83m.jpg', 'Poster', 14, FALSE),
('Quadro Colorful', 'Quadro colorato Brook - Tecnica mista', 42.99, '/images/quadri/brook_colorful.jpg', 'Quadro', 7, FALSE),
('Figure', 'Action Figure Brook - Classica', 62.99, '/images/figure/brook_classic.jpg', 'Figure', 10, FALSE),
('Figure King', 'Action Figure Brook Soul King', 77.99, '/images/figure/brook_king.jpg', 'Figure', 5, TRUE),
('Figure Soul', 'Action Figure Brook con anima', 69.99, '/images/figure/brook_soul.jpg', 'Figure', 6, FALSE),
('Figure New World', 'Action Figure Brook New World', 64.99, '/images/figure/brook_newworld.jpg', 'Figure', 7, FALSE),

-- Franky
('Poster 94m', 'Poster bounty Franky (94 milioni)', 19.99, '/images/posters/franky_94m.jpg', 'Poster', 15, FALSE),
('Quadro Colorful', 'Quadro colorato Franky - Tecnica mista', 47.99, '/images/quadri/franky_colorful.jpg', 'Quadro', 6, FALSE),
('Figure', 'Action Figure Franky - Classica', 67.99, '/images/figure/franky_classic.jpg', 'Figure', 9, FALSE),
('Figure Shogun', 'Action Figure General Franky Shogun', 119.99, '/images/figure/franky_shogun.jpg', 'Figure', 3, TRUE),
('Figure King', 'Action Figure Franky Iron Pirate', 84.99, '/images/figure/franky_king.jpg', 'Figure', 4, FALSE),

-- Nami
('Cosplay Wano', 'Completo cosplay Nami stile Wano', 87.99, '/images/cosplay/nami_wano.jpg', 'Abbigliamento', 5, TRUE),
('Figure', 'Action Figure Nami - Classica', 54.99, '/images/figure/nami_classic.jpg', 'Figure', 13, FALSE),
('Poster 66m', 'Poster bounty Nami (66 milioni)', 16.99, '/images/posters/nami_66m.jpg', 'Poster', 18, FALSE),
('Figure Chibi', 'Chibi Figure Nami - Edizione limitata', 34.99, '/images/figure/nami_chibi.jpg', 'Figure', 20, TRUE),
('Figure Queen', 'Action Figure Nami Regina dei Mari', 69.99, '/images/figure/nami_queen.jpg', 'Figure', 7, FALSE),
('Figure Pre', 'Action Figure Nami Pre-timeskip', 59.99, '/images/figure/nami_pre.jpg', 'Figure', 9, FALSE),

-- Chopper
('Poster 100', 'Poster bounty Chopper (100 Berry)', 14.99, '/images/posters/chopper_100.jpg', 'Poster', 25, TRUE),
('Maglia', 'Maglietta Tony Tony Chopper', 27.99, '/images/abbigliamento/chopper_maglia.jpg', 'Abbigliamento', 22, FALSE),
('Quadro Colorful', 'Quadro colorato Chopper - Tecnica mista', 39.99, '/images/quadri/chopper_colorful.jpg', 'Quadro', 11, FALSE),
('Pelouche', 'Pelouche Tony Tony Chopper (40cm)', 29.99, '/images/pelouche/chopper_40cm.jpg', 'Pelouche', 30, TRUE),
('Figure', 'Action Figure Chopper - Classica', 44.99, '/images/figure/chopper_classic.jpg', 'Figure', 18, FALSE),
('Figure King', 'Action Figure Chopper Monster Point', 74.99, '/images/figure/chopper_king.jpg', 'Figure', 5, TRUE),
('Figure Horn Point', 'Action Figure Chopper Horn Point', 59.99, '/images/figure/chopper_horn.jpg', 'Figure', 8, FALSE),

-- Usopp
('Poster 200m', 'Poster bounty Usopp (200 milioni)', 20.99, '/images/posters/usopp_200m.jpg', 'Poster', 16, TRUE),
('Figure', 'Action Figure Usopp - Classica', 52.99, '/images/figure/usopp_classic.jpg', 'Figure', 12, FALSE),
('Figure New World', 'Action Figure God Usopp', 64.99, '/images/figure/usopp_god.jpg', 'Figure', 7, TRUE),
('Figure Sogeking', 'Action Figure Sogeking con Kabuto', 57.99, '/images/figure/usopp_sogeking.jpg', 'Figure', 9, FALSE),

-- Law
('Figure w/Luffy', 'Action Figure Law & Luffy Alliance', 89.99, '/images/figure/law_luffy.jpg', 'Figure', 6, TRUE),
('Maglia', 'Maglietta Trafalgar Law Heart Pirates', 32.99, '/images/abbigliamento/law_maglia.jpg', 'Abbigliamento', 14, FALSE),
('Cosplay', 'Completo cosplay Trafalgar Law', 84.99, '/images/cosplay/law_classic.jpg', 'Abbigliamento', 5, TRUE),
('Quadro', 'Quadro Trafalgar Law - Surgeon of Death', 54.99, '/images/quadri/law_quadro.jpg', 'Quadro', 8, FALSE),
('Quadro Colorful', 'Quadro colorato Law - Tecnica mista', 49.99, '/images/quadri/law_colorful.jpg', 'Quadro', 7, FALSE),
('Figure', 'Action Figure Trafalgar Law - Classica', 69.99, '/images/figure/law_classic.jpg', 'Figure', 10, FALSE),
('Figure New World', 'Action Figure Law New World', 74.99, '/images/figure/law_newworld.jpg', 'Figure', 6, FALSE),

-- Kidd
('Figure', 'Action Figure Eustass Kid Supernova', 67.99, '/images/figure/kidd_supernova.jpg', 'Figure', 8, FALSE),

-- Ace
('Figure ASL', 'Action Figure Ace, Sabo, Luffy da bambini', 74.99, '/images/figure/asl_trio.jpg', 'Figure', 9, TRUE),
('Maglia', 'Maglietta Portgas D. Ace', 31.99, '/images/abbigliamento/ace_maglia.jpg', 'Abbigliamento', 16, FALSE),
('Poster 550m', 'Poster bounty Ace (550 milioni)', 25.99, '/images/posters/ace_550m.jpg', 'Poster', 12, TRUE),
('Figure w/Luffy', 'Action Figure Ace & Luffy', 72.99, '/images/figure/ace_luffy.jpg', 'Figure', 8, TRUE),
('Maglia Barbabianca', 'Maglietta Ace con simbolo Barbabianca', 33.99, '/images/abbigliamento/ace_barbabianca.jpg', 'Abbigliamento', 15, FALSE),
('Quadro Colorful', 'Quadro colorato Ace - Tecnica mista', 52.99, '/images/quadri/ace_colorful.jpg', 'Quadro', 6, FALSE),
('Figure', 'Action Figure Portgas D. Ace - Classica', 64.99, '/images/figure/ace_classic.jpg', 'Figure', 11, FALSE),
('Figure King', 'Action Figure Ace Flame Emperor', 79.99, '/images/figure/ace_king.jpg', 'Figure', 5, TRUE),

-- Sabo
('Figure ASL', 'Action Figure Sabo, Ace, Luffy da bambini', 74.99, '/images/figure/asl_trio.jpg', 'Figure', 9, TRUE),
('Pelouche', 'Pelouche Sabo (35cm)', 32.99, '/images/pelouche/sabo_35cm.jpg', 'Pelouche', 18, FALSE),
('Figure', 'Action Figure Sabo - Classica', 66.99, '/images/figure/sabo_classic.jpg', 'Figure', 10, FALSE),
('Figure Flame Emperor', 'Action Figure Sabo Flame Emperor', 84.99, '/images/figure/sabo_flame.jpg', 'Figure', 4, TRUE),

-- Shanks
('Poster 4M', 'Poster bounty Shanks (4.048M)', 28.99, '/images/posters/shanks_4m.jpg', 'Poster', 11, TRUE),
('Cosplay', 'Completo cosplay Shanks il Rosso', 119.99, '/images/cosplay/shanks_classic.jpg', 'Abbigliamento', 3, FALSE),
('Quadro Colorful', 'Quadro colorato Shanks - Tecnica mista', 64.99, '/images/quadri/shanks_colorful.jpg', 'Quadro', 5, FALSE),
('Figure', 'Action Figure Shanks - Classica', 89.99, '/images/figure/shanks_classic.jpg', 'Figure', 7, FALSE),
('Figure King', 'Action Figure Shanks Emperor Edition', 129.99, '/images/figure/shanks_king.jpg', 'Figure', 3, TRUE),
('Figure Chibi', 'Chibi Figure Shanks - 15cm', 37.99, '/images/figure/shanks_chibi.jpg', 'Figure', 12, FALSE),

-- Kaido
('Poster 4M', 'Poster bounty Kaido (4.611M)', 29.99, '/images/posters/kaido_4m.jpg', 'Poster', 9, TRUE),
('Figure', 'Action Figure Kaido Dragon Form', 139.99, '/images/figure/kaido_dragon.jpg', 'Figure', 4, TRUE),

-- Barbabianca
('Poster 5M', 'Poster bounty Barbabianca (5.046M)', 30.99, '/images/posters/barbabianca_5m.jpg', 'Poster', 8, TRUE),
('Maglia', 'Maglietta Edward Newgate Barbabianca', 35.99, '/images/abbigliamento/barbabianca_maglia.jpg', 'Abbigliamento', 13, FALSE),
('Figure', 'Action Figure Barbabianca - Classica', 109.99, '/images/figure/barbabianca_classic.jpg', 'Figure', 6, FALSE),
('Figure King', 'Action Figure Barbabianca Emperor Edition', 149.99, '/images/figure/barbabianca_king.jpg', 'Figure', 3, TRUE),

-- Barbanera
('Poster 2M', 'Poster bounty Barbanera (2.247M)', 26.99, '/images/posters/barbanera_2m.jpg', 'Poster', 10, FALSE),
('Figure', 'Action Figure Marshall D. Teach', 99.99, '/images/figure/barbanera_classic.jpg', 'Figure', 7, FALSE),
('Figure King', 'Action Figure Barbanera Emperor Edition', 139.99, '/images/figure/barbanera_king.jpg', 'Figure', 3, TRUE),

-- Roger
('Poster 5M', 'Poster bounty Gol D. Roger (5.564M)', 31.99, '/images/posters/roger_5m.jpg', 'Poster', 9, TRUE),
('Quadro', 'Quadro Gol D. Roger - Edizione commemorativa', 79.99, '/images/quadri/roger_quadro.jpg', 'Quadro', 6, TRUE),
('Figure', 'Action Figure Gol D. Roger', 149.99, '/images/figure/roger_classic.jpg', 'Figure', 4, TRUE),

-- Navi
('Going Merry', 'Modellino nave Going Merry scala 1/100', 179.99, '/images/navi/going_merry.jpg', 'Navi', 5, TRUE),
('Queen Mama Chanter', 'Modellino Queen Mama Chanter scala 1/150', 199.99, '/images/navi/queen_mama.jpg', 'Navi', 3, FALSE),
('Baratie', 'Modellino ristorante galleggiante Baratie', 159.99, '/images/navi/baratie.jpg', 'Navi', 4, FALSE),
('Arca Maxim', 'Modellino Arca Maxim di Enel', 189.99, '/images/navi/arca_maxim.jpg', 'Navi', 3, FALSE),
('Thousand Sunny', 'Modellino Thousand Sunny scala 1/100', 219.99, '/images/navi/thousand_sunny.jpg', 'Navi', 6, TRUE);

-- PRODOTTI BASE PER GADGET
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Portachiavi', 'Portachiavi ufficiale One Piece', 12.99, '/images/gadget/portachiavi_base.jpg', 'Gadget', 0, FALSE),
('Portafoglio', 'Portafoglio in pelle con logo One Piece', 34.99, '/images/gadget/portafoglio_base.jpg', 'Gadget', 0, FALSE),
('Bracciale', 'Bracciale in silicone resistente', 9.99, '/images/gadget/bracciale_base.jpg', 'Gadget', 0, FALSE),
('Cappelli', 'Cappelli ufficiali One Piece', 29.99, '/images/gadget/cappelli_base.jpg', 'Gadget', 0, FALSE);

-- 3. Popolamento associazioni prodotto-personaggio
-- POPOLAMENTO TABELLA PRODUCT_CHARACTERS (ASSOCIAZIONI COMPLETE)
INSERT INTO product_characters (product_id, character_id, is_primary) 
SELECT p.id, c.id, TRUE
FROM (
    -- MAPPATURA PRODOTTI -> PERSONAGGI
    SELECT name AS product_name, 'Luffy' AS character_name FROM products WHERE name IN (
        'Poster 1.5m', 'Maglia Bandiera', 'Maglia Legend', 'Maglia Occhiata', 'Cosplay', 'Quadro Gear4', 'Quadro Wano', 'Figure', 
        'Maglia Snakeman', 'Cosplay Wano', 'Quadro Colorful', 'Figure Gear4', 'Figure ASL', 'Figure King', 'Figure w/Law', 'Figure w/Ace'
    ) UNION ALL
    SELECT name, 'Zoro' FROM products WHERE name IN (
        'Quadro Wano', 'Poster 120m', 'Poster 320m', 'Maglia Albero', 'Maglia Luna', 'Cosplay Wano', 'Maglia Santoryu', 'Cosplay', 
        'Quadro Asura', 'Quadro Colorful', 'Figure', 'Figure King', 'Figure BountyHunter'
    ) UNION ALL
    SELECT name, 'Sanji' FROM products WHERE name IN (
        'Figure New World', 'Poster 330m', 'Cosplay', 'Cosplay Wano', 'Quadro Colorful', 'Figure SobaMask', 'Figure King'
    ) UNION ALL
    SELECT name, 'Jinbei' FROM products WHERE name IN (
        'Figure', 'Poster 400m', 'Figure King'
    ) UNION ALL
    SELECT name, 'Robin' FROM products WHERE name IN (
        'Poster 130m', 'Cosplay', 'Cosplay Wano', 'Figure', 'Figure Queen', 'Figure New World'
    ) UNION ALL
    SELECT name, 'Brook' FROM products WHERE name IN (
        'Poster 83m', 'Quadro Colorful', 'Figure', 'Figure King', 'Figure Soul', 'Figure New World'
    ) UNION ALL
    SELECT name, 'Franky' FROM products WHERE name IN (
        'Poster 94m', 'Quadro Colorful', 'Figure', 'Figure Shogun', 'Figure King'
    ) UNION ALL
    SELECT name, 'Nami' FROM products WHERE name IN (
        'Cosplay Wano', 'Figure', 'Poster 66m', 'Figure Chibi', 'Figure Queen', 'Figure Pre'
    ) UNION ALL
    SELECT name, 'Chopper' FROM products WHERE name IN (
        'Poster 100', 'Maglia', 'Quadro Colorful', 'Pelouche', 'Figure', 'Figure King', 'Figure Horn Point'
    ) UNION ALL
    SELECT name, 'Usopp' FROM products WHERE name IN (
        'Poster 200m', 'Figure', 'Figure New World', 'Figure Sogeking'
    ) UNION ALL
    SELECT name, 'Law' FROM products WHERE name IN (
        'Figure w/Luffy', 'Maglia', 'Cosplay', 'Quadro', 'Quadro Colorful', 'Figure', 'Figure New World'
    ) UNION ALL
    SELECT name, 'Kidd' FROM products WHERE name IN ('Figure') 
    UNION ALL
    SELECT name, 'Ace' FROM products WHERE name IN (
        'Figure ASL', 'Maglia', 'Poster 550m', 'Figure w/Luffy', 'Maglia Barbabianca', 'Quadro Colorful', 'Figure', 'Figure King'
    ) UNION ALL
    SELECT name, 'Sabo' FROM products WHERE name IN (
        'Figure ASL', 'Pelouche', 'Figure', 'Figure Flame Emperor'
    ) UNION ALL
    SELECT name, 'Shanks' FROM products WHERE name IN (
        'Poster 4M', 'Cosplay', 'Quadro Colorful', 'Figure', 'Figure King', 'Figure Chibi'
    ) UNION ALL
    SELECT name, 'Kaido' FROM products WHERE name IN ('Poster 4M', 'Figure') 
    UNION ALL
    SELECT name, 'Barbabianca' FROM products WHERE name IN (
        'Poster 5M', 'Maglia', 'Figure', 'Figure King'
    ) UNION ALL
    SELECT name, 'Barbanera' FROM products WHERE name IN ('Poster 2M', 'Figure', 'Figure King') 
    UNION ALL
    SELECT name, 'Roger' FROM products WHERE name IN ('Poster 5M', 'Quadro', 'Figure') 
    UNION ALL
    SELECT name, 'Going Merry' FROM products WHERE name = 'Going Merry'
) AS mapping
JOIN products p ON p.name = mapping.product_name
JOIN characters c ON c.name = mapping.character_name;

-- AGGIUNTA ASSOCIAZIONI MULTI-PERSONAGGIO (ES: FIGURE ASL)
INSERT INTO product_characters (product_id, character_id, is_primary)
SELECT p.id, c.id, TRUE
FROM (
    SELECT 'Figure ASL' AS product_name, 'Ace' AS character_name
    UNION ALL SELECT 'Figure ASL', 'Sabo'
    UNION ALL SELECT 'Figure w/Law', 'Law'
    UNION ALL SELECT 'Figure w/Ace', 'Ace'
    UNION ALL SELECT 'Monster Trio', 'Zoro'
    UNION ALL SELECT 'Monster Trio', 'Sanji'
) AS multi_mapping
JOIN products p ON p.name = multi_mapping.product_name
JOIN characters c ON c.name = multi_mapping.character_name;

-- 4. Popolamento varianti
-- VARIANTI PER GADGET
INSERT INTO product_variants (product_id, variant_name, stock_quantity) VALUES
-- Portachiavi
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Cappello', 20),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Luffy', 15),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Luffy Wano', 12),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Monster Trio', 18),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Jolly Roger Zoro', 10),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Zoro', 14),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Jolly Roger Sanji', 10),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Sanji', 14),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Robin', 12),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Brook', 11),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Nami', 15),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Chopper', 22),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Usopp', 10),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Law', 13),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Sabo', 9),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Ace', 16),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Cappello Ace', 11),
((SELECT id FROM products WHERE name = 'Portachiavi'), 'Jolly Roger Barbabianca', 8),

-- Portafoglio
((SELECT id FROM products WHERE name = 'Portafoglio'), 'Jolly Roger', 15),
((SELECT id FROM products WHERE name = 'Portafoglio'), 'Chopper', 12),
((SELECT id FROM products WHERE name = 'Portafoglio'), 'Jolly Roger Law', 10),
((SELECT id FROM products WHERE name = 'Portafoglio'), 'Ace', 13),

-- Bracciale
((SELECT id FROM products WHERE name = 'Bracciale'), 'Logo', 25),
((SELECT id FROM products WHERE name = 'Bracciale'), 'Jolly Roger', 20),
((SELECT id FROM products WHERE name = 'Bracciale'), 'Ace', 18),

-- Cappelli
((SELECT id FROM products WHERE name = 'Cappelli'), 'Luffy', 10),
((SELECT id FROM products WHERE name = 'Cappelli'), 'Chopper', 15),
((SELECT id FROM products WHERE name = 'Cappelli'), 'Ace', 8),
((SELECT id FROM products WHERE name = 'Cappelli'), 'Barbabianca', 7);