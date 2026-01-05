
Create Database Maven_Advanced_SQL;
Use Maven_Advanced_SQL;


-- Drop tables if they already exist
IF OBJECT_ID('dbo.students', 'U') IS NOT NULL
	DROP TABLE dbo.students;
--DROP TABLE students;
--DROP TABLE happiness_scores;
--DROP TABLE happiness_scores_current;
--DROP TABLE country_stats;
--DROP TABLE inflation_rates;
--DROP TABLE orders;
--DROP TABLE customers;
--DROP TABLE products;
--DROP TABLE student_grades;

-- SECTION 1: SQL Basics Review

--
-- Table structure for table `students`
--

CREATE TABLE students (
    id INT PRIMARY KEY,
    student_name VARCHAR(50),
    grade_level INT,
    gpa DECIMAL(2, 1),
    school_lunch VARCHAR(3),
    birthday DATE,
    email VARCHAR(100)
);

--
-- Insert data into table `students`
--

INSERT INTO students (id, student_name,  grade_level, gpa, school_lunch, birthday, email) VALUES
(1, 'Abby Johnson', 10, 3.1, 'Yes', '2008-05-14', 'abby.johnson@mavenhighschool.com'),
(2, 'Bob Smith', 11, 3.1, 'No', '2007-09-30', 'bob.smith@mavenhighschool.com'),
(3, 'Catherine Davis', 12, 3.6, 'Yes', '2006-11-21', 'catherine.davis@mavenhighschool.com'),
(4, 'Daniel Brown', 9, 3.5, 'Yes', '2009-03-10', 'daniel.brown@mavenhighschool.edu'),
(5, 'Eva Martinez', 10, 2.7, 'No', '2008-02-05', 'eva.martinez@mavenhighschool.com'),
(6, 'Frank Wilson', 11, 3.2, 'No', '2007-07-17', 'frank.wilson@mavenhighschool.com'),
(7, 'Grace Lee', 12, 3.0, 'Yes', '2006-12-02', 'grace.lee@mavenhighschool.com'),
(8, 'Henry Taylor', 9, 3.0, 'Yes', '2009-06-08', NULL),
(9, 'Isabella Moore', 10, 2.8, 'Yes', '2008-01-19', 'isabella.moore@mavenhighschool.com'),
(10, 'Jack Thompson', 11, 2.9, 'Yes', '2007-04-25', 'jack.thompson@mavenhighschool.com'),
(11, 'Karen White', 9, 3.4, 'No', '2009-09-10', 'karen.white@mavenhighschool.edu'),
(12, 'Liam Green', 10, 4.0, 'Yes', '2008-08-03', 'liam.green@mavenhighschool.com'),
(13, 'Mia Harris', 11, 3.0, 'No', '2007-02-28', 'mia.harris@mavenhighschool.com'),
(14, 'Noah Scott', 12, 3.3, 'No', '2006-10-15', 'noah.scott@mavenparkdistrict.com'),
(15, 'Olivia Adams', 9, 3.7, 'Yes', '2009-12-11', 'olivia.adams@mavenhighschool.edu'),
(16, 'Peter Park', 12, 2.9, 'Yes', '2006-02-11', 'peter.park@mavenhighschool.com'),
(17, 'Noah Scott', 12, 3.3, 'No', '2006-10-15', 'noah.scott@mavenhighschool.com');

-- SECTIONS 2-6: Advanced SQL Concepts

--
-- Table structure for table `happiness_scores`
--

CREATE TABLE happiness_scores (
    year INT,
    country VARCHAR(100),
    region VARCHAR(100),
    happiness_score DECIMAL(5,3),
    gdp_per_capita DECIMAL(10,5),
    social_support DECIMAL(10,5),
    healthy_life_expectancy DECIMAL(10,5),
    freedom_to_make_life_choices DECIMAL(10,5),
    generosity DECIMAL(10,5),
    perceptions_of_corruption DECIMAL(10,5),
    PRIMARY KEY (year, country)
);

--
-- Table structure for table `happiness_scores_current`
--

CREATE TABLE happiness_scores_current (
    country VARCHAR(100),
    ladder_score DECIMAL(5,3),
    gdp_per_capita DECIMAL(5,3),
    social_support DECIMAL(5,3),
    healthy_life_expectancy DECIMAL(5,3),
    freedom_to_make_life_choices DECIMAL(5,3),
    generosity DECIMAL(5,3),
    perceptions_of_corruption DECIMAL(5,3),
    PRIMARY KEY (country)
);

--
-- Table structure for table `country_stats`
--

CREATE TABLE country_stats (
    country VARCHAR(50),
    continent VARCHAR(50),
    population BIGINT,
    urban_population BIGINT,
    land_area_km2 BIGINT,
    unemployment_rate DECIMAL(3,2),
    fertility_rate DECIMAL(3,2),
    infant_mortality DECIMAL(5,2),
    life_expectancy DECIMAL(5,2),
    physicians_per_thousand DECIMAL(5,2),
    PRIMARY KEY (country)
);

--
-- Table structure for table `inflation_rates`
--

CREATE TABLE inflation_rates (
    year INT,
    country_name VARCHAR(100),
    inflation_rate DECIMAL(4, 1),
    PRIMARY KEY (year, country_name)
);

--
-- Insert data into table `happiness_scores`

BULK INSERT happiness_scores
FROM 'C:\Users\DELL\Downloads\Advanced+SQL+Querying\Course Materials\Data\happiness_scores.csv'
WITH (
    FIRSTROW = 2,  -- skip header row
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
	TABLOCK
);


Select * from happiness_scores;


--

INSERT INTO happiness_scores (year, country, region, happiness_score,
							  gdp_per_capita, social_support, healthy_life_expectancy,
                              freedom_to_make_life_choices, generosity,
                              perceptions_of_corruption) VALUES

(2015, 'Afghanistan', 'South Asia', 3.575, 0.31982, 0.30285, 0.30335, 0.23414, 0.3651, 0.09719),
(2015, 'Albania', 'Central and Eastern Europe', 4.959, 0.87867, 0.80434, 0.81325, 0.35733, 0.14272, 0.06413),
(2015, 'Algeria', 'Middle East and North Africa', 5.605, 0.93929, 1.07772, 0.61766, 0.28579, 0.07822, 0.17383),
(2023, 'Zimbabwe', 'Sub-Saharan Africa', 3.204, 0.758, 0.881, 0.069, 0.363, 0.112, 0.117);

--
-- Insert data into table `happiness_scores_current`
--

INSERT INTO happiness_scores_current (country, ladder_score, gdp_per_capita,
									  social_support, healthy_life_expectancy,
                                      freedom_to_make_life_choices, generosity,
                                      perceptions_of_corruption) VALUES
