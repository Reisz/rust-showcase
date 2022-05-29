cmake_minimum_required(VERSION 2.8.12)

project(RustShowcase NONE)

# Imports
set(PDFLATEX_COMPILER_FLAGS
    "-interaction=batchmode -file-line-error -shell-escape" # Adds -shell-escape
    CACHE STRING "Flags passed to latex.")
include(${CMAKE_CURRENT_LIST_DIR}/deps/UseLATEX/UseLATEX.cmake)

# Config
set(PDFLATEX_COMPILER lualatex)

# Frames
set(SECTIONS "01-introduction")
set(FRAMES_01-introduction "01-history")

# Inputs
set(INPUTS defs.tex)
foreach(SECTION IN LISTS SECTIONS)
  foreach(FRAME IN LISTS FRAMES_${SECTION})
    list(APPEND INPUTS frames/${SECTION}/${FRAME}.tex)
  endforeach()
endforeach()

# Targets
add_latex_document(slides.tex INPUTS ${INPUTS})
