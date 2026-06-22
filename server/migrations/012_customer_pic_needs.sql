-- Add customer PIC and needs fields
ALTER TABLE customers ADD COLUMN whatsapp VARCHAR(20) NULL AFTER phone;
ALTER TABLE customers ADD COLUMN credit_limit DECIMAL(15,2) NULL AFTER city;
ALTER TABLE customers ADD COLUMN payment_terms VARCHAR(20) DEFAULT 'NET14' AFTER credit_limit;
ALTER TABLE customers ADD COLUMN needs_plan TEXT NULL AFTER payment_terms;
ALTER TABLE customers ADD COLUMN pic_user_id INT NULL AFTER needs_plan;
ALTER TABLE customers ADD COLUMN pic_name VARCHAR(100) NULL AFTER pic_user_id;
ALTER TABLE customers ADD COLUMN npwp VARCHAR(30) NULL AFTER pic_name;
ALTER TABLE customers ADD COLUMN tax_address TEXT NULL AFTER npwp;
