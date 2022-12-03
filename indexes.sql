CREATE UNIQUE INDEX visitor_idx ON visitor(passport) INCLUDE (full_name, sport_kind);

CREATE UNIQUE INDEX group_idx ON groups(group_id) WITH (fillfactor = 70);

SELECT * FROM (
    SELECT * FROM coach c
        JOIN groups g ON c.passport = g.coach_passport
) cc
    JOIN group_visitors gv ON cc.group_id = gv.group_id;