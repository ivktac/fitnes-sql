CREATE TABLE public.sport_kind
(
    sport_kind_id SERIAL,
    name          VARCHAR(50) UNIQUE NOT NULL,
    max_visitors  INT                NOT NULL,
    price         INT                NOT NULL,
    PRIMARY KEY (sport_kind_id)
);

CREATE TABLE public.sport_place
(
    sport_place_id SERIAL,
    name           VARCHAR(50) UNIQUE NOT NULL,
    max_visitors   INT                NOT NULL,
    PRIMARY KEY (sport_place_id)
);

CREATE TABLE public.visitor
(
    passport   VARCHAR(50),
    full_name  VARCHAR(50) NOT NULL,
    sport_kind INT         NOT NULL,
    PRIMARY KEY (passport)
);

CREATE TABLE public.coach
(
    passport   VARCHAR(50) NOT NULL,
    birthday   DATE        NOT NULL,
    full_name  VARCHAR(50),
    sport_kind INT         NOT NULL,
    PRIMARY KEY (passport)
);

CREATE TABLE public.payment
(
    payment_id       SERIAL,
    visitor_passport VARCHAR(50) NOT NULL,
    monthly          BOOLEAN     NOT NULL,
    date             DATE        NOT NULL default (now()),
    PRIMARY KEY (payment_id)
);

CREATE TABLE groups
(
    group_id       SERIAL,
    sport_place    INTEGER NOT NULL,
    coach_passport VARCHAR(50),
    PRIMARY KEY (group_id)
);

CREATE TABLE group_visitors
(
    id         SERIAL PRIMARY KEY,
    group_id   INTEGER     NOT NULL,
    visitor_id VARCHAR(50) NOT NULL
);

CREATE TABLE schedule
(
    schedule_id SERIAL,
    datetime    TIMESTAMP NOT NULL,
    group_id    INTEGER   NOT NULL,
    PRIMARY KEY (schedule_id)
);

ALTER TABLE visitor
    ADD CONSTRAINT fk_sport_kind_visitor
        FOREIGN KEY (sport_kind)
            REFERENCES sport_kind (sport_kind_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE coach
    ADD CONSTRAINT fk_sport_kind_coach
        FOREIGN KEY (sport_kind)
            REFERENCES sport_kind (sport_kind_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE payment
    ADD CONSTRAINT fk_visitor_id_payment
        FOREIGN KEY (visitor_passport)
            REFERENCES visitor (passport)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE groups
    ADD CONSTRAINT fk_sport_place
        FOREIGN KEY (sport_place)
            REFERENCES sport_place (sport_place_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE groups
    ADD CONSTRAINT fk_coach_id_group
        FOREIGN KEY (coach_passport)
            REFERENCES coach (passport)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE group_visitors
    ADD CONSTRAINT fk_visitor_id_group
        FOREIGN KEY (visitor_id)
            REFERENCES visitor (passport)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE group_visitors
    ADD CONSTRAINT fk_group_group_id
        FOREIGN KEY (group_id)
            REFERENCES groups (group_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE schedule
    ADD CONSTRAINT fk_group_schedule
        FOREIGN KEY (group_id)
            REFERENCES groups (group_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE;

CREATE TABLE subscription
(
    subscription_id SERIAL PRIMARY KEY,
    name            VARCHAR(50) NOT NULL,
    cost            INTEGER     NOT NULL
);

ALTER TABLE payment
    DROP COLUMN monthly CASCADE;

ALTER TABLE payment
    ADD COLUMN subscription_id INTEGER;
ALTER TABLE payment
    ADD CONSTRAINT fk_subscription_payment FOREIGN KEY (subscription_id)
        REFERENCES subscription (subscription_id);

ALTER TABLE coach
    ADD COLUMN salary INTEGER;

ALTER TABLE coach ADD CHECK (salary > 0);

ALTER TABLE payment ALTER COLUMN subscription_id SET DEFAULT 3;

ALTER TABLE payment ALTER column date SET DEFAULT now();
