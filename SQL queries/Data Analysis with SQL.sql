USE Phone_data

--CHECK THE DATA
SELECT * FROM Mobile_phone_dataset

--COUNT OF SELLS OF EACH COMPANY
SELECT COUNT(COMPANY_NAME) AS TOTAL_SALES,Company_name, DENSE_RANK() OVER(ORDER BY COUNT(COMPANY_NAME) DESC) RANKING
FROM Mobile_phone_dataset
GROUP BY Company_name
ORDER BY TOTAL_SALES DESC
	--SAMSUNG AND REALME appearse on top with 240units, and vivo is on second position


--TOP 10 MOST EXPENSIVE PHONES LIST
SELECT TOP 10 PRICE_IN_INR, [Phone Name]
FROM Mobile_phone_dataset
ORDER BY PRICE_IN_INR DESC
	--ALL THE PHONES ARE APPLE IPHONE 14 PRO

-- WHAT IS THE AVERAGE PRICE OF PHONES OF EACH COMPANY
SELECT AVG(PRICE_IN_INR) AS AVERAGE_PRICE ,Company_name
FROM Mobile_phone_dataset
GROUP BY Company_name
ORDER BY AVERAGE_PRICE DESC
	--APPLE'S PRODUCTS ARE EXPENSIVE THEN OTHERS FOLLOWED BY GOOGLE

--WHICH PHONE HAS MORE RATING
SELECT TOP 50 [Rating ?/5], [Phone Name],Company_name
FROM Mobile_phone_dataset
ORDER BY [Rating ?/5] DESC
	-- 10A MOTOROLA IS LEADING WITH 4.8 RATING BUT APPLE IS PERFORMING AWESOME THEN OTHERS

-- WHICH PHONE GOT MORE BUYERS NUMBER OF RATINGS
SELECT TOP 50 [Number of Ratings],[Phone Name],Company_name
FROM Mobile_phone_dataset
ORDER BY [Number of Ratings] DESC
	-- IN THIS COMPARISON REALME 8 HAS 96600 RATINGS AND MOSTLY PRODUCTS ARE FROM REALME TOO.

--PRICE BY RAM_SIZE
SELECT RAM_Size , AVG(PRICE_IN_INR) AS AVERAGE_PRICE
FROM Mobile_phone_dataset
WHERE RAM_Size > 0 AND RAM_Size <16
GROUP BY RAM_Size
ORDER BY RAM_Size ASC
	--SO AS THE RAM SIZE GOES UP THE PRICES ARE ALSO GO UP

--PRICE BY STORAGE_SIZE
SELECT STORAGE_SIZE, AVG(PRICE_IN_INR) AS AVERAGE_PRICE
FROM Mobile_phone_dataset
WHERE STORAGE_SIZE>1
GROUP BY STORAGE_SIZE
ORDER BY STORAGE_SIZE DESC
	--SO SAME AS RAM SIZE THE PRICE GOES UP WITH SIZE


-- MAKE A STORED PROCEDURE TO GET THE DATA OF RELATED COMPANIES
CREATE PROCEDURE COMPANIES_DATA @COMPANY_NAME VARCHAR (20)
AS 
SELECT *
FROM Mobile_phone_dataset
WHERE Company_name = @COMPANY_NAME
GO

EXEC COMPANIES_DATA @COMPANY_NAME = 'GOOGLE'
	--AND WE WILL GET THE ONLY GOOGLE COMPANY DATA

-- CREATE THE VIEW WHERE THE PHONE PRICE IS LESS THEN 20,000 INR
CREATE VIEW CHEAP_PHONES
AS 
SELECT *
FROM Mobile_phone_dataset
WHERE PRICE_IN_INR< 20000

SELECT * FROM CHEAP_PHONES


-- MAKE THE TEMP TABLE TO STORE ONLY THE PHONE NAME, PROCESSOR, RAM SIZE , MEMORY AND PRICE FOR ONLY "QUALQUAM PROCESSOER" FOR GAMERS
CREATE TABLE #GAMERS_SPECS(
PHONE_NAME VARCHAR(255) NOT NULL,
PROCESSOR VARCHAR (255) NOT NULL,
RAM_SIZE INT DEFAULT 2,
STORAGE_SIZE INT,
PRICE BIGINT
)
DROP TABLE #GAMERS_SPECS

--INSERT VALUES
SELECT [Phone Name],Processor,RAM_Size,STORAGE_SIZE,PRICE_IN_INR 
INTO #GAMERS_SPECS
FROM Mobile_phone_dataset 
WHERE Processor LIKE '%QUALCOMM%'

SELECT * FROM #GAMERS_SPECS

-- NOW WE NEED THE DATA THAT HAS NO QUALCOMM PROCESSOR
-- WE WILL USE LEFT JOIN WITH BOTH #GAMERS_SPECS AND MOBILE_PHONE_DATASET
-- AND GET ALL THE DATA

SELECT OLD.[Phone Name], OLD.Processor, OLD.RAM_Size, OLD.STORAGE_SIZE, OLD.PRICE_IN_INR, NEW.Battery, NEW.[Front Camera]
FROM  #GAMERS_SPECS AS OLD
LEFT JOIN Mobile_phone_dataset AS NEW
ON OLD.PROCESSOR = NEW.PROCESSOR