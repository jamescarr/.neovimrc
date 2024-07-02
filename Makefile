# Makefile

# Variables
NVIM_CONFIG_DIR = ~/.config/nvim
BACKUP_DIR = ~/.config/nvim_backup_$(shell date +%Y%m%d%H%M%S)
BACKUP_PATTERN = ~/.config/nvim_backup_*

# Default target
install: backup copy lock

# Target to backup the existing nvim configuration
backup:
	@echo "Backing up existing nvim configuration to $(BACKUP_DIR)"
	@mv $(NVIM_CONFIG_DIR) $(BACKUP_DIR) || true

# Target to copy current directory structure to nvim config directory
copy:
	@echo "Copying current directory structure to $(NVIM_CONFIG_DIR)"
	@mkdir -p $(NVIM_CONFIG_DIR)
	@rsync -av --exclude='Makefile' ./ $(NVIM_CONFIG_DIR)/

#Target to generate lazy-lock.json
lock:
	@echo "Generating lazy-lock.json..."
	nvim --headless +Lazy! lock +qall
	@echo "lazy-lock.json generated."

# Target to delete all backup directories
clean_backups:
	@echo "Deleting all backup directories"
	@rm -rf $(BACKUP_PATTERN)

# Display help text
help:
	@echo "\nUsage: make [install|backup|copy|clean_backups]\n"
	@echo "install: Backup existing nvim configuration and copy current directory structure to nvim config directory"
	@echo "backup: Backup existing nvim configuration"
	@echo "copy: Copy current directory structure to nvim config directory"
	@echo "clean_backups: Delete all backup directories"

# Phony targets
.PHONY: install backup copy clean_backups help

