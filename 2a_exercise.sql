-- 1
SELECT NAZWISKO, 
  CONCAT(SUBSTR(ETAT,1,1), SUBSTR(NAZWISKO, 1,1), ID_PRAC) 
FROM PRACOWNICY;
-- 2
-- ORACLE VERSION
SELECT NAZWISKO,
  TRANSLATE(NAZWISKO, 'KLM', 'XXX')
FROM PRACOWNICY;
-- 3
SELECT NAZWISKO
FROM PRACOWNICY
WHERE SUBSTR(NAZWISKO, 1, CEIL(LENGTH(NAZWISKO)/2)) LIKE '%L%';
-- 4
SELECT NAZWISKO, ROUND(PLACA_POD*1.15)
FROM PRACOWNICY;
-- 5
SELECT NAZWISKO, PLACA_POD,
  PLACA_POD*0.2 AS INWESTYCJA,
  PLACA_POD*0.2*POWER(1.1, 10) AS KAPITAL,
  PLACA_POD*0.2*POWER(1.1, 10)-PLACA_POD*0.2 AS ZYSK
FROM PRACOWNICY;
-- 6
SELECT NAZWISKO, ZATRUDNIONY,
  ROUND(DATEDIFF(STR_TO_DATE('01-01-2000','%d-%m-%Y'), ZATRUDNIONY)/365) AS LATA
FROM PRACOWNICY;
-- 7
SELECT NAZWISKO, ZATRUDNIONY,
  DATE_FORMAT(ZATRUDNIONY, '%M, %d %Y')
FROM PRACOWNICY
WHERE ID_ZESP=20;