('Finland', 7.741, 1.844, 1.572, 0.695, 0.859, 0.142, 0.546),
('Denmark', 7.583, 1.908, 1.52, 0.699, 0.823, 0.204, 0.548),
('Iceland', 7.525, 1.881, 1.617, 0.718, 0.819, 0.258, 0.182),
('Sweden', 7.344, 1.878, 1.501, 0.724, 0.838, 0.221, 0.524),
('Israel', 7.341, 1.803, 1.513, 0.74, 0.641, 0.153, 0.193),
('Netherlands', 7.319, 1.901, 1.462, 0.706, 0.725, 0.247, 0.372),
('Norway', 7.302, 1.952, 1.517, 0.704, 0.835, 0.224, 0.484),
('Luxembourg', 7.122, 2.141, 1.355, 0.708, 0.801, 0.146, 0.432),
('Switzerland', 7.06, 1.97, 1.425, 0.747, 0.759, 0.173, 0.498),
('Australia', 7.057, 1.854, 1.461, 0.692, 0.756, 0.225, 0.323),
('New Zealand', 7.029, 1.81, 1.527, 0.673, 0.746, 0.226, 0.48),
('Costa Rica', 6.955, 1.561, 1.373, 0.661, 0.797, 0.109, 0.123),
('Kuwait', 6.951, 1.845, 1.364, 0.661, 0.827, 0.2, 0.172),
('Austria', 6.905, 1.885, 1.336, 0.696, 0.703, 0.214, 0.305),
('Canada', 6.9, 1.84, 1.459, 0.701, 0.73, 0.23, 0.368),
('Belgium', 6.894, 1.868, 1.44, 0.69, 0.729, 0.17, 0.311),
('Ireland', 6.838, 2.129, 1.39, 0.7, 0.758, 0.205, 0.418),
('Czechia', 6.822, 1.783, 1.511, 0.638, 0.787, 0.177, 0.068),
('Lithuania', 6.818, 1.766, 1.454, 0.598, 0.533, 0.044, 0.116),
('United Kingdom', 6.749, 1.822, 1.326, 0.672, 0.713, 0.267, 0.351),
('Slovenia', 6.743, 1.786, 1.502, 0.695, 0.789, 0.157, 0.131),
('United Arab Emirates', 6.733, 1.983, 1.164, 0.563, 0.815, 0.209, 0.258),
('United States', 6.725, 1.939, 1.392, 0.542, 0.586, 0.223, 0.169),
('Germany', 6.719, 1.871, 1.39, 0.702, 0.7, 0.174, 0.368),
('Mexico', 6.678, 1.521, 1.241, 0.544, 0.722, 0.086, 0.127),
('Uruguay', 6.611, 1.596, 1.431, 0.592, 0.775, 0.106, 0.22),
('France', 6.609, 1.818, 1.348, 0.727, 0.65, 0.112, 0.281),
('Saudi Arabia', 6.594, 1.842, 1.361, 0.511, 0.787, 0.114, 0.188),
('Kosovo', 6.561, 1.364, 1.277, 0.599, 0.739, 0.254, 0.073),
('Singapore', 6.523, 2.118, 1.361, 0.769, 0.743, 0.168, 0.575),
('Taiwan Province of China', 6.503, 1.842, 1.346, 0.65, 0.649, 0.068, 0.202),
('Romania', 6.491, 1.699, 1.236, 0.583, 0.717, 0.041, 0.006),
('El Salvador', 6.469, 1.265, 1.08, 0.549, 0.816, 0.083, 0.253),
('Estonia', 6.448, 1.752, 1.527, 0.657, 0.805, 0.166, 0.401),
('Poland', 6.442, 1.738, 1.417, 0.639, 0.6, 0.081, 0.175),
('Spain', 6.421, 1.766, 1.471, 0.729, 0.619, 0.119, 0.177),
('Serbia', 6.411, 1.538, 1.391, 0.585, 0.663, 0.2, 0.101),
('Chile', 6.36, 1.616, 1.369, 0.673, 0.651, 0.117, 0.075),
('Panama', 6.358, 1.702, 1.392, 0.633, 0.72, 0.063, 0.043),
('Malta', 6.346, 1.827, 1.444, 0.707, 0.727, 0.25, 0.125),
('Italy', 6.324, 1.8, 1.328, 0.72, 0.513, 0.112, 0.074),
('Guatemala', 6.287, 1.26, 1.169, 0.467, 0.735, 0.105, 0.078),
('Nicaragua', 6.284, 1.097, 1.263, 0.542, 0.793, 0.133, 0.251),
('Brazil', 6.272, 1.43, 1.269, 0.548, 0.685, 0.13, 0.142),
('Slovakia', 6.257, 1.706, 1.54, 0.638, 0.566, 0.096, 0.058),
('Latvia', 6.234, 1.7, 1.508, 0.564, 0.666, 0.127, 0.078),
('Uzbekistan', 6.195, 1.212, 1.394, 0.539, 0.835, 0.251, 0.215),
('Argentina', 6.188, 1.562, 1.381, 0.585, 0.681, 0.087, 0.08),
('Kazakhstan', 6.188, 1.622, 1.457, 0.556, 0.733, 0.149, 0.12),
('Cyprus', 6.068, 1.794, 1.217, 0.744, 0.529, 0.124, 0.049),
('Japan', 6.06, 1.786, 1.354, 0.785, 0.632, 0.023, 0.219),
('South Korea', 6.058, 1.815, 1.178, 0.77, 0.555, 0.126, 0.158),
('Philippines', 6.048, 1.232, 1.146, 0.441, 0.826, 0.099, 0.136),
('Vietnam', 6.043, 1.331, 1.267, 0.539, 0.843, 0.094, 0.16),
('Portugal', 6.03, 1.728, 1.368, 0.699, 0.757, 0.047, 0.035),
('Hungary', 6.017, 1.722, 1.528, 0.596, 0.581, 0.123, 0.067),
('Paraguay', 5.977, 1.398, 1.408, 0.549, 0.788, 0.131, 0.065),
('Thailand', 5.976, 1.484, 1.347, 0.62, 0.756, 0.283, 0.024),
('Malaysia', 5.975, 1.646, 1.143, 0.54, 0.829, 0.226, 0.119),
('China', 5.973, 1.497, 1.239, 0.629, 0.704, 0.132, 0.164),
('Honduras', 5.968, 1.091, 1.035, 0.502, 0.72, 0.175, 0.081),
('Bahrain', 5.959, NULL, NULL, NULL, NULL, NULL, NULL),
('Croatia', 5.942, 1.71, 1.445, 0.637, 0.469, 0.064, 0.043),
('Greece', 5.934, 1.684, 1.276, 0.696, 0.337, 0.018, 0.093),
('Bosnia and Herzegovina', 5.877, 1.465, 1.318, 0.587, 0.621, 0.246, NULL),
('Libya', 5.866, 1.526, 1.1, 0.55, 0.592, 0.111, 0.204),
('Jamaica', 5.842, 1.28, 1.324, 0.567, 0.647, 0.089, 0.028),
('Peru', 5.841, 1.371, 1.18, 0.662, 0.615, 0.078, 0.029),
('Dominican Republic', 5.823, 1.517, 1.272, 0.511, 0.73, 0.086, 0.196),
('Mauritius', 5.816, 1.57, 1.358, 0.49, 0.641, 0.123, 0.118),
('Moldova', 5.816, 1.385, 1.277, 0.542, 0.695, 0.077, 0.044),
('Russia', 5.785, 1.642, 1.351, 0.531, 0.551, 0.138, 0.121),
('Bolivia', 5.784, 1.217, 1.179, 0.488, 0.719, 0.1, 0.061),
('Ecuador', 5.725, 1.315, 1.151, 0.64, 0.606, 0.087, 0.078),
('Kyrgyzstan', 5.714, 1.054, 1.477, 0.588, 0.834, 0.225, 0.03),
('Montenegro', 5.707, 1.571, 1.318, 0.587, 0.632, 0.11, 0.132),
('Mongolia', 5.696, 1.353, 1.511, 0.4, 0.501, 0.237, 0.055),
('Colombia', 5.695, 1.437, 1.241, 0.648, 0.644, 0.072, 0.059),
('Venezuela', 5.607, NULL, 1.321, 0.491, 0.518, 0.192, 0.086),
('Indonesia', 5.568, 1.361, 1.184, 0.472, 0.779, 0.399, 0.055),
('Bulgaria', 5.463, 1.629, 1.469, 0.567, 0.62, 0.083, 0.006),
('Armenia', 5.455, 1.444, 1.154, 0.603, 0.65, 0.051, 0.173),
('South Africa', 5.422, 1.389, 1.369, 0.322, 0.537, 0.078, 0.034),
('North Macedonia', 5.369, 1.475, 1.277, 0.569, 0.58, 0.194, 0.015),
('Algeria', 5.364, 1.324, 1.191, 0.568, 0.247, 0.091, 0.2),
('Hong Kong S.A.R. of China', 5.316, 1.909, 1.184, 0.857, 0.485, 0.147, 0.402),
('Albania', 5.304, 1.438, 0.924, 0.638, 0.69, 0.138, 0.049),
('Tajikistan', 5.281, NULL, NULL, NULL, NULL, NULL, NULL),
('Congo (Brazzaville)', 5.221, 0.892, 0.622, 0.306, 0.523, 0.124, 0.138),
('Mozambique', 5.216, 0.56, 0.883, 0.156, 0.728, 0.158, 0.196),
('Georgia', 5.185, 1.467, 0.99, 0.524, 0.68, NULL, 0.174),
('Iraq', 5.166, 1.249, 0.996, 0.498, 0.425, 0.141, 0.048),
('Nepal', 5.158, 0.965, 0.99, 0.443, 0.653, 0.209, 0.115),
('Laos', 5.139, 1.208, 0.846, 0.423, 0.796, 0.17, 0.167),
('Gabon', 5.106, 1.403, 1.038, 0.344, 0.516, 0.045, 0.1),
('Ivory Coast', 5.08, 1.08, 0.578, 0.288, 0.547, 0.12, 0.164),
('Guinea', 5.023, 0.831, 0.622, 0.236, 0.521, 0.21, 0.107),
('Turkiye', 4.975, 1.702, 1.175, 0.631, 0.202, 0.068, 0.115),
('Senegal', 4.969, 0.927, 0.751, 0.392, 0.607, 0.152, 0.069),
('Iran', 4.923, 1.435, 1.136, 0.571, 0.366, 0.235, 0.123),
('Azerbaijan', 4.893, 1.433, 0.876, 0.496, 0.668, 0.112, 0.199),
('Nigeria', 4.881, 1.042, 1.075, 0.256, 0.566, 0.201, 0.019),
('State of Palestine', 4.879, NULL, NULL, NULL, NULL, NULL, NULL),
('Cameroon', 4.874, 0.943, 0.856, 0.288, 0.521, 0.126, 0.06),
('Ukraine', 4.873, 1.35, 1.315, 0.513, 0.631, 0.285, 0.025),
('Namibia', 4.832, 1.266, 1.212, 0.307, 0.47, 0.069, 0.061),
('Morocco', 4.795, 1.213, 0.471, 0.495, 0.631, 0.042, 0.082),
('Pakistan', 4.657, 1.069, 0.6, 0.321, 0.542, 0.144, 0.074),
('Niger', 4.556, 0.573, 0.677, 0.293, 0.615, 0.145, 0.147),
('Burkina Faso', 4.548, 0.756, 0.685, 0.274, 0.483, 0.173, 0.179),
('Mauritania', 4.505, 1.078, 0.705, 0.4, 0.343, 0.133, 0.198),
('Gambia', 4.485, 0.75, 0.684, 0.33, 0.459, 0.324, 0.048),
('Chad', 4.471, 0.603, 0.805, 0.199, 0.411, 0.218, 0.113),
('Kenya', 4.47, 1.037, 0.895, 0.353, 0.519, 0.282, 0.069),
('Tunisia', 4.422, 1.306, 0.955, 0.579, 0.254, 0.024, 0.018),
('Benin', 4.377, 0.914, 0.128, 0.284, 0.567, 0.112, 0.252),
('Uganda', 4.372, 0.772, 1.151, 0.373, 0.587, 0.178, 0.054),
('Myanmar', 4.354, 0.978, 0.988, 0.436, 0.45, 0.401, 0.174),
('Cambodia', 4.341, 1.011, 1.019, 0.442, 0.863, 0.17, 0.071),
('Ghana', 4.289, 1.077, 0.747, 0.36, 0.623, 0.183, 0.028),
('Liberia', 4.269, 0.619, 0.673, 0.301, 0.546, 0.178, 0.075),
('Mali', 4.232, 0.747, 0.688, 0.267, 0.586, 0.12, 0.09),
('Madagascar', 4.228, 0.628, 0.823, 0.333, 0.25, 0.172, 0.123),
('Togo', 4.214, 0.758, 0.586, 0.32, 0.453, 0.127, 0.156),
('Jordan', 4.186, 1.262, 0.983, 0.594, 0.593, 0.059, 0.189),
('India', 4.054, 1.166, 0.653, 0.417, 0.767, 0.174, 0.122),
('Egypt', 3.977, 1.37, 0.996, 0.488, 0.49, 0.025, 0.259),
('Sri Lanka', 3.898, 1.361, 1.179, 0.586, 0.583, 0.144, 0.031),
('Bangladesh', 3.886, 1.122, 0.249, 0.513, 0.775, 0.14, 0.167),
('Ethiopia', 3.861, 0.792, 0.915, 0.42, 0.441, 0.27, 0.101),
('Tanzania', 3.781, 0.82, 0.706, 0.38, 0.709, 0.191, 0.257),
('Comoros', 3.566, 0.896, 0.328, 0.37, 0.172, 0.128, 0.16),
('Yemen', 3.561, 0.671, 1.281, 0.293, 0.362, 0.08, 0.113),
('Zambia', 3.502, 0.899, 0.809, 0.264, 0.727, 0.168, 0.109),
('Eswatini', 3.502, 1.255, 0.925, 0.176, 0.284, 0.059, 0.116),
('Malawi', 3.421, 0.617, 0.41, 0.349, 0.571, 0.135, 0.136),
('Botswana', 3.383, 1.445, 0.969, 0.241, 0.567, 0.014, 0.082),
('Zimbabwe', 3.341, 0.748, 0.85, 0.232, 0.487, 0.096, 0.131),
('Congo (Kinshasa)', 3.295, 0.534, 0.665, 0.262, 0.473, 0.189, 0.072),
('Sierra Leone', 3.245, 0.654, 0.566, 0.253, 0.469, 0.181, 0.053),
('Lesotho', 3.186, 0.771, 0.851, NULL, 0.523, 0.082, 0.085),
('Lebanon', 2.707, 1.377, 0.577, 0.556, 0.173, 0.068, 0.029),
('Afghanistan', 1.721, 0.628, NULL, 0.242, NULL, 0.091, 0.088);

