/* 1a */  
select title from movies where pyear between 1995 and 2005;
/* ��� ���� ������ ����� ���������������� ���� ��� �� ������� ���� ����� pyear  */
/* ���� �� ���������� ��� ��������� ����� �� ���������� �� ����� �� �� �� ����� ���� �� ������ */
CREATE INDEX idx_movies_pyear ON movies (pyear);

/* 1b */  
select pyear, title from movies where pyear between 1995 and 2005 
/* ���� ��� ���� ���� ��� ������� ���� . �� ������ �� ����������� ��� �������������� �� ��� ������ */
/* ��� ������. ��� �����/����� peyar ��� ��� title */
CREATE INDEX idx_movies_pyear_title ON movies (pyear, title);

/* 1c */
select title, pyear  
from movies 
where pyear between 1995 and 2005  
order by pyear, title;

/* ��� ������� ��������� ���� ������ pyear ���������� �� ����������� (������� where) */
/* ��� �� title ��� ���������� (order by). �� ��������� ��� �� ��������� ��� ��������� ��� ���������. */
CREATE INDEX idx_movies_pyear_title ON movies (pyear, title);


/* 2 a) */
SELECT MOVIES.title, MOVIES.pyear
FROM MOVIES
JOIN MOVIE_DIRECTORS ON MOVIES.mid = MOVIE_DIRECTORS.mid
JOIN DIRECTORS ON MOVIE_DIRECTORS.did = DIRECTORS.did
WHERE DIRECTORS.lastName = 'Zygadlo';

/*  ��� ������ �� ���������� ��� ���������������  �������� �� ������� ������ ��� ������������� ������� ���� */
/* ����� ����������� ������ �� ������� �� lasname ��� �� directors , �� ����� ������ ��� ��� ������ movies ��� �� ����� ��� ����������� ������  */
/* movie_directors did & mid ���� ����� �� ���������� ������� ��� directors & movies.  ���� ������ ��������� ��  ������� ��������� */
/*  ��� ��� �������� �������� ��� sql qyery. � ������� �� ���������� ����� �: */

/* ���������� ���������� ��� �� ������� ��� ���������� */
CREATE INDEX idx_directors_lastname ON DIRECTORS (lastName);

/*   ���������� ���������� ��� �� ����� `did` ���� ������ `MOVIE_DIRECTORS`  */
CREATE INDEX idx_movie_directors_did ON MOVIE_DIRECTORS (did);

/*   ���������� ���������� ��� �� ����� `mid` ���� ������ `MOVIE_DIRECTORS`  */
CREATE INDEX idx_movie_directors_mid ON MOVIE_DIRECTORS (mid);

/*  ���������� ���������� ��� �� ����� `mid` ���� ������ `MOVIES`  */
CREATE INDEX idx_movies_mid ON MOVIES (mid);


/* 2 b) */
SELECT MOVIES.title, MOVIES.pyear, MOVIES.mrank
FROM MOVIES
JOIN MOVIES_GENRE ON MOVIES.mid = MOVIES_GENRE.mid
WHERE MOVIES_GENRE.genre = 'Comedy'
AND MOVIES.mrank > 7;
-- ��� �� ����� ������  ��� ��� ���������� ���������� ����� �� genre. 
-- ������ ��� ��� ���� ������� ��������� ���� ��� ����� ������������ �������, 
-- ��� movies ��� movies_genre, ����� ������� ��� �� ����� rank ���� ����� ��� �������  ������.
-- �� ��������� ������������ �� ����:
-- ��� ��� ������� ������ ��� ������� �� �������� ���������� ��� 7.
CREATE INDEX idx_movies_mrank ON MOVIES (mrank);

--  ��� ��� ������� ������ ��� ������� ��� ���������� "Comedy".
CREATE INDEX idx_movies_genre_genre ON MOVIES_GENRE (genre);

-- ���������� �� ������� ��� ������� �� ��� ���������� ����.
CREATE INDEX idx_movies_genre_mid ON MOVIES_GENRE (mid);

/*  2 c) */
SELECT title, mrank
FROM MOVIES
WHERE pyear = 2000
AND mrank > 5;

-- E�� ������ �������� ��� ������� ��� ���������� ��� �����, ���� �������� 
-- �� ���� ���� ��� ��������. ����� � ��������� ��� �� ��������� �� ����� ��� ����� pyear
-- ��� �� ����� ��������� ����� ���������� ���� ��, ��� ���������� �� �� ��������� ��� ����� �������� (rank)
-- ��� ��������� ������������ ��� �������� ���������/����������. ����� ��� �� ��������� �����:

