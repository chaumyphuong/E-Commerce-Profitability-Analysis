# E-Commerce-Profitability-Analysis
- Author: Chau My Phuong
- Date: 6/3/2026

## SCENERIO:
You are a financial analyst at a direct-to-consumer e-commerce brand that sells products across multiple categories and channels. While top-line revenue looks healthy, the CEO suspects that not all product categories and sales channels are actually profitable once you account for shipping, returns, platform fees, and marketing costs. In this project you will perform a true profitability analysis by connecting order-level transaction data with product costs and marketing spend to find out where the company is actually making (and losing) money.

## ABOUT COMPANY:
BrightCart is an online retailer selling products across 8 categories through their website, mobile app, third-party marketplaces, and social commerce. The company did $1M+ in gross revenue over the past two years, but net margins have been shrinking. The CEO wants to know which product categories and sales channels are truly profitable after all costs, which marketing platforms are delivering the best return on ad spend, and whether the return rate is eating into margins. You have three datasets: order-level transactions, a product catalog with cost data, and monthly marketing spend by platform.

## Questions to Answer
- What is the average profit margin by product category? Which categories are the most and least profitable, and what is driving the difference (product cost, shipping, returns, or discounts)?
- How does profitability differ across sales channels (Website, Mobile App, Marketplace, Social Commerce)? Which channel has the best and worst profit per order after accounting for platform fees?
- What is the return rate by category and channel? Estimate how much total revenue was lost to returns over the analysis period.
- Analyze the marketing spend data: Which advertising platform delivers the best ROAS (Return on Ad Spend)? Are there any platforms where the company is spending money but not getting a positive return?
- If the CEO asked you to cut 20% of the marketing budget, which platforms and months would you recommend reducing spend on? Support your recommendation with data.

## Data set:
- marketing_spend.csv
- orders.csv
- products.csv
## Tech Stack include:
- SQL
- Pandas
- Excel

## Introduce steps
### 1. Import and Explore
- Load all three CSVs.
- Verify that order-level costs add up correctly (product cost + shipping + fees = total costs).
- Check for any data quality issues.

### 2. Category Profitability
- Group orders by product category.
- Calculate total revenue, total costs, total profit, and profit margin for each.
- Identify the top and bottom performers.

### 3. Channel Analysis
- Group by sales channel.
- Compare average order value, average profit, and return rate across channels.
- Factor in platform fees for Marketplace and Social Commerce.

### 4. Marketing ROI
- Analyze the marketing spend dataset.
- Calculate ROAS, cost per acquisition, and cost per click by platform.
- Identify which platforms are underperforming.

### 5. Recommendations
- Create a one-page summary with your top 3 recommendations for improving profitability.
- Include specific numbers (e.g., cutting X platform saves $Y with minimal revenue impact).

