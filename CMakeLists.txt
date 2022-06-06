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

# Frames
set(SECTIONS "01-introduction" "02-showcase")

set(SECTION_01-introduction_NAME "Introduction")
set(FRAMES_01-introduction "01-definition" "02-history" "03-surveys"
                           "04-motivation")

set(SECTION_02-showcase_NAME "Showcase")
set(FRAMES_02-showcase "01-memory-safety" "02-fearless-concurrency")

# Build table of contents and list of inputs
set(INPUTS defs.tex)
set(TOC_FILE ${OUTPUT_DIR}/toc.tex)
file(WRITE ${TOC_FILE} "% Generated in ${CMAKE_CURRENT_LIST_FILE}\n")

foreach(SECTION IN LISTS SECTIONS)
  # Write section title
  file(APPEND ${TOC_FILE} "\\section{${SECTION_${SECTION}_NAME}}%\n")

  foreach(FRAME IN LISTS FRAMES_${SECTION})
    # Add file to inputs
    list(APPEND INPUTS frames/${SECTION}/${FRAME}.tex)
    # Write input statement
    file(APPEND ${TOC_FILE} "\\input{frames/${SECTION}/${FRAME}}%\n")
  endforeach()
endforeach()

# Data Command
file(
  GLOB DATA
  RELATIVE ${CMAKE_CURRENT_LIST_DIR}
  ${CMAKE_CURRENT_LIST_DIR}/data/*)

set(DATA_IN ${DATA})
list(TRANSFORM DATA_IN PREPEND ${CMAKE_CURRENT_LIST_DIR}/)

set(DATA_OUT ${DATA})
list(TRANSFORM DATA_OUT PREPEND ${OUTPUT_DIR}/)

add_custom_command(
  OUTPUT ${DATA_OUT}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_LIST_DIR}/data
          ${OUTPUT_DIR}/data
  DEPENDS ${DATA_IN})

# Main Target
add_latex_document(
  slides.tex
  INPUTS ${INPUTS}
  BIBFILES slides.bib
  USE_BIBLATEX
  DEPENDS ${TOC_FILE} ${DATA_OUT})
