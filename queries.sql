-- 1. Знаходження всі види занять, що проходять у спортзалі
CREATE VIEW groups_coach AS
SELECT sp.name,
  g.coach_passport,
  c.sport_kind
FROM groups g
  JOIN sport_place sp ON g.sport_place = sp.sport_place_id
  JOIN coach c ON g.coach_passport = c.passport
  JOIN sport_kind sk ON gc.sport_kind = sk.sport_kind_id;
SELECT sk.name
FROM groups_coach gc
WHERE gc.name = 'Gym';
-- 1. Знайти тренерів, які мають заняття з йоги впродовж місяця.
CREATE VIEW yoga_coaches AS
SELECT *
FROM coach c
  JOIN groups g ON c.passport = g.coach_passport
  JOIN schedule s ON g.group_id = s.group_id
WHERE s.datetime BETWEEN now()
  AND now() + '1 month'
  AND c.sport_kind = (
    SELECT sport_kind_id
    FROM sport_kind
    WHERE name = 'Yoga'
  );
SELECT *
FROM yoga_coaches;
-- 2. Знайти для кожного тренера, скільки він має оплатити податків за попередній місяць,
-- якщо формула податків: зароблені гроші за заняття з відвідувачів - 5% від зарплати.
CREATE VIEW coach_taxes AS
SELECT c.passport,
  SUM(cost) / salary - salary * 0.05 AS tax
FROM subscription s
  JOIN payment p ON s.subscription_id = p.subscription_id
  JOIN group_visitors gv ON gv.visitor_id = p.visitor_passport
  JOIN groups g ON g.group_id = gv.group_id
  JOIN coach c ON g.coach_passport = c.passport
WHERE p.date BETWEEN now() - INTERVAL '1 month'
  AND now()
  AND tax > 0
GROUP BY c.passport;
SELECT *
FROM coach_taxes;
-- 2.
-- 3. Отримати дохід за минулий місяць
SELECT SUM(cost)
FROM subscription s
  JOIN payment p ON s.subscription_id = p.subscription_id
WHERE p.date BETWEEN now() - INTERVAL '1 month'
  AND now();
-- 3. Знайти максимальну зарплату серед тренерів, якщо їхня загальна сума не кратна двом, інакше мінімальну.
SELECT CASE
    WHEN SUM(salary) % 2 != 0 THEN MAX(salary)
    WHEN SUM(salary) % 2 = 0 THEN MIN(salary)
  END
FROM coach
  JOIN groups ON coach_passport = passport;
-- 4. Знаходження усього заробітку для кожного заняття
CREATE VIEW gain_sport_kind AS
SELECT sk.name,
  SUM(salary)
FROM coach c
  JOIN groups g ON c.passport = g.coach_passport
  JOIN schedule s ON g.group_id = s.group_id
  JOIN sport_kind sk ON c.sport_kind = sk.sport_kind_id
GROUP BY sk.name;
SELECT *
FROM gain_sport_kind;
-- 4. К-сть усіх проведених занять та ранжування кожного тренера за кількістю занять
SELECT c.passport,
  c.full_name,
  gc.cnt do_count,
  RANK() OVER (
    ORDER BY gc.cnt DESC
  ) do_rank
FROM coach c
  JOIN (
    SELECT coach_passport,
      COUNT(*) AS cnt
    FROM groups
    GROUP BY coach_passport
  ) gc ON gc.coach_passport = c.passport;
-- 5. Знаходження усіх груп, серед тих, що утворені, у яких більше 10 людей у порядку спадання.
CREATE VIEW groups_with_more_10_visitors AS
SELECT group_id,
  COUNT(group_id)
FROM group_visitor
GROUP BY group_id
HAVING COUNT(visitor_id) < 10
ORDER BY COUNT(visitor_id);
SELECT *
FROM groups_with_more_10_visitors;
-- 5.  Знайти заробіток для кожного типу підписки
SELECT payment.subscription_id,
  SUM(
    CASE
      WHEN payment.subscription_id = 1 THEN cost * 30
      WHEN payment.subscription_id = 2 THEN cost * 365
      WHEN payment.subscription_id = 3 THEN cost
      ELSE 0
    END
  )
