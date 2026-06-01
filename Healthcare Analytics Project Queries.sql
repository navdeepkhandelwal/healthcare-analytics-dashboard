use healthcare_db;
#1.Data Count Validation
SELECT COUNT(*) FROM Patient;
SELECT COUNT(*) FROM Visit;
SELECT COUNT(*) FROM Treatment;
SELECT COUNT(*) FROM Labtest;

# 2.Data Completeness Check
SELECT * FROM Patient WHERE FirstName IS NULL OR LastName IS NULL;
SELECT * FROM Visit WHERE VisitType IS NULL OR VisitDate IS NULL;
SELECT * FROM Treatment WHERE TreatmentName IS NULL OR Status IS NULL;
SELECT * FROM Labtest WHERE TestName IS NULL OR testResult IS NULL;

#3.Data Consistency Check
SELECT v.VisitID, v.PatientID, p.PatientID FROM Visit v
LEFT JOIN Patient p ON v.PatientID = p.PatientID WHERE p.PatientID IS NULL;  -- Should return 0 rows

SELECT t.TreatmentID, t.VisitID, v.VisitID FROM Treatment t
LEFT JOIN Visit v ON t.VisitID = v.VisitID WHERE v.VisitID IS NULL;  -- Should return 0 rows

#4.Duplicate Records Check
SELECT PatientID, COUNT(*) FROM Patient GROUP BY PatientID HAVING COUNT(*) > 1;

SELECT VisitID, COUNT(*) FROM Visit GROUP BY VisitID HAVING COUNT(*) > 1;

#5.Dashboard Aggregation Check
SELECT SUM(TotalEpisodeCost) FROM Treatment;  -- Compare with Power BI total cost
SELECT AVG(Age) FROM Patient;  -- Compare with Power BI average age

#6.Performance Testing (Query Execution Time)
SELECT * FROM Visit WHERE STR_TO_DATE(VisitDate, '%d-%m-%Y') BETWEEN '2023-01-01' AND '2023-12-31';

#7.Total Patients
SELECT COUNT(PatientID) AS TotalPatients FROM Patient;

#8.Total Doctors
SELECT COUNT(DoctorID) AS TotalDoctors FROM Doctor;

#9.Total Visits
SELECT COUNT(VisitID) AS TotalVisits FROM Visit;

#10.Average Age of Patients
SELECT AVG(Age) AS AverageAge FROM Patient;

#11.Top 5 Diagnosed Conditions
SELECT Diagnosis, COUNT(*) AS TotalCases FROM Visit GROUP BY Diagnosis ORDER BY TotalCases DESC LIMIT 5;

#12.Follow-Up Rate
SELECT round(COUNT(*) / (SELECT COUNT(*) FROM Visit)*100,2) AS FollowUpRate FROM Visit WHERE FollowUpRequired = 'Yes';

#13.Average Treatment Cost Per Visit
SELECT AVG(TotalEpisodeCost) AS AvgTreatmentCost FROM Treatment;

#14.Total Lab Tests Conducted
SELECT COUNT(LabResultID) AS TotalLabTests FROM Labtest;

#15.Percentage of Abnormal Lab Results
SELECT round((count(*) / (SELECT COUNT(*) FROM Labtest)*100),2) AS AbnormalResultPercentage FROM Labtest WHERE TestResult = 'Abnormal';

#16.Doctor Workload
SELECT round(COUNT(VisitID) / COUNT(DISTINCT DoctorID),0) AS AvgPatientsPerDoctor FROM Visit;

#17.Complete Patient Visit Report
# Purpose: Generates complete patient treatment and lab history
SELECT concat(p.FirstName," ", p.LastName)Full_Name, v.VisitDate, v.ReasonForVisit, t.TreatmentName, l.TestName, l.TestResult
FROM Patient p JOIN Visit v ON p.PatientID = v.PatientID LEFT JOIN Treatment t ON v.VisitID = t.VisitID
LEFT JOIN Labtest l ON v.VisitID = l.VisitID;