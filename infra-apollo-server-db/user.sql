CREATE USER IF NOT EXISTS `infra_apollo_config`;
GRANT ALL ON `infra_apollo_config`.* TO 'infra_apollo_config'@'%';
ALTER USER 'infra_apollo_config'@'%' IDENTIFIED WITH mysql_native_password BY 'infra_apollo_config';
FLUSH PRIVILEGES;

CREATE USER IF NOT EXISTS `infra_apollo_portal`;
GRANT ALL ON `infra_apollo_portal`.* TO 'infra_apollo_portal'@'%';
ALTER USER 'infra_apollo_portal'@'%' IDENTIFIED WITH mysql_native_password BY 'infra_apollo_portal';
FLUSH PRIVILEGES;
