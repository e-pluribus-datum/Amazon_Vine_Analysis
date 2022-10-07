-- Filter for total_votes >= 20 to disregard reviews of low sample size

CREATE VIEW total_votes_20 AS
SELECT * FROM vine_table
WHERE total_votes >= 20;

-- Filter further to retrieve rows with helpful_votes >= 50%

CREATE VIEW total_votes_50Per AS
SELECT * FROM total_votes_20
WHERE (helpful_votes / total_votes) >= 0.5;

-- Filter further to retrieve Vine reviews

CREATE VIEW paid_reviews AS
SELECT * FROM total_votes_50Per
WHERE vine = 'Y';

-- Repeat for non-Vine reviews

CREATE VIEW unpaid_reviews AS
SELECT * FROM total_votes_50Per
WHERE vine = 'N';

-- Determine total number of reviews, number of 5-star reviews, and percentage of 5-star reviews
-- For the two types of review (paid vs unpaid)

-- Paid:
-- Number of reviews
CREATE VIEW total_paid AS
SELECT COUNT(total_votes) AS total_paid_reviews
FROM paid_reviews;

-- Number of 5-star reviews
CREATE VIEW total_paid_five_star AS
SELECT COUNT(total_votes) AS total_paid_five_star_reviews
FROM paid_reviews
WHERE star_rating = 5;

-- Percentage of 5-star reviews
CREATE VIEW paid_review_analysis AS
SELECT tp.total_paid_reviews, tpfs.total_paid_five_star_reviews,
	CAST(tpfs.total_paid_five_star_reviews AS FLOAT) / CAST(tp.total_paid_reviews AS FLOAT) * 100
	AS percent_five_star_paid
FROM total_paid AS tp
INNER JOIN total_paid_five_star AS tpfs
	ON 1 = 1;

-- Unpaid:
-- Number of reviews
CREATE VIEW total_unpaid AS
SELECT COUNT(total_votes) AS total_unpaid_reviews
FROM unpaid_reviews;

-- Number of 5-star reviews
CREATE VIEW total_unpaid_five_star AS
SELECT COUNT(total_votes) AS total_unpaid_five_star_reviews
FROM unpaid_reviews
WHERE star_rating = 5;

-- Percentage of 5-star reviews
CREATE VIEW unpaid_review_analysis AS
SELECT tu.total_unpaid_reviews, tufs.total_unpaid_five_star_reviews,
	CAST(tufs.total_unpaid_five_star_reviews AS FLOAT) / CAST(tu.total_unpaid_reviews AS FLOAT) * 100
	AS percent_five_star_unpaid
FROM total_unpaid AS tu
INNER JOIN total_unpaid_five_star AS tufs
	ON 1 = 1;
	
-- Combine analysis for both types
CREATE VIEW vines_review_analysis AS
SELECT * FROM paid_review_analysis
INNER JOIN unpaid_review_analysis
	ON 1=1;