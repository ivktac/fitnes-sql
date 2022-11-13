COPY sport_kind  FROM 'sport_kind.csv' 
DELIMITER ',' CSV HEADER;

COPY sport_place  FROM 'sport_place.csv'
DELIMITER ',' CSV HEADER;

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