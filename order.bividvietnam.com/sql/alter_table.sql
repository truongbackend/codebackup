/*  cms_customers table */
ALTER TABLE cms_customers ADD COLUMN user_assigned INT NOT NULL;

/*  cms_users table */
ALTER TABLE cms_users ADD COLUMN roles_id INT NOT NULL;

/*  cms_users table */
ALTER TABLE cms_users ADD COLUMN user_assigned INT NOT NULL;

/*  cms_users table */
ALTER TABLE cms_users ADD COLUMN user_erp varchar(255) NOT NULL;
/*  cms_stores table */
ALTER TABLE `cms_stores` ADD COLUMN `status` TINYINT(1) NOT NULL DEFAULT '1';