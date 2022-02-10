---INSPECTING THE DATA FOR ANY POTENTIAL RESTRICTED/CONFIDENTIAL ATTRIBUTES
SELECT TOP 100 * 
FROM UNIVERSITY_FULL


---DEVELOPING A DATA SET TO BE USED FOR ANALYSIS
SELECT 
IL.[ID number]
,IL.[State abbreviation]
,IL.[Longitude location of institution]
,IL.[Latitude location of institution]
, E.[APPLICANTS TOTAL]
, E.[ADMISSIONS TOTAL]
, E.[ENROLLED TOTAL]
, E.[Estimated freshman enrollment, full time]
, E.[Associate's degrees awarded]
, E.[Bachelor's degrees awarded]
, E.[Master's degrees awarded]
, G.[Graduation rate - Bachelor degree within 5 years, total]
, G.[Graduation rate - Bachelor degree within 6 years, total]
INTO #TMP_DATA
FROM [dbo].[Enrollment] E 
INNER JOIN [dbo].[InstitutionLocation] IL
ON E.[ID number]= IL.[ID number]
INNER JOIN [dbo].[Graduation] G
ON G.[ID number]= E.[ID number]
WHERE [Applicants total] IS NOT NULL

---FINAL DATA SET TO EXPORT INTO SAS
SELECT APPLICANT_TOT, ADMISSION_TOT, ENROLLED_TOT, FRESHMAN_ENROLL, ASSOCIATE_DEGREE
, BACHELOR_DEGREE, MASTERS_DEGREE, BACHELOR_5YR, BACHELOR_6YR
, (APPLICANT_TOT-ADMISSION_TOT) AS DIFF_OF_APP_ADMISS
, STATE_VAL

FROM ( ---INLINE VIEW CALCULATIONS

SELECT DISTINCT [State abbreviation] AS STATE_VAL
, SUM([APPLICANTS TOTAL]) AS APPLICANT_TOT
, SUM([ADMISSIONS TOTAL]) AS ADMISSION_TOT
, SUM([ENROLLED TOTAL]) AS ENROLLED_TOT
, SUM([Estimated freshman enrollment, full time]) AS FRESHMAN_ENROLL
, SUM([Associate's degrees awarded]) AS ASSOCIATE_DEGREE
, SUM([Bachelor's degrees awarded]) AS BACHELOR_DEGREE
, SUM([Master's degrees awarded]) AS MASTERS_DEGREE
, SUM([Graduation rate - Bachelor degree within 5 years, total]) AS BACHELOR_5YR
, SUM([Graduation rate - Bachelor degree within 6 years, total]) AS BACHELOR_6YR
FROM #TMP_DATA
GROUP BY [State abbreviation]) TAB1



--CREATING AGGREGATIONS TO ANALYZE IN SAS
SELECT 
APPLICANT_TOT
, ADMISSION_TOT
, ADMISSION_TOT/(ADMISSION_TOT+APPLICANT_TOT)*100 as ADM_PER
, ADMISSION_TOT/(ADMISSION_TOT+APPLICANT_TOT) as ADM_DEC
, ENROLLED_TOT
, ENROLLED_TOT/(ADMISSION_TOT+ENROLLED_TOT)*100 as ENR_PER
, ENROLLED_TOT/(ADMISSION_TOT+ENROLLED_TOT) as ENR_DEC
, BACHELOR_DEGREE
, (APPLICANT_TOT-ADMISSION_TOT) AS DIFF_OF_APP_ADMISS
, STATE_VAL

FROM ( ---INLINE VIEW CALCULATIONS

SELECT DISTINCT [State abbreviation] AS STATE_VAL
, SUM([APPLICANTS TOTAL]) AS APPLICANT_TOT
, SUM([ADMISSIONS TOTAL]) AS ADMISSION_TOT
, SUM([ENROLLED TOTAL]) AS ENROLLED_TOT
, SUM([Estimated freshman enrollment, full time]) AS FRESHMAN_ENROLL
, SUM([Associate's degrees awarded]) AS ASSOCIATE_DEGREE
, SUM([Bachelor's degrees awarded]) AS BACHELOR_DEGREE
, SUM([Master's degrees awarded]) AS MASTERS_DEGREE
, SUM([Graduation rate - Bachelor degree within 5 years, total]) AS BACHELOR_5YR
, SUM([Graduation rate - Bachelor degree within 6 years, total]) AS BACHELOR_6YR
FROM #TMP_DATA
GROUP BY [State abbreviation]) TAB1