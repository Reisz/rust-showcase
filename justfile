build:
	cmake -B build
	cmake --build build

clean:
    rm -rf build

open:
	xdg-open build/slides.pdf
