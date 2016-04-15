.NOTPARALLEL:

.PHONY: all
all: build

.PHONY: build
build:
	mkdir -p ${ROOT}/dev/pts
	mkdir -p ${ROOT}/dev/shm
	mknod ${ROOT}/dev/rtc c 254 0
	ln -s /dev/rtc ${ROOT}/dev/rtc0
	mknod ${ROOT}/dev/fd0 b 2 0
	mknod ${ROOT}/dev/fd1 b 2 1
	mknod ${ROOT}/dev/hda b 3 0
	mknod ${ROOT}/dev/hda1 b 3 1
	mknod ${ROOT}/dev/hda2 b 3 2
	mknod ${ROOT}/dev/hda3 b 3 3
	mknod ${ROOT}/dev/hda4 b 3 4
	mknod ${ROOT}/dev/hda5 b 3 5
	mknod ${ROOT}/dev/hda6 b 3 6
	mknod ${ROOT}/dev/hda7 b 3 7
	mknod ${ROOT}/dev/hda8 b 3 8
	mknod ${ROOT}/dev/hdb b 3 64
	mknod ${ROOT}/dev/hdb1 b 3 65
	mknod ${ROOT}/dev/hdb2 b 3 66
	mknod ${ROOT}/dev/hdb3 b 3 67
	mknod ${ROOT}/dev/hdb4 b 3 68
	mknod ${ROOT}/dev/hdb5 b 3 69
	mknod ${ROOT}/dev/hdb6 b 3 70
	mknod ${ROOT}/dev/hdb7 b 3 71
	mknod ${ROOT}/dev/hdb8 b 3 72
	mknod ${ROOT}/dev/hdc b 22 0
	mknod ${ROOT}/dev/hdc1 b 22 1
	mknod ${ROOT}/dev/hdc2 b 22 2
	mknod ${ROOT}/dev/hdc3 b 22 3
	mknod ${ROOT}/dev/hdc4 b 22 4
	mknod ${ROOT}/dev/hdc5 b 22 5
	mknod ${ROOT}/dev/hdc6 b 22 6
	mknod ${ROOT}/dev/hdc7 b 22 7
	mknod ${ROOT}/dev/hdc8 b 22 8
	mknod ${ROOT}/dev/hdd b 22 64
	mknod ${ROOT}/dev/hdd3 b 22 67
	mknod ${ROOT}/dev/hdd4 b 22 68
	mknod ${ROOT}/dev/hdd5 b 22 69
	mknod ${ROOT}/dev/hdd6 b 22 70
	mknod ${ROOT}/dev/hdd7 b 22 71
	mknod ${ROOT}/dev/hdd8 b 22 72
	mknod ${ROOT}/dev/sda b 8 0
	mknod ${ROOT}/dev/sda1 b 8 1
	mknod ${ROOT}/dev/sda2 b 8 2
	mknod ${ROOT}/dev/sda3 b 8 3
	mknod ${ROOT}/dev/sda4 b 8 4
	mknod ${ROOT}/dev/sda5 b 8 5
	mknod ${ROOT}/dev/sda6 b 8 6
	mknod ${ROOT}/dev/sda7 b 8 7
	mknod ${ROOT}/dev/sda8 b 8 8
	mknod ${ROOT}/dev/sdb b 8 16
	mknod ${ROOT}/dev/sdb1 b 8 17
	mknod ${ROOT}/dev/sdb2 b 8 18
	mknod ${ROOT}/dev/sdb3 b 8 19
	mknod ${ROOT}/dev/sdb4 b 8 20
	mknod ${ROOT}/dev/sdb5 b 8 21
	mknod ${ROOT}/dev/sdb6 b 8 22
	mknod ${ROOT}/dev/sdb7 b 8 23
	mknod ${ROOT}/dev/sdb8 b 8 24
	mknod ${ROOT}/dev/sr0 b 11 0
	mknod ${ROOT}/dev/sr1 b 11 1
	mknod ${ROOT}/dev/tty c 5 0
	mknod ${ROOT}/dev/console c 5 1
	mknod ${ROOT}/dev/ttys0 c 4 64
	mknod ${ROOT}/dev/ttys1 c 4 65
	mknod ${ROOT}/dev/ttys2 c 4 66
	mknod ${ROOT}/dev/ttys3 c 4 67
	mknod ${ROOT}/dev/tty1 c 4 1
	mknod ${ROOT}/dev/tty2 c 4 2
	mknod ${ROOT}/dev/tty3 c 4 3
	mknod ${ROOT}/dev/tty4 c 4 4
	mknod ${ROOT}/dev/ram b 1 1
	mknod ${ROOT}/dev/mem c 1 1
	mknod ${ROOT}/dev/kmem c 1 2
	mknod ${ROOT}/dev/null c 1 3
	mknod ${ROOT}/dev/zero c 1 5

.PHONY: clean
clean:
