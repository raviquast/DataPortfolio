WITH CSR AS(
	SELECT
  		*
	FROM
  		crime_scene_report AS CSR
	WHERE
  		date = 20180115
  		AND type LIKE '%murder%'
  		AND city LIKE '%SQL City%'
),
	
WITNESSES AS(
	SELECT
  		*
  	FROM
  		person
  	WHERE
  		address_number = 
			(
				SELECT 
					MAX(address_number) 
				FROM 
					person
				WHERE
					address_street_name LIKE 'Northwestern Dr'
			)
  		OR (address_street_name LIKE '%Franklin Ave%'
			AND name LIKE 'Annabel%')
  		
  	ORDER BY
  		address_street_name
),
	
INTERVIEWS AS (
	SELECT
  		*
  	FROM
  		interview AS I
  	JOIN WITNESSES ON WITNESSES.id = I.person_id
  	
),
	
SUSPECTS AS (
	SELECT
  		M.person_id AS person_id
  	FROM
  		get_fit_now_check_in AS C
  	JOIN get_fit_now_member AS M ON M.id = C.membership_id
  	WHERE
  		check_in_date = 20180109
  		AND membership_id LIKE '48Z%'
  	
),
	
MURDERER AS (
	SELECT
  		P.name AS name
  		, P.id AS person_id
  	FROM
  		person AS P
  	JOIN SUSPECTS AS S ON S.person_id = P.id
  	JOIN drivers_license AS DL ON P.license_id = DL.id
),
	
MURDERER_INTERVIEW AS (
	SELECT
		*
	FROM
		interview
	WHERE
		interview.person_id = (SELECT person_id FROM MURDERER)
),
	
HIRING_SUSPECTS AS (
	SELECT
  		P.id AS person_id
  		, P.name AS name
  	FROM
  		drivers_license as DL
  	JOIN person AS P ON P.license_id = DL.id
  	WHERE
  		DL.gender LIKE '%female%'
  		AND DL.hair_color LIKE '%red%'
  		AND (DL.height >= 65 AND DL.height <= 67)
  		AND DL.car_make LIKE '%Tesla%'
  		AND DL.car_model LIKE '%Model S%'
  	
),
	
HIRING_BITCH AS (
	SELECT
  		FB.person_id AS person_id
  		, HS.name AS name
  		, COUNT(FB.event_name) AS attendance
  	FROM
  		facebook_event_checkin AS FB
  	JOIN HIRING_SUSPECTS AS HS ON HS.person_id = FB.person_id
  	WHERE
  		(FB.date >= 20171201 AND FB.date <= 20171231)
  		AND FB.event_name LIKE '%SQL Symphony Concert%'
  	GROUP BY
  		FB.person_id
  	HAVING
  		attendance = 3
  		
)

SELECT
	*
FROM
	HIRING_BITCH




              
