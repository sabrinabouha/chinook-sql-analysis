# Chinook SQL Analysis: 10 Business Questions

SQL practice project where I answer business questions about a digital music store, the way a data analyst would.

> **Note:** this is a learning project on a public sample database (Chinook), not a real company's data.

## Goal

Practice turning a business question into a SQL query, then turning the result into a clear insight. Questions go from simple (`JOIN`, `GROUP BY`) to more realistic (CTEs, window functions, churn analysis).

## Dataset

[Chinook](https://github.com/lerocha/chinook-database) is a sample database of a music store, created by Luis Rocha.

| Table | Content |
|---|---|
| `Customer` | 59 customers and their assigned sales rep |
| `Employee` | 8 employees, including 3 sales reps |
| `Invoice` / `InvoiceLine` | 412 invoices, 2,240 invoice lines (2021 to 2025) |
| `Track` / `Album` / `Artist` / `Genre` | the music catalogue (3,503 tracks) |

Main join paths:

```
Customer -> Invoice -> InvoiceLine -> Track -> Genre
Track -> Album -> Artist
Employee -> Customer (SupportRepId)
```

## Tools

- SQLite
- DB Browser for SQLite
- SQL features used: `JOIN`, `LEFT JOIN`, `GROUP BY`, `HAVING`, subqueries with `EXISTS`, CTEs (`WITH`), window function `LAG()`, date functions (`strftime`)

## The 10 questions

All queries are in [`chinook_queries.sql`](chinook_queries.sql).

| # | Business question | Skills |
|---|---|---|
| 1 | Which 5 countries bring the most revenue? | `GROUP BY`, `ORDER BY`, `LIMIT` |
| 2 | Who are the top 10 customers by spending? | `JOIN`, `GROUP BY` |
| 3 | How many tracks does each genre have? | `JOIN`, `COUNT` |
| 4 | Which genres generate the most revenue? | multiple joins |
| 5 | Which 10 artists generate the most revenue? | 4-table join |
| 6 | Which sales rep brings in the most revenue? | multiple joins |
| 7 | What is the revenue per year and the growth %? | CTE, `LAG()`, `NULLIF` |
| 8 | What is the average order value per country (at least 5 invoices)? | `AVG`, `HAVING` |
| 9 | Which customers never bought anything? | `LEFT JOIN ... IS NULL` |
| 10 | Which customers bought in 2023 but not in 2024? | `EXISTS`, `NOT EXISTS` |

## Key findings

- **Total revenue is 2,328.60** across 24 countries.
- **The USA is the biggest market** with 523.06 (about 22% of revenue), followed by Canada (303.96), France (195.10), Brazil (190.10) and Germany (156.48).
- **Rock dominates the catalogue and the sales:** 1,297 tracks and 826.65 in revenue (about 35% of the total). Latin (382.14) and Metal (261.36) follow.
- **Top artists by revenue:** Iron Maiden (138.60), U2 (105.93), Metallica (90.09).
- **Top sales rep:** Jane Peacock with 833.04, ahead of Margaret Park (775.40) and Steve Johnson (720.16).
- **Revenue is flat, not growing:** between 449 and 481 per year. Growth was +7.1% in 2022, -2.5% in 2023, +1.7% in 2024 and **-5.6% in 2025**.
- **Highest average order:** Chile (6.66), then Ireland and Hungary (6.52).
- **Churn signal:** 12 customers who bought in 2023 did not buy in 2024. They are a good target for a re-engagement campaign.
- **Every customer has bought at least once** (question 9 returns no rows).

## Lessons learned

- **Group by the ID, not by the name.** In question 2, grouping by first name and country merged two different customers called Frank from the USA and made one of them look like the top customer. Grouping by `CustomerId` fixed it.
- **Use `COUNT(*)`, not `SUM(id)`.** Summing ID numbers has no meaning.
- **Always write `JOIN ... ON`.** It is clearer, faster, and required in most SQL databases.
- **Read the question exactly.** "Top 10" and "at least 5" change the query (`LIMIT 10`, `>= 5`).
- **Check your totals.** For example, revenue by rep adds up to the total of `Invoice.Total`.

## How to run

1. Download the Chinook SQLite file from the [official repository](https://github.com/lerocha/chinook-database).
2. Open it with DB Browser for SQLite, or in a terminal:
   ```bash
   sqlite3 chinook.sqlite < chinook_queries.sql
   ```
3. Run the queries one at a time and compare with the findings above.

## Author

**[Your Name]**: aspiring data analyst
[LinkedIn](https://www.linkedin.com/in/your-profile) | [GitHub](https://github.com/your-username)
