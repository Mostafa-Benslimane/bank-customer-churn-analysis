/*
Project: Bank Customer Churn Analysis

Goal:
Identify the key factors contributing to customer churn and extract
actionable insights to support business decision-making.

Process:
In this analysis, I cleaned the dataset in Excel then applied a total of 25 SQL queries divided into three stages:

1. Data Overview :
   - Consists of 6 queries.
   - These queries were used to explore the dataset structure,
     understand the available variables, and perform initial data inspection.

2. Churn Rate Analysis :
   - Consists of 12 queries.
   - This stage evaluates churn rates across different variables
     to identify which factors are strongly associated with customer churn
     and which variables show little impact.

3. Cross Variable Analysis :
   - Consists of 7 queries.
   - In this stage, the four most influential variables identified earlier
     were combined to analyze interaction effects and identify
     the highest-risk customer segments.
*/

-------------------------------------------------------
----- Data Overview -----
-------------------------------------------------------
-- 1\ Dataset
SELECT * FROM churn_dataset;

-- 2\ Total Number of Members
SELECT COUNT(CustomerId) AS Total_Customers FROM churn_dataset;

-- 3\ Total Number Of Members Per Country 
SELECT Geography, COUNT(*) AS Num_Members FROM churn_dataset GROUP BY Geography;

-- 4\ Total Number Of Members Per Gender 
SELECT Gender, COUNT(*) AS Num_Members FROM churn_dataset GROUP BY Gender;

-- 5\ Total Number Of Members Per Age 
SELECT Age, COUNT(*) AS Num_Members FROM churn_dataset group by Age ORDER by Age desc;

-- 6\ Total Number Of Members Per Age Group  
SELECT 
CASE 	
	WHEN Age BETWEEN 18 AND 25 THEN "Young_Adults"
	WHEN Age BETWEEN 26 AND 35 THEN "New_Career"
	WHEN Age BETWEEN 36 AND 45 THEN "Mid_Career"
	WHEN Age BETWEEN 46 AND 55 THEN "Senior" 
    Else "Retired"
END AS Age_Group, COUNT(*) AS Num_Members
FROM churn_dataset
GROUP BY Age_Group
ORDER BY MIN(Age);

-------------------------------------------------------
----- Churn Rate Analysis -----
-------------------------------------------------------
-- 7\ Total Number of Members Still With The Bank 
SELECT COUNT(CustomerId) AS Num_StillWithBank FROM churn_dataset WHERE Exited = 0;

-- 8\ Total Number of Members Who Left The Bank 
SELECT COUNT(CustomerId) AS Num_LeftTheBank FROM churn_dataset WHERE Exited = 1;

-- 9\ Overall Churn Rate (%)  
SELECT ROUND(SUM(Exited) *100 / COUNT(*), 2) AS Churn_Rate 
FROM churn_dataset; 

-- 10\ Churn Per Geography
SELECT Geography,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate_Per_Geography
FROM churn_dataset 
GROUP BY Geography; 

-- 11\ Churn Per Gender
SELECT Gender,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate_Per_Gender
FROM churn_dataset 
GROUP BY Gender; 

-- 12\ Churn Per Age Group
SELECT CASE 	
	WHEN Age BETWEEN 18 AND 25 THEN "Young_Adults"
	WHEN Age BETWEEN 26 AND 35 THEN "New_Career"
	WHEN Age BETWEEN 36 AND 45 THEN "Mid_Career"
	WHEN Age BETWEEN 46 AND 55 THEN "Senior" 
    Else "Retired"
END AS Age_Group,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate_Per_Age_Group
FROM churn_dataset 
GROUP BY Age_Group
ORDER BY MIN(Age);

-- 13\ Churn Per Tenure
SELECT 
CASE 	
	WHEN Tenure BETWEEN 0 AND 2 THEN "New_Members"
	WHEN Tenure BETWEEN 3 AND 5 THEN "Old_Members"
    Else "Loyal_Members"
END AS Tenure_Group,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate_Per_Tenure
FROM churn_dataset 
GROUP BY Tenure_Group
ORDER BY MIN(Tenure);

-- 14\ Churn Per Products
SELECT
CASE
	WHEN NumOfProducts IN(1,2) THEN 'Low_Product_Usage'
    WHEN NumOfProducts IN(3,4) THEN 'High_Product_Usage'
END AS Product_Usage,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate_Per_NumOfProducts
FROM churn_dataset 
GROUP BY Product_Usage
ORDER BY Product_Usage;

-- 15\ Churn Per Balance
SELECT 
CASE 	
	WHEN Balance < 50000 THEN "Low_Balance"
    WHEN Balance < 100000 THEN "Medium_Balance"
	WHEN Balance < 150000 THEN "High_Balance"
    Else "Top_Balance"
END AS Balance_Group,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate_Per_Balance
FROM churn_dataset 
GROUP BY Balance_Group
ORDER BY 
CASE Balance_Group
    WHEN 'Low_Balance' THEN 1
    WHEN 'Medium_Balance' THEN 2
    WHEN 'High_Balance' THEN 3
    WHEN 'Top_Balance' THEN 4
END;

-- 16\ Churn Per CreditCard Usage
SELECT 
CASE 
 WHEN HasCrCard = 1 THEN "YES" ELSE 'NO'
END AS HasCrCard,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate_Per_CreditCard
FROM churn_dataset 
GROUP BY HasCrCard;

