-- 1. SALES OVERVIEW

-- 1.1 Total Revenue;
SELECT ROUND(SUM(money), 2) AS TotalRevenue
FROM CoffeeSales;
-- 1.2 Total Transactions (Sales)
SELECT COUNT(*) AS TotalTransactions
FROM CoffeeSales;
-- 1.3 Average Daily Sales
SELECT ROUND(AVG(DailySales), 2) AS AvgDailySales
FROM (
    SELECT date, SUM(money) AS DailySales
    FROM CoffeeSales
    GROUP BY date
) AS DailyRevenue;

-- 2. Best-Selling Coffee Types

-- 2.1 Total Revenue by Coffee Types
SELECT coffee_name, ROUND(SUM(money), 2) AS TotalRevenue
FROM CoffeeSales
GROUP BY coffee_name
ORDER BY TotalRevenue DESC;
-- 2.2 Total Sales by Coffee Type
SELECT coffee_name, COUNT(*) AS TotalSales
FROM CoffeeSales
GROUP BY coffee_name
ORDER BY TotalSales DESC;
-- 2.3 Average Price Per Coffee Type
SELECT coffee_name, ROUND(AVG(money), 2) AS AvgPrice
FROM CoffeeSales
GROUP BY coffee_name
ORDER BY AvgPrice DESC;

-- 3. Peak Sales Time Analysis

-- 3.1 Top 5 Busiest Days Per Month (special events/ promos?)
WITH RankedSales AS (
    SELECT 
        FORMAT(datetime, 'yyyy-MM') AS Month,
        CAST(datetime AS DATE) AS SaleDate,
        COUNT(*) AS TotalSales,
        RANK() OVER (PARTITION BY FORMAT(datetime, 'yyyy-MM') ORDER BY COUNT(*) DESC) AS SalesRank
    FROM CoffeeSales
    GROUP BY FORMAT(datetime, 'yyyy-MM'), CAST(datetime AS DATE)
)
SELECT Month, SaleDate, TotalSales
FROM RankedSales
WHERE SalesRank <= 5
ORDER BY Month, TotalSales;
-- 3.2 Daily Sales Trend (See how sales fluctuate each day)
SELECT CAST(datetime AS DATE) AS SaleDate, COUNT(*) AS TotalSales
FROM CoffeeSales
GROUP BY CAST(datetime AS DATE)
ORDER BY SaleDate;
-- 3.3 Weekly Sales Trend (Weekly patterns in customer purchases)
SELECT DATEPART(YEAR, datetime) AS Year, DATEPART(WEEK, datetime) AS WeekNumber, COUNT(*) AS TotalSales
FROM CoffeeSales
GROUP BY DATEPART(YEAR, datetime), DATEPART(WEEK, datetime)
ORDER BY Year DESC, WeekNumber DESC;
-- 3.4 Monthly Sales Trend (Growth vs Decline monthly)
SELECT FORMAT(datetime, 'yyyy-MM') AS Month, COUNT(*) AS TotalSales
FROM CoffeeSales
GROUP BY FORMAT(datetime, 'yyyy-MM')
ORDER BY Month DESC;

-- 4. Peak hours & days. How much staff is needed? How to do staffing for shifts?

-- 4.1 Sales by hour (peak time of day; what hours need more employees for scheduling)
SELECT DATEPART(HOUR, datetime) AS SaleHour, COUNT(*) AS TotalSales
FROM CoffeeSales
GROUP BY DATEPART(HOUR, datetime)
ORDER BY TotalSales DESC;
-- 4.2 Sales by Day of Week (what days need more employees?)
SELECT DATENAME(WEEKDAY, datetime) AS SaleDay, COUNT(*) AS TotalSales
FROM CoffeeSales
GROUP BY DATENAME(WEEKDAY, datetime)
ORDER BY TotalSales DESC;

-- 5. Payment Method Analysis

-- 5.1 % of Sales paid in card vs cash (what's more popular payment method?)
SELECT 
    CASE 
        WHEN card = 'Cash' THEN 'Cash' 
        ELSE 'Card' 
    END AS PaymentMethod,
    COUNT(*) AS TotalTransactions,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM CoffeeSales), 2) AS PercentageOfSales
FROM CoffeeSales
GROUP BY CASE 
        WHEN card = 'Cash' THEN 'Cash' 
        ELSE 'Card' 
    END;
-- 5.2 Revenue Comparison (Card vs Cash)
SELECT 
    CASE 
        WHEN card = 'Cash' THEN 'Cash' 
        ELSE 'Card' 
    END AS PaymentMethod,
    ROUND(SUM(money), 2) AS TotalRevenue,
    ROUND(SUM(money) * 100.0 / (SELECT SUM(money) FROM CoffeeSales), 2) AS PercentageOfRevenue
FROM CoffeeSales
GROUP BY CASE 
        WHEN card = 'Cash' THEN 'Cash' 
        ELSE 'Card' 
    END;

	-- 6. Customer Trends

	-- 6.1 Average Spend Per Transaction
	SELECT 
    ROUND(AVG(money), 2) AS AverageSpendPerTransaction
	FROM CoffeeSales;
	-- 6.2 Most Common Order Times (When most orders happen?)
	SELECT 
    CASE 
        WHEN DATEPART(HOUR, datetime) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, datetime) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, datetime) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END AS OrderTimePeriod,
    COUNT(*) AS TotalOrders
FROM CoffeeSales
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, datetime) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, datetime) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, datetime) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END
ORDER BY TotalOrders DESC;
	-- 6.3 Top 5 Customers by Revenue
	SELECT TOP 5 
    card, 
    ROUND(SUM(money), 2) AS TotalSpent
FROM CoffeeSales
WHERE card <> 'Cash' -- Excludes cash transactions
GROUP BY card
ORDER BY TotalSpent DESC;


