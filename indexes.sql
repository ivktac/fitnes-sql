CREATE VIEW coach_groups AS
SELECT full_name,
    passport,
    salary,
    s.name as sport_kind,
    sp.name as sport_place,
    group_id
FROM coach c
    JOIN groups g ON g.coach_passport = c.passport
    JOIN sport_kind s ON c.sport_kind = s.sport_kind_id
    JOIN sport_place sp ON sp.sport_place_id = sport_place;
CREATE VIEW visitor_groups AS
SELECT passport,
    full_name,
    sk.name as sport_kind,
    group_id
FROM visitor v
    JOIN group_visitors gv ON v.passport = gv.visitor_id
    JOIN sport_kind sk ON sk.sport_kind_id = sport_kind;
-- 5. Знаходження усіх груп, серед тих, що утворені, у яких більше 10 людей у порядку спадання.
SELECT group_id,
    COUNT(group_id)
FROM visitor_groups
GROUP BY group_id
HAVING COUNT(passport) < 10
ORDER BY COUNT(passport);
-- 8. Знаходження тренерів, які проводять заняття у групі з плавання
SELECT DISTINCT full_name
FROM coach_groups
WHERE sport_kind = 'Swimming';
-- 7. Вивести список скільки кожен тренер має відвідувачів у порядку спадання
SELECT coach,
    COUNT(visitor)
FROM fitnes_group
GROUP BY group_id,
    coach
ORDER BY COUNT(visitor) DESC;
-- 8. Знаходження тренерів, які мають зарплату більшу ніж середню
SELECT DISTINCT cg1.full_name,
    cg1.salary
FROM coach_groups cg1
WHERE salary > (
        SELECT AVG(salary)
        FROM coach_groups cg2
        WHERE cg2.sport_kind = cg1.sport_kind
    );
--
-- ІНДЕКСИ
---
CREATE INDEX visitor_index ON visitor(sport_kind);
CREATE INDEX coach_index ON coach(sport_kind);
CREATE INDEX payment_index ON payment(visitor_passport) INCLUDE (subscription_id);
CREATE INDEX groups_index ON groups(sport_place) INCLUDE (coach_passport);
CREATE INDEX group_visitors_index ON group_visitors(visitor_id) INCLUDE (group_id);
CREATE INDEX schedule_index ON schedule(group_id);
---
--- Похідні таблиці
---
CREATE TABLE children_coach(max_children_age int) INHERITS (coach);
INSERT INTO children_coach(
        passport,
        birthday,
        full_name,
        sport_kind,
        salary,
        max_children_age
    )
VALUES (
        'passport1',
        '03-15-1971',
        'Malvina Malvina',
        2,
        3500,
        12
    );
SELECT COUNT(*)
FROM coach;
CREATE TABLE subscription_charity(
    charity_name VARCHAR(50),
    charity_value FLOAT
) INHERITS(subscription);
INSERT INTO subscription_charity(name, cost, charity_name, charity_value)
VALUES ('monthly', 150, 'new year monthly 30%', 0.3);
SELECT *
FROM ONLY subscription;