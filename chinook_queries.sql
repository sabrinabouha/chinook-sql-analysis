-- ============================================================
-- Chinook SQL Practice: 10 business questions
-- Database: Chinook (SQLite version)
-- ============================================================

-- ---------- LEVEL 1: WARM-UP ----------

-- Q1. Which 5 countries bring the most revenue?
SELECT BillingCountry,
       SUM(Total) AS total_revenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY total_revenue DESC
LIMIT 5;

-- Q2. Who are the top 10 customers by total spending?
-- Note: group by CustomerId, not by name (two customers can share a name).
SELECT c.CustomerId,
       c.FirstName,
       c.LastName,
       c.Country,
       SUM(i.Total) AS total_spending
FROM Customer c
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Country
ORDER BY total_spending DESC
LIMIT 10;

-- Q3. How many tracks does each genre have?
SELECT g.Name AS genre,
       COUNT(*) AS nb_tracks
FROM Genre g
JOIN Track t ON t.GenreId = g.GenreId
GROUP BY g.GenreId, g.Name
ORDER BY nb_tracks DESC;

-- ---------- LEVEL 2: ANALYST THINKING ----------

-- Q4. Which genres generate the most revenue?
SELECT g.Name AS genre,
       SUM(il.Quantity * il.UnitPrice) AS revenue
FROM InvoiceLine il
JOIN Track t ON t.TrackId = il.TrackId
JOIN Genre g ON g.GenreId = t.GenreId
GROUP BY g.GenreId, g.Name
ORDER BY revenue DESC;

-- Q5. Which 10 artists generate the most revenue?
SELECT ar.Name AS artist,
       SUM(il.Quantity * il.UnitPrice) AS revenue
FROM Artist ar
JOIN Album al ON al.ArtistId = ar.ArtistId
JOIN Track t ON t.AlbumId = al.AlbumId
JOIN InvoiceLine il ON il.TrackId = t.TrackId
GROUP BY ar.ArtistId, ar.Name
ORDER BY revenue DESC
LIMIT 10;

-- Q6. Which sales rep brings in the most revenue from their customers?
SELECT e.EmployeeId,
       e.FirstName,
       e.LastName,
       SUM(i.Total) AS total_revenue
FROM Employee e
JOIN Customer c ON c.SupportRepId = e.EmployeeId
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY total_revenue DESC;

-- ---------- LEVEL 3: REAL BUSINESS QUESTIONS ----------

-- Q7. Revenue per year and growth % compared to the previous year
WITH yearly_revenue AS (
    SELECT strftime('%Y', InvoiceDate) AS year,
           SUM(Total) AS revenue
    FROM Invoice
    GROUP BY year
),
revenue_comparison AS (
    SELECT year,
           revenue,
           LAG(revenue) OVER (ORDER BY year) AS previous_revenue
    FROM yearly_revenue
)
SELECT year,
       revenue,
       previous_revenue,
       ROUND((revenue - previous_revenue) * 100.0
             / NULLIF(previous_revenue, 0), 2) AS growth_percentage
FROM revenue_comparison
ORDER BY year;

-- Q8. Average order value per country (countries with at least 5 invoices)
SELECT BillingCountry,
       ROUND(AVG(Total), 2) AS avg_order_value,
       COUNT(*) AS nb_invoices
FROM Invoice
GROUP BY BillingCountry
HAVING COUNT(*) >= 5
ORDER BY avg_order_value DESC;

-- Q9. Customers who have never bought anything
SELECT c.CustomerId, c.FirstName, c.LastName
FROM Customer c
LEFT JOIN Invoice i ON i.CustomerId = c.CustomerId
WHERE i.InvoiceId IS NULL;

-- Q10. Customers who bought in 2023 but not in 2024 (churn)
SELECT c.CustomerId, c.FirstName, c.LastName
FROM Customer c
WHERE EXISTS (
        SELECT 1 FROM Invoice i
        WHERE i.CustomerId = c.CustomerId
          AND strftime('%Y', i.InvoiceDate) = '2023')
  AND NOT EXISTS (
        SELECT 1 FROM Invoice i
        WHERE i.CustomerId = c.CustomerId
          AND strftime('%Y', i.InvoiceDate) = '2024');
