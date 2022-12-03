CREATE TABLE children_coach(
    max_children_age int
) INHERITS (coach);

INSERT INTO children_coach(passport,birthday,full_name,sport_kind,salary,max_children_age)
VALUES ('passport1', '03-15-1971', 'Malvina Malvina', 2, 3500, 12);

SELECT COUNT(*) FROM coach;

CREATE TABLE subscription_charity(
    charity_name VARCHAR(50),
    charity_value FLOAT
) INHERITS(subscription);

INSERT INTO subscription_charity(name, cost, charity_name, charity_value)
VALUES ('monthly', 150, 'new year monthly 30%', 0.3);

SELECT * FROM ONLY subscription;