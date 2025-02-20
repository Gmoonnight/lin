AS := nasm
ASFLAGS := -f bin -MD

CC := clang
CFLAGS_BARE := -std=c17 -ffreestanding -MMD
CFLAGS_STD := -std=c17 -MMD

SRC_DIR := src
BUILD_DIR := build

SRCS := $(shell find $(SRC_DIR) -type f -name "*.asm" -or -name "*.c")
DEPS := $(SRCS:$(SRC_DIR)/%=$(BUILD_DIR)/%.d)
OBJS := $(DEPS:.d=.o)

$(BUILD_DIR)/%.asm.o: $(SRC_DIR)/%.asm
	mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $^
$(BUILD_DIR)/tools/%.c.o: $(SRC_DIR)/tools/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS_STD) -c $< -o $@
$(BUILD_DIR)/%.c.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS_BARE) -c $< -o $@

# $(BUILD_DIR)/tools/build.c.o: $(SRC_DIR)/tools/build.c

.PHONY: all clean

all: $(OBJS)
	echo "Success!"

-include $(DEPS)

clean:
	rm -rf build
	echo "Success!"



#echo "src/boot/boot_sector.asm src/boot/setup.asm src/kernel/kernel.c src/tools/build.c src/tools/print_string.asm" | awk '{for(i = 1; i <= NF; i++) {gsub(/^src/, "build/dep", $i); gsub(/\.(asm|c)/, ".d", $i); printf "%s ", $i}}'



# boot/boot_sector: tools/print_string.asm boot/boot_sector.asm
# 	nasm -f bin boot/boot_sector.asm -o boot/boot_sector
# 	echo 'Build boot/boot_sector...OK'

# boot/setup: tools/print_string.asm boot/setup.asm
# 	nasm -f bin boot/setup.asm -o boot/setup
# 	echo 'Build boot/setup...OK'

# kernel/kernel:
# 	clang -std=c17 kernel/kernel.c -o 

# tools/build:
# 	clang -std=c17 tools/build.c -o tools/build
# 	echo 'Build tools/build...OK'

# os: boot/boot_sector boot/setup tools/build
# 	tools/build
# 	echo 'Build os by tools/build...OK'
# 	echo 'Success!'

# erase_disk:
# 	diskutil eraseDisk FAT32 UNTITLED MBR /dev/disk2
# 	diskutil unmountDisk /dev/disk2
# 	echo 'Erase disk to FAT32...OK'
# 	echo 'Success!'

# disk: os
# 	sudo dd if=os of=/dev/disk2 bs=512 seek=0
# 	echo 'Build disk...OK'
# 	echo 'Success!'

# clean: 
# 	rm -rf boot/boot_sector boot/setup tools/build os
# 	echo 'Success!'