--
-- Insert data into table `country_stats`
--

INSERT INTO country_stats (country, continent, population, urban_population, land_area_km2,
                           unemployment_rate, fertility_rate, infant_mortality,
                           life_expectancy, physicians_per_thousand) VALUES
('Afghanistan', 'Asia', 38041754, 9797273, 652230, 0.11, 4.47, 47.9, 64.5, 0.28),
('Albania', 'Europe', 2854191, 1747593, 28748, 0.12, 1.62, 7.8, 78.5, 1.2),
('Algeria', 'Africa', 43053054, 31510100, 2381741, 0.12, 3.02, 20.1, 76.7, 1.72),
('Andorra', 'Europe', 77142, 67873, 468, NULL, 1.27, 2.7, NULL, 3.33),
('Angola', 'Africa', 31825295, 21061025, 1246700, 0.07, 5.52, 51.6, 60.8, 0.21),
('Antigua and Barbuda', 'North America', 97118, 23800, 443, NULL, 1.99, 5, 76.9, 2.76),
('Argentina', 'South America', 44938712, 41339571, 2780400, 0.1, 2.26, 8.8, 76.5, 3.96),
('Armenia', 'Asia', 2957731, 1869848, 29743, 0.17, 1.76, 11, 74.9, 4.4),
('Australia', 'Australia/Oceania', 25766605, 21844756, 7741220, 0.05, 1.74, 3.1, 82.7, 3.68),
('Austria', 'Europe', 8877067, 5194416, 83871, 0.05, 1.47, 2.9, 81.6, 5.17),
('Azerbaijan', 'Asia', 10023318, 5616165, 86600, 0.06, 1.73, 19.2, 72.9, 3.45),
('The Bahamas', 'North America', 389482, 323784, 13880, 0.1, 1.75, 8.3, 73.8, 1.94),
('Bahrain', 'Asia', 1501635, 1467109, 765, 0.01, 1.99, 6.1, 77.2, 0.93),
('Bangladesh', 'Asia', 167310838, 60987417, 148460, 0.04, 2.04, 25.1, 72.3, 0.58),
('Barbados', 'North America', 287025, 89431, 430, 0.1, 1.62, 11.3, 79.1, 2.48),
('Belarus', 'Europe', 9466856, 7482982, 207600, 0.05, 1.45, 2.6, 74.2, 5.19),
('Belgium', 'Europe', 11484055, 11259082, 30528, 0.06, 1.62, 2.9, 81.6, 3.07),
('Belize', 'North America', 390353, 179039, 22966, 0.06, 2.31, 11.2, 74.5, 1.12),
('Benin', 'Africa', 11801151, 5648149, 112622, 0.02, 4.84, 60.5, 61.5, 0.08),
('Bhutan', 'Asia', 727145, 317538, 38394, 0.02, 1.98, 24.8, 71.5, 0.42),
('Bolivia', 'South America', 11513100, 8033035, 1098581, 0.04, 2.73, 21.8, 71.2, 1.59),
('Bosnia and Herzegovina', 'Europe', 3301000, 1605144, 51197, 0.18, 1.27, 5, 77.3, 2.16),
('Botswana', 'Africa', 2346179, 1616550, 581730, 0.18, 2.87, 30, 69.3, 0.37),
('Brazil', 'South America', 212559417, 183241641, 8515770, 0.12, 1.73, 12.8, 75.7, 2.15),
('Brunei', 'Asia', 433285, 337711, 5765, 0.09, 1.85, 9.8, 75.7, 1.61),
('Bulgaria', 'Europe', 6975761, 5256027, 110879, 0.04, 1.56, 5.9, 74.9, 4.03),
('Burkina Faso', 'Africa', 20321378, 6092349, 274200, 0.06, 5.19, 49, 61.2, 0.08),
('Burundi', 'Africa', 11530580, 1541177, 27830, 0.01, 5.41, 41, 61.2, 0.1),
('Ivory Coast (Cote d''Ivoire)', 'Africa', 25716544, 13176900, 322463, 0.03, 4.65, 59.4, 57.4, 0.23),
('Cape Verde', 'Africa', 483628, 364029, 4033, 0.12, 2.27, 16.7, 72.8, 0.77),
('Cambodia', 'Asia', 16486542, 3924621, 181035, 0.01, 2.5, 24, 69.6, 0.17),
('Cameroon', 'Africa', 25876380, 14741256, 475440, 0.03, 4.57, 50.6, 58.9, 0.09),
('Canada', 'North America', 36991981, 30628482, 9984670, 0.06, 1.5, 4.3, 81.9, 2.61),
('Central African Republic', 'Africa', 4745185, 1982064, 622984, 0.04, 4.72, 84.5, 52.8, 0.06),
('Chad', 'Africa', 15946876, 3712273, 1284000, 0.02, 5.75, 71.4, 54, 0.04),
('Chile', 'South America', 18952038, 16610135, 756096, 0.07, 1.65, 6.2, 80, 2.59),
('China', 'Asia', 1397715000, 842933962, 9596960, 0.04, 1.69, 7.4, 77, 1.98),
('Colombia', 'South America', 50339443, 40827302, 1138910, 0.1, 1.81, 12.2, 77.1, 2.18),
('Comoros', 'Africa', 850886, 248152, 2235, 0.04, 4.21, 51.3, 64.1, 0.27),
('Republic of the Congo', 'Africa', 5380508, 3625010, 342000, 0.09, 4.43, 36.2, 64.3, 0.12),
('Costa Rica', 'North America', 5047561, 4041885, 51100, 0.12, 1.75, 7.6, 80.1, 2.89),
('Croatia', 'Europe', 4067500, 2328318, 56594, 0.07, 1.47, 4, 78.1, 3),
('Cuba', 'North America', 11333483, 8739135, 110860, 0.02, 1.62, 3.7, 78.7, 8.42),
('Cyprus', 'Asia', 1198575, 800708, 9251, 0.07, 1.33, 1.9, 80.8, 1.95),
('Czech Republic', 'Europe', 10669709, 7887156, 78867, 0.02, 1.69, 2.7, 79, 4.12),
('Democratic Republic of the Congo', 'Africa', 86790567, 39095679, 2344858, 0.04, 5.92, 68.2, 60.4, 0.07),
('Denmark', 'Europe', 5818553, 5119978, 43094, 0.05, 1.73, 3.6, 81, 4.01),
('Djibouti', 'Africa', 973560, 758549, 23200, 0.1, 2.73, 49.8, 66.6, 0.22),
('Dominica', 'North America', 71808, 50830, 751, NULL, 1.9, 32.9, 76.6, 1.08),
('Dominican Republic', 'North America', 10738958, 8787475, 48670, 0.06, 2.35, 24.1, 73.9, 1.56),
('Ecuador', 'South America', 17373662, 11116711, 283561, 0.04, 2.43, 12.2, 76.8, 2.04),
('Egypt', 'Africa', 100388073, 42895824, 1001450, 0.11, 3.33, 18.1, 71.8, 0.45),
('El Salvador', 'North America', 6453553, 4694702, 21041, 0.04, 2.04, 11.8, 73.1, 1.57),
('Equatorial Guinea', 'Africa', 1355986, 984812, 28051, 0.06, 4.51, 62.6, 58.4, 0.4),
('Eritrea', 'Africa', 6333135, 1149670, 117600, 0.05, 4.06, 31.3, 65.9, 0.06),
('Estonia', 'Europe', 1331824, 916024, 45228, 0.05, 1.59, 2.1, 78.2, 4.48),
('Eswatini', 'Africa', 1093238, NULL, 17364, NULL, NULL, NULL, NULL, NULL),
('Ethiopia', 'Africa', 112078730, 23788710, 1104300, 0.02, 4.25, 39.1, 66.2, 0.08),
('Fiji', 'Australia/Oceania', 889953, 505048, 18274, 0.04, 2.77, 21.6, 67.3, 0.84),
('Finland', 'Europe', 5520314, 4716888, 338145, 0.07, 1.41, 1.4, 81.7, 3.81),
('France', 'Europe', 67059887, 54123364, 643801, 0.08, 1.88, 3.4, 82.5, 3.27),
('Gabon', 'Africa', 2172579, 1949694, 267667, 0.2, 3.97, 32.7, 66.2, 0.68),
('The Gambia', 'Africa', 2347706, 1453958, 11300, 0.09, 5.22, 39, 61.7, 0.1),
('Georgia', 'Asia', 3720382, 2196476, 69700, 0.14, 2.06, 8.7, 73.6, 7.12),
('Germany', 'Europe', 83132799, 64324835, 357022, 0.03, 1.56, 3.1, 80.9, 4.25),
('Ghana', 'Africa', 30792608, 17249054, 238533, 0.04, 3.87, 34.9, 63.8, 0.14),
('Greece', 'Europe', 10716322, 8507474, 131957, 0.17, 1.35, 3.6, 81.3, 5.48),
('Grenada', 'North America', 112003, 40765, 349, NULL, 2.06, 13.7, 72.4, 1.41),
('Guatemala', 'North America', 16604026, 8540945, 108889, 0.02, 2.87, 22.1, 74.1, 0.35),
('Guinea', 'Africa', 12771246, 4661505, 245857, 0.04, 4.7, 64.9, 61.2, 0.08),
('Guinea-Bissau', 'Africa', 1920922, 840922, 36125, 0.02, 4.48, 54, 58, 0.13),
('Guyana', 'South America', 782766, 208912, 214969, 0.12, 2.46, 25.1, 69.8, 0.8),
('Haiti', 'North America', 11263077, 6328948, 27750, 0.14, 2.94, 49.5, 63.7, 0.23),
('Vatican City', 'Europe', 836, NULL, 0, NULL, NULL, NULL, NULL, NULL),
('Honduras', 'North America', 9746117, 5626433, 112090, 0.05, 2.46, 15.1, 75.1, 0.31),
('Hungary', 'Europe', 9769949, 6999582, 93028, 0.03, 1.54, 3.6, 75.8, 3.41),
('Iceland', 'Europe', 361313, 339110, 103000, 0.03, 1.71, 1.5, 82.7, 4.08),
('India', 'Asia', 1366417754, 471031528, 3287263, 0.05, 2.22, 29.9, 69.4, 0.86),
('Indonesia', 'Asia', 270203917, 151509724, 1904569, 0.05, 2.31, 21.1, 71.5, 0.43),
('Iran', 'Asia', 82913906, 62509623, 1648195, 0.11, 2.14, 12.4, 76.5, 1.58),
('Iraq', 'Asia', 39309783, 27783368, 438317, 0.13, 3.67, 22.5, 70.5, 0.71),
('Republic of Ireland', 'Europe', 5007069, 3133123, 70273, 0.05, 1.75, 3.1, 82.3, 3.31),
('Israel', 'Asia', 9053300, 8374393, 20770, 0.04, 3.09, 3, 82.8, 4.62),
('Italy', 'Europe', 60297396, 42651966, 301340, 0.1, 1.29, 2.6, 82.9, 3.98),
('Jamaica', 'North America', 2948279, 1650594, 10991, 0.08, 1.98, 12.4, 74.4, 1.31),
('Japan', 'Asia', 126226568, 115782416, 377944, 0.02, 1.42, 1.8, 84.2, 2.41),
('Jordan', 'Asia', 10101694, 9213048, 89342, 0.15, 2.76, 13.9, 74.4, 2.32),
('Kazakhstan', 'Asia', 18513930, 10652915, 2724900, 0.05, 2.84, 8.8, 73.2, 3.25),
('Kenya', 'Africa', 52573973, 14461523, 580367, 0.03, 3.49, 30.6, 66.3, 0.16),
('Kiribati', 'Australia/Oceania', 117606, 64489, 811, NULL, 3.57, 41.2, 68.1, 0.2),
('Kuwait', 'Asia', 4207083, 4207083, 17818, 0.02, 2.08, 6.7, 75.4, 2.58),
('Kyrgyzstan', 'Asia', 6456900, 2362644, 199951, 0.06, 3.3, 16.9, 71.4, 1.88),
('Laos', 'Asia', 7169455, 2555552, 236800, 0.01, 2.67, 37.6, 67.6, 0.37),
('Latvia', 'Europe', 1912789, 1304943, 64589, 0.07, 1.6, 3.3, 74.7, 3.19),
('Lebanon', 'Asia', 6855713, 6084994, 10400, 0.06, 2.09, 6.4, 78.9, 2.1),
('Lesotho', 'Africa', 2125268, 607508, 30355, 0.23, 3.14, 65.7, 53.7, 0.07),
('Liberia', 'Africa', 4937374, 2548426, 111369, 0.03, 4.32, 53.5, 63.7, 0.04),
('Libya', 'Africa', 6777452, 5448597, 1759540, 0.19, 2.24, 10.2, 72.7, 2.09),
('Liechtenstein', 'Europe', 38019, 5464, 160, NULL, 1.44, NULL, 83, NULL),
('Lithuania', 'Europe', 2786844, 1891013, 65300, 0.06, 1.63, 3.3, 75.7, 6.35),
('Luxembourg', 'Europe', 645397, 565488, 2586, 0.05, 1.37, 1.9, 82.1, 3.01),
('Madagascar', 'Africa', 26969307, 10210849, 587041, 0.02, 4.08, 38.2, 66.7, 0.18),
('Malawi', 'Africa', 18628747, 3199301, 118484, 0.06, 4.21, 35.3, 63.8, 0.04),
('Malaysia', 'Asia', 32447385, 24475766, 329847, 0.03, 2, 6.7, 76, 1.51),
('Maldives', 'Asia', 530953, 213645, 298, 0.06, 1.87, 7.4, 78.6, 4.56),
('Mali', 'Africa', 19658031, 8479688, 1240192, 0.07, 5.88, 62, 58.9, 0.13),
('Malta', 'Europe', 502653, 475902, 316, 0.03, 1.23, 6.1, 82.3, 2.86),
('Marshall Islands', 'Australia/Oceania', 58791, 45514, 181, NULL, 4.05, 27.4, 65.2, 0.42),
('Mauritania', 'Africa', 4525696, 2466821, 1030700, 0.1, 4.56, 51.5, 64.7, 0.19),
('Mauritius', 'Africa', 1265711, 515980, 2040, 0.07, 1.41, 13.6, 74.4, 2.53),
('Mexico', 'North America', 126014024, 102626859, 1964375, 0.03, 2.13, 11, 75, 2.38),
('Federated States of Micronesia', 'Australia/Oceania', 113815, 25963, 702, NULL, 3.05, 25.6, 67.8, 0.18),
('Moldova', 'Europe', 2657637, 1135502, 33851, 0.05, 1.26, 13.6, 71.8, 3.21),
('Monaco', 'Europe', 38964, 38964, 2, NULL, NULL, 2.6, NULL, 6.56),
('Mongolia', 'Asia', 3225167, 2210626, 1564116, 0.06, 2.9, 14, 69.7, 2.86),
('Montenegro', 'Europe', 622137, 417765, 13812, 0.15, 1.75, 2.3, 76.8, 2.76),
('Morocco', 'Africa', 36910560, 22975026, 446550, 0.09, 2.42, 19.2, 76.5, 0.73),
('Mozambique', 'Africa', 30366036, 11092106, 799380, 0.03, 4.85, 54, 60.2, 0.08),
('Myanmar', 'Asia', 54045420, 16674093, 676578, 0.02, 2.15, 36.8, 66.9, 0.68),
('Namibia', 'Africa', 2494530, 1273258, 824292, 0.2, 3.4, 29, 63.4, 0.42),
('Nauru', 'Australia/Oceania', 10084, NULL, 21, NULL, NULL, NULL, NULL, NULL),
('Nepal', 'Asia', 28608710, 5765513, 147181, 0.01, 1.92, 26.7, 70.5, 0.75),
('Netherlands', 'Europe', 17332850, 15924729, 41543, 0.03, 1.59, 3.3, 81.8, 3.61),
('New Zealand', 'Australia/Oceania', 4841000, 4258860, 268838, 0.04, 1.71, 4.7, 81.9, 3.59),
('Nicaragua', 'North America', 6545502, 3846137, 130370, 0.07, 2.4, 15.7, 74.3, 0.98),
('Niger', 'Africa', 23310715, 3850231, 1267000, 0, 6.91, 48, 62, 0.04),
('Nigeria', 'Africa', 200963599, 102806948, 923768, 0.08, 5.39, 75.7, 54.3, 0.38),
('North Korea', 'Asia', 25666161, 15947412, 120538, 0.03, 1.9, 13.7, 72.1, 3.67),
('North Macedonia', 'Europe', 1836713, NULL, 25713, NULL, NULL, NULL, NULL, NULL),
('Norway', 'Europe', 5347896, 4418218, 323802, 0.03, 1.56, 2.1, 82.8, 2.92),
('Oman', 'Asia', 5266535, 4250777, 309500, 0.03, 2.89, 9.8, 77.6, 2),
('Pakistan', 'Asia', 216565318, 79927762, 796095, 0.04, 3.51, 57.2, 67.1, 0.98),
('Palau', 'Australia/Oceania', 18233, 14491, 459, NULL, 2.21, 16.6, 69.1, 1.18),
('Palestinian National Authority', 'Asia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('Panama', 'North America', 4246439, 2890084, 75420, 0.04, 2.46, 13.1, 78.3, 1.57),
('Papua New Guinea', 'Australia/Oceania', 8776109, 1162834, 462840, 0.02, 3.56, 38, 64.3, 0.07),
('Paraguay', 'South America', 7044636, 4359150, 406752, 0.05, 2.43, 17.2, 74.1, 1.35),
('Peru', 'South America', 32510453, 25390339, 1285216, 0.03, 2.25, 11.1, 76.5, 1.27),
('Philippines', 'Asia', 108116615, 50975903, 300000, 0.02, 2.58, 22.5, 71.1, 0.6),
('Poland', 'Europe', 37970874, 22796574, 312685, 0.03, 1.46, 3.8, 77.6, 2.38),
('Portugal', 'Europe', 10269417, 6753579, 92212, 0.06, 1.38, 3.1, 81.3, 5.12),
('Qatar', 'Asia', 2832067, 2809071, 11586, 0, 1.87, 5.8, 80.1, 2.49),
('Romania', 'Europe', 19356544, 10468793, 238391, 0.04, 1.71, 6.1, 75.4, 2.98),
('Russia', 'Europe/Asia', 144373535, 107683889, 17098240, 0.05, 1.57, 6.1, 72.7, 4.01),
('Rwanda', 'Africa', 12626950, 2186104, 26338, 0.01, 4.04, 27, 68.7, 0.13),
('Saint Kitts and Nevis', 'North America', 52823, 16269, 261, NULL, 2.11, 9.8, 71.3, 2.52),
('Saint Lucia', 'North America', 182790, 34280, 616, 0.21, 1.44, 14.9, 76.1, 0.64),
('Saint Vincent and the Grenadines', 'North America', 100455, 58185, 389, 0.19, 1.89, 14.8, 72.4, 0.66),
('Samoa', 'Australia/Oceania', 202506, 35588, 2831, 0.08, 3.88, 13.6, 73.2, 0.34),
('San Marino', 'Europe', 33860, 32969, 61, NULL, 1.26, 1.7, 85.4, 6.11),
('Sao Tome and Principe', 'Africa', 215056, 158277, 964, 0.13, 4.32, 24.4, 70.2, 0.05),
('Saudi Arabia', 'Asia', 34268528, 28807838, 2149690, 0.06, 2.32, 6, 75, 2.61),
('Senegal', 'Africa', 16296364, 7765706, 196722, 0.07, 4.63, 31.8, 67.7, 0.07),
('Serbia', 'Europe', 6944975, 3907243, 77474, 0.13, 1.49, 4.8, 75.5, 3.11),
('Seychelles', 'Africa', 97625, 55762, 455, NULL, 2.41, 12.4, 72.8, 0.95),
('Sierra Leone', 'Africa', 7813215, 3319366, 71740, 0.04, 4.26, 78.5, 54.3, 0.03),
('Singapore', 'Asia', 5703569, 5703569, 716, 0.04, 1.14, 2.3, 83.1, 2.29),
('Slovakia', 'Europe', 5454073, 2930419, 49035, 0.06, 1.52, 4.6, 77.2, 3.42),
('Slovenia', 'Europe', 2087946, 1144654, 20273, 0.04, 1.6, 1.7, 81, 3.09),
('Solomon Islands', 'Australia/Oceania', 669823, 162164, 28896, 0.01, 4.4, 17.1, 72.8, 0.19),
('Somalia', 'Africa', 15442905, 7034861, 637657, 0.11, 6.07, 76.6, 57.1, 0.02),
('South Africa', 'Africa', 58558270, 39149717, 1219090, 0.28, 2.41, 28.5, 63.9, 0.91),
('South Korea', 'Asia', 51709098, 42106719, 99720, 0.04, 0.98, 2.7, 82.6, 2.36),
('South Sudan', 'Africa', 11062113, 2201250, 644329, 0.12, 4.7, 63.7, 57.6, NULL),
('Spain', 'Europe', 47076781, 37927409, 505370, 0.14, 1.26, 2.5, 83.3, 3.87),
('Sri Lanka', 'Asia', 21803000, 4052088, 65610, 0.04, 2.2, 6.4, 76.8, 1),
('Sudan', 'Africa', 42813238, 14957233, 1861484, 0.17, 4.41, 42.1, 65.1, 0.26),
('Suriname', 'South America', 581372, 384258, 163820, 0.07, 2.42, 16.9, 71.6, 1.21),
('Sweden', 'Europe', 10285453, 9021165, 450295, 0.06, 1.76, 2.2, 82.5, 3.98),
('Switzerland', 'Europe', 8574832, 6332428, 41277, 0.05, 1.52, 3.7, 83.6, 4.3),
('Syria', 'Asia', 17070135, 9358019, 185180, 0.08, 2.81, 14, 71.8, 1.22),
('Tajikistan', 'Asia', 9321018, 2545477, 144100, 0.11, 3.59, 30.4, 70.9, 1.7),
('Tanzania', 'Africa', 58005463, 20011885, 947300, 0.02, 4.89, 37.6, 65, 0.01),
('Thailand', 'Asia', 69625582, 35294600, 513120, 0.01, 1.53, 7.8, 76.9, 0.81),
('East Timor', 'Asia', 3500000, 400182, 14874, 0.05, 4.02, 39.3, 69.3, 0.72),
('Togo', 'Africa', 8082366, 3414638, 56785, 0.02, 4.32, 47.4, 60.8, 0.08),
('Tonga', 'Australia/Oceania', 100209, 24145, 747, 0.01, 3.56, 13.4, 70.8, 0.52),
('Trinidad and Tobago', 'North America', 1394973, 741944, 5128, 0.03, 1.73, 16.4, 73.4, 4.17),
('Tunisia', 'Africa', 11694719, 8099061, 163610, 0.16, 2.2, 14.6, 76.5, 1.3),
('Turkey', 'Europe/Asia', 83429615, 63097818, 783562, 0.13, 2.07, 9.1, 77.4, 1.85),
('Turkmenistan', 'Asia', 5942089, 3092738, 488100, 0.04, 2.79, 39.3, 68.1, 2.22),
('Tuvalu', 'Australia/Oceania', 11646, 7362, 26, NULL, NULL, 20.6, NULL, 0.92),
('Uganda', 'Africa', 44269594, 10784516, 241038, 0.02, 4.96, 33.8, 63, 0.17),
('Ukraine', 'Europe', 44385155, 30835699, 603550, 0.09, 1.3, 7.5, 71.6, 2.99),
('United Arab Emirates', 'Asia', 9770529, 8479744, 83600, 0.02, 1.41, 6.5, 77.8, 2.53),
('United Kingdom', 'Europe', 66834405, 55908316, 243610, 0.04, 1.68, 3.6, 81.3, 2.81),
('United States', 'North America', 328239523, 270663028, 9833517, 0.15, 1.73, 5.6, 78.5, 2.61),
('Uruguay', 'South America', 3461734, 3303394, 176215, 0.09, 1.97, 6.4, 77.8, 5.05),
('Uzbekistan', 'Asia', 33580650, 16935729, 447400, 0.06, 2.42, 19.1, 71.6, 2.37),
('Vanuatu', 'Australia/Oceania', 299882, 76152, 12189, 0.04, 3.78, 22.3, 70.3, 0.17),
('Venezuela', 'South America', 28515829, 25162368, 912050, 0.09, 2.27, 21.4, 72.1, 1.92),
('Vietnam', 'Asia', 96462106, 35332140, 331210, 0.02, 2.05, 16.5, 75.3, 0.82),
('Yemen', 'Asia', 29161922, 10869523, 527968, 0.13, 3.79, 42.9, 66.1, 0.31),
('Zambia', 'Africa', 17861030, 7871713, 752618, 0.11, 4.63, 40.4, 63.5, 1.19),
('Zimbabwe', 'Africa', 14645468, 4717305, 390757, 0.05, 3.62, 33.9, 61.2, 0.21);

--
-- Insert data into table `inflation_rates`
--

INSERT INTO inflation_rates (year, country_name, inflation_rate) VALUES
(2015, 'China', 1.4),
(2015, 'India', 4.9),
(2015, 'United States', 0.1),
(2015, 'Indonesia', 6.4),
(2015, 'Pakistan', 4.5),
(2015, 'Brazil', 9),
(2015, 'Nigeria', 9),
(2015, 'Bangladesh', 6.1),
(2015, 'Russia', 15.5),
(2015, 'Mexico', 2.1),
(2015, 'Japan', 0.8),
(2015, 'Ethiopia', 6.1),
(2015, 'Philippines', 1.4),
(2015, 'Vietnam', 0.6),
(2015, 'DR Congo', 1.6),
(2015, 'Turkey', 7.6),
(2015, 'Iran', 14.6),
(2015, 'Germany', 0.3),
(2015, 'Thailand', -0.9),
(2015, 'United Kingdom', 0.1),
(2015, 'France', 0.1),
(2016, 'China', 2),
(2016, 'India', 4.5),
(2016, 'United States', 1.3),
(2016, 'Indonesia', 3.5),
(2016, 'Pakistan', 3.8),
(2016, 'Brazil', 8.7),
(2016, 'Nigeria', 15.7),
(2016, 'Bangladesh', 5.5),
(2016, 'Russia', 7.1),
(2016, 'Mexico', 2.8),
(2016, 'Japan', -0.1),
(2016, 'Ethiopia', 8.5),
(2016, 'Philippines', 1.3),
(2016, 'Vietnam', 2.7),
(2016, 'DR Congo', 3.2),
(2016, 'Turkey', 7.8),
(2016, 'Iran', 9.6),
(2016, 'Germany', 0.5),
(2016, 'Thailand', 0.2),
(2016, 'United Kingdom', 0.5),
(2016, 'France', 0.3),
(2017, 'China', 1.6),
(2017, 'India', 3.3),
(2017, 'United States', 2.1),
(2017, 'Indonesia', 3.8),
(2017, 'Pakistan', 4),
(2017, 'Brazil', 3.4),
(2017, 'Nigeria', 16.5),
(2017, 'Bangladesh', 6.3),
(2017, 'Russia', 3.7),
(2017, 'Mexico', 6),
(2017, 'Japan', 0.5),
(2017, 'Ethiopia', 9),
(2017, 'Philippines', 2.6),
(2017, 'Vietnam', 3.5),
(2017, 'DR Congo', 1.5),
(2017, 'Turkey', 11.1),
(2017, 'Iran', 9.6),
(2017, 'Germany', 1.5),
(2017, 'Thailand', 0.9),
(2017, 'United Kingdom', 2.7),
(2017, 'France', 1),
(2018, 'China', 2.1),
(2018, 'India', 3.4),
(2018, 'United States', 2.4),
(2018, 'Indonesia', 3.2),
(2018, 'Pakistan', 3.9),
(2018, 'Brazil', 3.7),
(2018, 'Nigeria', 12.1),
(2018, 'Bangladesh', 5.6),
(2018, 'Russia', 2.9),
(2018, 'Mexico', 4.9),
(2018, 'Japan', 0.9),
(2018, 'Ethiopia', 13),
(2018, 'Philippines', 5.2),
(2018, 'Vietnam', 3.5),
(2018, 'DR Congo', 1),
(2018, 'Turkey', 16.3),
(2018, 'Iran', 31.2),
(2018, 'Germany', 1.9),
(2018, 'Thailand', 1.1),
(2018, 'United Kingdom', 2.5),
(2018, 'France', 1.8),
(2019, 'China', 2.9),
(2019, 'India', 3.7),
(2019, 'United States', 1.8),
(2019, 'Indonesia', 3),
(2019, 'Pakistan', 6.8),
(2019, 'Brazil', 3.7),
(2019, 'Nigeria', 11.4),
(2019, 'Bangladesh', 5.6),
(2019, 'Russia', 3),
(2019, 'Mexico', 3.6),
(2019, 'Japan', 0.5),
(2019, 'Ethiopia', 10.8),
(2019, 'Philippines', 2.5),
(2019, 'Vietnam', 2.8),
(2019, 'DR Congo', 0.8),
(2019, 'Turkey', 15.2),
(2019, 'Iran', 37),
(2019, 'Germany', 1.4),
(2019, 'Thailand', 0.7),
(2019, 'United Kingdom', 1.8),
(2019, 'France', 1.1),
(2020, 'China', 2.4),
(2020, 'India', 6.6),
(2020, 'United States', 1.2),
(2020, 'Indonesia', 1.6),
(2020, 'Pakistan', 10.7),
(2020, 'Brazil', 3.2),
(2020, 'Nigeria', 13.2),
(2020, 'Bangladesh', 5.7),
(2020, 'Russia', 3.4),
(2020, 'Mexico', 3.3),
(2020, 'Japan', 0),
(2020, 'Ethiopia', 20.5),
(2020, 'Philippines', 2.6),
(2020, 'Vietnam', 3.2),
(2020, 'DR Congo', 11.3),
(2020, 'Turkey', 12.3),
(2020, 'Iran', 36.5),
(2020, 'Germany', 0.4),
(2020, 'Thailand', -0.8),
(2020, 'United Kingdom', 0.9),
(2020, 'France', 0.5),
(2021, 'China', 0.9),
(2021, 'India', 5.5),
(2021, 'United States', 7),
(2021, 'Indonesia', 1.6),
(2021, 'Pakistan', 10.9),
(2021, 'Brazil', 8.5),
(2021, 'Nigeria', 16.9),
(2021, 'Bangladesh', 5.6),
(2021, 'Russia', 6.7),
(2021, 'Mexico', 5.4),
(2021, 'Japan', -0.8),
(2021, 'Ethiopia', 34.8),
(2021, 'Philippines', 3.9),
(2021, 'Vietnam', 1.8),
(2021, 'DR Congo', 2.4),
(2021, 'Turkey', 19.6),
(2021, 'Iran', 39.7),
(2021, 'Germany', 2.4),
(2021, 'Thailand', 1.2),
(2021, 'United Kingdom', 2.5),
(2021, 'France', 2.1),
(2022, 'China', 2),
(2022, 'India', 6.7),
(2022, 'United States', 8),
(2022, 'Indonesia', 5.5),
(2022, 'Pakistan', 12),
(2022, 'Brazil', 5.6),
(2022, 'Nigeria', 18.7),
(2022, 'Bangladesh', 6.2),
(2022, 'Russia', 14.6),
(2022, 'Mexico', 7.8),
(2022, 'Japan', 2.4),
(2022, 'Ethiopia', 34.4),
(2022, 'Philippines', 5.8),
(2022, 'Vietnam', 3.1),
(2022, 'DR Congo', 9),
(2022, 'Turkey', 64.3),
(2022, 'Iran', 52.5),
(2022, 'Germany', 8.7),
(2022, 'Thailand', 6.2),
(2022, 'United Kingdom', 9.1),
(2022, 'France', 5.2),
(2023, 'China', 0),
(2023, 'India', 5.2),
(2023, 'United States', 4),
(2023, 'Indonesia', 3.5),
(2023, 'Pakistan', 25),
(2023, 'Brazil', 6),
(2023, 'Nigeria', 23.1),
(2023, 'Bangladesh', 8.7),
(2023, 'Russia', 3),
(2023, 'Mexico', 5.5),
(2023, 'Japan', 2.3),
(2023, 'Ethiopia', 23.1),
(2023, 'Philippines', 5.1),
(2023, 'Vietnam', 3.4),
(2023, 'DR Congo', 8.4),
(2023, 'Turkey', 70),
(2023, 'Iran', 38.2),
(2023, 'Germany', 5.5),
(2023, 'Thailand', 2.4),
(2023, 'United Kingdom', 6.9),
(2023, 'France', 5.8);

-- SECTIONS 2-6: ASSIGNMENTS

--
-- Table structure for table `orders`
--

CREATE TABLE orders (
    transaction_id CHAR(6) PRIMARY KEY,
    customer_id INT,
    order_id VARCHAR(20),
    order_date DATE,
    product_id VARCHAR(20),
    units INT
);

--
-- Table structure for table `customers`
--

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    city VARCHAR(50),
    state_province VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50)
);

