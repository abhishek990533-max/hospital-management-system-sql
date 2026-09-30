DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;

CREATE TABLE departments (
    dept_id     INT AUTO_INCREMENT,
    dept_name   VARCHAR(50) NOT NULL,
    location    VARCHAR(50),
    CONSTRAINT pk_departments PRIMARY KEY (dept_id),
    CONSTRAINT uq_dept_name   UNIQUE (dept_name)
);

CREATE TABLE doctors (
    doctor_id        INT AUTO_INCREMENT,
    name             VARCHAR(100) NOT NULL,
    specialization   VARCHAR(50),
    dept_id          INT NOT NULL,
    phone            VARCHAR(15),
    consultation_fee DECIMAL(8,2) NOT NULL,
    CONSTRAINT pk_doctors    PRIMARY KEY (doctor_id),
    CONSTRAINT uq_doc_phone  UNIQUE (phone),
    CONSTRAINT chk_doc_fee   CHECK (consultation_fee > 0),
    CONSTRAINT fk_doc_dept   FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE patients (
    patient_id   INT AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL,
    dob          DATE NOT NULL,
    gender       ENUM('M','F','O') NOT NULL,
    phone        VARCHAR(15),
    city         VARCHAR(50),
    blood_group  VARCHAR(5),
    CONSTRAINT pk_patients PRIMARY KEY (patient_id)
);

CREATE TABLE appointments (
    appt_id     INT AUTO_INCREMENT,
    patient_id  INT NOT NULL,
    doctor_id   INT NOT NULL,
    appt_date   DATE NOT NULL,
    appt_time   TIME NOT NULL,
    status      ENUM('Scheduled','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled',
    CONSTRAINT pk_appointments PRIMARY KEY (appt_id),
    CONSTRAINT fk_appt_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_appt_doctor  FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id),
    CONSTRAINT uq_doctor_slot  UNIQUE (doctor_id, appt_date, appt_time)
);

CREATE TABLE billing (
    bill_id         INT AUTO_INCREMENT,
    appt_id         INT NOT NULL,
    amount          DECIMAL(10,2) NOT NULL,
    payment_status  ENUM('Pending','Paid') NOT NULL DEFAULT 'Pending',
    payment_date    DATE,
    CONSTRAINT pk_billing      PRIMARY KEY (bill_id),
    CONSTRAINT uq_bill_appt    UNIQUE (appt_id),
    CONSTRAINT chk_bill_amount CHECK (amount >= 0),
    CONSTRAINT chk_paid_date   CHECK (payment_status = 'Pending' OR payment_date IS NOT NULL),
    CONSTRAINT fk_bill_appt    FOREIGN KEY (appt_id) REFERENCES appointments(appt_id)
);

CREATE TABLE medical_records (
    record_id     INT AUTO_INCREMENT,
    appt_id       INT NOT NULL,
    diagnosis     VARCHAR(200) NOT NULL,
    prescription  VARCHAR(300),
    CONSTRAINT pk_records      PRIMARY KEY (record_id),
    CONSTRAINT uq_record_appt  UNIQUE (appt_id),
    CONSTRAINT fk_record_appt  FOREIGN KEY (appt_id) REFERENCES appointments(appt_id)
);

INSERT INTO departments (dept_name, location) VALUES
('Cardiology',       'Block A'),
('Orthopedics',      'Block B'),
('Pediatrics',       'Block C'),
('General Medicine', 'Block A');

INSERT INTO doctors (name, specialization, dept_id, phone, consultation_fee) VALUES
('Dr. Rakesh Sharma', 'Cardiologist',       1, '9000000001', 800),
('Dr. Neha Verma',    'Cardiologist',       1, '9000000002', 700),
('Dr. Amit Singh',    'Orthopedic Surgeon', 2, '9000000003', 600),
('Dr. Priya Nair',    'Pediatrician',       3, '9000000004', 500),
('Dr. Sanjay Gupta',  'General Physician',  4, '9000000005', 400),
('Dr. Kavita Rao',    'General Physician',  4, '9000000006', 450);

INSERT INTO patients (name, dob, gender, phone, city, blood_group) VALUES
('Rahul Kumar',     '1998-05-12', 'M', '8100000001', 'Patna',    'A+'),
('Sneha Singh',     '1990-08-23', 'F', '8100000002', 'Dehradun', 'B+'),
('Amit Yadav',      '1985-01-15', 'M', '8100000003', 'Delhi',    'O+'),
('Pooja Sharma',    '2015-03-30', 'F', '8100000004', 'Patna',    'A-'),
('Vikram Rathore',  '1970-11-02', 'M', '8100000005', 'Lucknow',  'B-'),
('Anita Devi',      '1962-07-19', 'F', '8100000006', 'Patna',    'O-'),
('Rohan Mehta',     '2001-12-25', 'M', '8100000007', 'Dehradun', 'AB+'),
('Kiran Joshi',     '1995-09-09', 'F', '8100000008', 'Delhi',    'A+');

INSERT INTO appointments (patient_id, doctor_id, appt_date, appt_time, status) VALUES
(1, 5, '2026-09-01', '10:00:00', 'Completed'),
(2, 1, '2026-09-01', '11:00:00', 'Completed'),
(3, 3, '2026-09-02', '09:30:00', 'Completed'),
(4, 4, '2026-09-02', '10:30:00', 'Completed'),
(5, 1, '2026-09-03', '12:00:00', 'Completed'),
(6, 2, '2026-09-03', '10:00:00', 'Cancelled'),
(7, 5, '2026-09-04', '11:30:00', 'Completed'),
(1, 6, '2026-09-05', '15:00:00', 'Scheduled'),
(8, 3, '2026-09-06', '16:00:00', 'Scheduled'),
(2, 5, '2026-09-07', '10:00:00', 'Scheduled'),
(6, 1, '2026-09-08', '09:00:00', 'Scheduled'),
(3, 5, '2026-09-08', '10:00:00', 'Cancelled');

INSERT INTO billing (appt_id, amount, payment_status, payment_date) VALUES
(1, 400, 'Paid',    '2026-09-01'),
(2, 800, 'Paid',    '2026-09-01'),
(3, 600, 'Pending', NULL),
(4, 500, 'Paid',    '2026-09-02'),
(5, 800, 'Pending', NULL),
(7, 400, 'Paid',    '2026-09-04');

INSERT INTO medical_records (appt_id, diagnosis, prescription) VALUES
(1, 'Viral fever',        'Paracetamol 500mg, 3 days'),
(2, 'Hypertension',       'Amlodipine 5mg, 30 days'),
(3, 'Knee ligament pain', 'Ibuprofen 400mg, 5 days'),
(4, 'Common cold',        'Cetirizine 5mg, 5 days'),
(5, 'Chest pain (mild)',  'Aspirin 75mg, 30 days'),
(7, 'Seasonal allergy',   'Levocetirizine 5mg, 7 days');

UPDATE patients
SET phone = '8199999999'
WHERE patient_id = 1;

UPDATE appointments
SET status = 'Completed'
WHERE appt_id = 8;

UPDATE billing
SET payment_status = 'Paid', payment_date = '2026-09-10'
WHERE bill_id = 3;

UPDATE doctors
SET consultation_fee = consultation_fee * 1.10
WHERE dept_id = 1;

SELECT * FROM departments;
SELECT name, specialization, consultation_fee FROM doctors;

SELECT * FROM doctors  WHERE consultation_fee > 500;
SELECT * FROM appointments WHERE status = 'Scheduled';
SELECT * FROM appointments WHERE status != 'Cancelled';

SELECT * FROM patients WHERE city = 'Patna' AND gender = 'F';
SELECT * FROM patients WHERE city = 'Patna' OR city = 'Delhi';
SELECT * FROM appointments WHERE NOT status = 'Completed';

SELECT * FROM appointments WHERE appt_date BETWEEN '2026-09-01' AND '2026-09-04';
SELECT * FROM doctors WHERE consultation_fee BETWEEN 400 AND 700;

SELECT * FROM patients WHERE city IN ('Patna', 'Dehradun');
SELECT * FROM doctors  WHERE dept_id NOT IN (1, 2);

SELECT * FROM patients WHERE name LIKE 'R%';
SELECT * FROM doctors  WHERE name LIKE '%Singh';
SELECT * FROM doctors  WHERE specialization LIKE '%ist';

SELECT * FROM billing WHERE payment_date IS NULL;
SELECT * FROM billing WHERE payment_date IS NOT NULL;

SELECT name, consultation_fee, consultation_fee * 1.18 AS fee_with_gst
FROM doctors;

SELECT name, dob, TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS age
FROM patients;

SELECT DISTINCT city FROM patients;

SELECT name, consultation_fee
FROM doctors
ORDER BY consultation_fee DESC
LIMIT 3;

SELECT bill_id, appt_id, amount
FROM billing
ORDER BY amount DESC
LIMIT 3;

SELECT * FROM appointments
ORDER BY appt_date DESC, appt_time DESC
LIMIT 5;

SELECT name, dob FROM patients
ORDER BY dob DESC
LIMIT 3;

SELECT * FROM patients
ORDER BY patient_id
LIMIT 3, 3;

SELECT dept_id, COUNT(*) AS total_doctors
FROM doctors
GROUP BY dept_id;

SELECT city, COUNT(*) AS total_patients
FROM patients
GROUP BY city;

SELECT status, COUNT(*) AS total
FROM appointments
GROUP BY status;

SELECT doctor_id, COUNT(*) AS total_appointments
FROM appointments
GROUP BY doctor_id
ORDER BY total_appointments DESC;

SELECT payment_status,
       COUNT(*)    AS total_bills,
       SUM(amount) AS total_amount,
       AVG(amount) AS avg_amount
FROM billing
GROUP BY payment_status;

SELECT dept_id,
       AVG(consultation_fee) AS avg_fee,
       MAX(consultation_fee) AS max_fee
FROM doctors
GROUP BY dept_id;

SELECT gender, COUNT(*) AS total FROM patients GROUP BY gender;

SELECT doctor_id, COUNT(*) AS total_appointments
FROM appointments
GROUP BY doctor_id
HAVING COUNT(*) >= 2;

SELECT city, COUNT(*) AS total_patients
FROM patients
GROUP BY city
HAVING COUNT(*) >= 2;

SELECT dept_id, AVG(consultation_fee) AS avg_fee
FROM doctors
GROUP BY dept_id
HAVING AVG(consultation_fee) > 500;

SELECT patient_id, COUNT(*) AS visits
FROM appointments
WHERE status != 'Cancelled'
GROUP BY patient_id
HAVING COUNT(*) >= 2
ORDER BY visits DESC
LIMIT 5;
