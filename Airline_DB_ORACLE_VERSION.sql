-- ================================================
-- AIRLINE DATABASE - ORACLE VERSION
-- ================================================

-- 1. جدول شركة الطيران
CREATE TABLE AIRLINE (
    airline_id   NUMBER PRIMARY KEY,
    name         VARCHAR2(100) NOT NULL,
    address      CLOB,
    contact_name VARCHAR2(100),
    phone        VARCHAR2(30)
);

-- =============================================

-- 2. جدول الموظفين
CREATE TABLE EMPLOYEE (
    emp_id         NUMBER PRIMARY KEY,
    airline_id     NUMBER NOT NULL,
    name           VARCHAR2(100) NOT NULL,
    address        CLOB,
    birth_day      NUMBER,
    birth_month    NUMBER,
    birth_year     NUMBER,
    gender         VARCHAR2(10),
    position       VARCHAR2(100),
    qualifications CLOB,

    FOREIGN KEY (airline_id) REFERENCES AIRLINE(airline_id)
        ON DELETE CASCADE
);

-- =============================================

-- 3. جدول الطائرات
CREATE TABLE AIRCRAFT (
    aircraft_id NUMBER PRIMARY KEY,
    airline_id  NUMBER NOT NULL,
    capacity    NUMBER,
    model       VARCHAR2(100),

    FOREIGN KEY (airline_id) REFERENCES AIRLINE(airline_id)
        ON DELETE CASCADE
);

-- =============================================

-- 4. جدول المسارات
CREATE TABLE ROUTE (
    route_id       NUMBER PRIMARY KEY,
    origin         VARCHAR2(100),
    destination    VARCHAR2(100),
    distance       NUMBER,
    classification VARCHAR2(50)
);

-- =============================================

-- 5. جدول الربط
CREATE TABLE AIRCRAFT_ROUTE (
    aircraft_id        NUMBER NOT NULL,
    route_id           NUMBER NOT NULL,
    num_passengers     NUMBER,
    price_per_passenger NUMBER,
    departure_datetime TIMESTAMP,
    arrival_datetime   TIMESTAMP,
    travel_time        NUMBER,

    PRIMARY KEY (aircraft_id, route_id),

    FOREIGN KEY (aircraft_id) REFERENCES AIRCRAFT(aircraft_id)
        ON DELETE CASCADE,
    FOREIGN KEY (route_id) REFERENCES ROUTE(route_id)
        ON DELETE CASCADE
);

-- =============================================

-- 6. جدول الطاقم
CREATE TABLE CREW (
    crew_id         NUMBER PRIMARY KEY,
    aircraft_id     NUMBER UNIQUE NOT NULL,
    major_pilot     VARCHAR2(100),
    assistant_pilot VARCHAR2(100),
    hostess1        VARCHAR2(100),
    hostess2        VARCHAR2(100),

    FOREIGN KEY (aircraft_id) REFERENCES AIRCRAFT(aircraft_id)
        ON DELETE CASCADE
);

-- =============================================

-- 7. جدول المعاملات
CREATE TABLE TRANSACTIONS (
    transaction_id NUMBER PRIMARY KEY,
    airline_id     NUMBER NOT NULL,
    trans_date     DATE,
    description    CLOB,
    amount         NUMBER,
    type           VARCHAR2(10),

    FOREIGN KEY (airline_id) REFERENCES AIRLINE(airline_id)
        ON DELETE CASCADE
);

-- ================================================
-- INSERT DATA
-- ================================================

INSERT INTO AIRLINE VALUES (1, 'EgyptAir', 'Cairo, Egypt', 'Ahmed Ali', '+20-2-2222-2222');
INSERT INTO AIRLINE VALUES (2, 'Emirates', 'Dubai, UAE', 'Mohammed K.', '+971-4-5555-5555');
INSERT INTO AIRLINE VALUES (3, 'Qatar Airways', 'Doha, Qatar', 'Sara Hassan', '+974-1-3333-3333');

INSERT INTO EMPLOYEE VALUES (1, 1, 'Omar Saeed', 'Cairo', 5, 3, 1985, 'Male', 'Manager', 'MBA, Aviation Mgmt');
INSERT INTO EMPLOYEE VALUES (2, 1, 'Nour Khaled', 'Alexandria', 12, 7, 1992, 'Female', 'HR Specialist', 'BSc HR');
INSERT INTO EMPLOYEE VALUES (3, 2, 'Ali Rahman', 'Dubai', 20, 1, 1980, 'Male', 'Finance Manager', 'CPA, MBA');

