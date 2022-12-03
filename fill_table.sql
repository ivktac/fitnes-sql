INSERT INTO sport_kind(name, max_visitors, price)
VALUES ('Yoga', 15, 200), ('Swimming', 10, 300), ('Workout', 30, 150);

INSERT INTO sport_place(name, max_visitors)
VALUES ('Gym', 30), ('Swimming pool', 10), ('Pool', 50);

COPY visitor FROM 'visitor.csv'
DELIMITER ',' CSV HEADER;

COPY coach FROM 'coach.csv'
DELIMITER ',' CSV HEADER;

INSERT INTO subscription(name, cost)
VALUES ('monthly', 300), ('yearly', 5000), ('once', 30);

COPY payment FROM 'payment.csv'
DELIMITER ',' CSV HEADER;

COPY groups FROM 'groups.csv'
DELIMITER ',' CSV HEADER;

COPY group_visitors FROM 'group_visitors.csv'
DELIMITER ',' CSV HEADER;

COPY schedule FROM 'schedule.csv'
DELIMITER ',' CSV HEADER;