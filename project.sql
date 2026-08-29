

CREATE TABLE Department (
    Dept_id INT PRIMARY KEY,
    Dept_name VARCHAR(50) NOT NULL,
    Dept_description VARCHAR(1000)
);

CREATE TABLE Employee (
    Employee_id INT PRIMARY KEY,
    F_name VARCHAR(20) NOT NULL,
    L_name VARCHAR(50) NOT NULL,
    em_phone VARCHAR(20),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(Dept_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Customer (
    Customer_id INT PRIMARY KEY,
    cus_F_Name VARCHAR(50) NOT NULL,
    cus_L_Name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE,
    Gov VARCHAR(50),
    street VARCHAR(50),
    building VARCHAR(50)
);

CREATE TABLE Customer_Phone (
    Customer_id INT,
    cus_phone VARCHAR(20),
    PRIMARY KEY (Customer_id, cus_phone),
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Factory (
    Factory_id INT PRIMARY KEY,
    Factory_name VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    prod_code INT PRIMARY KEY,
    prod_name VARCHAR(50) NOT NULL,
    prod_description VARCHAR(200),
    prod_price DECIMAL(10,2) NOT NULL,
    prod_imag VARCHAR(255),
    prod_rating INT CHECK (prod_rating BETWEEN 1 AND 5),
    dept_id INT,
    factory_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(Dept_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (factory_id) REFERENCES Factory(Factory_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT check_Price CHECK (prod_price > 0)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    ord_date DATE NOT NULL,
    ord_total_price DECIMAL(10,2) NOT NULL,
    ord_state VARCHAR(50) NOT NULL
        CHECK (ord_state IN ('Pending','Confirmed','Shipped','Delivered','Cancelled')),
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(Customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE Order_Product (
    ord_id INT,
    prod_code INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ord_id, prod_code),
    FOREIGN KEY (ord_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (prod_code) REFERENCES Products(prod_code)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


CREATE TABLE Bill (
    bill_id INT,
    ord_id INT,
    bill_amount DECIMAL(10,2) NOT NULL,
    bill_date DATE NOT NULL,
    PRIMARY KEY (bill_id, ord_id),
    FOREIGN KEY (ord_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Shipping (
    shipping_id INT,
    ship_name VARCHAR(50),
    ship_start_date DATE,
    delivary_date DATE,
    ship_state VARCHAR(50)
        CHECK (ship_state IN ('Preparing','In Transit','Delivered','Returned')),
    ord_id INT,
    PRIMARY KEY (shipping_id, ord_id),
    FOREIGN KEY (ord_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    method VARCHAR(50)
        CHECK (method IN ('Cash','Credit Card','Debit Card','Wallet','Bank Transfer')),
    pay_state VARCHAR(20)
        CHECK (pay_state IN ('Pending','Paid','Failed','Refunded')),
    payment_date DATE,
    bill_id INT,
    ord_id INT UNIQUE,
    FOREIGN KEY (bill_id, ord_id) REFERENCES Bill(bill_id, ord_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
