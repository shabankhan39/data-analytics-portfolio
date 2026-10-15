-- DATA CLEANING

SELECT * FROM layoffs ;

-- 1. Remove Duplicates
-- 2. Stardization
-- 3. Remove Null and Blank values
-- 4. Remove Columns


CREATE TABLE layoffs_stagging
like layoffs;

SELECT * FROM layoffs_stagging;

INSERT INTO layoffs_stagging
SELECT
* FROM layoffs;


-- REMOVE DUPLICATES:

WITH duplicate_identifier AS (
select * ,
row_number () over(partition by company, location,industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as rows_number
from layoffs_stagging
)
SELECT * FROM 
duplicate_identifier
where rows_number = 2;





CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `rows_number` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_stagging2
select * ,
row_number () over(partition by company, location,industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as rows_number
from layoffs_stagging;

SELECT * FROM layoffs_stagging2;


select * from layoffs_stagging2
where rows_number = 1;

-- Standardize the data :

select * from layoffs_stagging2;

select company, trim(company) 
from layoffs_stagging2;

update layoffs_stagging2
SET company = trim(company) ;

SELECT industry
FROM layoffs_stagging2
order by 1;

SELECT distinct (industry) 
from layoffs_stagging2
where industry like 'Crypto%';

update layoffs_stagging2
SET industry = 'Crypto'
where  industry like 'Crypto%';

SELECT country, trim(trailing '.' from country)
FROM layoffs_stagging2
WHERE country like 'United states%';

update layoffs_stagging2
SET country = trim(trailing '.' from country);

select * from layoffs_stagging2;

select * from layoffs_stagging2
where industry IS NULL or industry= '';

update layoffs_stagging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_stagging2
modify column `date` DATE;	


update layoffs_stagging2
set industry = null
where industry = '';


UPDATE
layoffs_stagging2 t1
join
layoffs_stagging2 t2
ON t1.company=t2.company
set t1.industry = t2.industry
where  t1.industry IS NULL AND
t2.industry IS NOT NULL
;

delete FROM layoffs_stagging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

select * from layoffs_stagging2;


ALTER TABLE layoffs_stagging2
DROP COLUMN rows_number;