--
-- Table structure for table `products`
--

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    factory VARCHAR(100),
    division VARCHAR(50),
    unit_price DECIMAL(10, 2)
);

--
-- Insert data into table `orders`
--

Bulk insert orders
from "C:\Users\DELL\Downloads\Advanced+SQL+Querying\Course Materials\Data\orders.csv"
With (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK);


-- Insert data into table `customers`

Bulk insert customers
from "C:\Users\DELL\Downloads\Advanced+SQL+Querying\Course Materials\Data\customers.csv"
with(
	FIRSTROW = 2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='\n',
	TABLOCK);
	


--
-- Insert data into table `products`
--



INSERT INTO products (product_id, product_name, factory, division, unit_price) VALUES
('CHO-FUD-51000', 'Wonka Bar - Fudge Mallows', 'Lot''s O'' Nuts', 'Chocolate', 3.6),
('CHO-NUT-13000', 'Wonka Bar - Nutty Crunch Surprise', 'Lot''s O'' Nuts', 'Chocolate', 3.49),
('CHO-SCR-58000', 'Wonka Bar - Scrumdiddlyumptious', 'Lot''s O'' Nuts', 'Chocolate', 3.6),
('CHO-MIL-31000', 'Wonka Bar - Milk Chocolate', 'Wicked Choccy''s', 'Chocolate', 3.25),
('CHO-TRI-54000', 'Wonka Bar - Triple Dazzle Caramel', 'Wicked Choccy''s', 'Chocolate', 3.75),
('SUG-EVE-47000', 'Everlasting Gobstopper', 'Secret Factory', 'Sugar', 10),
('SUG-FUN-75000', 'Fun Dip', 'Sugar Shack', 'Sugar', 1.5),
('SUG-LAF-25000', 'Laffy Taffy', 'Sugar Shack', 'Sugar', 1.99),
('SUG-LOO-45000', 'Loopy Lollipops', 'Sugar Shack', 'Sugar', 2.75),
('SUG-PIX-62000', 'Pixy Stix', 'Sugar Shack', 'Sugar', 1.25),
('SUG-NER-92000', 'Nerds', 'Sugar Shack', 'Sugar', 1.5),
('SUG-NER-92001', 'Tropical Nerds', 'Sugar Shack', 'Other', NULL),
('SUG-HAI-55000', 'Hair Toffee', 'The Other Factory', 'Sugar', 4.5),
('SUG-SWE-91000', 'SweeTARTS', 'Sugar Shack', 'Sugar', 1.5),
('OTH-GUM-21000', 'Wonka Gum', 'Secret Factory', 'Other', 1.25),
('OTH-LIC-15000', 'Lickable Wallpaper', 'Secret Factory', 'Other', 20),
('OTH-FIZ-56000', 'Fizzy Lifting Drinks', 'Sugar Shack', NULL, 3.75),
('OTH-KAZ-38000', 'Kazookles', 'The Other Factory', NULL, 3.25);

