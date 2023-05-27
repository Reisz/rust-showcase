build:
	cmake -B build
	cmake --build build

open:
	xdg-open build/slides.pdf
