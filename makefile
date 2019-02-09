all: draw.o bresenham.o byte2str.o prgrid.o
	ld draw.o bresenham.o byte2str.o prgrid.o -o bresenham
	convert image.ppm image.png
	display image.png
draw.o: draw.S
	gcc draw.S -c -g
bresenham.o: bresenham.S
	gcc bresenham.S -c -g
byte2str.o: byte2str.S
	gcc byte2str.S -c -g
prgrid.o: prgrid.S
	gcc prgrid.S -c -g
