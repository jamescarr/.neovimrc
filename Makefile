# Makefile

# Variables
NVIM_CONFIG_DIR = ~/.config/nvim
BACKUP_DIR = ~/.config/nvim_backup_$(shell date +%Y%m%d%H%M%S)
BACKUP_PATTERN = ~/.config/.nvim_backup_*
# Default target
install: backup copy

# Target to backup the existing nvim configuration
backup:
	@echo "Backing up existing nvim configuration to $(BACKUP_DIR)"
	@mv $(NVIM_CONFIG_DIR) $(BACKUP_DIR) || true

# Target to copy current directory structure to nvim config directory
copy:
	@echo "Copying current directory structure to $(NVIM_CONFIG_DIR)"
	@mkdir -p $(NVIM_CONFIG_DIR)
	@rsync -av --exclude='Makefile' ./ $(NVIM_CONFIG_DIR)/

# Target to delete all backup directories
clean_backups:
	@echo "Deleting all backup directories"
	@rm -rf $(BACKUP_PATTERN)

# Phony targets
.PHONY: install backup copy clean_backups

