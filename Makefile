# Makefile

# Variables
NVIM_CONFIG_DIR = ~/.config/nvim
BACKUP_DIR = ~/.config/nvim_backup_$(shell date +%Y%m%d%H%M%S)
BACKUP_PATTERN = ~/.config/nvim_backup_*
TEST_LOG = /tmp/nvim_test.log
TEST_NVIM_DIR = /tmp/nvim_test_config
XDG_DATA_HOME = /tmp/nvim_test_data
XDG_STATE_HOME = /tmp/nvim_test_state
XDG_CACHE_HOME = /tmp/nvim_test_cache

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

# Target to generate lazy-lock.json
lock:
	@echo "Generating lazy-lock.json..."
	nvim --headless +Lazy! lock +qall
	@echo "lazy-lock.json generated."

# Target to set up clean test environment
test-setup:
	@echo "Setting up clean test environment..."
	@rm -rf $(TEST_NVIM_DIR) $(XDG_DATA_HOME) $(XDG_CACHE_HOME) $(XDG_STATE_HOME)
	@mkdir -p $(TEST_NVIM_DIR)
	@mkdir -p $(XDG_DATA_HOME)
	@mkdir -p $(XDG_CACHE_HOME)
	@mkdir -p $(XDG_STATE_HOME)
	@rsync -av --exclude='Makefile' ./ $(TEST_NVIM_DIR)/

# Target to run tests
test: test-setup test-init test-plugins

# Target to test basic initialization
test-init:
	@echo "Testing Neovim configuration initialization..."
	@XDG_CONFIG_HOME=/tmp \
	 XDG_DATA_HOME=$(XDG_DATA_HOME) \
	 XDG_CACHE_HOME=$(XDG_CACHE_HOME) \
	 XDG_STATE_HOME=$(XDG_STATE_HOME) \
	 NVIM_CONFIG_DIR=$(TEST_NVIM_DIR) \
	 nvim --clean --headless \
	      -u $(TEST_NVIM_DIR)/init.lua \
	      -c "q" 2> $(TEST_LOG) || \
		(echo "❌ Basic initialization failed. Check $(TEST_LOG)" && exit 1)
	@echo "✅ Basic initialization successful"

# Target to test plugin loading
test-plugins:
	@echo "Testing plugin initialization..."
	@XDG_CONFIG_HOME=/tmp \
	 XDG_DATA_HOME=$(XDG_DATA_HOME) \
	 XDG_CACHE_HOME=$(XDG_CACHE_HOME) \
	 XDG_STATE_HOME=$(XDG_STATE_HOME) \
	 NVIM_CONFIG_DIR=$(TEST_NVIM_DIR) \
	 nvim --clean --headless \
	      -u $(TEST_NVIM_DIR)/init.lua \
	      -c "lua require('lazy').sync()" \
	      -c "lua vim.wait(5000, function() return not require('lazy').plugins_running end)" \
	      -c "lua if next(require('lazy').plugins_errors) then error('Plugin errors found') end" \
	      -c "q" 2> $(TEST_LOG) || \
		(echo "❌ Plugin initialization failed. Check $(TEST_LOG)" && exit 1)
	@echo "✅ Plugin initialization successful"

# Target to run a more comprehensive test suite
test-full: test-setup
	@echo "Running comprehensive tests..."
	@XDG_CONFIG_HOME=/tmp \
	 XDG_DATA_HOME=$(XDG_DATA_HOME) \
	 XDG_CACHE_HOME=$(XDG_CACHE_HOME) \
	 XDG_STATE_HOME=$(XDG_STATE_HOME) \
	 NVIM_CONFIG_DIR=$(TEST_NVIM_DIR) \
	 nvim --clean --headless \
	      -u $(TEST_NVIM_DIR)/init.lua \
	      -c "lua require('lazy').sync()" \
	      -c "lua vim.wait(5000, function() return not require('lazy').plugins_running end)" \
	      -c "checkhealth" \
	      -c "TSInstallSync all" \
	      -c "LspInstall lua_ls" \
	      -c "q" 2> $(TEST_LOG) || \
		(echo "❌ Full test suite failed. Check $(TEST_LOG)" && exit 1)
	@echo "✅ Full test suite passed"

# Target to clean test environment
test-clean:
	@echo "Cleaning up test environment..."
	@rm -rf $(TEST_NVIM_DIR) $(XDG_DATA_HOME) $(XDG_CACHE_HOME) $(XDG_STATE_HOME)

# Target to delete all backup directories
clean_backups:
	@echo "Deleting all backup directories"
	@rm -rf $(BACKUP_PATTERN)

# Display help text
help:
	@echo "\nUsage: make [install|backup|copy|clean_backups|test|test-full|test-clean]\n"
	@echo "install: Backup existing nvim configuration and copy current directory structure to nvim config directory"
	@echo "backup: Backup existing nvim configuration"
	@echo "copy: Copy current directory structure to nvim config directory"
	@echo "clean_backups: Delete all backup directories"
	@echo "test: Run basic configuration tests in clean environment"
	@echo "test-full: Run comprehensive test suite in clean environment"
	@echo "test-clean: Clean up test environment"

# Phony targets
.PHONY: install backup copy clean_backups help test test-init test-plugins test-full test-setup test-clean

