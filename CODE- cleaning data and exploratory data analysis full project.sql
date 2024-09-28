### Cleaning and analysing data - full project

## First I will be cleaning the data and for that I will do the following:
	-- 1: Remove duplicates
    -- 2: Standardize the data
    -- 3: Null values or blank values
    -- 4: Remove any columns
## Then I will be performing exploratory data analysis on the cleaned version of this data to find trends and patterns by running different queries.


SELECT *
FROM layoffs;

# Step 1 : delete duplicates

-- I will make another table bcz I dont wanna change the original data.



CREATE TABLE layoffs_staging
LIKE layoffs;


SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;


SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging)
SELECT *
FROM duplicate_cte
WHERE row_num > 1 ;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging)
DELETE 
FROM duplicate_cte
WHERE row_num > 1 ;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging ;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- duplicated rows deleted.

# Step 2 : standardizing data.  8:45pm

-- I will now be trimming spaces
SELECT *
FROM layoffs_staging2;

SELECT DISTINCT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry ASC;


-- Now I will be standardizing the names of industries

SELECT  industry
FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry ASC;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country ASC ;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';



-- OR

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%';

-- Now, fixing format of date

SELECT *
FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date` , '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT *
FROM layoffs_staging2;

-- Now, working with null and blank values

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'airbnb';


SELECT *
FROM layoffs_staging2
WHERE company LIKE 'bally%';

-- There is no row for Bally where the industry is not null to populate.


UPDATE layoffs_staging2
SET industry = 'travel'
WHERE company LIKE 'airbnb';


-- Deleting null rows where there are no lay offs.

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Now, I will delete the extra column I initially created.

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2
;

-- Data has been cleaned.
-- Next I will be performing exploratory data analysis using this cleaned data to find trends and patterns by running different queries.


# Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

-- I will now look at the maximum laid off and mainly companies that laid all their staff off.

SELECT MAX(total_laid_off)
FROM layoffs_staging2;



SELECT company, total_laid_off 
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
ORDER BY total_laid_off ;

-- So, maximum laid off is 12,000 by Google and 2nd largest laid off is 10,000 by Microsaoft.

-- Now I will look at companies that laid all their staff off

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1 AND total_laid_off IS NOT NULL;

-- So, companies 1.Britishvolt, 2.EMX Digital, 3.Openpay laid all their staff off and all in the first 2 months of 2023.

-- Now I will look at the fundings these companies raised.

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1 AND total_laid_off IS NOT NULL
ORDER by funds_raised_millions;

-- Out of these companies, Britishvolt got the most funding which is 2.4 billion.

-- Now I will look at the lay off companywise.

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- now i will look at dates when these companies laid off to find trends.

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- So the layoff date starts from March of 2020, which is around the same time when covid hit and the ending date is almost exactly 3 years later i.e, March 2023.

-- Now, I will look at what industry had the most impact of covid in terms of layoffs.

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- So, comsumer and retail industry had the most layoffs which makes sense.

-- The industry that were not impacted a lot are manufacturing with only 20 layoffs and fintech with only 215 layoffs.

SELECT *
FROM layoffs_staging2;

-- Now I will look at the layoffs impact on different countries.

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- United states had the most layoffs according to the data available. Next is India where people lost most jobs.alter

-- Now I wanna look at dates and when exactly the layoffs happened.alter

SELECT `date` , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 2 DESC;

-- So the most layoffs i.e, 16,171 happened in January 2023

-- I will now look at the years.

SELECT YEAR(`date`) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- So, 2022 had the most layoffs i.e, 160,661. 
-- In 2023, just in the first 3 months, 125,677 people were laid off. So, if we got the data of the full 2023 year, it would most likely be even more than 2022.

-- Now I will look at the stages that the reported companies are in

SELECT stage , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- So, post IPOs had the most layoffs. These are the large companies.

-- Now, I will look at average percentages.

SELECT company , AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Now I wanna look at the progression of lay offs and I will use rolling sum for that.
-- I will do this based on the months.

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC;

-- Now I want rolling sum of this.

WITH rolling_total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER (ORDER BY `month`) AS rolling_total
FROM rolling_total;

-- 2021 year looks good comparitively. 2022, around 150,000 which is a lot.
-- So, October 2022 to January 2023 were the worst months in terms of lay off impact.

-- Now I wanna look at rolling total while also looking at companies.
 
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`);


-- Now I wanna look at the layoffs companywise and per year.

SELECT *
FROM layoffs_staging2;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) as ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY ranking;


WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *,
 DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) as ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;

-- So, in 2020, UBER laid off most of the people i.e, 7,525. In 2021, bytedance laid off most people i.e, 3,600.In 2022, Meta laid off most people i.e, 11,000. In 2023, Google laid off most people i.e, 12,000.













