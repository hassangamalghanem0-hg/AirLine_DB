-- ================================================
-- قاعدة بيانات شركات الطيران
-- AIRLINE DATABASE - SQL Script
-- مناسب للمبتدئين مع شرح كل خطوة
-- ================================================

-- أولاً: إنشاء الجداول (CREATE TABLES)
-- ----------------------------------------
CREATE DATABASE Airline_DB;

-- 1. جدول شركة الطيران (الجدول الرئيسي)
CREATE TABLE AIRLINE (
    airline_id   INT PRIMARY KEY,      -- رقم تعريف الشركة (لا يتكرر)
    name         VARCHAR(100) NOT NULL, -- اسم الشركة (مطلوب)
    address      TEXT,                  -- عنوان الشركة
    contact_name VARCHAR(100),          -- اسم المسؤول
    phone        VARCHAR(30)            -- رقم التليفون
);

-- =============================================

-- 2. جدول الموظفين
--    كل موظف منتمي لشركة طيران (airline_id)
CREATE TABLE EMPLOYEE (
    emp_id         INT PRIMARY KEY,       -- رقم الموظف
    airline_id     INT NOT NULL,          -- رقم الشركة اللي شغال فيها
    name           VARCHAR(100) NOT NULL, -- اسم الموظف
    address        TEXT,                  -- عنوانه
    birth_day      INT,                   -- يوم الميلاد (مثال: 15)
    birth_month    INT,                   -- شهر الميلاد (مثال: 3)
    birth_year     INT,                   -- سنة الميلاد (مثال: 1990)
    gender         VARCHAR(10),           -- الجنس (Male / Female)
    position       VARCHAR(100),          -- المنصب (مثال: Manager)
    qualifications TEXT,                  -- المؤهلات

    -- الربط مع جدول AIRLINE
    -- لو الشركة اتمسحت، الموظفين بتوعها بيتمسحوا كمان
    FOREIGN KEY (airline_id) REFERENCES AIRLINE(airline_id)
        ON DELETE CASCADE
);

-- =============================================

-- 3. جدول الطائرات
--    كل طائرة مملوكة لشركة طيران
CREATE TABLE AIRCRAFT (
    aircraft_id INT PRIMARY KEY,       -- رقم الطائرة
    airline_id  INT NOT NULL,          -- رقم الشركة المالكة
    capacity    INT,                   -- عدد المقاعد
    model       VARCHAR(100),          -- موديل الطائرة (مثال: Boeing 737)

    FOREIGN KEY (airline_id) REFERENCES AIRLINE(airline_id)
        ON DELETE CASCADE
);

-- =============================================

-- 4. جدول المسارات (الرحلات الثابتة)
CREATE TABLE ROUTE (
    route_id       INT PRIMARY KEY,   -- رقم المسار
    origin         VARCHAR(100),      -- نقطة الانطلاق (مثال: القاهرة)
    destination    VARCHAR(100),      -- الوجهة (مثال: دبي)
    distance       FLOAT,             -- المسافة بالكيلومتر
    classification VARCHAR(50)        -- نوع: Domestic (داخلي) أو International (دولي)
);

-- =============================================

-- 5. جدول الربط بين الطائرات والمسارات
--    لأن طائرة واحدة ممكن تشتغل على أكتر من مسار
--    والمسار الواحد ممكن يكون فيه أكتر من طائرة
--    المفتاح الأساسي هنا مزدوج (aircraft_id + route_id)
CREATE TABLE AIRCRAFT_ROUTE (
    aircraft_id        INT NOT NULL,      -- رقم الطائرة
    route_id           INT NOT NULL,      -- رقم المسار
    num_passengers     INT,               -- عدد الركاب في الرحلة دي
    price_per_passenger FLOAT,            -- سعر التذكرة للراكب الواحد
    departure_datetime DATETIME,          -- وقت الإقلاع
    arrival_datetime   DATETIME,          -- وقت الوصول
    travel_time        FLOAT,             -- مدة الرحلة بالساعات

    -- المفتاح الأساسي المزدوج
    PRIMARY KEY (aircraft_id, route_id),

    FOREIGN KEY (aircraft_id) REFERENCES AIRCRAFT(aircraft_id)
        ON DELETE CASCADE,
    FOREIGN KEY (route_id)    REFERENCES ROUTE(route_id)
        ON DELETE CASCADE
);

-- =============================================

-- 6. جدول طاقم الطائرة
--    كل طائرة عندها طاقم واحد بس (علاقة 1-to-1)
--    الطاقم مش بيتحسب كموظفين في الشركة
CREATE TABLE CREW (
    crew_id         INT PRIMARY KEY,  -- رقم الطاقم
    aircraft_id     INT UNIQUE NOT NULL, -- رقم الطائرة (UNIQUE يضمن كل طائرة بطاقم واحد بس)
    major_pilot     VARCHAR(100),     -- الطيار الرئيسي
    assistant_pilot VARCHAR(100),     -- مساعد الطيار
    hostess1        VARCHAR(100),     -- المضيفة الأولى
    hostess2        VARCHAR(100),     -- المضيفة الثانية

    FOREIGN KEY (aircraft_id) REFERENCES AIRCRAFT(aircraft_id)
        ON DELETE CASCADE
);

-- =============================================

-- 7. جدول المعاملات المالية (بيع وشراء)
--    مثال: بيع تذكرة = Sell، دفع صيانة = Buy
CREATE TABLE TRANSACTIONS (
    transaction_id INT PRIMARY KEY,    -- رقم المعاملة
    airline_id     INT NOT NULL,       -- الشركة اللي عملت المعاملة دي
    trans_date     DATE,               -- تاريخ المعاملة
    description    TEXT,               -- وصف المعاملة
    amount         FLOAT,              -- المبلغ (بالدولار مثلاً)
    type           VARCHAR(10),        -- النوع: Buy أو Sell

    FOREIGN KEY (airline_id) REFERENCES AIRLINE(airline_id)
        ON DELETE CASCADE
);

