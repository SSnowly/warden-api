-- CreateTable
CREATE TABLE `Users` (
    `id` VARCHAR(32) NOT NULL,
    `last_username` VARCHAR(191) NOT NULL,
    `avatar` VARCHAR(191) NOT NULL,
    `type` ENUM('OTHER', 'LEAKER', 'CHEATER', 'SUPPORTER', 'OWNER', 'BOT') NOT NULL,
    `status` ENUM('APPEALED', 'BLACKLISTED', 'PERM_BLACKLISTED', 'WHITELISTED') NOT NULL DEFAULT 'BLACKLISTED',
    `appeals` INTEGER NOT NULL DEFAULT 0,
    `reason` VARCHAR(191) NULL,

    UNIQUE INDEX `Users_id_key`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Notes` (
    `nId` INTEGER NOT NULL AUTO_INCREMENT,
    `id` VARCHAR(32) NOT NULL,
    `note` LONGTEXT NOT NULL,
    `addedBy` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`nId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Imports` (
    `id` VARCHAR(32) NOT NULL,
    `server` VARCHAR(191) NOT NULL,
    `roles` MEDIUMTEXT NOT NULL,
    `type` ENUM('OTHER', 'LEAKER', 'CHEATER', 'SUPPORTER', 'OWNER', 'BOT') NOT NULL,
    `appealed` BOOLEAN NOT NULL DEFAULT false,
    `reason` VARCHAR(256) NOT NULL DEFAULT 'Not Specified',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Imports_id_server_key`(`id`, `server`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `BadServers` (
    `id` VARCHAR(32) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `oldNames` LONGTEXT NULL,
    `type` ENUM('CHEATING', 'LEAKING', 'RESELLING', 'ADVERTISING', 'OTHER') NOT NULL,
    `addedBy` VARCHAR(191) NOT NULL,
    `invite` VARCHAR(191) NULL,
    `reason` VARCHAR(191) NOT NULL DEFAULT 'None provided',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `BadServers_id_key`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Staff` (
    `id` VARCHAR(32) NOT NULL,
    `role` ENUM('DEV', 'ADMIN', 'EXSTAFF') NOT NULL DEFAULT 'ADMIN',
    `appeals` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Staff_id_key`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Guild` (
    `id` VARCHAR(32) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `logChannel` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Guild_id_key`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Punishments` (
    `id` VARCHAR(32) NOT NULL,
    `owner` ENUM('ROLE', 'WARN', 'KICK', 'BAN') NOT NULL DEFAULT 'BAN',
    `supporter` ENUM('ROLE', 'WARN', 'KICK', 'BAN') NOT NULL DEFAULT 'KICK',
    `leaker` ENUM('ROLE', 'WARN', 'KICK', 'BAN') NOT NULL DEFAULT 'WARN',
    `cheater` ENUM('ROLE', 'WARN', 'KICK', 'BAN') NOT NULL DEFAULT 'WARN',
    `other` ENUM('ROLE', 'WARN', 'KICK', 'BAN') NOT NULL DEFAULT 'WARN',
    `enabled` BOOLEAN NOT NULL DEFAULT false,
    `unban` BOOLEAN NOT NULL DEFAULT false,
    `globalCheck` BOOLEAN NOT NULL DEFAULT false,
    `roleId` VARCHAR(32) NULL,

    UNIQUE INDEX `Punishments_id_key`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Bans` (
    `id` VARCHAR(32) NOT NULL,
    `guild` VARCHAR(32) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Roles` (
    `id` VARCHAR(32) NOT NULL,
    `roles` LONGTEXT NOT NULL,
    `guild` VARCHAR(32) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Logs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `executedBy` VARCHAR(32) NOT NULL,
    `action` ENUM('bad_server_added', 'bad_server_removed', 'bad_server_updated', 'user_appealed', 'user_updated', 'user_created', 'globalscan_start', 'globalscan_finish', 'staff_member_added', 'staff_member_removed', 'procfile_start', 'procfile_finish', 'note_added', 'note_removed', 'forcecheck_start', 'forcecheck_finish') NOT NULL,
    `message` LONGTEXT NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Notes` ADD CONSTRAINT `Notes_id_fkey` FOREIGN KEY (`id`) REFERENCES `Users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Notes` ADD CONSTRAINT `Notes_addedBy_fkey` FOREIGN KEY (`addedBy`) REFERENCES `Staff`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Imports` ADD CONSTRAINT `Imports_server_fkey` FOREIGN KEY (`server`) REFERENCES `BadServers`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Imports` ADD CONSTRAINT `Imports_id_fkey` FOREIGN KEY (`id`) REFERENCES `Users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `BadServers` ADD CONSTRAINT `BadServers_addedBy_fkey` FOREIGN KEY (`addedBy`) REFERENCES `Staff`(`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Punishments` ADD CONSTRAINT `Punishments_id_fkey` FOREIGN KEY (`id`) REFERENCES `Guild`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Bans` ADD CONSTRAINT `Bans_guild_fkey` FOREIGN KEY (`guild`) REFERENCES `Guild`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Roles` ADD CONSTRAINT `Roles_guild_fkey` FOREIGN KEY (`guild`) REFERENCES `Guild`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Logs` ADD CONSTRAINT `Logs_executedBy_fkey` FOREIGN KEY (`executedBy`) REFERENCES `Staff`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
