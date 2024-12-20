all:
	nasm -f bin ./src/boot.asm -o ./bin/boot.bin

clean:
	rm -rf ./bin/boot.bin

build:
	rm -rf ./bin/boot.bin
	nasm -f bin ./src/boot.asm -o ./bin/boot.bin