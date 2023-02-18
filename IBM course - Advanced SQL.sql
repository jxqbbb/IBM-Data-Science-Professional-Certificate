SELECT C.CASE_NUMBER, C.PRIMARY_TYPE, CS.COMMUNITY_AREA_NAME FROM chicago_crime_data C
LEFT JOIN chicago_census_data CS 
ON CS.COMMUNITY_AREA_NUMBER = C.COMMUNITY_AREA_NUMBER
WHERE C.LOCATION_DESCRIPTION LIKE '%SCHOOL%';

-----------------------------------------------------------------------------------------------------------------

CREATE VIEW SCHOOL_NON_SENSITIVE_DATA(School_Name, Safety_Rating, Family_Rating, 
Environment_Rating, Instruction_Rating, Leaders_rating, Teachers_rating) 
AS SELECT NAME_OF_SCHOOL, SAFETY_ICON, FAMILY_INVOLVEMENT_ICON, ENVIRONMENT_ICON,
INSTRUCTION_ICON, LEADERS_ICON, TEACHERS_ICON FROM chicago_public_schools;

SELECT * FROM SCHOOL_NON_SENSITIVE_DATA ;

SELECT School_name, Leaders_rating FROM SCHOOL_NON_SENSITIVE_DATA;

-----------------------------------------------------------------------------------------------------------------

--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE( 
IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

LANGUAGE SQL                       
MODIFIES SQL DATA                      

BEGIN; 

UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Score = in_Leader_Score
WHERE School_ID = in_School_ID

IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN                           
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Icon = 'Very_weak'
WHERE School_ID = in_School_ID;

ELSEIF in_Leader_Score < 40 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Icon = 'Weak'
WHERE School_ID = in_School_ID;

ELSEIF in_Leader_Score < 60 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Icon = 'Average'
WHERE School_ID = in_School_ID;  

ELSEIF in_Leader_Score < 80 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Icon = 'Strong'
WHERE School_ID = in_School_ID;

ELSEIF in_Leader_Score < 100 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Icon = 'Very strong'
WHERE School_ID = in_School_ID;

ELSE 
ROLLBACK WORK;

END IF;  

COMMIT WORK;

END
@                                 

CALL UPDATE_LEADERS_SCORE(123, 50); 

-----------------------------------------------------------------------------------------------------------------
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE( 
IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

LANGUAGE SQL                        
MODIFIES SQL DATA                      

BEGIN 
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
END;

START TRANSACTION;

UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Score = in_Leader_Score
WHERE School_ID = in_School_ID;

IF in_Leader_Score BETWEEN 0 AND 19 THEN                           
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Icon = 'Very weak'
WHERE School_ID = in_School_ID;

ELSEIF in_Leader_Score BETWEEN 20 AND 39 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Icon = 'Weak'
WHERE School_ID = in_School_ID;

ELSEIF in_Leader_Score BETWEEN 40 AND 59 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Icon = 'Average'
WHERE School_ID = in_School_ID;   

ELSEIF in_Leader_Score BETWEEN 60 AND 79 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Icon = 'Strong'
WHERE School_ID = in_School_ID;  

ELSEIF in_Leader_Score BETWEEN 80 AND 99 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Icon = 'Very strong'
WHERE School_ID = in_School_ID; 

ELSE 
ROLLBACK;

END IF;  

COMMIT;

END
@

CALL UPDATE_LEADERS_SCORE(3, 38);

CALL UPDATE_LEADERS_SCORE(3, 101);
