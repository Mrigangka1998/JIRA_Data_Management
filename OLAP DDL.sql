--DATE DIM

CREATE SCHEMA MYDB.JIRA_ANALYTICS;

DROP TABLE IF EXISTS MYDB.JIRA_ANALYTICS.DATE_DIM;

CREATE OR REPLACE TABLE MYDB.JIRA_ANALYTICS.DATE_DIM (
	DATE_KEY				NUMBER(9) PRIMARY KEY,
	DATE					DATE ,
	FULL_DATE_DESC			VARCHAR(64),
	DAY_NUM_IN_WEEK			NUMBER(1) ,
	DAY_NUM_IN_MONTH		NUMBER(2) ,
	DAY_NUM_IN_YEAR			NUMBER(3) ,
	DAY_NAME				VARCHAR(10) ,
	DAY_ABBREV				VARCHAR(3) ,
	WEEKDAY_IND				VARCHAR(64) ,
	US_HOLIDAY_IND			VARCHAR(64) ,
	/*<COMPANYNAME>*/_HOLIDAY_IND VARCHAR(64) ,
	MONTH_END_IND			VARCHAR(64) ,
	WEEK_BEGIN_DATE_NKEY		NUMBER(9) ,
	WEEK_BEGIN_DATE			DATE ,
	WEEK_END_DATE_NKEY		NUMBER(9) ,
	WEEK_END_DATE			DATE ,
	WEEK_NUM_IN_YEAR		NUMBER(9) ,
	MONTH_NAME				VARCHAR(10) ,
	MONTH_ABBREV			VARCHAR(3) ,
	MONTH_NUM_IN_YEAR		NUMBER(2) ,
	YEARMONTH				VARCHAR(10) ,
	QUARTER					NUMBER(1) ,
	YEARQUARTER				VARCHAR(10) ,
	YEAR					NUMBER(5) ,
	FISCAL_WEEK_NUM			NUMBER(2) ,
	FISCAL_MONTH_NUM		NUMBER(2) ,
	FISCAL_YEARMONTH		VARCHAR(10) ,
	FISCAL_QUARTER			NUMBER(1) ,
	FISCAL_YEARQUARTER		VARCHAR(10) ,
	FISCAL_HALFYEAR			NUMBER(1) ,
	FISCAL_YEAR				NUMBER(5) ,
	SQL_TIMESTAMP			TIMESTAMP_NTZ,
	CURRENT_ROW_IND			CHAR(1) DEFAULT 'Y',
	EFFECTIVE_DATE			DATE DEFAULT TO_DATE(CURRENT_TIMESTAMP),
	EXPIRATION_DATE			DATE DEFAULT TO_DATE('9999-12-31') 
); 

