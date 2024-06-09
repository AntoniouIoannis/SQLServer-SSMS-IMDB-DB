/* 1a */  
select title from movies where pyear between 1995 and 2005;
/* μια απλή βασική μορφη ευρετηριοποίησης οπου και θα κανουμε στην στηλη pyear  */
/* Αυτό θα επιταχυνει την αναζητηση γιατι θα περιορισει το ευρος απ το να ψαξει όλον το πινακα */
CREATE INDEX idx_movies_pyear ON movies (pyear);

/* 1b */  
select pyear, title from movies where pyear between 1995 and 2005 
/* αλλη μια απλη μονο πιο συνθετη λυση . θα πρεπει να εφαρμοσουνε την ευρετηριοπηηση σε δυο στηλες */
/* του πινακα. Στο πεδιο/στηλη peyar και στο title */
CREATE INDEX idx_movies_pyear_title ON movies (pyear, title);

/* 1c */
select title, pyear  
from movies 
where pyear between 1995 and 2005  
order by pyear, title;

/* Ένα σύνθετο ευρετήριο στις στήλες pyear εξυπηρετεί το φιλτράρισμα (συνθήκη where) */
/* και το title την ταξινόμηση (order by). το ευρετήριο για να εκτελέσει την επερώτηση πιο αποδοτικά. */
CREATE INDEX idx_movies_pyear_title ON movies (pyear, title);


/* 2 a) */
SELECT MOVIES.title, MOVIES.pyear
FROM MOVIES
JOIN MOVIE_DIRECTORS ON MOVIES.mid = MOVIE_DIRECTORS.mid
JOIN DIRECTORS ON MOVIE_DIRECTORS.did = DIRECTORS.did
WHERE DIRECTORS.lastName = 'Zygadlo';

/*  Εδώ πρεπει να συνταξουμε την ευρερηριοποιηση  συνθετου με επιλογη πεδίων από διαφορετικους πινακες ομως */
/* Οπότε συνδυαστικά πρεπει να παρουμε το lasname απο το directors , το πεδίο τιτλος απο τον πινακα movies και τα πεδια του παραγωμενου πινακα  */
/* movie_directors did & mid οπου ειναι τα πρωτευοντα κλειδια των directors & movies.  Αυτα λοιπον συνθετουν το  σύνθετο ευρετηριο */
/*  για την ταχυτερη εκτελεση της sql qyery. Η συνταξη το ευρετηριου ειναι η: */

/* Δημιουργία ευρετηρίου για το επώνυμο των σκηνοθετών */
CREATE INDEX idx_directors_lastname ON DIRECTORS (lastName);

/*   Δημιουργία ευρετηρίου για το πεδίο `did` στον πίνακα `MOVIE_DIRECTORS`  */
CREATE INDEX idx_movie_directors_did ON MOVIE_DIRECTORS (did);

/*   Δημιουργία ευρετηρίου για το πεδίο `mid` στον πίνακα `MOVIE_DIRECTORS`  */
CREATE INDEX idx_movie_directors_mid ON MOVIE_DIRECTORS (mid);

/*  Δημιουργία ευρετηρίου για το πεδίο `mid` στον πίνακα `MOVIES`  */
CREATE INDEX idx_movies_mid ON MOVIES (mid);


/* 2 b) */
SELECT MOVIES.title, MOVIES.pyear, MOVIES.mrank
FROM MOVIES
JOIN MOVIES_GENRE ON MOVIES.mid = MOVIES_GENRE.mid
WHERE MOVIES_GENRE.genre = 'Comedy'
AND MOVIES.mrank > 7;
-- Εδώ το πεδίο κλειδί  για την δημιουργία ευρετηρίου ειναι το genre. 
-- Έχουμε και εδω πάλι σύνθετο ευρετήριο πάλι απο πεδία διαφορετικών πινάκων, 
-- του movies και movies_genre, διότι θέλουμε και το πεδίο rank όπου είναι ενα δεύτερο  φίλτρο.
-- Το ευρετηριο διαμορφώνετε ως εξής:
-- για την γρήγορη εύρεση των ταινιών με κατάταξη μεγαλύτερη του 7.
CREATE INDEX idx_movies_mrank ON MOVIES (mrank);

--  για την γρήγορη εύρεση των ταινιών της κατηγορίας "Comedy".
CREATE INDEX idx_movies_genre_genre ON MOVIES_GENRE (genre);

-- Επιταχύνει τη σύνδεση των ταινιών με τις κατηγορίες τους.
CREATE INDEX idx_movies_genre_mid ON MOVIES_GENRE (mid);

/*  2 c) */
SELECT title, mrank
FROM MOVIES
WHERE pyear = 2000
AND mrank > 5;

-- Eδω λοιπον φτιαξανε ενα ερωτημα που δημιουργει μια λιστα, εναν κατάλογο 
-- με βαση ετος και κατάταξη. Οπότε ο ευρετηριο που θα φτιαξουμε θα ειναι στο πεδιο pyear
-- για να δωσει μικροτερο ευρος αναζητησης στην ΒΔ, και ταυτοχρονα με το ευρετηριο στο πεδιο καταταξη (rank)
-- για βελτιωσει περρισσότερο την ταχύτητα ανάσυρσης/αναζήτησης. Οπότε εδω το ευρετηριο ειναι:

-- γρήγορη εύρεση των ταινιών που κυκλοφόρησαν το 2000.
CREATE INDEX idx_movies_pyear ON MOVIES (pyear);

