WITH CTE AS
(
    SELECT #Appt1.*, RowNum = ROW_NUMBER() OVER (PARTITION BY PatientID ORDER BY ApptDate, ApptID) FROM #Appt1
)

SELECT  OP.ApptID1 'AppID', OP.PatientID1 'PatientID', OP.ApptDate1 'ApptDate',OP.Expected_Category FROM 
(
	SELECT A.ApptID 'ApptID1', A.PatientID 'PatientID1', A.ApptDate 'ApptDate1',A.RowNum 'RowNum1',B.ApptID 'ApptID2', B.PatientID 'PatientID2', B.ApptDate 'ApptDate2',B.RowNum 'RowNum2'
	,diff = DATEDIFF(DAY, B.ApptDate, A.ApptDate)
	,Expected_Category = CASE WHEN (DATEDIFF(MONTH, B.ApptDate, A.ApptDate) > 0) THEN 'New' 
	WHEN (DATEDIFF(DAY, B.ApptDate, A.ApptDate) <= 30) then 'Followup' 
	ELSE 'New' END
	FROM CTE A
	LEFT OUTER JOIN CTE B on A.PatientID = B.PatientID 
	AND A.rownum = B.rownum + 1
) AS OP ORDER BY PatientID, ApptDate