-- ������� ������ ��� ������� ��� ������������ �� 2000.
CREATE INDEX idx_movies_pyear ON MOVIES (pyear);

--  ������� ������ ��� ������� �� �������� ���������� ��� 5 ��� �� ����� ��� �� sql query.
CREATE INDEX idx_movies_mrank ON MOVIES (mrank);

/*  3  */
-- �� ������ ����������� ���� ��� ��� �������� ������������ ��� ��� �������� 
SELECT M.title
FROM MOVIES M
WHERE NOT EXISTS (
    SELECT 1
    FROM ROLES R
    JOIN ACTORS A ON R.aid = A.aid
    WHERE R.mid = M.mid
    AND A.gender = 'F'
);
 --  ��� ���� 
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

-- ���� ��� �� ������������ ��� �������� �� ������ �� "����������������" ���� 
-- ������� movies,  actors ������,  ���� ��� ��� roles ���������� �� ��������� �����.

-- ���� �� ��������� �� ���������� �� ������� ��� ������� �� ���� ������ ����.
CREATE INDEX idx_roles_mid ON ROLES (mid);

-- ���� �� ��������� �� ���������� �� ������� ��� ����� �� ���� ���������.
CREATE INDEX idx_roles_aid ON ROLES (aid);

-- ���� ��������� ���� ����.
CREATE INDEX idx_actors_gender ON ACTORS (gender);

-- ���� � ���������� ��� ����� ��� � ����� ��� not exist ������ �� ����� ��������, �����
-- ������ �� ���� �� distinct �������� �� left join ��� �� ��� ����������� ������ ��������.
-- ��� �������� ���� ��� ��������, �� not exists �� "������" ��� �� ������� ����������.
-- ����� �� ������ -��� ������������� - ������� ��� ��������� �� ������ �� ����� ��:
--  �������
SELECT M.title
FROM MOVIES M
WHERE NOT EXISTS (
    SELECT 1
    FROM ROLES R
    JOIN ACTORS A ON R.aid = A.aid
    WHERE R.mid = M.mid
    AND A.gender = 'F'
);
-- ���������
CREATE INDEX idx_roles_mid ON ROLES (mid);

CREATE INDEX idx_roles_aid ON ROLES (aid);

CREATE INDEX idx_actors_gender ON ACTORS (gender);


/*  4  */
-- ���� ������� �� ���������� �� ����� ��� ������ � ��� �� ���������� ������
-- ������ �������� ����� -����� ��� �� ����������- ��� �� ����������� ��� ���������� �������!!!!
-- ����� ������� ������������� ����� �� ���� ��� ���� ���� ����, �� "�������" ��� ��� ���� ����� ���.
-- ����� ��� ����� �������, �� ����� �� ���� ����� ������� "������ ��� ����" �� �� ��� �� ����� �� ����� 
-- ����������� ������� ���� �� ������ ������ ��� ����������� ��� ������ ��� ������ �� �� ���� ��� ��������� 
-- ���/��� ����������/��� ��� ��������. ��� �� ����� ������� �� ������ ������ ��� �� ����� �� ���� 
-- ����� ����� ������� ����� ����������� ������ ���������� ��� ��� 5 ��� ���� ��� ������ ����� ��� Iron Man
-- ���� ������� ��� �� ���� ����������� ��� Robert Downey.
-- SQL query 1�� ����������
SELECT M.title, M.mrank
FROM MOVIES M
JOIN USER_MOVIES UM ON M.mid = UM.mid
WHERE UM.rating = 5;

-- SQL query 2�� ����������
SELECT M.title, M.pyear
FROM MOVIES M
JOIN ROLES R ON M.mid = R.mid
JOIN ACTORS A ON R.aid = A.aid
WHERE A.firstName = 'Robert'
AND A.lastName = 'Downey';

-- ���� �� �������� ������ �� ��� ������ �� ���� �� ��������� ���
-- ���� �������� ��� ������� �� ���������� 5 ��� ��� ��� ������������� ��������.
-- ���� ����� ���������� �� ��������� ����� ��� ���� ����������� �������:

CREATE INDEX idx_user_movies_rating ON USER_MOVIES (rating);

CREATE INDEX idx_user_movies_mid ON USER_MOVIES (mid);

CREATE INDEX idx_actors_name ON ACTORS (firstName, lastName);

CREATE INDEX idx_roles_aid ON ROLES (aid);

CREATE INDEX idx_roles_mid ON ROLES (mid);
















