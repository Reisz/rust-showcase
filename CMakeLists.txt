cmake_minimum_required(VERSION 3.8)

project(RustShowcase NONE)

# Imports
set(PDFLATEX_COMPILER_FLAGS
    "-interaction=batchmode -file-line-error -shell-escape" # Adds -shell-escape
    CACHE STRING "Flags passed to latex.")
include(${CMAKE_CURRENT_LIST_DIR}/deps/UseLATEX/UseLATEX.cmake)
latex_get_output_path(OUTPUT_DIR)

# Config
set(PDFLATEX_COMPILER lualatex)
set(INPUTS defs.tex)

# Files
set(TOC_FILE ${OUTPUT_DIR}/content.tex)
file(WRITE ${TOC_FILE} "% Generated in ${CMAKE_CURRENT_LIST_FILE}\n")

file(GLOB SECTIONS CONFIGURE_DEPENDS RELATIVE ${CMAKE_CURRENT_LIST_DIR} [0-9][0-9]-*)
foreach(SECTION IN LISTS SECTIONS)
  string(SUBSTRING ${SECTION} 3 -1 TITLE)
  file(APPEND ${TOC_FILE} "\\section{${TITLE}}%\n")

  file(GLOB FILES CONFIGURE_DEPENDS RELATIVE ${CMAKE_CURRENT_LIST_DIR} ${SECTION}/*.tex)
  foreach(FILE IN LISTS FILES)
    list(APPEND INPUTS ${FILE})
    file(APPEND ${TOC_FILE} "\\input{${FILE}}%\n")
  endforeach()
endforeach()

# Main Target
add_latex_document(
  slides.tex
  INPUTS ${INPUTS}
  BIBFILES slides.bib
  USE_BIBLATEX
  DEPENDS ${TOC_FILE} ${DATA_OUT})