FROM payment
  INNER JOIN subscription ON payment.subscription_id = subscription.subscription_id
GROUP BY payment.subscription_id;
-- 6. Отримати розклад на наступний рік  для групи 2
CREATE VIEW schedule_year AS
SELECT group_id,
  datetime
FROM schedule s
WHERE s.datetime BETWEEN now()
  AND now() + INTERVAL '1 year'
  AND group_id = 2
GROUP BY group_id,
  datetime
ORDER BY datetime DESC;
SELECT *
FROM schedule_year;
-- 7. Відфільтрувати групи за типом (група тренера або відвідувача), 
-- так щоб тренер мав не менше 10 груп
SELECT 'Visitors' as group_type,
  group_id
FROM group_visitors
GROUP BY(group_id)
HAVING COUNT(*) > 2
UNION ALL
SELECT 'Coaches' as group_type,
  group_id
FROM groups
GROUP BY coach_passport,
  group_id
HAVING COUNT(*) > 2
ORDER BY group_type,
  group_id;
-- 7. Вивести список скільки кожен тренер має груп у порядку спадання
CREATE VIEW coach_groups AS
SELECT full_name,
  COUNT(group_id)
FROM coach c
  JOIN groups g on c.passport = g.coach_passport
GROUP BY full_name
HAVING COUNT(group_id) > 2
ORDER BY COUNT(group_id);
SELECT *
FROM coach_groups;
-- 8. Знаходження тренерів, які проводять заняття у групі з йоги
SELECT full_name
FROM coach c
  JOIN groups g ON c.passport = g.coach_passport
WHERE sport_kind = (
    SELECT sport_kind_id
    FROM sport_kind
    WHERE name = 'Yoga'
  );
-- 8. Знаходження тренерів, які мають зарплату більшу ніж середню
SELECT full_name,
  salary
FROM coach c
  JOIN sport_kind sk ON c.sport_kind = sk.sport_kind_id
WHERE salary > (
    SELECT AVG(salary)
    FROM coach
    WHERE sk.name = 'Yoga'
  );
-- 9. Отримати клієнтів, які ще не сплатили за заняття.
CREATE VIEW unpaid_visitors AS
SELECT v.passport
FROM visitor v
  JOIN payment p ON v.passport = p.visitor_passport
WHERE p.date() <= now()
  AND p.subscription_id IN (
    SELECT subscription_id
    FROM subscription
    WHERE name = 'once'
  );
SELECT *
FROM unpaid_visitors;
-- 9.  Перевірити, чи були тренери які мали більше 2 груп
SELECT *
FROM coach c
WHERE c.passport IN (
    SELECT g.coach_passport
    FROM groups g
    GROUP BY(coach_passport)
    HAVING COUNT(*) > 2
  );
-- 10. Знайти тренерів, зарплата яких дорівнює найвищий зарплаті з того ж самого заняття:
CREATE VIEW sport_coach AS
SELECT *
FROM coach c
  JOIN sport_kind sk c.sport_kind = sk.sport_kind_id;
SELECT passport,
  full_name,
  sport_kind
FROM sport_coach sc1
WHERE salary IN (
    SELECT MAX(sc2.salary)
    FROM sport_coach sc2
    WHERE sc2.sport_kind = sc1.sport_kind
    GROUP BY sc2.sport_kind
  )
ORDER BY sport_kind,
  full_name;
-- 10. Знайти відвудувачів, заняття яких дорівнює найбільшому занятті з усіх відвідувачів
CREATE OR REPLACE VIEW visitor_group AS
SELECT passport,
  COUNT(group_id) count_group
FROM visitor v
  JOIN group_visitors gv ON v.passport = gv.visitor_id
GROUP BY passport,
  group_id;
SELECT *
FROM visitor_group vg
WHERE count_group IN (
    SELECT MAX(count_group)
    FROM visitor_group vg2
    WHERE vg2.passport = vg.passport
  );