INSERT INTO AIRCRAFT VALUES (1, 1, 250, 'Boeing 737');
INSERT INTO AIRCRAFT VALUES (2, 1, 400, 'Airbus A380');
INSERT INTO AIRCRAFT VALUES (3, 2, 350, 'Boeing 777');
INSERT INTO AIRCRAFT VALUES (4, 3, 300, 'Airbus A350');

INSERT INTO ROUTE VALUES (1, 'Cairo', 'Dubai', 2417, 'International');
INSERT INTO ROUTE VALUES (2, 'Dubai', 'London', 5470, 'International');
INSERT INTO ROUTE VALUES (3, 'Cairo', 'Luxor', 670, 'Domestic');
INSERT INTO ROUTE VALUES (4, 'Doha', 'New York', 11770, 'International');

INSERT INTO AIRCRAFT_ROUTE VALUES (
1, 1, 230, 450,
TO_TIMESTAMP('2025-06-01 08:00:00','YYYY-MM-DD HH24:MI:SS'),
TO_TIMESTAMP('2025-06-01 12:00:00','YYYY-MM-DD HH24:MI:SS'),
4
);

INSERT INTO AIRCRAFT_ROUTE VALUES (
1, 3, 180, 120,
TO_TIMESTAMP('2025-06-05 07:00:00','YYYY-MM-DD HH24:MI:SS'),
TO_TIMESTAMP('2025-06-05 08:05:00','YYYY-MM-DD HH24:MI:SS'),
1.08
);

INSERT INTO AIRCRAFT_ROUTE VALUES (
3, 2, 340, 750,
TO_TIMESTAMP('2025-06-02 14:00:00','YYYY-MM-DD HH24:MI:SS'),
TO_TIMESTAMP('2025-06-02 21:00:00','YYYY-MM-DD HH24:MI:SS'),
7
);

INSERT INTO AIRCRAFT_ROUTE VALUES (
4, 4, 290, 1200,
TO_TIMESTAMP('2025-06-03 09:00:00','YYYY-MM-DD HH24:MI:SS'),
TO_TIMESTAMP('2025-06-03 23:00:00','YYYY-MM-DD HH24:MI:SS'),
14
);

INSERT INTO CREW VALUES (1, 1, 'Capt. Karim Hassan', 'F.O. Mona Adel', 'Rania Said', 'Hana Youssef');
INSERT INTO CREW VALUES (2, 2, 'Capt. Tarek Nour', 'F.O. Layla Farid', 'Sara Omar', 'Dina Magdy');
INSERT INTO CREW VALUES (3, 3, 'Capt. James Clark', 'F.O. Liu Wei', 'Amy Brown', 'Fatima Al-Ali');
INSERT INTO CREW VALUES (4, 4, 'Capt. Hamad Al-Sayed', 'F.O. Anna Smith', 'Maryam Nasser', 'Noura Khalid');

INSERT INTO TRANSACTIONS VALUES (1, 1, TO_DATE('2025-05-01','YYYY-MM-DD'), 'Ticket sale - Cairo to Dubai', 45000, 'Sell');
INSERT INTO TRANSACTIONS VALUES (2, 1, TO_DATE('2025-05-02','YYYY-MM-DD'), 'Aircraft maintenance fee', 8000, 'Buy');
INSERT INTO TRANSACTIONS VALUES (3, 2, TO_DATE('2025-05-03','YYYY-MM-DD'), 'Ticket sale - Dubai to London', 120000, 'Sell');
INSERT INTO TRANSACTIONS VALUES (4, 2, TO_DATE('2025-05-04','YYYY-MM-DD'), 'Fuel purchase', 35000, 'Buy');
INSERT INTO TRANSACTIONS VALUES (5, 3, TO_DATE('2025-05-05','YYYY-MM-DD'), 'Ticket sale - Doha to New York', 95000, 'Sell');

-- ================================================
-- QUERIES (نفسها بدون تغيير)
-- ================================================

SELECT * FROM AIRLINE;

SELECT name, position FROM EMPLOYEE
WHERE airline_id = 1;

SELECT * FROM ROUTE
WHERE classification = 'International';

SELECT a.name, SUM(t.amount) AS total_revenue
FROM AIRLINE a
JOIN TRANSACTIONS t ON a.airline_id = t.airline_id
WHERE t.type = 'Sell'
GROUP BY a.name;

SELECT ac.model, c.major_pilot, c.assistant_pilot, c.hostess1, c.hostess2
FROM AIRCRAFT ac
JOIN CREW c ON ac.aircraft_id = c.aircraft_id;