--  γρήγορη εύρεση των ταινιών με κατάταξη μεγαλύτερη του 5 που θα παρει απο το sql query.
CREATE INDEX idx_movies_mrank ON MOVIES (mrank);

/*  3  */
-- Σε πολλές περιπτώσεις όπως και εδώ υπαρχουν περισσοτερες απο μια επιλογές 
SELECT M.title
FROM MOVIES M
WHERE NOT EXISTS (
    SELECT 1
    FROM ROLES R
    JOIN ACTORS A ON R.aid = A.aid
    WHERE R.mid = M.mid
    AND A.gender = 'F'
);
 --  και αυτη 
 SELECT DISTINCT M.title
FROM MOVIES M
LEFT JOIN ROLES R ON M.mid = R.mid
LEFT JOIN ACTORS A ON R.aid = A.aid
WHERE A.gender = 'M'
AND M.mid NOT IN (
    SELECT R2.mid
    FROM ROLES R2
    JOIN ACTORS A2 ON R2.aid = A2.aid
    WHERE A2.gender = 'F'
);

-- Τώρα για να επιταχυνουμε την εκτελεση θα πρεπει να "χρησιμοποιησουμε" τους 
-- πίνακες movies,  actors φυσικά,  αλλα και τον roles παίρνοντας τα κατάλληλα πεδία.

-- Αυτό το ευρετήριο θα επιταχύνει τη σύνδεση των ταινιών με τους ρόλους τους.
CREATE INDEX idx_roles_mid ON ROLES (mid);

-- Αυτό το ευρετήριο θα επιταχύνει τη σύνδεση των ρόλων με τους ηθοποιούς.
CREATE INDEX idx_roles_aid ON ROLES (aid);

-- τους ηθοποιούς κατά φύλο.
CREATE INDEX idx_actors_gender ON ACTORS (gender);

-- Τωρα η αξιολογηση μου ειναι οτι η χρηση του not exist πρεπει να ειναι ταχυτερη, διότι
-- επρεπε να βαλω το distinct δίνοντας ρο left join για να μην εμφανιστουν διπλές εγγραφές.
-- Ένω φαίνεται κατά την εκτέλεση, το not exists τα "βλέπει" και τα εξαιρεί κατευθειαν.
-- Οπότε το τελικό -και καταλληλότερο - ερώτημα και ευρετηριο θα πρέπει να είναι το:
--  ερώτημα
SELECT M.title
FROM MOVIES M
WHERE NOT EXISTS (
    SELECT 1
    FROM ROLES R
    JOIN ACTORS A ON R.aid = A.aid
    WHERE R.mid = M.mid
    AND A.gender = 'F'
);
-- ευρετηριο
CREATE INDEX idx_roles_mid ON ROLES (mid);

CREATE INDEX idx_roles_aid ON ROLES (aid);

CREATE INDEX idx_actors_gender ON ACTORS (gender);


/*  4  */
-- Όταν θέλουμε να επιλέξουμε να δούμε μια ταινία ή και να αγοράσουμε καποιο
-- προϊόν κοιτούμε πάντα -εκτός απο το οικονομικό- και τη βαθμολόγηση τών υπαρχόντων χρηστών!!!!
-- Συχνά δίνουμε προτεραιότητα πρώτα σε αυτο και μετά στην τιμή, ως "εγγύηση" για την καλή αγορά μας.
-- Οπότε ενα πρώτο ερωτημα, θα ηθελα να ξερω ποιες ταινίες "αξιζει τον κόπο" να δω αρα θα ηθελα να ειναι 
-- τουλάχιστον μετριες κατά το γενικό συνολο της αξιολογησης των θεατών και φυσικά να δω ολες τις ταινιαρες 
-- του/της αγαπημένου/νης μου ηθοποιού. ’ρα το πρωτο ερώτημα σε φυσική γλώσσα που θα ηθελα να κανω 
-- ειναι ποιες ταινίες εχουν τουλάχιστον μετρια αξιολογηση δλδ απο 5 και πάνω και επειδη αγαπώ τον Iron Man
-- τους τιτλους και το ετος κυκλοφοριας του Robert Downey.
-- SQL query 1ου ερωτηματος
SELECT M.title, M.mrank
FROM MOVIES M
JOIN USER_MOVIES UM ON M.mid = UM.mid
WHERE UM.rating = 5;

-- SQL query 2ου ερωτηματος
SELECT M.title, M.pyear
FROM MOVIES M
JOIN ROLES R ON M.mid = R.mid
JOIN ACTORS A ON R.aid = A.aid
WHERE A.firstName = 'Robert'
AND A.lastName = 'Downey';

-- Τώρα θα μπορουσα λοιπον με μια κινηση να κανω το ευρετηριο της
-- εξης ερωτησης τις ταινιες με αξιολογηση 5 και ναω του συγκεκριμενου υθηποιού.
-- Αυτο ειναι παιπνοντας τα καταλληλα πεδια απο τους κατάλληλους πίνακες:

CREATE INDEX idx_user_movies_rating ON USER_MOVIES (rating);

CREATE INDEX idx_user_movies_mid ON USER_MOVIES (mid);

CREATE INDEX idx_actors_name ON ACTORS (firstName, lastName);

CREATE INDEX idx_roles_aid ON ROLES (aid);

CREATE INDEX idx_roles_mid ON ROLES (mid);
















