WITH CTE AS
(
    SELECT Appt1.*, RowNum = ROW_NUMBER() OVER (PARTITION BY PatientID ORDER BY ApptDate, ApptID) FROM Appt1
)

SELECT A.ApptID , A.PatientID , A.ApptDate ,
Expected_Category = CASE WHEN (DATEDIFF(MONTH, B.ApptDate, A.ApptDate) > 0) THEN 'New' 
WHEN (DATEDIFF(DAY, B.ApptDate, A.ApptDate) <= 30) then 'Followup' 
ELSE 'New' END
FROM CTE A
LEFT OUTER JOIN CTE B on A.PatientID = B.PatientID 
AND A.rownum = B.rownum + 1
ORDER BY A.PatientID, A.ApptDate