--
-- Table structure for table `student_grades`
--

CREATE TABLE student_grades (
    semester_id CHAR(5),
    class_id INT,
    department VARCHAR(50),
    class_name VARCHAR(50),
    student_id INT,
    final_grade INT,
    PRIMARY KEY (class_id, student_id)
);

--
-- Insert data into table `student_grades`
--

INSERT INTO student_grades (semester_id, class_id, department,
                            class_name, student_id, final_grade) VALUES
('F2024', 101, 'Math', 'Algebra', 4, 85),
('F2024', 101, 'Math', 'Algebra', 8, 76),
('F2024', 101, 'Math', 'Algebra', 11, 90),
('F2024', 101, 'Math', 'Algebra', 15, 97),
('F2024', 102, 'Math', 'Geometry', 1, 93),
('F2024', 102, 'Math', 'Geometry', 5, 80),
('F2024', 102, 'Math', 'Geometry', 9, 72),
('F2024', 102, 'Math', 'Geometry', 17, 84),
('F2024', 103, 'Math', 'Statistics', 2, 88),
('F2024', 103, 'Math', 'Statistics', 6, 90),
('F2024', 103, 'Math', 'Statistics', 10, 82),
('F2024', 103, 'Math', 'Statistics', 12, 99),
('F2024', 103, 'Math', 'Statistics', 13, 85),
('F2024', 104, 'Math', 'Calculus', 3, 98),
('F2024', 104, 'Math', 'Calculus', 7, 86),
('F2024', 104, 'Math', 'Calculus', 16, 71),
('F2024', 201, 'Science', 'Biology', 4, 82),
('F2024', 201, 'Science', 'Biology', 8, 72),
('F2024', 201, 'Science', 'Biology', 11, 87),
('F2024', 201, 'Science', 'Biology', 15, 96),
('F2024', 202, 'Science', 'Chemistry', 1, 94),
('F2024', 202, 'Science', 'Chemistry', 2, 88),
('F2024', 202, 'Science', 'Chemistry', 5, 74),
('F2024', 202, 'Science', 'Chemistry', 6, 98),
('F2024', 202, 'Science', 'Chemistry', 9, 76),
('F2024', 202, 'Science', 'Chemistry', 17, 85),
('F2024', 203, 'Science', 'Physics', 3, 95),
('F2024', 203, 'Science', 'Physics', 7, 82),
('F2024', 203, 'Science', 'Physics', 10, 77),
('F2024', 203, 'Science', 'Physics', 12, 96),
('F2024', 203, 'Science', 'Physics', 13, 86),
('F2024', 203, 'Science', 'Physics', 16, 74),
('F2024', 301, 'Humanities', 'English', 1, 82),
('F2024', 301, 'Humanities', 'English', 4, 75),
('F2024', 301, 'Humanities', 'English', 5, 87),
('F2024', 301, 'Humanities', 'English', 8, 80),
('F2024', 301, 'Humanities', 'English', 9, 84),
('F2024', 301, 'Humanities', 'English', 11, 98),
('F2024', 301, 'Humanities', 'English', 15, 99),
('F2024', 301, 'Humanities', 'English', 17, 89),
('F2024', 302, 'Humanities', 'World History', 2, 75),
('F2024', 302, 'Humanities', 'World History', 3, 92),
('F2024', 302, 'Humanities', 'World History', 6, 95),
('F2024', 302, 'Humanities', 'World History', 7, 94),
('F2024', 302, 'Humanities', 'World History', 10, 84),
('F2024', 302, 'Humanities', 'World History', 12, 98),
('F2024', 302, 'Humanities', 'World History', 13, 82),
('F2024', 302, 'Humanities', 'World History', 16, 86),
('F2024', 401, 'General', 'Physical Education', 1, 85),
('F2024', 401, 'General', 'Physical Education', 2, 80),
('F2024', 401, 'General', 'Physical Education', 4, 95),
('F2024', 401, 'General', 'Physical Education', 5, 85),
('F2024', 401, 'General', 'Physical Education', 6, 95),
('F2024', 401, 'General', 'Physical Education', 8, 90),
('F2024', 401, 'General', 'Physical Education', 9, 90),
('F2024', 401, 'General', 'Physical Education', 10, 85),
('F2024', 401, 'General', 'Physical Education', 11, 95),
('F2024', 401, 'General', 'Physical Education', 12, 95),
('F2024', 401, 'General', 'Physical Education', 13, 90),
('F2024', 401, 'General', 'Physical Education', 15, 95),
('F2024', 404, 'General', 'Senior Seminar', 3, NULL),
('F2024', 404, 'General', 'Senior Seminar', 7, NULL),
('F2024', 404, 'General', 'Senior Seminar', 16, NULL),
('F2024', 404, 'General', 'Senior Seminar', 17, NULL);



Select * from students