-- ================================================
-- ثانياً: إدراج بيانات تجريبية (INSERT DATA)
-- ================================================

-- إضافة شركات طيران
INSERT INTO AIRLINE VALUES (1, 'EgyptAir',       'Cairo, Egypt',   'Ahmed Ali',   '+20-2-2222-2222');
INSERT INTO AIRLINE VALUES (2, 'Emirates',        'Dubai, UAE',     'Mohammed K.', '+971-4-5555-5555');
INSERT INTO AIRLINE VALUES (3, 'Qatar Airways',   'Doha, Qatar',    'Sara Hassan', '+974-1-3333-3333');

-- إضافة موظفين
INSERT INTO EMPLOYEE VALUES (1, 1, 'Omar Saeed',   'Cairo',       5,  3, 1985, 'Male',   'Manager',        'MBA, Aviation Mgmt');
INSERT INTO EMPLOYEE VALUES (2, 1, 'Nour Khaled',  'Alexandria',  12, 7, 1992, 'Female', 'HR Specialist',  'BSc HR');
INSERT INTO EMPLOYEE VALUES (3, 2, 'Ali Rahman',   'Dubai',       20, 1, 1980, 'Male',   'Finance Manager','CPA, MBA');

-- إضافة طائرات
INSERT INTO AIRCRAFT VALUES (1, 1, 250, 'Boeing 737');
INSERT INTO AIRCRAFT VALUES (2, 1, 400, 'Airbus A380');
INSERT INTO AIRCRAFT VALUES (3, 2, 350, 'Boeing 777');
INSERT INTO AIRCRAFT VALUES (4, 3, 300, 'Airbus A350');

-- إضافة مسارات
INSERT INTO ROUTE VALUES (1, 'Cairo',   'Dubai',    2417.0, 'International');
INSERT INTO ROUTE VALUES (2, 'Dubai',   'London',   5470.0, 'International');
INSERT INTO ROUTE VALUES (3, 'Cairo',   'Luxor',     670.0, 'Domestic');
INSERT INTO ROUTE VALUES (4, 'Doha',    'New York', 11770.0,'International');

-- إضافة رحلات (طائرة + مسار)
INSERT INTO AIRCRAFT_ROUTE VALUES (1, 1, 230, 450.00, '2025-06-01 08:00:00', '2025-06-01 12:00:00', 4.0);
INSERT INTO AIRCRAFT_ROUTE VALUES (1, 3, 180, 120.00, '2025-06-05 07:00:00', '2025-06-05 08:05:00', 1.08);
INSERT INTO AIRCRAFT_ROUTE VALUES (3, 2, 340, 750.00, '2025-06-02 14:00:00', '2025-06-02 21:00:00', 7.0);
INSERT INTO AIRCRAFT_ROUTE VALUES (4, 4, 290, 1200.00,'2025-06-03 09:00:00', '2025-06-03 23:00:00', 14.0);

-- إضافة أطقم
INSERT INTO CREW VALUES (1, 1, 'Capt. Karim Hassan', 'F.O. Mona Adel',   'Rania Said',  'Hana Youssef');
INSERT INTO CREW VALUES (2, 2, 'Capt. Tarek Nour',   'F.O. Layla Farid', 'Sara Omar',   'Dina Magdy');
INSERT INTO CREW VALUES (3, 3, 'Capt. James Clark',  'F.O. Liu Wei',     'Amy Brown',   'Fatima Al-Ali');
INSERT INTO CREW VALUES (4, 4, 'Capt. Hamad Al-Sayed','F.O. Anna Smith', 'Maryam Nasser','Noura Khalid');

-- إضافة معاملات مالية
INSERT INTO TRANSACTIONS VALUES (1, 1, '2025-05-01', 'Ticket sale - Cairo to Dubai',     45000.00, 'Sell');
INSERT INTO TRANSACTIONS VALUES (2, 1, '2025-05-02', 'Aircraft maintenance fee',          8000.00,  'Buy');
INSERT INTO TRANSACTIONS VALUES (3, 2, '2025-05-03', 'Ticket sale - Dubai to London',    120000.00,'Sell');
INSERT INTO TRANSACTIONS VALUES (4, 2, '2025-05-04', 'Fuel purchase',                    35000.00, 'Buy');
INSERT INTO TRANSACTIONS VALUES (5, 3, '2025-05-05', 'Ticket sale - Doha to New York',   95000.00, 'Sell');

-- ================================================
-- ثالثاً: استعلامات مفيدة (SELECT - QUERIES)
-- ================================================

-- جلب كل الشركاتS
SELECT * FROM AIRLINE;

-- جلب موظفي شركة معينة (مثال: رقم 1)
SELECT name, position FROM EMPLOYEE
WHERE airline_id = 1;

-- جلب الرحلات الدولية فقط
SELECT * FROM ROUTE
WHERE classification = 'International';

-- جلب إجمالي الإيرادات (Sell) لكل شركة
SELECT a.name, SUM(t.amount) AS total_revenue
FROM AIRLINE a
JOIN TRANSACTIONS t ON a.airline_id = t.airline_id
WHERE t.type = 'Sell'
GROUP BY a.name;

-- جلب الطائرة مع طاقمها
SELECT ac.model, c.major_pilot, c.assistant_pilot, c.hostess1, c.hostess2
FROM AIRCRAFT ac
JOIN CREW c ON ac.aircraft_id = c.aircraft_id;

-- ================================================
-- END OF SCRIPT
-- ================================================