-- 17\ Churn Per Credit Score
SELECT 
CASE 	
	WHEN CreditScore < 580 THEN "Poor_Score"
	WHEN CreditScore < 680 THEN "Average_Score"
    WHEN CreditScore < 780 THEN "Good_Score"
    Else "Excellent_Score"
END AS CreditScore_Group,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate_Per_CreditScore
FROM churn_dataset 
GROUP BY CreditScore_Group
ORDER BY MIN(CreditScore);

-- 18\ Churn Per Active Members
SELECT 
CASE 
 WHEN IsActiveMember = 1 THEN "YES" ELSE 'NO'
END AS Active_Member,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate_Per_Active_Member
FROM churn_dataset 
GROUP BY IsActiveMember;

-------------------------------------------------------
----- Churn Rate With Cross Analysis  -----
-------------------------------------------------------
-- 19\ Churn Per Age Group × NumOfProducts
SELECT 
CASE 	
	WHEN Age BETWEEN 18 AND 25 THEN "Young_Adults"
	WHEN Age BETWEEN 26 AND 35 THEN "New_Career"
	WHEN Age BETWEEN 36 AND 45 THEN "Mid_Career"
	WHEN Age BETWEEN 46 AND 55 THEN "Senior" 
    Else "Retired"
END AS Age_Group,
CASE
	WHEN NumOfProducts IN(1,2) THEN 'Low_Product_Usage'
    WHEN NumOfProducts IN(3,4) THEN 'High_Product_Usage'
END AS Product_Usage,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate
FROM churn_dataset 
GROUP BY Age_Group,Product_Usage
ORDER BY Churn_Rate DESC;

-- 20\ Churn Per Age Group × IsActiveMember
SELECT
CASE 	
	WHEN Age BETWEEN 18 AND 25 THEN "Young_Adults"
	WHEN Age BETWEEN 26 AND 35 THEN "New_Career"
	WHEN Age BETWEEN 36 AND 45 THEN "Mid_Career"
	WHEN Age BETWEEN 46 AND 55 THEN "Senior" 
    Else "Retired"
END AS Age_Group,
CASE 
 WHEN IsActiveMember = 1 THEN "YES" ELSE 'NO'
END AS Active_Member,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate
FROM churn_dataset 
GROUP BY Age_Group,Active_Member
ORDER BY Churn_Rate DESC;

-- 21\ Churn Per Age Group × Geography
SELECT
CASE 	
	WHEN Age BETWEEN 18 AND 25 THEN "Young_Adults"
	WHEN Age BETWEEN 26 AND 35 THEN "New_Career"
	WHEN Age BETWEEN 36 AND 45 THEN "Mid_Career"
	WHEN Age BETWEEN 46 AND 55 THEN "Senior" 
    Else "Retired"
END AS Age_Group,
Geography,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate
FROM churn_dataset 
GROUP BY Age_Group,Geography
ORDER BY Churn_Rate DESC;

-- 22\ Churn Per NumOfProducts × Geography
SELECT
CASE
	WHEN NumOfProducts IN(1,2) THEN 'Low_Product_Usage'
    WHEN NumOfProducts IN(3,4) THEN 'High_Product_Usage'
END AS Product_Usage,
Geography,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate
FROM churn_dataset 
GROUP BY Product_Usage,Geography
ORDER BY Churn_Rate DESC;

-- 23\ Churn Per NumOfProducts × IsActiveMember
SELECT
CASE
	WHEN NumOfProducts IN(1,2) THEN 'Low_Product_Usage'
    WHEN NumOfProducts IN(3,4) THEN 'High_Product_Usage'
END AS Product_Usage,
CASE 
 WHEN IsActiveMember = 1 THEN "YES" ELSE 'NO'
END AS Active_Member,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate
FROM churn_dataset 
GROUP BY Product_Usage,Active_Member
ORDER BY Churn_Rate DESC;

-- 24\ Churn Per Geography × IsActiveMember
SELECT
Geography,
CASE 
 WHEN IsActiveMember = 1 THEN "YES" ELSE 'NO'
END AS Active_Member,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate
FROM churn_dataset 
GROUP BY Geography,Active_Member
ORDER BY Churn_Rate DESC;

-- 25\ Churn Per Geography × IsActiveMember x Age Group
SELECT
Geography,
CASE 	
	WHEN Age BETWEEN 18 AND 25 THEN "Young_Adults"
	WHEN Age BETWEEN 26 AND 35 THEN "New_Career"
	WHEN Age BETWEEN 36 AND 45 THEN "Mid_Career"
	WHEN Age BETWEEN 46 AND 55 THEN "Senior" 
    Else "Retired"
END AS Age_Group,
CASE 
 WHEN IsActiveMember = 1 THEN "YES" ELSE 'NO'
END AS Active_Member,
ROUND(SUM(Exited)*100 / COUNT(*),2) AS Churn_Rate
FROM churn_dataset 
GROUP BY Geography,Active_Member,Age_Group
ORDER BY Churn_Rate DESC;

/*
Final Key Insights:
1- Inactive customers churn almost twice as much as active customers. 
 This pattern is consistent across all countries, indicating customer engagement is a key factor in retention.
2- Churn increases significantly with age, with senior customers showing the highest churn rates across all countries.
3- Customers in Germany churn at roughly double the rate of those in France and Spain, 
suggesting potential dissatisfaction or competitive pressure.
4- Customers with high product usage appear to have much higher churn rates; however, 
this segment represents a small proportion of the dataset, so conclusions should be interpreted carefully.
5- Older inactive customers across all countries represent the highest-risk churn segment in the dataset.

*/
