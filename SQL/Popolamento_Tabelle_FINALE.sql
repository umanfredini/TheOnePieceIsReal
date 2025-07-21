-- =====================================================
-- POPOLAMENTO TABELLE FINALE
-- =====================================================

USE onepiece;

-- 1. Popolamento prodotti con personaggi direttamente nel campo is_featured
-- PRODOTTI PER LUFFY (SENZA MAGLIE - LE GESTIAMO CON VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 1.5m', 'Poster ufficiale Monkey D. Luffy (1.5 metri)', 24.99, 'LUFFY_PosterTaglia_1.5M.jpg', 'Poster', 15, 'Luffy'),
('Cosplay', 'Completo cosplay Monkey D. Luffy completo', 89.99, 'LUFFY_Cosplay.jpg', 'Abbigliamento', 8, 'Luffy'),
('Quadro Gear4', 'Quadro Luffy Gear Fourth - Stampa artistica', 59.99, 'LUFFY_Quadro_GearFourth.jpg', 'Quadro', 12, 'Luffy'),
('Quadro Wano', 'Quadro Luffy a Wano Kuni - Edizione limitata', 54.99, 'LUFFY_ZORO_Quadro_Wano.jpg', 'Quadro', 10, 'Luffy'),
('Figure', 'Action Figure Monkey D. Luffy - Classica', 49.99, 'LUFFY_Figure.jpg', 'Figure', 25, 'Luffy'),
('Cosplay Wano', 'Completo cosplay Luffy stile Wano', 94.99, 'LUFFY_Cosplay_Wano.jpg', 'Abbigliamento', 6, 'Luffy'),
('Quadro Colorful', 'Quadro colorato Luffy - Tecnica mista', 49.99, 'LUFFY_Quadro_Colorful.jpg', 'Quadro', 8, 'Luffy'),
('Figure Gear4', 'Action Figure Luffy Gear Fourth Boundman', 79.99, 'LUFFY_Figure_Gear4.jpg', 'Figure', 7, 'Luffy'),
('Figure King', 'Action Figure Luffy Re dei Pirati Edition', 89.99, 'LUFFY_Figure_King.jpg', 'Figure', 5, 'Luffy');

-- MAGLIE LUFFY (PRODOTTI SINGOLI - SENZA VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Maglia Bandiera', 'Maglietta bandiera pirati di Cappello di Paglia', 29.99, 'LUFFY_Maglia_Bandiera_BIANCA.jpg', 'Abbigliamento', 15, 'Luffy'),
('Maglia Legend', 'Maglietta "Future King of Pirates"', 32.99, 'LUFFY_Maglia_Legend.jpg', 'Abbigliamento', 12, 'Luffy'),
('Maglia Occhiata', 'Maglietta con occhiata caratteristica di Luffy', 31.99, 'LUFFY_Maglia_Occhiata_GRIGIA.jpg', 'Abbigliamento', 18, 'Luffy'),
('Maglia Snakeman', 'Maglietta Luffy Snakeman design esclusivo', 34.99, 'LUFFY_Maglia_Snakeman.jpg', 'Abbigliamento', 10, 'Luffy');

-- PRODOTTI PER ZORO (SENZA MAGLIE - LE GESTIAMO CON VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Quadro Wano Zoro', 'Stampa artistica Roronoa Zoro a Wano', 49.99, 'LUFFY_ZORO_Quadro_Wano.jpg', 'Quadro', 11, 'Zoro'),
('Poster 120m', 'Poster bounty Zoro (120 milioni)', 19.99, 'ZORO_PosterTaglia_120m.jpg', 'Poster', 20, 'Zoro'),
('Poster 320m', 'Poster bounty Zoro (320 milioni)', 22.99, 'ZORO_PosterTaglia_320m.jpg', 'Poster', 18, 'Zoro'),
('Cosplay Wano Zoro', 'Completo cosplay Zoro stile Wano', 99.99, 'ZORO_Cosplay_Wano.jpg', 'Abbigliamento', 5, 'Zoro'),
('Cosplay Zoro', 'Completo cosplay Roronoa Zoro classico', 84.99, 'ZORO_Cosplay.jpg', 'Abbigliamento', 7, 'Zoro'),
('Quadro Asura', 'Quadro Zoro Asura - Edizione speciale', 64.99, 'ZORO_Quadro_Asura.jpg', 'Quadro', 6, 'Zoro'),
('Quadro Colorful Zoro', 'Quadro colorato Zoro - Tecnica mista', 47.99, 'ZORO_Quadro_Colorful.jpg', 'Quadro', 9, 'Zoro'),
('Figure Zoro', 'Action Figure Roronoa Zoro - Classica', 54.99, 'ZORO_Figure.jpg', 'Figure', 22, 'Zoro'),
('Figure King Zoro', 'Action Figure Zoro King of Hell', 89.99, 'ZORO_Figure_King.jpg', 'Figure', 4, 'Zoro'),
('Figure BountyHunter', 'Action Figure Zoro cacciatore di taglie', 59.99, 'ZORO_Figure_BountyHunter.jpg', 'Figure', 8, 'Zoro');

-- MAGLIE ZORO (PRODOTTI SINGOLI - SENZA VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Maglia Albero', 'Maglietta Zoro "Nothing Happened"', 31.99, 'ZORO_Maglia_Albero.jpg', 'Abbigliamento', 14, 'Zoro'),
('Maglia Luna', 'Maglietta Zoro taglia la luna', 29.99, 'ZORO_Maglia_Luna.jpg', 'Abbigliamento', 16, 'Zoro'),
('Maglia Santoryu', 'Maglietta Zoro Santoryu style', 33.99, 'ZORO_Maglia_Santoryu.jpg', 'Abbigliamento', 12, 'Zoro');

-- PRODOTTI PER SANJI (SENZA MAGLIE - LE GESTIAMO CON VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Figure New World', 'Action Figure Sanji New World', 67.99, 'SANJI_Figure_NewWorld.jpg', 'Figure', 10, 'Sanji'),
('Poster 330m', 'Poster bounty Sanji (330 milioni)', 21.99, 'SANJI_PosterTaglia_330m.jpg', 'Poster', 17, 'Sanji'),
('Cosplay Sanji', 'Completo cosplay Vinsmoke Sanji', 79.99, 'SANJI_Cosplay.jpg', 'Abbigliamento', 6, 'Sanji'),
('Cosplay Wano Sanji', 'Completo cosplay Sanji stile Wano', 89.99, 'SANJI_Cosplay_Wano.jpg', 'Abbigliamento', 5, 'Sanji'),
('Quadro Colorful Sanji', 'Quadro colorato Sanji - Tecnica mista', 44.99, 'SANJI_Quadro_Colorful.jpg', 'Quadro', 8, 'Sanji'),
('Figure SobaMask', 'Action Figure Sanji Soba Mask', 74.99, 'SANJI_Figure_SobaMask.jpg', 'Figure', 7, 'Sanji'),
('Figure King Sanji', 'Action Figure Sanji Germa 66', 69.99, 'SANJI_Figure_King.jpg', 'Figure', 6, 'Sanji');

-- PRODOTTI PER JINBEI
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Figure Jinbei', 'Action Figure Jinbei - Versione classica', 64.99, 'JINBEI_Figure.jpg', 'Figure', 9, 'Jinbei'),
('Poster 400m', 'Poster bounty Jinbei (438 milioni)', 23.99, 'JINBEI_PosterTaglia_400m.jpg', 'Poster', 13, 'Jinbei'),
('Figure King Jinbei', 'Action Figure Jinbei Cavaliere di Mari', 79.99, 'JINBEI_Figure_King.jpg', 'Figure', 5, 'Jinbei');

-- PRODOTTI PER ROBIN
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 130m', 'Poster bounty Robin (130 milioni)', 18.99, 'ROBIN_PosterTaglia_130m.jpg', 'Poster', 16, 'Robin'),
('Cosplay Robin', 'Completo cosplay Nico Robin classico', 82.99, 'ROBIN_Cosplay.jpg', 'Abbigliamento', 7, 'Robin'),
('Cosplay Wano Robin', 'Completo cosplay Robin stile Wano', 92.99, 'ROBIN_Cosplay_Wano.jpg', 'Abbigliamento', 4, 'Robin'),
('Figure Robin', 'Action Figure Nico Robin - Classica', 59.99, 'ROBIN_Figure.jpg', 'Figure', 11, 'Robin'),
('Figure Queen Robin', 'Action Figure Robin Demonio dei Mari', 72.99, 'ROBIN_Figure_Queen.jpg', 'Figure', 6, 'Robin'),
('Figure New World Robin', 'Action Figure Robin New World', 67.99, 'ROBIN_Figure_NewWorld.jpg', 'Figure', 8, 'Robin');

-- PRODOTTI PER BROOK
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 83m', 'Poster bounty Brook (83 milioni)', 17.99, 'BROOK_PosterTaglia_83m.jpg', 'Poster', 14, 'Brook'),
('Quadro Colorful Brook', 'Quadro colorato Brook - Tecnica mista', 42.99, 'BROOK_Quadro_Colorful.jpg', 'Quadro', 7, 'Brook'),
('Figure Brook', 'Action Figure Brook - Classica', 62.99, 'BROOK_Figure.jpg', 'Figure', 10, 'Brook'),
('Figure King Brook', 'Action Figure Brook Soul King', 77.99, 'BROOK_Figure_King.jpg', 'Figure', 5, 'Brook'),
('Figure Soul', 'Action Figure Brook con anima', 69.99, 'BROOK_Figure_Soul.jpg', 'Figure', 6, 'Brook'),
('Figure New World Brook', 'Action Figure Brook New World', 64.99, 'BROOK_Figure_NewWorld.jpg', 'Figure', 7, 'Brook');

-- PRODOTTI PER FRANKY
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 94m', 'Poster bounty Franky (94 milioni)', 19.99, 'FRANKY_PosterTaglia_94m.jpg', 'Poster', 15, 'Franky'),
('Quadro Colorful Franky', 'Quadro colorato Franky - Tecnica mista', 47.99, 'FRANKY_Quadro_Colorful.jpg', 'Quadro', 6, 'Franky'),
('Figure Franky', 'Action Figure Franky - Classica', 67.99, 'FRANKY_Figure.jpg', 'Figure', 9, 'Franky'),
('Figure Shogun', 'Action Figure General Franky Shogun', 119.99, 'FRANKY_Figure_Shogun.jpg', 'Figure', 3, 'Franky'),
('Figure King Franky', 'Action Figure Franky Iron Pirate', 84.99, 'FRANKY_Figure_King.jpg', 'Figure', 4, 'Franky');

-- PRODOTTI PER NAMI
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Cosplay Wano Nami', 'Completo cosplay Nami stile Wano', 87.99, 'NAMI_Cosplay_Wano.jpg', 'Abbigliamento', 5, 'Nami'),
('Figure Nami', 'Action Figure Nami - Classica', 54.99, 'NAMI_Figure.jpg', 'Figure', 13, 'Nami'),
('Poster 66m', 'Poster bounty Nami (66 milioni)', 16.99, 'NAMI_PosterTaglia_66m.jpg', 'Poster', 18, 'Nami'),
('Figure Chibi', 'Chibi Figure Nami - Edizione limitata', 34.99, 'NAMI_Figure_Chibi.jpg', 'Figure', 20, 'Nami'),
('Figure Queen Nami', 'Action Figure Nami Regina dei Mari', 69.99, 'NAMI_Figure_Queen.jpg', 'Figure', 7, 'Nami'),
('Figure Pre Nami', 'Action Figure Nami Pre-timeskip', 59.99, 'NAMI_Figure_Pre.jpg', 'Figure', 9, 'Nami');

-- PRODOTTI PER CHOPPER (SENZA MAGLIA - LA GESTIAMO CON VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 100', 'Poster bounty Chopper (100 Berry)', 14.99, 'CHOPPER_PosterTaglia_100.jpg', 'Poster', 25, 'Chopper'),
('Quadro Colorful Chopper', 'Quadro colorato Chopper - Tecnica mista', 39.99, 'CHOPPER_Quadro_Colorful.jpg', 'Quadro', 11, 'Chopper'),
('Pelouche', 'Pelouche Tony Tony Chopper (40cm)', 29.99, 'CHOPPER_Pelouche.jpg', 'Pelouche', 30, 'Chopper'),
('Figure Chopper', 'Action Figure Chopper - Classica', 44.99, 'CHOPPER_Figure.jpg', 'Figure', 18, 'Chopper'),
('Figure King Chopper', 'Action Figure Chopper Monster Point', 74.99, 'CHOPPER_Figure_King.jpg', 'Figure', 5, 'Chopper'),
('Figure Horn Point', 'Action Figure Chopper Horn Point', 59.99, 'CHOPPER_Figure_HornPoint.jpg', 'Figure', 8, 'Chopper');

-- MAGLIA CHOPPER (PRODOTTO SINGOLO - SENZA VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Maglia Chopper', 'Maglietta Tony Tony Chopper', 27.99, 'CHOPPER_Maglia.jpg', 'Abbigliamento', 20, 'Chopper');

-- PRODOTTI PER USOPP
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 200m', 'Poster bounty Usopp (200 milioni)', 20.99, 'USOPP_PosterTaglia_200m.jpg', 'Poster', 16, 'Usopp'),
('Figure Usopp', 'Action Figure Usopp - Classica', 52.99, 'USOPP_Figure.jpg', 'Figure', 12, 'Usopp'),
('Figure New World Usopp', 'Action Figure God Usopp', 64.99, 'USOPP_Figure_NewWorld.jpg', 'Figure', 7, 'Usopp'),
('Figure Sogeking', 'Action Figure Sogeking con Kabuto', 57.99, 'USOPP_Figure_Sogeking.jpg', 'Figure', 9, 'Usopp');

-- PRODOTTI PER LAW (SENZA MAGLIA - LA GESTIAMO CON VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Cosplay Law', 'Completo cosplay Trafalgar Law', 84.99, 'LAW_Cosplay.jpg', 'Abbigliamento', 5, 'Law'),
('Quadro Law', 'Quadro Trafalgar Law - Surgeon of Death', 54.99, 'LAW_Quadro.jpg', 'Quadro', 8, 'Law'),
('Quadro Colorful Law', 'Quadro colorato Law - Tecnica mista', 49.99, 'LAW_Quadro_Colorful.jpg', 'Quadro', 7, 'Law'),
('Figure Law', 'Action Figure Trafalgar Law - Classica', 69.99, 'LAW_Figure.jpg', 'Figure', 10, 'Law'),
('Figure New World Law', 'Action Figure Law New World', 74.99, 'LAW_Figure_NewWorld.jpg', 'Figure', 6, 'Law');

-- MAGLIA LAW (PRODOTTO SINGOLO - SENZA VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Maglia Law', 'Maglietta Trafalgar Law Heart Pirates', 32.99, 'LAW_Maglia.jpg', 'Abbigliamento', 15, 'Law');

-- PRODOTTI PER KIDD
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Figure Kidd', 'Action Figure Eustass Kid Supernova', 67.99, 'KIDD_Figure.jpg', 'Figure', 8, 'Kidd');

-- PRODOTTI PER ACE (SENZA MAGLIE - LE GESTIAMO CON VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 550m', 'Poster bounty Ace (550 milioni)', 25.99, 'ACE_PosterTaglia_550m.jpg', 'Poster', 12, 'Ace'),
('Quadro Colorful Ace', 'Quadro colorato Ace - Tecnica mista', 52.99, 'ACE_Quadro_Colorful.jpg', 'Quadro', 6, 'Ace'),
('Figure Ace', 'Action Figure Portgas D. Ace - Classica', 64.99, 'ACE_Figure.jpg', 'Figure', 11, 'Ace'),
('Figure King Ace', 'Action Figure Ace Flame Emperor', 79.99, 'ACE_Figure_King.jpg', 'Figure', 5, 'Ace');

-- MAGLIE ACE (PRODOTTI SINGOLI - SENZA VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Maglia Ace', 'Maglietta Portgas D. Ace', 31.99, 'ACE_Maglia.jpg', 'Abbigliamento', 18, 'Ace'),
('Maglia Barbabianca Ace', 'Maglietta Ace con simbolo Barbabianca', 33.99, 'ACE_Maglia_Barbabianca (fronte).jpg', 'Abbigliamento', 12, 'Ace');

-- PRODOTTI PER SABO
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Pelouche Sabo', 'Pelouche Sabo (35cm)', 32.99, 'SABO_Pelouche.jpg', 'Pelouche', 18, 'Sabo'),
('Figure Sabo', 'Action Figure Sabo - Classica', 66.99, 'SABO_Figure.jpg', 'Figure', 10, 'Sabo'),
('Figure Flame Emperor', 'Action Figure Sabo Flame Emperor', 84.99, 'SABO_Figure_FlameEmperor.jpg', 'Figure', 4, 'Sabo');

-- PRODOTTI PER SHANKS
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 4M Shanks', 'Poster bounty Shanks (4.048M)', 28.99, 'SHANKS_PosterTaglia_4M.jpg', 'Poster', 11, 'Shanks'),
('Cosplay Shanks', 'Completo cosplay Shanks il Rosso', 119.99, 'SHANKS_Cosplay.jpg', 'Abbigliamento', 3, 'Shanks'),
('Quadro Colorful Shanks', 'Quadro colorato Shanks - Tecnica mista', 64.99, 'SHANKS_Quadro_Colorful.jpg', 'Quadro', 5, 'Shanks'),
('Figure Shanks', 'Action Figure Shanks - Classica', 89.99, 'SHANKS_Figure.jpg', 'Figure', 7, 'Shanks'),
('Figure King Shanks', 'Action Figure Shanks Emperor Edition', 129.99, 'SHANKS_Figure_King.jpg', 'Figure', 3, 'Shanks'),
('Figure Chibi Shanks', 'Chibi Figure Shanks - 15cm', 37.99, 'SHANKS_Figure_Chibi.jpg', 'Figure', 12, 'Shanks');

-- PRODOTTI PER KAIDO
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 4M Kaido', 'Poster bounty Kaido (4.611M)', 29.99, 'KAIDO_PosterTaglia_4M.jpg', 'Poster', 9, 'Kaido'),
('Figure Kaido', 'Action Figure Kaido Dragon Form', 139.99, 'KAIDO_Figure.jpg', 'Figure', 4, 'Kaido');

-- PRODOTTI PER BARBABIANCA (SENZA MAGLIA - LA GESTIAMO CON VARIANTI)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 5M', 'Poster bounty Barbabianca (5.046M)', 30.99, 'BARBABIANCA_PosterTaglia_5M.jpg', 'Poster', 8, 'Barbabianca'),
('Figure Barbabianca', 'Action Figure Barbabianca - Classica', 109.99, 'BARBABIANCA_Figure.jpg', 'Figure', 6, 'Barbabianca'),
('Figure King Barbabianca', 'Action Figure Barbabianca Emperor Edition', 149.99, 'BARBABIANCA_Figure_King.jpg', 'Figure', 3, 'Barbabianca');

-- MAGLIA BARBABIANCA (PRODOTTO BASE CON VARIANTI COLORE)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Maglia Barbabianca', 'Maglietta Edward Newgate Barbabianca Child of the Sea', 35.99, 'BARBABIANCA_Maglia_ChildOfTheSea_BIANCA.jpg', 'Abbigliamento', 0, 'Barbabianca');

-- PRODOTTI PER BARBANERA
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 2M', 'Poster bounty Barbanera (2.247M)', 26.99, 'BARBANERA_PosterTaglia_2M.jpg', 'Poster', 10, 'Barbanera'),
('Figure Barbanera', 'Action Figure Marshall D. Teach', 99.99, 'BARBANERA_Figure.jpg', 'Figure', 7, 'Barbanera'),
('Figure King Barbanera', 'Action Figure Barbanera Emperor Edition', 139.99, 'BARBANERA_Figure_King.jpg', 'Figure', 3, 'Barbanera');

-- PRODOTTI PER ROGER
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Poster 5M Roger', 'Poster bounty Gol D. Roger (5.564M)', 31.99, 'ROGER_PosterTaglia_5M.jpg', 'Poster', 9, 'Roger'),
('Quadro Roger', 'Quadro Gol D. Roger - Edizione commemorativa', 79.99, 'ROGER_Quadro.jpg', 'Quadro', 6, 'Roger'),
('Figure Roger', 'Action Figure Gol D. Roger', 149.99, 'ROGER_Figure.jpg', 'Figure', 4, 'Roger');

-- PRODOTTI MULTI-PERSONAGGIO (FEATURED)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Figure ASL', 'Action Figure Luffy, Ace, Sabo da bambini', 74.99, 'ASL_Figure (LUFFY_ACE_SABO).jpg', 'Figure', 9, 'Luffy, Ace, Sabo'),
('Figure w/Law', 'Action Figure Law & Luffy Alliance', 89.99, 'LUFFY_LAW_Figure.jpg', 'Figure', 6, 'Luffy, Law'),
('Figure w/Ace', 'Action Figure Ace & Luffy', 72.99, 'LUFFY_ACE_Figure.png', 'Figure', 8, 'Luffy, Ace');

-- NAVI (senza personaggi specifici)
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Going Merry', 'Modellino nave Going Merry scala 1/100', 179.99, 'Nave_GoingMerry.jpg', 'Navi', 5, NULL),
('Queen Mama Chanter', 'Modellino Queen Mama Chanter scala 1/150', 199.99, 'Nave_BigMom.jpg', 'Navi', 3, NULL),
('Baratie', 'Modellino ristorante galleggiante Baratie', 159.99, 'Nave_Baratie.jpg', 'Navi', 4, NULL),
('Arca Maxim', 'Modellino Arca Maxim di Enel', 189.99, 'Nave_ArcaMaxim.jpg', 'Navi', 3, NULL),
('Thousand Sunny', 'Modellino Thousand Sunny scala 1/100', 219.99, 'Nave_ThousandSunny.jpg', 'Navi', 6, NULL);

-- GADGET (PRODOTTI SEPARATI PER OGNI PERSONAGGIO)
-- Portachiavi
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Portachiavi Cappello', 'Portachiavi cappello di paglia ufficiale', 12.99, 'Portachiavi_CappelloDiPaglia.jpg', 'Gadget', 20, NULL),
('Portachiavi Luffy', 'Portachiavi Monkey D. Luffy', 12.99, 'Portachiavi_Luffy.jpg', 'Gadget', 15, 'Luffy'),
('Portachiavi Luffy Wano', 'Portachiavi Luffy stile Wano', 12.99, 'Portachiavi_Luffy_Wano.jpg', 'Gadget', 12, 'Luffy'),
('Portachiavi Monster Trio', 'Portachiavi Luffy, Zoro, Sanji', 12.99, 'Portachiavi_MonsterTrio.jpg', 'Gadget', 18, 'Luffy, Zoro, Sanji'),
('Portachiavi Jolly Roger Zoro', 'Portachiavi Jolly Roger di Zoro', 12.99, 'Portachiavi_Zoro_JollyRoger.jpg', 'Gadget', 10, 'Zoro'),
('Portachiavi Zoro', 'Portachiavi Roronoa Zoro', 12.99, 'Portachiavi_Zoro.jpg', 'Gadget', 14, 'Zoro'),
('Portachiavi Jolly Roger Sanji', 'Portachiavi Jolly Roger di Sanji', 12.99, 'Portachiavi_Sanji_JollyRoger.jpg', 'Gadget', 10, 'Sanji'),
('Portachiavi Sanji', 'Portachiavi Vinsmoke Sanji', 12.99, 'Portachiavi_Sanji.jpg', 'Gadget', 14, 'Sanji'),
('Portachiavi Robin', 'Portachiavi Nico Robin', 12.99, 'Portachiavi_Robin.jpg', 'Gadget', 12, 'Robin'),
('Portachiavi Brook', 'Portachiavi Brook', 12.99, 'Portachiavi_Brook.jpg', 'Gadget', 11, 'Brook'),
('Portachiavi Nami', 'Portachiavi Nami', 12.99, 'Portachiavi_Nami.jpg', 'Gadget', 15, 'Nami'),
('Portachiavi Chopper', 'Portachiavi Tony Tony Chopper', 12.99, 'Portachiavi_Chopper.jpg', 'Gadget', 22, 'Chopper'),
('Portachiavi Usopp', 'Portachiavi Usopp', 12.99, 'Portachiavi_Usopp.jpg', 'Gadget', 10, 'Usopp'),
('Portachiavi Law', 'Portachiavi Trafalgar Law', 12.99, 'Portachiavi_Law.jpg', 'Gadget', 13, 'Law'),
('Portachiavi Sabo', 'Portachiavi Sabo', 12.99, 'Portachiavi_Sabo.jpg', 'Gadget', 9, 'Sabo'),
('Portachiavi Ace', 'Portachiavi Portgas D. Ace', 12.99, 'Portachiavi_Ace.jpg', 'Gadget', 16, 'Ace'),
('Portachiavi Cappello Ace', 'Portachiavi cappello di Ace', 12.99, 'Portachiavi_CappelloAce.jpg', 'Gadget', 11, 'Ace'),
('Portachiavi Jolly Roger Barbabianca', 'Portachiavi Jolly Roger di Barbabianca', 12.99, 'Portachiavi_Barbabianca.jpg', 'Gadget', 8, 'Barbabianca');

-- Portafogli
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Portafoglio Jolly Roger', 'Portafoglio con Jolly Roger', 34.99, 'Portafoglio_JollyRoger.jpg', 'Gadget', 15, NULL),
('Portafoglio Chopper', 'Portafoglio Tony Tony Chopper', 34.99, 'Portafoglio_Chopper.jpg', 'Gadget', 12, 'Chopper'),
('Portafoglio Jolly Roger Law', 'Portafoglio Jolly Roger di Law', 34.99, 'Portafoglio_JollyRoger_Law.jpg', 'Gadget', 10, 'Law'),
('Portafoglio Ace', 'Portafoglio Portgas D. Ace', 34.99, 'Portafoglio_Ace.jpg', 'Gadget', 13, 'Ace');

-- Bracciali
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Bracciale Logo', 'Bracciale con logo One Piece', 9.99, 'Bracciale_Logo.jpg', 'Gadget', 25, NULL),
('Bracciale Jolly Roger', 'Bracciale con Jolly Roger', 9.99, 'Bracciale_JollyRoger.jpg', 'Gadget', 20, NULL),
('Bracciale Ace', 'Bracciale Portgas D. Ace', 9.99, 'Bracciale_Ace.jpg', 'Gadget', 18, 'Ace');

-- Cappelli
INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) VALUES
('Cappello Luffy', 'Cappello di paglia di Luffy', 29.99, 'Cappello_Luffy.jpg', 'Gadget', 10, 'Luffy'),
('Cappello Chopper', 'Cappello di Chopper', 29.99, 'Cappello_Chopper.jpg', 'Gadget', 15, 'Chopper'),
('Cappello Ace', 'Cappello di Ace', 29.99, 'Cappello_Ace.jpg', 'Gadget', 8, 'Ace'),
('Cappello Barbabianca', 'Cappello di Barbabianca', 29.99, 'Cappello_Barbabianca.jpg', 'Gadget', 7, 'Barbabianca');

-- 2. Popolamento varianti per abbigliamento e cosplay
-- VARIANTI PER MAGLIE (COLORI) - SOLO MAGLIA BARBABIANCA HA VARIANTI REALI
INSERT INTO product_variants (product_id, variant_name, variant_type, stock_quantity) VALUES
-- Maglia Barbabianca Child of the Sea (UNICA MAGLIA CON VARIANTI REALI)
((SELECT id FROM products WHERE name = 'Maglia Barbabianca'), 'Bianca', 'color', 13),
((SELECT id FROM products WHERE name = 'Maglia Barbabianca'), 'Blu', 'color', 15),
((SELECT id FROM products WHERE name = 'Maglia Barbabianca'), 'Rossa', 'color', 12),
((SELECT id FROM products WHERE name = 'Maglia Barbabianca'), 'Verde', 'color', 10),
((SELECT id FROM products WHERE name = 'Maglia Barbabianca'), 'Grigia', 'color', 11);

-- VARIANTI PER COSPLAY (TAGLIE)
INSERT INTO product_variants (product_id, variant_name, variant_type, stock_quantity) VALUES
-- Cosplay Luffy
((SELECT id FROM products WHERE name = 'Cosplay'), 'S', 'size', 8),
((SELECT id FROM products WHERE name = 'Cosplay'), 'M', 'size', 12),
((SELECT id FROM products WHERE name = 'Cosplay'), 'L', 'size', 10),
((SELECT id FROM products WHERE name = 'Cosplay'), 'XL', 'size', 6),

-- Cosplay Wano Luffy
((SELECT id FROM products WHERE name = 'Cosplay Wano'), 'S', 'size', 6),
((SELECT id FROM products WHERE name = 'Cosplay Wano'), 'M', 'size', 8),
((SELECT id FROM products WHERE name = 'Cosplay Wano'), 'L', 'size', 6),
((SELECT id FROM products WHERE name = 'Cosplay Wano'), 'XL', 'size', 4),

-- Cosplay Zoro
((SELECT id FROM products WHERE name = 'Cosplay Zoro'), 'S', 'size', 7),
((SELECT id FROM products WHERE name = 'Cosplay Zoro'), 'M', 'size', 10),
((SELECT id FROM products WHERE name = 'Cosplay Zoro'), 'L', 'size', 8),
((SELECT id FROM products WHERE name = 'Cosplay Zoro'), 'XL', 'size', 5),

-- Cosplay Wano Zoro
((SELECT id FROM products WHERE name = 'Cosplay Wano Zoro'), 'S', 'size', 5),
((SELECT id FROM products WHERE name = 'Cosplay Wano Zoro'), 'M', 'size', 7),
((SELECT id FROM products WHERE name = 'Cosplay Wano Zoro'), 'L', 'size', 5),
((SELECT id FROM products WHERE name = 'Cosplay Wano Zoro'), 'XL', 'size', 3),

-- Cosplay Sanji
((SELECT id FROM products WHERE name = 'Cosplay Sanji'), 'S', 'size', 6),
((SELECT id FROM products WHERE name = 'Cosplay Sanji'), 'M', 'size', 8),
((SELECT id FROM products WHERE name = 'Cosplay Sanji'), 'L', 'size', 6),
((SELECT id FROM products WHERE name = 'Cosplay Sanji'), 'XL', 'size', 4),

-- Cosplay Wano Sanji
((SELECT id FROM products WHERE name = 'Cosplay Wano Sanji'), 'S', 'size', 5),
((SELECT id FROM products WHERE name = 'Cosplay Wano Sanji'), 'M', 'size', 7),
((SELECT id FROM products WHERE name = 'Cosplay Wano Sanji'), 'L', 'size', 5),
((SELECT id FROM products WHERE name = 'Cosplay Wano Sanji'), 'XL', 'size', 3),

-- Cosplay Robin
((SELECT id FROM products WHERE name = 'Cosplay Robin'), 'S', 'size', 7),
((SELECT id FROM products WHERE name = 'Cosplay Robin'), 'M', 'size', 10),
((SELECT id FROM products WHERE name = 'Cosplay Robin'), 'L', 'size', 8),
((SELECT id FROM products WHERE name = 'Cosplay Robin'), 'XL', 'size', 5),

-- Cosplay Wano Robin
((SELECT id FROM products WHERE name = 'Cosplay Wano Robin'), 'S', 'size', 4),
((SELECT id FROM products WHERE name = 'Cosplay Wano Robin'), 'M', 'size', 6),
((SELECT id FROM products WHERE name = 'Cosplay Wano Robin'), 'L', 'size', 4),
((SELECT id FROM products WHERE name = 'Cosplay Wano Robin'), 'XL', 'size', 2),

-- Cosplay Law
((SELECT id FROM products WHERE name = 'Cosplay Law'), 'S', 'size', 5),
((SELECT id FROM products WHERE name = 'Cosplay Law'), 'M', 'size', 7),
((SELECT id FROM products WHERE name = 'Cosplay Law'), 'L', 'size', 5),
((SELECT id FROM products WHERE name = 'Cosplay Law'), 'XL', 'size', 3),

-- Cosplay Shanks
((SELECT id FROM products WHERE name = 'Cosplay Shanks'), 'S', 'size', 3),
((SELECT id FROM products WHERE name = 'Cosplay Shanks'), 'M', 'size', 4),
((SELECT id FROM products WHERE name = 'Cosplay Shanks'), 'L', 'size', 3),
((SELECT id FROM products WHERE name = 'Cosplay Shanks'), 'XL', 'size', 2); 