-- POPULATE DATA INTO DIM_DATE
INSERT INTO DATE_DIM
SELECT DATE_PKEY,
		DATE_COLUMN,
        FULL_DATE_DESC,
		DAY_NUM_IN_WEEK,
		DAY_NUM_IN_MONTH,
		DAY_NUM_IN_YEAR,
		DAY_NAME,
		DAY_ABBREV,
		WEEKDAY_IND,
		US_HOLIDAY_IND,
        COMPANY_HOLIDAY_IND,
		MONTH_END_IND,
		WEEK_BEGIN_DATE_NKEY,
		WEEK_BEGIN_DATE,
		WEEK_END_DATE_NKEY,
		WEEK_END_DATE,
		WEEK_NUM_IN_YEAR,
		MONTH_NAME,
		MONTH_ABBREV,
		MONTH_NUM_IN_YEAR,
		YEARMONTH,
		CURRENT_QUARTER,
		YEARQUARTER,
		CURRENT_YEAR,
		FISCAL_WEEK_NUM,
		FISCAL_MONTH_NUM,
		FISCAL_YEARMONTH,
		FISCAL_QUARTER,
		FISCAL_YEARQUARTER,
		FISCAL_HALFYEAR,
		FISCAL_YEAR,
		SQL_TIMESTAMP,
		CURRENT_ROW_IND,
		EFFECTIVE_DATE,
		EXPIRA_DATE
	FROM 
	( SELECT  TO_DATE('1999-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS') AS DD, /*<<MODIFY DATE FOR PREFERRED TABLE START DATE*/
			SEQ1() AS SL,ROW_NUMBER() OVER (ORDER BY SL) AS ROW_NUMBERS,
			DATEADD(DAY,ROW_NUMBERS,DD) AS V_DATE,
			CASE WHEN DATE_PART(DD, V_DATE) < 10 AND DATE_PART(MM, V_DATE) > 9 THEN
				DATE_PART(YEAR, V_DATE)||DATE_PART(MM, V_DATE)||'0'||DATE_PART(DD, V_DATE)
				 WHEN DATE_PART(DD, V_DATE) < 10 AND  DATE_PART(MM, V_DATE) < 10 THEN 
				 DATE_PART(YEAR, V_DATE)||'0'||DATE_PART(MM, V_DATE)||'0'||DATE_PART(DD, V_DATE)
				 WHEN DATE_PART(DD, V_DATE) > 9 AND  DATE_PART(MM, V_DATE) < 10 THEN
				 DATE_PART(YEAR, V_DATE)||'0'||DATE_PART(MM, V_DATE)||DATE_PART(DD, V_DATE)
				 WHEN DATE_PART(DD, V_DATE) > 9 AND  DATE_PART(MM, V_DATE) > 9 THEN
				 DATE_PART(YEAR, V_DATE)||DATE_PART(MM, V_DATE)||DATE_PART(DD, V_DATE) END AS DATE_PKEY,
			V_DATE AS DATE_COLUMN,
			DAYNAME(DATEADD(DAY,ROW_NUMBERS,DD)) AS DAY_NAME_1,
			CASE 
				WHEN DAYNAME(DATEADD(DAY,ROW_NUMBERS,DD)) = 'MON' THEN 'MONDAY'
				WHEN DAYNAME(DATEADD(DAY,ROW_NUMBERS,DD)) = 'TUE' THEN 'TUESDAY'
				WHEN DAYNAME(DATEADD(DAY,ROW_NUMBERS,DD)) = 'WED' THEN 'WEDNESDAY'
				WHEN DAYNAME(DATEADD(DAY,ROW_NUMBERS,DD)) = 'THU' THEN 'THURSDAY'
				WHEN DAYNAME(DATEADD(DAY,ROW_NUMBERS,DD)) = 'FRI' THEN 'FRIDAY'
				WHEN DAYNAME(DATEADD(DAY,ROW_NUMBERS,DD)) = 'SAT' THEN 'SATURDAY'
				WHEN DAYNAME(DATEADD(DAY,ROW_NUMBERS,DD)) = 'SUN' THEN 'SUNDAY' END ||', '||
			CASE WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='JAN' THEN 'JANUARY'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='FEB' THEN 'FEBRUARY'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='MAR' THEN 'MARCH'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='APR' THEN 'APRIL'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='MAY' THEN 'MAY'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='JUN' THEN 'JUNE'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='JUL' THEN 'JULY'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='AUG' THEN 'AUGUST'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='SEP' THEN 'SEPTEMBER'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='OCT' THEN 'OCTOBER'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='NOV' THEN 'NOVEMBER'
				   WHEN MONTHNAME(DATEADD(DAY,ROW_NUMBERS,DD)) ='DEC' THEN 'DECEMBER' END
				   ||' '|| TO_VARCHAR(DATEADD(DAY,ROW_NUMBERS,DD), ' DD, YYYY') AS FULL_DATE_DESC,
			DATEADD(DAY,ROW_NUMBERS,DD) AS V_DATE_1,
			DAYOFWEEK(V_DATE_1)+1 AS DAY_NUM_IN_WEEK,
			DATE_PART(DD,V_DATE_1) AS DAY_NUM_IN_MONTH,
			DAYOFYEAR(V_DATE_1) AS DAY_NUM_IN_YEAR,
			CASE 
				WHEN DAYNAME(V_DATE_1) = 'MON' THEN 'MONDAY'
				WHEN DAYNAME(V_DATE_1) = 'TUE' THEN 'TUESDAY'
				WHEN DAYNAME(V_DATE_1) = 'WED' THEN 'WEDNESDAY'
				WHEN DAYNAME(V_DATE_1) = 'THU' THEN 'THURSDAY'
				WHEN DAYNAME(V_DATE_1) = 'FRI' THEN 'FRIDAY'
				WHEN DAYNAME(V_DATE_1) = 'SAT' THEN 'SATURDAY'
				WHEN DAYNAME(V_DATE_1) = 'SUN' THEN 'SUNDAY' END AS	DAY_NAME,
			DAYNAME(DATEADD(DAY,ROW_NUMBERS,DD)) AS DAY_ABBREV,
			CASE  
				WHEN DAYNAME(V_DATE_1) = 'SUN' AND DAYNAME(V_DATE_1) = 'SAT' THEN 
                 'NOT-WEEKDAY'
				ELSE 'WEEKDAY' END AS WEEKDAY_IND,
			 CASE 
				WHEN (DATE_PKEY = DATE_PART(YEAR, V_DATE)||'0101' OR DATE_PKEY = DATE_PART(YEAR, V_DATE)||'0704' OR
				DATE_PKEY = DATE_PART(YEAR, V_DATE)||'1225' OR DATE_PKEY = DATE_PART(YEAR, V_DATE)||'1226') THEN  
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='MAY' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'WED' 
				AND DATEADD(DAY,-2,LAST_DAY(V_DATE_1)) = V_DATE_1  THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='MAY' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'THU' 
				AND DATEADD(DAY,-3,LAST_DAY(V_DATE_1)) = V_DATE_1  THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='MAY' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'FRI' 
				AND DATEADD(DAY,-4,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='MAY' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'SAT' 
				AND DATEADD(DAY,-5,LAST_DAY(V_DATE_1)) = V_DATE_1  THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='MAY' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'SUN' 
				AND DATEADD(DAY,-6,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='MAY' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'MON' 
				AND LAST_DAY(V_DATE_1) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='MAY' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'TUE' 
				AND DATEADD(DAY,-1 ,LAST_DAY(V_DATE_1)) = V_DATE_1  THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'WED' 
				AND DATEADD(DAY,5,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'THU' 
				AND DATEADD(DAY,4,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'FRI' 
				AND DATEADD(DAY,3,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'SAT' 
				AND DATEADD(DAY,2,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'SUN' 
				AND DATEADD(DAY,1,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'MON' 
				AND DATE_PART(YEAR, V_DATE_1)||'-09-01' = V_DATE_1 THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'TUE' 
				AND DATEADD(DAY,6 ,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'WED' 
				AND (DATEADD(DAY,23,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1  OR 
					 DATEADD(DAY,22,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'THU' 
				AND ( DATEADD(DAY,22,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR 
					 DATEADD(DAY,21,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'FRI' 
				AND ( DATEADD(DAY,21,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR 
					 DATEADD(DAY,20,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN
				 'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'SAT' 
				AND ( DATEADD(DAY,27,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR 
					 DATEADD(DAY,26,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'SUN' 
				AND ( DATEADD(DAY,26,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR 
					 DATEADD(DAY,25,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'MON' 
				AND (DATEADD(DAY,25,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR 
					 DATEADD(DAY,24,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'TUE' 
				AND (DATEADD(DAY,24,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 OR 
					 DATEADD(DAY,23,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 ) THEN
				 'HOLIDAY'    
				ELSE
				'NOT-HOLIDAY' END AS US_HOLIDAY_IND,
			/*MODIFY THE FOLLOWING FOR COMPANY SPECIFIC HOLIDAYS*/
			CASE 
				WHEN (DATE_PKEY = DATE_PART(YEAR, V_DATE)||'0101' OR DATE_PKEY = DATE_PART(YEAR, V_DATE)||'0219'
				OR DATE_PKEY = DATE_PART(YEAR, V_DATE)||'0528' OR DATE_PKEY = DATE_PART(YEAR, V_DATE)||'0704' 
				OR DATE_PKEY = DATE_PART(YEAR, V_DATE)||'1225' )THEN 
				'HOLIDAY'               
                WHEN MONTHNAME(V_DATE_1) ='MAR' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'FRI' 
				AND LAST_DAY(V_DATE_1) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='MAR' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'SAT' 
				AND DATEADD(DAY,-1,LAST_DAY(V_DATE_1)) = V_DATE_1  THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='MAR' AND DAYNAME(LAST_DAY(V_DATE_1)) = 'SUN' 
				AND DATEADD(DAY,-2,LAST_DAY(V_DATE_1)) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'TUE'
                AND DATEADD(DAY,3,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'WED' 
				AND DATEADD(DAY,2,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'THU'
                AND DATEADD(DAY,1,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'FRI' 
				AND DATE_PART(YEAR, V_DATE_1)||'-04-01' = V_DATE_1 THEN
				'HOLIDAY'
                WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'WED' 
				AND DATEADD(DAY,5,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'THU' 
				AND DATEADD(DAY,4,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'FRI' 
				AND DATEADD(DAY,3,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'SAT' 
				AND DATEADD(DAY,2,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'SUN' 
				AND DATEADD(DAY,1,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1 THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'MON' 
                AND DATE_PART(YEAR, V_DATE_1)||'-04-01'= V_DATE_1 THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='APR' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-04-01') = 'TUE' 
				AND DATEADD(DAY,6 ,(DATE_PART(YEAR, V_DATE_1)||'-04-01')) = V_DATE_1  THEN
				'HOLIDAY'   
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'WED' 
				AND DATEADD(DAY,5,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'THU' 
				AND DATEADD(DAY,4,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'FRI' 
				AND DATEADD(DAY,3,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'SAT' 
				AND DATEADD(DAY,2,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'SUN' 
				AND DATEADD(DAY,1,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1 THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'MON' 
                AND DATE_PART(YEAR, V_DATE_1)||'-09-01' = V_DATE_1 THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='SEP' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-09-01') = 'TUE' 
				AND DATEADD(DAY,6 ,(DATE_PART(YEAR, V_DATE_1)||'-09-01')) = V_DATE_1  THEN
				'HOLIDAY' 
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'WED' 
				AND DATEADD(DAY,23,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'THU' 
				AND DATEADD(DAY,22,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'FRI' 
				AND DATEADD(DAY,21,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1  THEN
				 'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'SAT' 
				AND DATEADD(DAY,27,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'SUN' 
				AND DATEADD(DAY,26,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'MON' 
				AND DATEADD(DAY,25,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1 THEN
				'HOLIDAY'
				WHEN MONTHNAME(V_DATE_1) ='NOV' AND DAYNAME(DATE_PART(YEAR, V_DATE_1)||'-11-01') = 'TUE' 
				AND DATEADD(DAY,24,(DATE_PART(YEAR, V_DATE_1)||'-11-01')) = V_DATE_1  THEN
				 'HOLIDAY'     
				ELSE
				'NOT-HOLIDAY' END AS COMPANY_HOLIDAY_IND,
			CASE                                           
				WHEN LAST_DAY(V_DATE_1) = V_DATE_1 THEN 
				'MONTH-END'
				ELSE 'NOT-MONTH-END' END AS MONTH_END_IND,
					
			CASE WHEN DATE_PART(MM,DATE_TRUNC('WEEK',V_DATE_1)) < 10 AND DATE_PART(DD,DATE_TRUNC('WEEK',V_DATE_1)) < 10 THEN
					  DATE_PART(YYYY,DATE_TRUNC('WEEK',V_DATE_1))||'0'||
					  DATE_PART(MM,DATE_TRUNC('WEEK',V_DATE_1))||'0'||
					  DATE_PART(DD,DATE_TRUNC('WEEK',V_DATE_1))  
				 WHEN DATE_PART(MM,DATE_TRUNC('WEEK',V_DATE_1)) < 10 AND DATE_PART(DD,DATE_TRUNC('WEEK',V_DATE_1)) > 9 THEN
						DATE_PART(YYYY,DATE_TRUNC('WEEK',V_DATE_1))||'0'||
						DATE_PART(MM,DATE_TRUNC('WEEK',V_DATE_1))||DATE_PART(DD,DATE_TRUNC('WEEK',V_DATE_1))    
				 WHEN DATE_PART(MM,DATE_TRUNC('WEEK',V_DATE_1)) > 9 AND DATE_PART(DD,DATE_TRUNC('WEEK',V_DATE_1)) < 10 THEN
						DATE_PART(YYYY,DATE_TRUNC('WEEK',V_DATE_1))||DATE_PART(MM,DATE_TRUNC('WEEK',V_DATE_1))||
						'0'||DATE_PART(DD,DATE_TRUNC('WEEK',V_DATE_1))    
				WHEN DATE_PART(MM,DATE_TRUNC('WEEK',V_DATE_1)) > 9 AND DATE_PART(DD,DATE_TRUNC('WEEK',V_DATE_1)) > 9 THEN
						DATE_PART(YYYY,DATE_TRUNC('WEEK',V_DATE_1))||
						DATE_PART(MM,DATE_TRUNC('WEEK',V_DATE_1))||
						DATE_PART(DD,DATE_TRUNC('WEEK',V_DATE_1)) END AS WEEK_BEGIN_DATE_NKEY,
			DATE_TRUNC('WEEK',V_DATE_1) AS WEEK_BEGIN_DATE,

			CASE WHEN  DATE_PART(MM,LAST_DAY(V_DATE_1,'WEEK')) < 10 AND DATE_PART(DD,LAST_DAY(V_DATE_1,'WEEK')) < 10 THEN
					  DATE_PART(YYYY,LAST_DAY(V_DATE_1,'WEEK'))||'0'||
					  DATE_PART(MM,LAST_DAY(V_DATE_1,'WEEK'))||'0'||
					  DATE_PART(DD,LAST_DAY(V_DATE_1,'WEEK')) 
				 WHEN  DATE_PART(MM,LAST_DAY(V_DATE_1,'WEEK')) < 10 AND DATE_PART(DD,LAST_DAY(V_DATE_1,'WEEK')) > 9 THEN
					  DATE_PART(YYYY,LAST_DAY(V_DATE_1,'WEEK'))||'0'||
					  DATE_PART(MM,LAST_DAY(V_DATE_1,'WEEK'))||DATE_PART(DD,LAST_DAY(V_DATE_1,'WEEK'))   
				 WHEN  DATE_PART(MM,LAST_DAY(V_DATE_1,'WEEK')) > 9 AND DATE_PART(DD,LAST_DAY(V_DATE_1,'WEEK')) < 10  THEN
					  DATE_PART(YYYY,LAST_DAY(V_DATE_1,'WEEK'))||DATE_PART(MM,LAST_DAY(V_DATE_1,'WEEK'))||'0'||
					  DATE_PART(DD,LAST_DAY(V_DATE_1,'WEEK'))   
				 WHEN  DATE_PART(MM,LAST_DAY(V_DATE_1,'WEEK')) > 9 AND DATE_PART(DD,LAST_DAY(V_DATE_1,'WEEK')) > 9 THEN
					  DATE_PART(YYYY,LAST_DAY(V_DATE_1,'WEEK'))||
					  DATE_PART(MM,LAST_DAY(V_DATE_1,'WEEK'))||
					  DATE_PART(DD,LAST_DAY(V_DATE_1,'WEEK')) END AS WEEK_END_DATE_NKEY,
			LAST_DAY(V_DATE_1,'WEEK') AS WEEK_END_DATE,
			WEEK(V_DATE_1) AS WEEK_NUM_IN_YEAR,
			CASE WHEN MONTHNAME(V_DATE_1) ='JAN' THEN 'JANUARY'
				   WHEN MONTHNAME(V_DATE_1) ='FEB' THEN 'FEBRUARY'
				   WHEN MONTHNAME(V_DATE_1) ='MAR' THEN 'MARCH'
				   WHEN MONTHNAME(V_DATE_1) ='APR' THEN 'APRIL'
				   WHEN MONTHNAME(V_DATE_1) ='MAY' THEN 'MAY'
				   WHEN MONTHNAME(V_DATE_1) ='JUN' THEN 'JUNE'
				   WHEN MONTHNAME(V_DATE_1) ='JUL' THEN 'JULY'
				   WHEN MONTHNAME(V_DATE_1) ='AUG' THEN 'AUGUST'
				   WHEN MONTHNAME(V_DATE_1) ='SEP' THEN 'SEPTEMBER'
				   WHEN MONTHNAME(V_DATE_1) ='OCT' THEN 'OCTOBER'
				   WHEN MONTHNAME(V_DATE_1) ='NOV' THEN 'NOVEMBER'
				   WHEN MONTHNAME(V_DATE_1) ='DEC' THEN 'DECEMBER' END AS MONTH_NAME,
			MONTHNAME(V_DATE_1) AS MONTH_ABBREV,
			MONTH(V_DATE_1) AS MONTH_NUM_IN_YEAR,
			CASE WHEN MONTH(V_DATE_1) < 10 THEN 
			YEAR(V_DATE_1)||'-0'||MONTH(V_DATE_1)   
			ELSE YEAR(V_DATE_1)||'-'||MONTH(V_DATE_1) END AS YEARMONTH,
			QUARTER(V_DATE_1) AS CURRENT_QUARTER,
			YEAR(V_DATE_1)||'-0'||QUARTER(V_DATE_1) AS YEARQUARTER,
			YEAR(V_DATE_1) AS CURRENT_YEAR,
			/*MODIFY THE FOLLOWING BASED ON COMPANY FISCAL YEAR - ASSUMES JAN 01*/
            TO_DATE(YEAR(V_DATE_1)||'-01-01','YYYY-MM-DD') AS FISCAL_CUR_YEAR,
            TO_DATE(YEAR(V_DATE_1) -1||'-01-01','YYYY-MM-DD') AS FISCAL_PREV_YEAR,
			CASE WHEN   V_DATE_1 < FISCAL_CUR_YEAR THEN
			DATEDIFF('WEEK', FISCAL_PREV_YEAR,V_DATE_1)
			ELSE 
			DATEDIFF('WEEK', FISCAL_CUR_YEAR,V_DATE_1)  END AS FISCAL_WEEK_NUM  ,
			DECODE(DATEDIFF('MONTH',FISCAL_CUR_YEAR, V_DATE_1)+1 ,-2,10,-1,11,0,12,
                   DATEDIFF('MONTH',FISCAL_CUR_YEAR, V_DATE_1)+1 ) AS FISCAL_MONTH_NUM,
			CONCAT( YEAR(FISCAL_CUR_YEAR) 
				   ,CASE WHEN TO_NUMBER(FISCAL_MONTH_NUM) = 10 OR 
							TO_NUMBER(FISCAL_MONTH_NUM) = 11 OR 
                            TO_NUMBER(FISCAL_MONTH_NUM) = 12  THEN
							'-'||FISCAL_MONTH_NUM
					ELSE  CONCAT('-0',FISCAL_MONTH_NUM) END ) AS FISCAL_YEARMONTH,
			CASE WHEN QUARTER(V_DATE_1) = 4 THEN 4
				 WHEN QUARTER(V_DATE_1) = 3 THEN 3
				 WHEN QUARTER(V_DATE_1) = 2 THEN 2
				 WHEN QUARTER(V_DATE_1) = 1 THEN 1 END AS FISCAL_QUARTER,
			
			CASE WHEN   V_DATE_1 < FISCAL_CUR_YEAR THEN
					YEAR(FISCAL_CUR_YEAR)
					ELSE YEAR(FISCAL_CUR_YEAR)+1 END
					||'-0'||CASE WHEN QUARTER(V_DATE_1) = 4 THEN 4
					 WHEN QUARTER(V_DATE_1) = 3 THEN 3
					 WHEN QUARTER(V_DATE_1) = 2 THEN 2
					 WHEN QUARTER(V_DATE_1) = 1 THEN 1 END AS FISCAL_YEARQUARTER,
			CASE WHEN QUARTER(V_DATE_1) = 4  THEN 2 WHEN QUARTER(V_DATE_1) = 3 THEN 2
				WHEN QUARTER(V_DATE_1) = 1  THEN 1 WHEN QUARTER(V_DATE_1) = 2 THEN 1
			END AS FISCAL_HALFYEAR,
			YEAR(FISCAL_CUR_YEAR) AS FISCAL_YEAR,
			TO_TIMESTAMP_NTZ(V_DATE) AS SQL_TIMESTAMP,
			'Y' AS CURRENT_ROW_IND,
			TO_DATE(CURRENT_TIMESTAMP) AS EFFECTIVE_DATE,
			TO_DATE('9999-12-31') AS EXPIRA_DATE
			FROM TABLE(GENERATOR(ROWCOUNT => 15000)) /*<< SET TO GENERATE 20 YEARS. MODIFY ROWCOUNT TO INCREASE OR DECREASE SIZE*/
	)V;



-- NA RECORD
INSERT INTO DATE_DIM
SELECT -1,'9999-12-31','NA',-1,-1,-1,'NA','NA','NA','NA','NA','NA',-1,'9999-12-31',-1,'9999-12-31',-1,'NA','NA',-1,'NA',-1,'NA',-1,-1,-1,'NA',-1,'NA',-1,-1,'9999-12-31T00:00:00Z','/','9999-12-31','9999-12-31';



--TIMEOFDAY_DIM

DROP TABLE IF EXISTS MYDB.JIRA_ANALYTICS.TIMEOFDAY_DIM;

CREATE OR REPLACE TABLE MYDB.JIRA_ANALYTICS.TIMEOFDAY_DIM (
	TIMEOFDAY_KEY NUMBER(38,0) NOT NULL,
    TIME_OF_DAY TIME NOT NULL,
	HOUR NUMBER(38,0) NOT NULL,
	MINUTE NUMBER(38,0) NOT NULL,
	SECOND NUMBER(38,0) NOT NULL
	);

INSERT INTO MYDB.JIRA_ANALYTICS.TIMEOFDAY_DIM
SELECT TIMEOFDAY_KEY, TIME AS TIME_OF_DAY, HOUR, MINUTE, SECOND
FROM
(
WITH "GAPLESS_ROW_NUMBERS" AS (
  SELECT
    ROW_NUMBER() OVER (ORDER BY seq4()) - 1 as "ROW_NUMBER" 
  FROM TABLE(GENERATOR(rowcount => 60*60*24) ) -- rowcount is 60s x 60m x 24h
)
SELECT
    TIMEADD('second', "ROW_NUMBER", TIME('00:00')) as "TIME", -- Dimension starts at 00:00
    EXTRACT(hour FROM "TIME") as "HOUR",
    EXTRACT(minute FROM "TIME") as "MINUTE",
    EXTRACT(second FROM "TIME") as "SECOND",
    EXTRACT(hour FROM "TIME") * 3600 + EXTRACT(minute FROM "TIME")*60 + EXTRACT(second FROM "TIME") AS TIMEOFDAY_KEY      
FROM "GAPLESS_ROW_NUMBERS"
);

insert into MYDB.JIRA_ANALYTICS.TIMEOFDAY_DIM select -1,'00:00:00',-1,-1,-1;






-- USER DIM

DROP TABLE IF EXISTS MYDB.JIRA_ANALYTICS.USER_DIM;


CREATE OR REPLACE TABLE MYDB.JIRA_ANALYTICS.USER_DIM (
	USER_KEY NUMBER(38,0) NOT NULL autoincrement,
	user_id VARCHAR(50) NOT NULL,
	locale VARCHAR(50) NOT NULL DEFAULT 'NA',
	time_zone VARCHAR(50) NOT NULL DEFAULT 'NA',
	email VARCHAR(50),
	name VARCHAR(50) NOT NULL,
	username VARCHAR(50)
);


CREATE OR REPLACE SEQUENCE USER_DIM;

insert into MYDB.JIRA_ANALYTICS.USER_DIM
SELECT USER_DIM.nextval as USER_KEY,
user_id, locale, time_zone, email, name, username
from 
	(
	select u.id as user_id, u.locale, u.time_zone, u.email, u.name, u.username
	from FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.user u 
	);



-- ISSUE FACT
CREATE OR REPLACE TABLE MYDB.JIRA_ANALYTICS.ISSUE_FACT (
ISSUE_ID NUMBER(38,0) NOT NULL,
PROJECT_ID NUMBER(38,0) NOT NULL,
CREATE_USER_KEY NUMBER(38,0) NOT NULL,
RESOLVED_USER_KEY NUMBER(38,0) NOT NULL,
CREATE_DATE_KEY NUMBER(38,0) NOT NULL,
CREATE_TIME_KEY NUMBER(38,0) NOT NULL,
RESOLVED_DATE_KEY NUMBER(38,0) NOT NULL,
RESOLVED_TIME_KEY NUMBER(38,0) NOT NULL,
DUE_DATE_KEY NUMBER(38,0) NOT NULL,
DUE_TIME_KEY NUMBER(38,0) NOT NULL,
RESOLVED_FLAG NUMBER(38,0) NOT NULL,
CLOSED_FLAG NUMBER(38,0) NOT NULL
);


INSERT INTO MYDB.JIRA_ANALYTICS.ISSUE_FACT (
issue_id,
PROJECT_ID,
CREATE_USER_KEY ,
RESOLVED_USER_KEY ,
CREATE_DATE_KEY ,
CREATE_TIME_KEY ,
RESOLVED_DATE_KEY ,
RESOLVED_TIME_KEY ,
DUE_DATE_KEY ,
DUE_TIME_KEY ,
RESOLVED_FLAG ,
CLOSED_FLAG 
)
select i.id as issue_id, 
I.project as project_id, 
u1.user_key as create_user_key, 
coalesce(u2.user_key, -1) as RESOLVED_USER_KEY,
d1.date_key as CREATE_DATE_KEY, 
T1.TIMEOFDAY_KEY AS CREATE_TIME_KEY, 
coalesce(d2.date_key, -1) as RESOLVED_DATE_KEY, 
coalesce(T2.TIMEOFDAY_KEY, -1) AS RESOLVED_TIME_KEY, 
coalesce(d3.date_key, -1) as DUE_DATE_KEY,
coalesce(T3.TIMEOFDAY_KEY, -1) AS DUE_TIME_KEY, 
case when i.resolved is not null then 1 else 0 end as RESOLVED_FLAG,
case when x.state = 'closed' then 1 else 0 end as closed_flag 
from FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.issue i 
left join MYDB.JIRA_ANALYTICS.user_dim u1 
on i.creator = u1.user_id
left join MYDB.JIRA_ANALYTICS.user_dim u2 
on i.assignee = u2.user_id
and i.resolved is not null
left join MYDB.JIRA_ANALYTICS.date_dim d1 
on to_number(to_varchar(to_date(i.created),'YYYYMMDD')) = d1.DATE_KEY
left join MYDB.JIRA_ANALYTICS.timeofday_dim t1 
on  EXTRACT(hour FROM i.created) * 3600 + EXTRACT(minute FROM i.created)*60 + EXTRACT(second FROM i.created)= t1.TIMEOFDAY_KEY
left join MYDB.JIRA_ANALYTICS.date_dim d2 
on (case when i.resolved is null then -1 else to_number(to_varchar(to_date(i.resolved),'YYYYMMDD')) end) = d2.DATE_KEY
left join MYDB.JIRA_ANALYTICS.timeofday_dim t2 
on  (case when i.resolved is null then -1 else EXTRACT(hour FROM i.resolved) * 3600 + EXTRACT(minute FROM i.resolved)*60 + EXTRACT(second FROM i.resolved) end)= t2.TIMEOFDAY_KEY
left join
(
select issue_id, end_date, state 
from 
	(
	select a.id as issue_id, c.end_date, c.state,
	row_number() over(partition by a.id order by c.start_date desc) as rn
	from FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.issue a
	left join FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.issue_board b 
	on a.id = b.issue_id 
	left join FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.sprint c 
	on b.board_id = c.board_id 
	)
where rn = 1
) x 
on i.id = x.issue_id 
left join MYDB.JIRA_ANALYTICS.date_dim d3 
on (case when coalesce(i.due_date, x.end_date) is null then -1 else to_number(to_varchar(to_date(coalesce(i.due_date, x.end_date)),'YYYYMMDD')) end) = d3.DATE_KEY
left join MYDB.JIRA_ANALYTICS.timeofday_dim t3 
on  (case when coalesce(i.due_date, x.end_date) is null then -1 else EXTRACT(hour FROM coalesce(i.due_date, x.end_date)) * 3600 + EXTRACT(minute FROM coalesce(i.due_date, x.end_date))*60 + EXTRACT(second FROM coalesce(i.due_date, x.end_date)) end)= t3.TIMEOFDAY_KEY;



-- PROJECT FACT

DROP TABLE IF EXISTS MYDB.JIRA_ANALYTICS.PROJECT_FACT;


CREATE OR REPLACE TABLE MYDB.JIRA_ANALYTICS.PROJECT_FACT (
	PROJECT_ID NUMBER(38,0) NOT NULL,
	PROJECT_NAME_ABB VARCHAR(50) NOT NULL DEFAULT 'NA',
	PROJECT_NAME VARCHAR(50) NOT NULL DEFAULT 'NA',
	LEAD_ID VARCHAR(50) NOT NULL DEFAULT 'NA',
	num_issues NUMBER(38,0) NOT NULL,
	to_do_issues NUMBER(38,0) NOT NULL,
	resolved_issues NUMBER(38,0) NOT NULL,
	closed_issues NUMBER(38,0) NOT NULL,
	in_progress_issues NUMBER(38,0) NOT NULL,
	lowest_priority_issues NUMBER(38,0) NOT NULL,
	low_priority_issues NUMBER(38,0) NOT NULL,
	medium_priority_issues NUMBER(38,0) NOT NULL,
	high_priority_issues NUMBER(38,0) NOT NULL,
	highest_priority_issues NUMBER(38,0) NOT NULL,
	resolved_before_due_date_issues NUMBER(38,0) NOT NULL,
	perc_to_do_issues NUMBER(10,2) NOT NULL,
	perc_resolved_issues NUMBER(10,2) NOT NULL,
	perc_in_progress_issues NUMBER(10,2) NOT NULL,
	perc_closed_issues NUMBER(10,2) NOT NULL,
	perc_lowest_priority_issues NUMBER(10,2) NOT NULL,
	perc_low_priority_issues NUMBER(10,2) NOT NULL,
	perc_medium_priority_issues NUMBER(10,2) NOT NULL,
	perc_high_priority_issues NUMBER(10,2) NOT NULL,
	perc_highest_priority_issues NUMBER(10,2) NOT NULL,
	perc_lowest_priority_issues_done NUMBER(10,2) NOT NULL,
	perc_low_priority_issues_done NUMBER(10,2) NOT NULL,
	perc_medium_priority_issues_done NUMBER(10,2) NOT NULL,
	perc_high_priority_issues_done NUMBER(10,2) NOT NULL,
	perc_highest_priority_issues_done NUMBER(10,2) NOT NULL,
	perc_resolved_before_due_date_issues NUMBER(10,2) NOT NULL
);


insert into MYDB.JIRA_ANALYTICS.PROJECT_FACT
SELECT PROJECT_ID, PROJECT_NAME_ABB, PROJECT_NAME, LEAD_ID, 
num_issues, to_do_issues, resolved_issues, closed_issues, in_progress_issues, 
lowest_priority_issues, low_priority_issues, medium_priority_issues, high_priority_issues, highest_priority_issues, 
resolved_before_due_date_issues, perc_to_do_issues, perc_resolved_issues, perc_in_progress_issues, 
perc_closed_issues, perc_lowest_priority_issues, perc_low_priority_issues, perc_medium_priority_issues, 
perc_high_priority_issues, perc_highest_priority_issues, perc_lowest_priority_issues_done, 
perc_low_priority_issues_done,  perc_medium_priority_issues_done, perc_high_priority_issues_done, 
perc_highest_priority_issues_done, perc_resolved_before_due_date_issues
from 
	(
	select p.id as project_id, p.key as project_name_abb, p.name as project_name, p.lead_id as lead_id,
	coalesce(h.num_issues, 0) as num_issues,
	coalesce(h.to_do_issues, 0) as to_do_issues,
	coalesce(h.done_issues, 0) as resolved_issues,
	coalesce(h.closed_issues, 0) as closed_issues,
	coalesce(h.in_progress_issues, 0) as in_progress_issues,
	coalesce(h.lowest_priority_issues, 0) as lowest_priority_issues,
	coalesce(h.low_priority_issues, 0) as low_priority_issues,
	coalesce(h.medium_priority_issues, 0) as medium_priority_issues,
	coalesce(h.high_priority_issues, 0) as high_priority_issues,
	coalesce(h.highest_priority_issues, 0) as highest_priority_issues,
	coalesce(h.resolved_before_due_date_issues, 0) as resolved_before_due_date_issues,
	coalesce(h.perc_to_do_issues, 0) as perc_to_do_issues,
	coalesce(h.perc_done_issues, 0) as perc_resolved_issues,
	coalesce(h.perc_in_progress_issues, 0) as perc_in_progress_issues,
	coalesce(h.perc_closed_issues, 0) as perc_closed_issues,
	coalesce(h.perc_lowest_priority_issues, 0) as perc_lowest_priority_issues,
	coalesce(h.perc_low_priority_issues, 0) as perc_low_priority_issues,
	coalesce(h.perc_medium_priority_issues, 0) as perc_medium_priority_issues,
	coalesce(h.perc_high_priority_issues, 0) as perc_high_priority_issues,
	coalesce(h.perc_highest_priority_issues, 0) as perc_highest_priority_issues,
	coalesce(h.perc_lowest_priority_issues_done, 0) as perc_lowest_priority_issues_done,
	coalesce(h.perc_low_priority_issues_done, 0) as perc_low_priority_issues_done,
	coalesce(h.perc_medium_priority_issues_done, 0) as perc_medium_priority_issues_done,
	coalesce(h.perc_high_priority_issues_done, 0) as perc_high_priority_issues_done,
	coalesce(h.perc_highest_priority_issues_done, 0) as perc_highest_priority_issues_done,
	coalesce(h.perc_resolved_before_due_date_issues, 0) as perc_resolved_before_due_date_issues
	from 
		FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.project p
		left join 
		(
		select *, 
		case when num_issues = 0 then 0 else to_do_issues/num_issues * 100 end as perc_to_do_issues,
		case when num_issues = 0 then 0 else done_issues/num_issues * 100 end as perc_done_issues,
		case when num_issues = 0 then 0 else in_progress_issues/num_issues * 100 end as perc_in_progress_issues,
		case when num_issues = 0 then 0 else lowest_priority_issues/num_issues * 100 end as perc_lowest_priority_issues,
		case when num_issues = 0 then 0 else low_priority_issues/num_issues * 100 end as perc_low_priority_issues,
		case when num_issues = 0 then 0 else medium_priority_issues/num_issues * 100 end as perc_medium_priority_issues,
		case when num_issues = 0 then 0 else high_priority_issues/num_issues * 100 end as perc_high_priority_issues,
		case when num_issues = 0 then 0 else highest_priority_issues/num_issues * 100 end as perc_highest_priority_issues,
		case when lowest_priority_issues = 0 then 0 else lowest_priority_issues_done/lowest_priority_issues * 100 end as perc_lowest_priority_issues_done,
		case when low_priority_issues = 0 then 0 else low_priority_issues_done/low_priority_issues * 100 end as perc_low_priority_issues_done,
		case when medium_priority_issues = 0 then 0 else medium_priority_issues_done/medium_priority_issues * 100 end as perc_medium_priority_issues_done,
		case when high_priority_issues = 0 then 0 else high_priority_issues_done/high_priority_issues * 100 end as perc_high_priority_issues_done,
		case when highest_priority_issues = 0 then 0 else highest_priority_issues_done/highest_priority_issues * 100 end as perc_highest_priority_issues_done,
		case when num_issues = 0 then 0 else resolved_before_due_date_issues/num_issues * 100 end as perc_resolved_before_due_date_issues,
		case when num_issues = 0 then 0 else closed_issues/num_issues * 100 end as perc_closed_issues
		from 
			(
			select project_id, 
			count(*) as num_issues, 
			sum(to_do) as to_do_issues,
			sum(done) as done_issues,
			sum(in_progress) as in_progress_issues,
			sum(lowest) as lowest_priority_issues,
			sum(low) as low_priority_issues,
			sum(medium) as medium_priority_issues,
			sum(high) as high_priority_issues,
			sum(highest) as highest_priority_issues,
			sum(case when done = 1 and lowest = 1 then 1 else 0 end) as lowest_priority_issues_done,
			sum(case when done = 1 and low = 1 then 1 else 0 end) as low_priority_issues_done,
			sum(case when done = 1 and medium = 1 then 1 else 0 end) as medium_priority_issues_done,
			sum(case when done = 1 and high = 1 then 1 else 0 end) as high_priority_issues_done,
			sum(case when done = 1 and highest = 1 then 1 else 0 end) as highest_priority_issues_done,
			sum(resolved_before_due_date) as resolved_before_due_date_issues,
			sum(closed) as closed_issues
			from 
				(
				select *,
				case when status_category = 'To Do' then 1 else 0 end as to_do,
				case when status_category = 'Done' and status_name = 'Done' then 1 else 0 end as done,
				case when status_category = 'In Progress' then 1 else 0 end as in_progress,
				case when priority_name = 'Lowest' then 1 else 0 end as lowest,
				case when priority_name = 'Low' then 1 else 0 end as low,
				case when priority_name = 'Medium' then 1 else 0 end as medium,
				case when priority_name = 'High' then 1 else 0 end as high,
				case when priority_name = 'Highest' then 1 else 0 end as highest,
				case when resolved <= due_date then 1 else 0 end as resolved_before_due_date,
				case when state = 'closed' then 1 else 0 end as closed
				from 
					(
					select issue_id, coalesce(due_date, due_date_sprint) as due_date, resolved, status_name,
					status_category, priority_name, state, project_id
					from 
						(
						select a.id as issue_id, a.due_date, a.resolved,
						b.name as status_name, 
						c.name as status_category,
						d.name as priority_name,
						f.state as state,
						f.end_date as due_date_sprint,
						g.id as project_id,
						row_number() over(partition by a.id order by f.start_date desc) as rn 
						from FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.issue a 
						left join FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.status b 
						on a.status = b.id
						left join FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.status_category c 
						on b.status_category_id = c.id
						left join FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.priority d
						on a.priority = d.id
						left join FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.issue_board e 
						on a.id = e.issue_id 
						left join FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.sprint f
						on e.board_id = f.board_id 
						left join FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.project g
						on a.project = g.id
						)
					where rn = 1
					)
				)
			group by project_id
			)
		) h
		on p.id = h.project_id
	);


-- COMMENT FACT
CREATE OR REPLACE TABLE MYDB.JIRA_ANALYTICS.COMMENT_FACT (
COMMENT_ID NUMBER(38,0) NOT NULL,
ISSUE_ID NUMBER(38,0) NOT NULL,
AUTHOR_USER_KEY NUMBER(38,0) NOT NULL,
COMMENT_DATE_KEY NUMBER(38,0) NOT NULL,
COMMENT_TIME_KEY NUMBER(38,0) NOT NULL
);


INSERT INTO MYDB.JIRA_ANALYTICS.COMMENT_FACT 
select distinct
c.ID,
i.ID,
u.USER_KEY ,
d.DATE_KEY as COMMENT_DATE_KEY,
t.TIMEOFDAY_KEY as COMMENT_TIME_KEY
FROM FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.issue i
INNER JOIN FWLOYYD_PZA82601_DATASLEEK_DW_UCLA2024.DWH_UCLA2024_JIRA.comment c 
on i.id = c.issue_id
inner join MYDB.JIRA_ANALYTICS.user_dim u
on c.author_id = u.user_id
inner join MYDB.JIRA_ANALYTICS.date_dim d 
on to_number(to_varchar(to_date(c.created),'YYYYMMDD')) = d.DATE_KEY
inner join MYDB.JIRA_ANALYTICS.timeofday_dim t
on  EXTRACT(hour FROM c.created) * 3600 + EXTRACT(minute FROM c.created)*60 + EXTRACT(second FROM c.created)= t.TIMEOFDAY_KEY;
