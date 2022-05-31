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
set(SECTIONS "01-introduction")

set(SECTION_01-introduction_NAME "Introduction")
set(FRAMES_01-introduction "01-history" "02-properties" "03-motivation")

set(INPUTS defs.tex)

# Build table of contents and list of inputs
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

# Targets
file(GLOB IMAGES ${CMAKE_CURRENT_LIST_DIR}/images/*)
add_custom_target(
  images
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_LIST_DIR}/images
          ${OUTPUT_DIR}/images
  SOURCES ${images})

add_latex_document(
  slides.tex
  INPUTS ${INPUTS}
  IMAGE_DIRS images
  BIBFILES slides.bib
  USE_BIBLATEX)
add_dependencies(slides_pdf images)
