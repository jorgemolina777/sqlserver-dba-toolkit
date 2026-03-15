/* =============================================================*/
/* Find number of days in month for a selected date	*/
/* By Mariana Maas 						*/
/*--------------------------------------------------------------*/
/* Method:				*/
/* - Create the date with the first day of the selected date 	*/
/* - Add a month using the DATEADD function		*/
/* => now you have the first day of the next month	*/
/* - Subtract 1 day using the DATEADD function		*/
/* => now you have the last day of the current month	*/
/* - select the day and wallah!			*/
/*==============================================================*/
-->> The following code has been broken down into steps with print statements in between, so the logic behind it can be shown, it can all go into one statement (see bottom)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @mydate  DATETIME,
        @workStr DATETIME

SET @mydate = '2008-11-24'
--> find first day of month
SET @workStr = Cast(Cast(Year(@mydate) AS VARCHAR(04))
                    + RIGHT( ('0' + Cast(Month(@mydate) AS VARCHAR(02))), 2 )
                    + '01' AS DATETIME)

PRINT @workStr

--> Add a month to find first day of following month, then subtract a day to get last day of current month, extract the day
SELECT Day(Dateadd (DAY, -1, Dateadd(MONTH, 1, @workStr)))

-->> Code in one statement:
---------------------------
SELECT Day(Dateadd--<< 4. Extract the last day
           (DAY, -1, --<< 3. Find last day of current month
           Dateadd(MONTH, 1, --<< 2. Find first day of next month
           Cast(Cast( --<< 1. Find first day of the current month
                Year(CURRENT_TIMESTAMP) AS VARCHAR(04))
                + RIGHT( ('0' + Cast(Month(CURRENT_TIMESTAMP) AS VARCHAR(02))), 2 )
                + '01' AS DATETIME)))) 
print current_timestamp