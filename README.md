# E-Commerce-Profitability-Analysis
- Author: Chau My Phuong
- Date: 6/3/2026

## SCENERIO:
I am a financial analyst at a direct-to-consumer e-commerce brand that sells products across multiple categories and channels.While top-line revenue looks healthy, the CEO suspects that not all product categories and sales channels are actually profitable once you account for shipping, returns, platform fees, and marketing costs. In this project you will perform a true profitability analysis by connecting order-level transaction data with product costs and marketing spend to find out where the company is actually making (and losing) money.

## ABOUT COMPANY:
BrightCart is an online retailer selling products across 8 categories through their website, mobile app, third-party marketplaces, and social commerce. The company did $1M+ in gross revenue over the past two years, but net margins have been shrinking. The CEO wants to know which product categories and sales channels are truly profitable after all costs, which marketing platforms are delivering the best return on ad spend, and whether the return rate is eating into margins. You have three datasets: order-level transactions, a product catalog with cost data, and monthly marketing spend by platform.

## Questions to Answer
- What is the average profit margin by product category? Which categories are the most and least profitable, and what is driving the difference (product cost, shipping, returns, or discounts)?
- How does profitability differ across sales channels (Website, Mobile App, Marketplace, Social Commerce)? Which channel has the best and worst profit per order after accounting for platform fees?
- What is the return rate by category and channel? Estimate how much total revenue was lost to returns over the analysis period.
- Analyze the marketing spend data: Which advertising platform delivers the best ROAS (Return on Ad Spend)? Are there any platforms where the company is spending money but not getting a positive return?
- If the CEO asked you to cut 20% of the marketing budget, which platforms and months would you recommend reducing spend on? Support your recommendation with data.

## Tech Stack include:
- SQL
- Pandas
- Excel

## Introduce steps
**Workflow**
Raw CSV -> Import SQL -> Explore Data -> Data Cleaning -> Data Modeling (ERD) -> SQL Analysis -> Dashboard

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

## 1. Introduce data
### Raw data description
**Data set:**
- marketing_spend.csv: Monthly ad spend and engagement metrics by platform.
- orders.csv: Transaction-level data including revenue, costs, and shipping info.
- products.csv: A master catalog of products, costs, and supplier details.
### Raw data table
**marketing_spend.csv**
| Column             | Description                                                                              |
| ------------------ | ---------------------------------------------------------------------------------------- |
| month              | The reporting period in YYYY-MM format.                                                  |
| platform           | Advertising platform used for the campaign (e.g., Google Ads, Facebook Ads, TikTok Ads). |
| spend              | Total marketing budget spent on the platform during the month.                           |
| impressions        | Total number of times ads were displayed to users.                                       |
| clicks             | Number of times users clicked on the ads.                                                |
| conversions        | Number of successful actions generated from ads (e.g., purchases).                       |
| revenue_attributed | Revenue directly attributed to the marketing campaign.                                   |
| cpc                | Cost per click calculated as spend / clicks.                                    |
| cpa                | Cost per acquisition calculated as pend / conversions.                         |
| roas               | Return on Ad Spend calculated as revenue_attributed / spend.                    |


**orders.csv**
| Column           | Description                                                                |
| ---------------- | -------------------------------------------------------------------------- |
| order_id         | Unique identifier for each order transaction.                              |
| customer_id      | Unique identifier for the customer placing the order.                      |
| order_date       | Date when the order was placed.                                            |
| channel          | Sales channel where the order was made (Website, Mobile App, Marketplace). |
| payment_method   | Payment method used by the customer (Credit Card, PayPal, etc.).           |
| region           | Geographic region of the customer.                                         |
| items_ordered    | Total number of items in the order.                                        |
| primary_category | Main product category purchased in the order.                              |
| gross_revenue    | Total revenue before discounts.                                            |
| discount_pct     | Percentage discount applied to the order.                                  |
| discount_amount  | Total discount value applied to the order.                                 |
| shipping_cost    | Cost of shipping the order.                                                |
| product_cost     | Total cost of goods sold for the order.                                    |
| platform_fee     | Fee charged by marketplace or platform.                                    |
| transaction_fee  | Payment processing fee for the order.                                      |
| returned         | Indicates whether the order was returned (Yes/No).                         |
| refund_amount    | Amount refunded to the customer if the order was returned.                 |
| net_revenue      | Revenue after discounts and refunds.                                       |
| total_costs      | Sum of product_cost, shipping_cost, platform_fee, and transaction_fee.     |
| profit           | Net profit calculated as net_revenue minus total_costs.                    |

**products.csv**
| Column                 | Description                                       |
| ---------------------- | ------------------------------------------------- |
| product_id             | Unique SKU identifier for the product.            |
| product_name           | Name of the product.                              |
| category               | Main product category.                            |
| sub_category           | More specific classification within the category. |
| unit_cost              | Cost of goods sold per unit.                      |
| selling_price          | Standard retail selling price.                    |
| shipping_cost_per_unit | Shipping cost associated with each unit sold.     |
| weight_lbs             | Product weight measured in pounds.                |
| supplier               | The supplier providing the product.               |


## 2. Data cleaning
**marketing_spend.csv**
- Converted month column to date format for time-series analysis.
- Check all column value.
- Checked for missing values in spend, clicks, and conversions.
- Converted all number column to number type

**orders.csv**
- Converted order_date to date format.
- Check all column value.
- Converted all number column to number type

**products.csv**
- Checked for duplicate product_id values.
- Standardized category and sub_category naming conventions.
- Ensured unit_cost < selling_price to avoid negative margins.
- Converted weight_lbs to numeric format.
- Verified missing supplier values and replaced them with Unknown Supplier if necessary.

## 3. Data Modeling
### ERD
