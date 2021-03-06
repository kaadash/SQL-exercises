-- 1
SELECT NAZWISKO, ETAT, ID_ZESP
FROM PRACOWNICY
WHERE ID_ZESP=(SELECT ID_ZESP FROM PRACOWNICY WHERE NAZWISKO='BRZEZINSKI');
-- 2
SELECT NAZWISKO, ETAT, ZATRUDNIONY
FROM PRACOWNICY
WHERE ZATRUDNIONY=
  (SELECT MIN(ZATRUDNIONY)
    FROM PRACOWNICY
    WHERE ETAT='PROFESOR')
AND ETAT='PROFESOR';
-- 3
SELECT NAZWISKO, ZATRUDNIONY, ID_ZESP
FROM PRACOWNICY
WHERE (ZATRUDNIONY, ID_ZESP) IN
  (SELECT MAX(ZATRUDNIONY), ID_ZESP
    FROM PRACOWNICY
    GROUP BY ID_ZESP);
-- 4
SELECT * FROM ZESPOLY
WHERE ID_ZESP NOT IN (SELECT ID_ZESP 
FROM PRACOWNICY
GROUP BY ID_ZESP);

-- 5
  SELECT NAZWISKO, PLACA_POD, ETAT
  FROM PRACOWNICY p
  WHERE p.PLACA_POD>
  (SELECT AVG(PLACA_POD)
    FROM PRACOWNICY
    WHERE p.ETAT=ETAT);
-- 6
SELECT NAZWISKO, PLACA_POD
FROM PRACOWNICY prac
WHERE  PLACA_POD > 0.75*(
  SELECT sz.PLACA_POD
  FROM PRACOWNICY p
  JOIN PRACOWNICY sz ON sz.ID_PRAC=p.ID_SZEFA
  WHERE prac.ID_PRAC=p.ID_PRAC
);
-- 7
SELECT NAZWISKO
FROM PRACOWNICY p
WHERE NOT EXISTS (
  SELECT ID_PRAC FROM PRACOWNICY
  WHERE ID_SZEFA=p.ID_PRAC AND ETAT='STAZYSTA')
AND p.ETAT='PROFESOR';

-- 8
SELECT *
FROM ZESPOLY Z
WHERE NOT EXISTS (
  SELECT ID_ZESP
  FROM PRACOWNICY P
  WHERE Z.ID_ZESP=P.ID_ZESP
);
-- 9
SELECT ID_ZESP, SUM(PLACA_POD) AS SUMA
FROM PRACOWNICY P
GROUP BY ID_ZESP
HAVING SUM(PLACA_POD)>=ALL(
  SELECT SUM(PLACA_POD)
  FROM PRACOWNICY
  GROUP BY ID_ZESP
);


-- 10
SELECT NAZWISKO, PLACA_POD
FROM PRACOWNICY

-- 11
SELECT EXTRACT(YEAR FROM ZATRUDNIONY), COUNT(ID_PRAC) AS LICZBA
FROM PRACOWNICY
GROUP BY EXTRACT(YEAR FROM ZATRUDNIONY)
ORDER BY LICZBA DESC;

-- 12
SELECT EXTRACT(YEAR FROM ZATRUDNIONY), COUNT(ID_PRAC) AS LICZBA
FROM PRACOWNICY
GROUP BY EXTRACT(YEAR FROM ZATRUDNIONY)
HAVING COUNT(ID_PRAC)>=ALL(SELECT COUNT(ID_PRAC) AS LICZBA
FROM PRACOWNICY
GROUP BY EXTRACT(YEAR FROM ZATRUDNIONY));

-- 13
SELECT NAZWISKO, ETAT, PLACA_POD, NAZWA
FROM PRACOWNICY p
NATURAL JOIN ZESPOLY
WHERE PLACA_POD<(
  SELECT AVG(pod.PLACA_POD)
  FROM PRACOWNICY pod
  GROUP BY pod.ETAT
  HAVING pod.ETAT=p.ETAT
  );

-- 14
SELECT NAZWISKO, ETAT, PLACA_POD, (SELECT AVG(pod.PLACA_POD)
  FROM PRACOWNICY pod
  GROUP BY pod.ETAT
  HAVING pod.ETAT=p.ETAT) as srednia
FROM PRACOWNICY p;

-- 15
SELECT NAZWISKO, ETAT, PLACA_POD, 
(SELECT COUNT(sz.ID_PRAC)
  FROM PRACOWNICY sz
  JOIN PRACOWNICY prac ON sz.ID_PRAC=prac.ID_SZEFA 
  GROUP BY sz.ID_PRAC
  HAVING p.ID_PRAC=sz.ID_PRAC) as podwladni
FROM PRACOWNICY p
NATURAL JOIN ZESPOLY
WHERE p.ETAT='PROFESOR' AND ZESPOLY.ADRES LIKE '%PIOTROWO%';

-- 16
SELECT NAZWISKO, (SELECT AVG(PLACA_POD)
FROM PRACOWNICY
GROUP BY ID_ZESP
HAVING p.ID_ZESP=ID_ZESP) AS SREDNIA,
(SELECT MAX(PLACA_POD)
FROM PRACOWNICY) AS MAXIMUM
FROM PRACOWNICY p
WHERE ETAT='PROFESOR';

-- 17
SELECT NAZWISKO,
(SELECT NAZWA
FROM ZESPOLY
NATURAL JOIN PRACOWNICY PRAC 
WHERE PRAC.ID_PRAC=P.ID_PRAC) AS ZESPOL
FROM PRACOWNICY P;

-- 18
WITH ASYSTENCI AS 
  (SELECT NAZWISKO, ETAT, ID_ZESP
  FROM PRACOWNICY
  WHERE ETAT LIKE 'ASYSTENT'),
PIOTROWO AS 
  (SELECT NAZWA, ADRES, ID_ZESP
  FROM ZESPOLY
  WHERE ADRES LIKE '%PIOTROWO%')
SELECT *
FROM ASYSTENCI NATURAL JOIN PIOTROWO;
