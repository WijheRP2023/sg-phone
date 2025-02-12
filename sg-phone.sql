
--banking-app
CREATE TABLE IF NOT EXISTS `banking_transactions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `type` VARCHAR(20) NOT NULL,
    `amount` INT NOT NULL,
    `target` VARCHAR(50) NOT NULL,
    `date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--whatsapp
CREATE TABLE IF NOT EXISTS `whatsapp_messages` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `sender` VARCHAR(50) NOT NULL,
    `receiver` VARCHAR(50) NOT NULL,
    `message` TEXT NOT NULL,
    `type` ENUM('text', 'image') NOT NULL DEFAULT 'text',
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--marketplace
CREATE TABLE IF NOT EXISTS `marketplace` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `owner` VARCHAR(50) NOT NULL,
    `plate` VARCHAR(20) NOT NULL,
    `price` INT NOT NULL
);

--darkweb
CREATE TABLE IF NOT EXISTS `darkweb` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `seller` VARCHAR(50) NOT NULL,
    `item` VARCHAR(50) NOT NULL,
    `price` INT NOT NULL,
    `amount` INT NOT NULL
);

--tiktok
CREATE TABLE IF NOT EXISTS `tiktok_videos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `uploader` VARCHAR(50) NOT NULL,
    `videoUrl` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `likes` INT DEFAULT 0
);

--stocks
CREATE TABLE IF NOT EXISTS sg_phone_stocks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50) NOT NULL,
    stock VARCHAR(50) NOT NULL,
    amount INT NOT NULL,
    price INT NOT NULL
);