--1. primero realice la siguiente consulta para ver crimenes registrados
SELECT *
FROM crime_scene_report

--2. Teniendo como pista inicial un asesinato ocurrido el 15 de enero de 2018 en SQL City con esta consulta siguiendo esas pistas encontre esta descripcion: 
--Las imágenes de seguridad muestran que había dos testigos. El primero vive en la última casa de Northwestern Dr. El segundo, llamado Annabel, vive en algún lugar de Franklin Ave.

SELECT *
FROM crime_scene_report
WHERE date = 20180115
AND type = 'murder'
AND city = 'SQL City';

--3. siguiendo las pistas realice la consulta para esta primera busqueda: El primero vive en la última casa de Northwestern
SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;
-- con esto descubri que el primer testigo se trataba de Morty Schapiro

--4.  siguiendo con la pista anterior buscando a los testigos ahora tocaba realizar la consulta para Annabel

SELECT *
FROM person
WHERE name LIKE 'Annabel%'
AND address_street_name = 'Franklin Ave';

--5. Tome nota del identificador de cada testigo (14887)(16371) entonces busque en las entrevistas usando estos id en donde me lleve una grata sorpresa al entender de que el asesinato estaba relacionado con un gimnacio

SELECT *
FROM interview
WHERE person_id IN (14887, 16371);
              
--6. lo primero que hice en este punto fue buscar a quien pertenece un numero de socio 48Z del gimnacio.
SELECT *
FROM get_fit_now_member
WHERE id LIKE '48Z%';

--7. En las pistas anteriores se decia que esta persona tenia membresia gold por lo que encontre dos nombres clave (Joe Germuska)(Jeremy Bowers)
--8. Ahora teniendo a dos posibles sospechosos segui con otra pista y unir hilos, que era buscar de quien pertenece un coche con matricula H42W

SELECT p.name, d.plate_number
FROM person p
JOIN drivers_license d
ON p.license_id = d.id
WHERE p.name IN ('Joe Germuska', 'Jeremy Bowers')
AND d.plate_number LIKE '%H42W%';

--9. EL ASESINO ES Jeremy Bowers!!!!!!!!!!! ya que coincide con la matricula y la membresia que mencionan los testigos.

--10. Al confirmar que el asesino es Jeremy Bowers fui a revisar su entrevista haber si puedo encontrar algo extra.

SELECT *
FROM interview
WHERE person_id = (
    SELECT id
    FROM person
    WHERE name = 'Jeremy Bowers'
);

--11. Nos enteramos que el asesino fue contratado por una figura femenina ¿porque? ¿como se llama? 

/* 
Características:

Mujer

Altura: entre 65 y 67 pulgadas

Cabello rojo

Carro: Tesla Model S

Asistió al SQL Symphony Concert 3 veces en diciembre de 2017

Primero encontremos a las mujeres que coinciden con cabello, altura y carro.
*/

SELECT p.name, d.height, d.hair_color, d.car_make, d.car_model
FROM person p
JOIN drivers_license d
ON p.license_id = d.id
WHERE d.gender = 'female'
AND d.hair_color = 'red'
AND d.height BETWEEN 65 AND 67
AND d.car_make = 'Tesla'
AND d.car_model = 'Model S';

--12. se identificaron a 3 posibles responsables como autoras intelectuales del asesinato (Red Korb)(Regina George)(Miranda Priestly)
-- Ahora solo falta ver cuál de esas tres fue al concierto 3 veces en diciembre de 2017

SELECT p.name, COUNT(*) AS veces
FROM person p
JOIN facebook_event_checkin f
ON p.id = f.person_id
WHERE p.name IN ('Red Korb','Regina George','Miranda Priestly')
AND f.event_name = 'SQL Symphony Concert'
AND f.date BETWEEN 20171201 AND 20171231
GROUP BY p.name
HAVING COUNT(*) = 3;

--13. LA VILLANA PRINCIPAL DE ESTA ESCENA ES Miranda Priestly!!!!!!!!


--RESUMEN GENERAL DE LAS PRUEBAS PARA ACUSAR A MIRANDA PRIESTLY

-- ================================
-- RESOLUCIÓN DEL CASO
-- SQL Murder Mystery
-- ================================

-- 1. Se encontró el reporte del crimen ocurrido el 15 de enero de 2018 en SQL City.
-- 2. Los testigos indicaron que el asesino llevaba una bolsa de Get Fit Now Gym
--    con una membresía que comenzaba con "48Z" (solo miembros gold).
-- 3. También mencionaron que escapó en un automóvil cuya placa contenía "H42W".

-- 4. Al investigar las membresías del gimnasio con esas características,
--    se identificaron dos sospechosos: Joe Germuska y Jeremy Bowers.

-- 5. Revisando las licencias de conducir, se encontró que Jeremy Bowers
--    posee un vehículo cuya placa contiene "H42W", coincidiendo con la descripción.

-- 6. En la entrevista, Jeremy Bowers confesó que fue contratado por una mujer
--    rica, de cabello rojo, entre 65 y 67 pulgadas de altura, que conduce un Tesla Model S
--    y que asistió 3 veces al SQL Symphony Concert en diciembre de 2017.

-- 7. Al cruzar los datos de licencias y registros del evento,
--    la única persona que cumple TODAS las condiciones es:
--    Miranda Priestly

-- CONCLUSIÓN:
-- Miranda Priestly es la autora intelectual del asesinato,
-- ya que coincide con todas las características descritas por el asesino
-- y los registros de asistencia al evento confirman su identidad.

              



              