# Who buys again within 30 days?

If a shopper places two orders on the day they first visit a store, have they really *come back*? This analysis counts a return only when the shopper makes another paid purchase on a later calendar day. It groups shoppers by the month of their first paid order.

| First purchase | Eligible shoppers | Returned in 30 days | Repeat rate |
| --- | ---: | ---: | ---: |
| July 2026 | 4 | 2 | 50.0% |
| August 2026 | 3 | 1 | 33.3% |

In this fictional example, a single additional returning August shopper would move the rate from 33.3% to 66.7%. With groups this small, the sensible next step is to collect more cohorts before changing campaign spend.

## How the metric works

- Day 30 counts. Shopper A returned on day 30 and qualifies. Shopper B returned on day 31 and misses the window.
- A refunded purchase or a second order on the same day does not qualify. Shoppers C and E illustrate these cases.
- September 30 is the last day observed. Shopper H first bought on September 15, so their 30-day window is still open and they are excluded from the denominator.

## Reproduce the numbers

Run this command from this project folder with SQLite installed. The script builds its own fictional dataset in memory.

```sh
sqlite3 -header -column :memory: < analysis.sql
```

[Read the SQL](analysis.sql) · [View the calculated results](results.csv)
