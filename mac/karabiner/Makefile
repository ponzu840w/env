#
# Karabiner AppleScript Compiler
#
# 'make' で、AppleScriptをコンパイルします。
# 'make clean' で、コンパイル結果を削除します。
#
# セットアップ（シンボリックリンク作成）は README.md を参照してください。
#

SCRIPT_SRC_DIR = $(CURDIR)/applescript_src
SCRIPT_DEST_DIR = $(CURDIR)/karabiner/scripts

SCRIPT_SOURCES = $(wildcard $(SCRIPT_SRC_DIR)/*.applescript)
SCRIPT_TARGETS = $(patsubst $(SCRIPT_SRC_DIR)/%.applescript,$(SCRIPT_DEST_DIR)/%.scpt,$(SCRIPT_SOURCES))

.PHONY: all compile clean

all: compile

# AppleScriptをコンパイルして配置
compile: $(SCRIPT_TARGETS)

$(SCRIPT_DEST_DIR)/%.scpt: $(SCRIPT_SRC_DIR)/%.applescript
	@echo "Compiling $< -> $@"
	@mkdir -p $(dir $@)
	@osacompile -o $@ $<

clean:
	@echo "Cleaning compiled scripts..."
	@rm -rf $(SCRIPT_DEST_DIR)
